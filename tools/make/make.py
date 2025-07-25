import os
import glob
import sys
import argparse
import subprocess
import configparser
import shutil
import json
from binascii import crc32
import zipfile
from json import JSONDecodeError
from pathlib import Path
from typing import Optional

'''
https://stackoverflow.com/questions/13921323/handling-duplicate-keys-with-configparser
'''


class Manifest:
    def __init__(self):
        self.package_crcs = dict()
        self.default_ini_crc = None

    @staticmethod
    def load(path: str) -> 'Manifest':
        with open(path, 'r') as fp:
            manifest = Manifest()
            try:
                data = json.load(fp)
                if isinstance(data, dict):
                    manifest.package_crcs = data.get('package_crcs', dict())
                    manifest.default_ini_crc = data.get('default_ini_crc', None)
            except JSONDecodeError:
                pass
            return manifest

    def write(self, path):
        try:
            with open(path, 'w') as f:
                json.dump({
                    'package_crcs': self.package_crcs,
                    'default_ini_crc': self.default_ini_crc
                }, f, indent=2)
        except OSError:
            print('could not write mod make manifest')


class ConfigParserMultiOpt(configparser.RawConfigParser):
    """
    ConfigParser allowing duplicate keys. Values are stored in a list
    """

    def __init__(self):
        configparser.RawConfigParser.__init__(self, empty_lines_in_values=False, strict=False)

    def _read(self, fp, fpname):
        """Parse a sectioned configuration file.

        Each section in a configuration file contains a header, indicated by
        a name in square brackets (`[]'), plus key/value options, indicated by
        `name' and `value' delimited with a specific substring (`=' or `:' by
        default).

        Values can span multiple lines, as long as they are indented deeper
        than the first line of the value. Depending on the parser's mode, blank
        lines may be treated as parts of multiline values or ignored.

        Configuration files may include comments, prefixed by specific
        characters (`#' and `;' by default). Comments may appear on their own
        in an otherwise empty line or may be entered in lines holding values or
        section names.
        """
        elements_added = set()
        cursect = None  # None, or a dictionary
        sectname = None
        optname = None
        indent_level = 0
        e = None  # None, or an exception
        for lineno, line in enumerate(fp, start=1):
            comment_start = None
            # TODO: There is some sort of screw-up between Linux and Windows versions of configparser where Windows doesn't have `_prefixes`.
            # strip inline comments
            if hasattr(self, '_prefixes'):
                for prefix in self._prefixes.inline:
                    index = line.find(prefix)
                    if index == 0 or (index > 0 and line[index - 1].isspace()):
                        comment_start = index
                        break
                # strip full line comments
                for prefix in self._prefixes.full:
                    if line.strip().startswith(prefix):
                        comment_start = 0
                        break
            # strip inline comments
            if hasattr(self, '_inline_comment_prefixes'):
                for prefix in self._inline_comment_prefixes:
                    index = line.find(prefix)
                    if index == 0 or (index > 0 and line[index - 1].isspace()):
                        comment_start = index
                        break
            # strip full line comments
            if hasattr(self, '_comment_prefixes'):
                for prefix in self._comment_prefixes:
                    if line.strip().startswith(prefix):
                        comment_start = 0
                        break
            value = line[:comment_start].strip()
            if not value:
                if self._empty_lines_in_values:
                    # add empty line to the value, but only if there was no
                    # comment on the line
                    if (comment_start is None and
                            cursect is not None and
                            optname and
                            cursect[optname] is not None):
                        cursect[optname].append('')  # newlines added at join
                else:
                    # empty line marks end of value
                    indent_level = sys.maxsize
                continue
            # continuation line?
            first_nonspace = self.NONSPACECRE.search(line)
            cur_indent_level = first_nonspace.start() if first_nonspace else 0
            if (cursect is not None and optname and
                    cur_indent_level > indent_level):
                cursect[optname].append(value)
            # a section header or option header?
            else:
                indent_level = cur_indent_level
                # is it a section header?
                mo = self.SECTCRE.match(value)
                if mo:
                    sectname = mo.group('header')
                    if sectname in self._sections:
                        if self._strict and sectname in elements_added:
                            raise configparser.DuplicateSectionError(sectname, fpname, lineno)
                        cursect = self._sections[sectname]
                        elements_added.add(sectname)
                    elif sectname == self.default_section:
                        cursect = self._defaults
                    else:
                        cursect = self._dict()
                        self._sections[sectname] = cursect
                        self._proxies[sectname] = configparser.SectionProxy(self, sectname)
                        elements_added.add(sectname)
                    # So sections can't start with a continuation line
                    optname = None
                # no section header in the file?
                elif cursect is None:
                    raise configparser.MissingSectionHeaderError(fpname, lineno, line)
                # an option line?
                else:
                    mo = self._optcre.match(value)
                    if mo:
                        optname, vi, optval = mo.group('option', 'vi', 'value')
                        if not optname:
                            e = self._handle_error(e, fpname, lineno, line)
                        optname = self.optionxform(optname.rstrip())
                        if (self._strict and
                                (sectname, optname) in elements_added):
                            raise configparser.DuplicateOptionError(sectname, optname, fpname, lineno)
                        elements_added.add((sectname, optname))
                        # This check is fine because the OPTCRE cannot
                        # match if it would set optval to None
                        if optval is not None:
                            optval = optval.strip()
                            # Check if this optname already exists
                            if (optname in cursect) and (cursect[optname] is not None):
                                # If it does, convert it to a tuple if it isn't already one
                                if not isinstance(cursect[optname], tuple):
                                    cursect[optname] = tuple(cursect[optname])
                                cursect[optname] = cursect[optname] + tuple([optval])
                            else:
                                cursect[optname] = [optval]
                        else:
                            # valueless option handling
                            cursect[optname] = None
                    else:
                        # a non-fatal parsing error occurred. set up the
                        # exception but keep going. the exception will be
                        # raised at the end of the file and will contain a
                        # list of all bogus lines
                        e = self._handle_error(e, fpname, lineno, line)
        # if any parsing errors occurred, raise an exception
        if e:
            raise e
        self._join_multiline_values()


PACKAGE_OK = 0
PACKAGE_SOURCE_MISMATCH = 1
PACKAGE_CASCADE = 2

PACKAGE_STATUS_STRINGS = {
    PACKAGE_OK: 'Up-to-date',
    PACKAGE_SOURCE_MISMATCH: 'Out-of-date',
    PACKAGE_CASCADE: 'Dependency out-of-date',
}


def print_header(s=''):
    header = list('-' * 70)
    i = int(len(header) / 2) - int(len(s) / 2)
    header[i:i + len(s)] = list(s)
    print(''.join(header))


def main():
    # parse options
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir', default='.', help='root directory')
    argparser.add_argument('-mod', required=True, help='mod name')
    argparser.add_argument('-ignore_dependencies', required=False, default=False, action='store_true',
                           help='ignore package dependencies')
    argparser.add_argument('-clean', required=False, action='store_true', help='compile all packages')
    argparser.add_argument('-dumpint', required=False, action='store_true', help='dump localization files (.int)')
    argparser.add_argument('-debug', required=False, action='store_true', default=False,
                           help='compile debug packages (for use with UDebugger)')
    
    args = argparser.parse_args()

    args.dir = os.path.abspath(args.dir)

    if not os.path.isdir(args.dir):
        print('Error: "{}" is not a directory'.format(dir))
        sys.exit(1)

    # System directory.
    sys_dir = os.path.join(args.dir, 'System')
    if not os.path.isdir(sys_dir):
        print(f'Error: Could not resolve System directory ({sys_dir})')
        sys.exit(1)

    # Mod directory.
    mod_dir = os.path.join(args.dir, args.mod)
    if not os.path.isdir(mod_dir):
        print(f'Error: Could not resolve mod directory ({mod_dir})')
        sys.exit(1)

    # Mod system directory.
    mod_sys_dir = os.path.join(mod_dir, 'System')
    if not os.path.isdir(mod_sys_dir):
        print(f'Error: Could not resolve mod System directory ({mod_sys_dir})')
        sys.exit(1)

    # Read the default config.
    default_config_path = os.path.join(mod_sys_dir, 'Default.ini')
    if not os.path.isfile(default_config_path):
        print('Error: Could not resolve mod config file ({default_config_path})')
        sys.exit(1)
    
    # Calculate the CRC of the default config.
    # We will check this against the one logged in the manifest and force a clean build if it has changed.
    default_ini_crc = crc32(Path(default_config_path).read_bytes())

    config = ConfigParserMultiOpt()
    config.read(default_config_path)
    default_packages = config.get('Editor.EditorEngine', '+editpackages')

    # Read the paths and make sure that there are no ambiguous file names.
    config_path = os.path.join(mod_sys_dir, args.mod + '.ini')
    paths = []
    if os.path.isfile(config_path):
        config = ConfigParserMultiOpt()
        config.read(config_path)
        paths = config.get('Core.System', 'paths')

    filename_paths = dict()
    for path in paths:
        pathname = os.path.abspath(os.path.join(mod_dir, path))
        for path in glob.glob(pathname):
            basename = os.path.basename(path)
            if basename not in filename_paths:
                filename_paths[basename] = []
            filename_paths[basename].append(path)

    did_error = False

    # Read the make-config.json file from the mod directory.
    make_config = None
    make_config_path = Path(mod_dir) / 'make-config.json'
    if make_config_path.is_file():
        with open(make_config_path, 'r') as f:
            make_config = json.load(f)

    # Write build manifest file.
    if make_config is not None and make_config['should_write_build_manifest']:
        version_data = make_config['version']
        version = (version_data['major'], version_data['minor'], version_data['patch'])
        prerelease = version_data.get('prerelease', None)
        build_manifest = BuildManifest.new_from_cli(version, prerelease)
        if build_manifest is not None:
            # Need to define where the build manifest file will be written.
            build_manifest_path = Path(args.dir) / make_config['build_manifest_path']
            with open(build_manifest_path, 'w') as f:
                class_name = build_manifest_path.stem
                f.write(build_manifest.to_unrealscript_string(class_name))

    for filename, paths in filename_paths.items():
        if len(paths) > 1:
            did_error = True
            print('Error: Ambiguous file resolution for "' + filename + '"')
            print('    Files with that file name were found in the following paths:')
            for path in paths:
                print('        ' + path)
            print('This is likely the result of saving a file to the wrong folder.')

    if did_error:
        sys.exit(1)

    # Delete all mod packages from the root System folder.
    for package in default_packages:
        package_path = os.path.join(sys_dir, package + '.u')
        if os.path.isfile(package_path):
            try:
                os.remove(package_path)
            except OSError:
                print('Error: Failed to remove \'{}\' (is the client, server or editor running?)'.format(package))
                sys.exit(1)

    config_path = os.path.join(mod_sys_dir, args.mod + '.ini')
    manifest_path = os.path.join(mod_dir, '.make')

    manifest = Manifest()

    if not args.clean:
        # Load the manifest file.
        try:
            manifest = Manifest.load(manifest_path)
        except FileNotFoundError:
            pass

    if default_ini_crc != manifest.default_ini_crc:
        # Default configuration file has changed. This could mean that the EditPackages or ServerPackage have changed.
        # To be safe, we force a clean build if this happens so that the user doesn't need to fiddle around with their
        # generated configuration file. This has the nasty side effect of wiping out graphics settings etc. In future,
        # the ServerPackages and EditPackages should be explicitly updated and avoid changing the rest of the config.
        print('Detected change in Default.ini, forcing a clean build and localization dump!')
        args.clean = True
        args.dumpint = True

    if args.clean and os.path.isfile(config_path):
        # Clean build deletes the existing mod config.
        os.remove(config_path)

    # Get packages from generated INI.
    if os.path.isfile(config_path):
        config = ConfigParserMultiOpt()
        config.read(config_path)
        packages = config.get('Editor.EditorEngine', 'editpackages')
    else:
        packages = default_packages

    package_statuses = dict()
    changed_packages = set()

    if args.clean and os.path.isfile(manifest_path):
        os.remove(manifest_path)

    # Store the old CRCs before we overwrite them.
    old_package_crcs = manifest.package_crcs

    package_build_count = 0

    print('Checking for out-of-date packages...')

    # Get a list of the compiled files that exist in root System folder.
    # This is cross-platform solution since os.path.isfile behaves different depending on casing.
    files_in_root_system_folder = [x.upper() for x in os.listdir(sys_dir) if os.path.isfile(os.path.join(sys_dir, x))]

    def is_compiled_package_in_root_system_folder(package: str):
        return package.upper() in files_in_root_system_folder

    for package in packages:
        package_filename = f'{package}.u'
        sys_package_path = os.path.join(sys_dir, package_filename)

        if is_compiled_package_in_root_system_folder(package_filename):
            continue

        package_status = PACKAGE_OK

        if not args.ignore_dependencies and package_build_count > 0:
            package_status = PACKAGE_CASCADE

        package_src_dir = os.path.join(args.dir, package, 'Classes')
        package_crc = 0

        for root, dirs, filenames in os.walk(package_src_dir):
            for filename in filter(lambda x: x.endswith('.uc'), filenames):
                with open(os.path.join(root, filename), 'rb') as f:
                    package_crc = crc32(f.read(), package_crc)

        if package not in manifest.package_crcs or manifest.package_crcs[package] != package_crc:
            changed_packages.add(package + '.u')
            package_status = PACKAGE_SOURCE_MISMATCH

        package_statuses[package_filename] = package_status
        manifest.package_crcs[package] = package_crc

        if package_status != PACKAGE_OK:
            package_build_count += 1

    up_to_date_packages = set([package for (package, status) in package_statuses.items() if status == PACKAGE_OK])
    packages_to_compile = set([package for (package, status) in package_statuses.items() if status != PACKAGE_OK])
    compiled_packages = set()
    did_build_succeed = True

    has_packages_to_compile = len(packages_to_compile) > 0

    if has_packages_to_compile:
        print_header('Build started for mod: {}'.format(args.mod))

        sorted_package_statuses = filter(
            lambda x: x + '.u' in package_statuses and package_statuses[x + '.u'] != PACKAGE_OK, packages)
        sorted_package_statuses = [(package, package_statuses[package + '.u']) for package in sorted_package_statuses]

        for package, status in sorted_package_statuses:
            print('{}: {}'.format(package, PACKAGE_STATUS_STRINGS[status]))

        # Delete packages marked for compiling from both the root and mod's System folder.
        for package in packages_to_compile:
            for package_dir in [sys_dir, mod_sys_dir]:
                package_path = os.path.join(package_dir, package)
                if os.path.isfile(package_path):
                    try:
                        os.remove(package_path)
                    except OSError:
                        print(
                            'Error: Failed to remove \'{}\' (is the client, server or editor running?)'.format(package))
                        sys.exit(1)

        os.chdir(sys_dir)

        ucc_path = os.path.join(sys_dir, 'UCC.exe')
        if not os.path.exists(ucc_path):
            print(f'Error: Compiler executable ({ucc_path}) not found (do you have the SDK installed?)')
            sys.exit(1)

        # Run ucc make.
        ucc_args = ['ucc', 'make', '-mod=' + args.mod]
        if args.debug:
            ucc_args.append('-debug')
        if sys.platform == 'linux':
            # Run `ucc` through wine.
            ucc_args.insert(0, 'wine')

        proc = subprocess.Popen(ucc_args)
        proc.communicate()

        # Store contents of ucc.log before it's overwritten.
        ucc_log_path = os.path.join(sys_dir, 'UCC.log')
        ucc_log_file = open(ucc_log_path, 'rb')
        ucc_log_contents = ucc_log_file.read()
        ucc_log_file.close() 

        # Move compiled packages to mod directory.
        for root, dirs, filenames in os.walk(sys_dir):
            for filename in filenames:
                if filename in packages_to_compile:
                    shutil.copy(os.path.join(root, filename), mod_sys_dir)
                    os.remove(os.path.join(root, filename))
                    compiled_packages.add(filename)

        # Run dumpint on changed and compiled packages.
        if args.dumpint:
            print('Running dumpint (note: output may be garbled due to ucc writing to stdout in parallel)')
            processes = []
            for package in (compiled_packages & changed_packages):
                ucc_args = ['ucc', 'dumpint', package, '-mod=' + args.mod]
                if sys.platform == 'linux':
                    ucc_args.insert(0, 'wine')
                processes.append(subprocess.Popen(ucc_args))

            [p.wait() for p in processes]

            # Move localization files to mod directory.
            for root, dirs, filenames in os.walk(sys_dir):
                for filename in filenames:
                    if filename.replace('.int', '.u') in packages_to_compile:
                        shutil.copy(os.path.join(root, filename), mod_sys_dir)
                        os.remove(os.path.join(root, filename))

        # Rewrite ucc.log to be the contents of the original ucc make command (so that WOTgreal can parse it correctly).
        ucc_log_file = open(ucc_log_path, 'wb')
        ucc_log_file.truncate()
        ucc_log_file.write(ucc_log_contents)
        ucc_log_file.close()

        did_build_succeed = len(compiled_packages) == len(packages_to_compile)

        for package_name in compiled_packages:
            package_name = os.path.splitext(package_name)[0]
            old_package_crcs[package_name] = manifest.package_crcs[package_name]

        # Delete the CRCs of changed packages that failed to compile.
        for package_name in ((packages_to_compile - compiled_packages) & changed_packages):
            package_name = os.path.splitext(package_name)[0]
            if package_name in old_package_crcs:
                del old_package_crcs[package_name]

        # Write package manifest.
        manifest.default_ini_crc = default_ini_crc
        manifest.write(manifest_path)

    print_header('Build: {} succeeded, {} failed, {} skipped, {} up-to-date'.format(
        len(compiled_packages),
        len(packages_to_compile) - len(compiled_packages),
        0,  # TODO: these are ones that didn't even get evaluated
        len(up_to_date_packages),
    ))

    # Exit with an error code if the build fails
    if not did_build_succeed:
        sys.exit(1)


class BuildManifest:
    def __init__(self, version: (int, int, int), commit: str, branch: str = 'main', prerelease: Optional[str] = None):
        self.version = version
        self.prerelease = prerelease
        self.branch = branch
        self.commit = commit

    def to_unrealscript_string(self, class_name: str = 'BuildManifest') -> str:
        return '//===============================================''\n'\
               '// This file is generated by the build system''\n'\
               '// Do not modify this file manually''\n'\
               '//===============================================''\n'\
               '\n'\
               f'class {class_name} extends Object;\n'\
               '\n'\
               'var UVersion Version;\n'\
               'var string GitCommit;\n'\
               'var string GitBranch;\n'\
               '\n'\
               'defaultproperties\n'\
               '{\n'\
               f'    Begin Object Class=UVersion Name=VersionObject\n'\
               f'        Major={self.version[0]}\n'\
               f'        Minor={self.version[1]}\n'\
               f'        Patch={self.version[2]}\n'\
               f'        Prerelease="{self.prerelease if self.prerelease else ""}"\n'\
               f'        Metadata="{self.commit}"\n'\
               f'    End Object\n'\
               f'    Version=VersionObject\n'\
               f'    GitCommit="{self.commit}"\n'\
               f'    GitBranch="{self.branch}"\n'\
               '}\n'

    @staticmethod
    def new_from_cli(version: (int, int, int), prerelease: Optional[str] = None) -> 'BuildManifest':
        import subprocess
        p = subprocess.Popen(['git', 'rev-parse', '--short', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        commit, _ = p.communicate()
        if p.returncode != 0:
            print('Unable to get git commit')
            commit = ''
        else:
            commit = commit.decode().strip()

        p = subprocess.Popen(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        branch, _ = p.communicate()
        if p.returncode != 0:
            print('Unable to get git branch')
            branch = ''
        else:
            branch = branch.decode().strip()

        return BuildManifest(version=version,
                             prerelease=prerelease,
                             commit=commit,
                             branch=branch)


if __name__ == "__main__":
    main()
