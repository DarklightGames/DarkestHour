import os
import glob
import sys
import argparse
import subprocess
import shutil
import json
from binascii import crc32
import zipfile
import time
from unrealscriptplus import parse_file, ScriptParseError
from config import ConfigParserMultiOpt
import humanfriendly

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


def script_parse_error_to_string(f, error):
    args = error.args[0]
    variant = args['variant']
    if variant['type'] == 'parsing':
        line_col = args['line_col']
        positives = ', '.join(variant['positives'])
        return f'Error: {f} ({line_col[0]}) : Expected one of [{positives}]'
    elif variant['type'] == 'custom':
        line_col = args['line_col'][0]
        message = variant['message']
        return f'Error: {f} ({line_col[0]}) : {message}'


def main():
    # parse options
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir', default='.', help='root directory')
    argparser.add_argument('-mod', required=True, help='mod name')
    argparser.add_argument('-ignore_dependencies', required=False, default=False, action='store_true',
                           help='ignore package dependencies')
    argparser.add_argument('-clean', required=False, action='store_true', help='compile all packages')
    argparser.add_argument('-dumpint', required=False, action='store_true', help='dump localization files (.int)')
    argparser.add_argument('-snapshot', required=False, action='store_true', default=False,
                           help='compresses all build artifacts into a .zip file')
    argparser.add_argument('-debug', required=False, action='store_true', default=False,
                           help='compile debug packages (for use with UDebugger)')
    argparser.add_argument('-skip_usp', required=False, action='store_true', default=False,
                           help='skip pre-parsing files with UnrealScriptPlus')
    argparser.add_argument('-strict', required=False, action='store_true', default=True,
                           help='warnings will be treated as errors')
    args = argparser.parse_args()

    args.dir = os.path.abspath(args.dir)

    if not os.path.isdir(args.dir):
        print('error: "{}" is not a directory'.format(dir))
        sys.exit(1)

    # system directory
    sys_dir = os.path.join(args.dir, 'System')

    if not os.path.isdir(sys_dir):
        print('error: could not resolve System directory')
        sys.exit(1)

    # mod directory
    mod_dir = os.path.join(args.dir, args.mod)

    if not os.path.isdir(mod_dir):
        print('error: could not resolve mod directory')
        sys.exit(1)

    # mod system directory
    mod_sys_dir = os.path.join(mod_dir, 'System')

    if not os.path.isdir(mod_sys_dir):
        print('error: could not resolve mod system directory')
        sys.exit(1)

    # read the default config
    default_config_path = os.path.join(mod_sys_dir, 'Default.ini')
    if os.path.isfile(default_config_path):
        config = ConfigParserMultiOpt()
        config.read(default_config_path)
        default_packages = config.get('Editor.EditorEngine', '+editpackages')
    else:
        print('error: could not resolve mod config file')
        sys.exit(1)

    # read the paths and make sure that there are no ambiguous file names
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

    for filename, paths in filename_paths.items():
        if len(paths) > 1:
            did_error = True
            print('ERROR: Ambiguous file resolution for "' + filename + '"')
            print('    Files with that file name were found in the following paths:')
            for path in paths:
                print('        ' + path)
            print('This is likely the result of saving a file to the wrong folder.')

    if did_error:
        sys.exit(1)

    # delete ALL mod packages from the root system folder
    for package in default_packages:
        package_path = os.path.join(sys_dir, package + '.u')
        if os.path.isfile(package_path):
            try:
                os.remove(package_path)
            except OSError:
                print('error: failed to remove \'{}\' (is the client, server or editor running?)'.format(package))
                sys.exit(1)

    # mod config path
    config_path = os.path.join(mod_sys_dir, args.mod + '.ini')

    if args.clean and os.path.isfile(config_path):
        # clean build deletes the existing mod config
        # TODO: only have this find and re-set the EditPackages and ServerPackages entries!
        os.remove(config_path)

    # get packages from generated INI?
    if os.path.isfile(config_path):
        config = ConfigParserMultiOpt()
        config.read(config_path)
        packages = config.get('Editor.EditorEngine', 'editpackages')
    else:
        packages = default_packages

    package_statuses = dict()
    changed_packages = set()
    package_crcs = dict()

    manifest_path = os.path.join(mod_dir, '.make')

    # if we are doing a clean build, remove the manifest file
    if args.clean and os.path.isfile(manifest_path):
        os.remove(manifest_path)

    try:
        with open(manifest_path, 'r') as f:
            package_crcs = json.load(f)
    except IOError:
        pass

    # store the old CRCs before we overwrite them
    old_package_crcs = package_crcs

    package_build_count = 0

    for package in packages:
        sys_package_path = os.path.join(sys_dir, package + '.u')

        if os.path.isfile(sys_package_path):
            # compiled file exists in root system folder
            continue

        package_status = PACKAGE_OK

        if not args.ignore_dependencies and package_build_count > 0:
            package_status = PACKAGE_CASCADE

        # calculate the package CRC for all of the files in the package
        package_src_dir = os.path.join(args.dir, package, 'Classes')
        package_crc = 0

        for root, dirs, filenames in os.walk(package_src_dir):
            for filename in filter(lambda x: x.endswith('.uc'), filenames):
                path = os.path.join(root, filename)
                with open(path, 'rb') as f:
                    package_crc = crc32(f.read(), package_crc)

        # check the package CRC vs the saved package CRC
        # if there is a mismatch, add the package to the list of changed packages
        if package not in package_crcs or package_crcs[package] != package_crc:
            changed_packages.add(package + '.u')
            package_status = PACKAGE_SOURCE_MISMATCH

        package_statuses[package + '.u'] = package_status
        package_crcs[package] = package_crc

        if package_status != PACKAGE_OK:
            package_build_count += 1

    up_to_date_packages = set([package for (package, status) in package_statuses.items() if status == PACKAGE_OK])
    packages_to_compile = set([package for (package, status) in package_statuses.items() if status != PACKAGE_OK])
    compiled_packages = set()

    ucc_log_path = os.path.join(sys_dir, 'UCC.log')

    # write out an empty log file, so that even if there are n
    # packages to compile, WOTgreal still has a log file to parse
    if len(packages_to_compile) == 0:
        print('No packages were marked for compilation')
        ucc_log_file = open(ucc_log_path, 'w')
        ucc_log_file.write('Warning: No packages were marked for compilation')
        ucc_log_file.close()
        sys.exit(0)

    ucc_log_contents = bytearray()

    # UnrealScriptPlus
    if not args.skip_usp:
        print('Scanning files with UnrealScriptPlus...')
        manifest_mtime = 0
        if os.path.isfile(manifest_path):
            manifest_mtime = os.stat(manifest_path).st_mtime

        usp_error_count = 0
        usp_files_scanned = 0
        ucc_log_file = open(ucc_log_path, 'w')

        # for files with package source mismatches, find files in those packages that have been modified since
        # the last successful build and run usp on them
        usp_start_time = time.monotonic_ns()
        for package in filter(lambda x: package_statuses[x] == PACKAGE_SOURCE_MISMATCH, packages_to_compile):
            package_src_dir = os.path.join(args.dir, package[:-2], 'Classes')
            for root, dirs, filenames in os.walk(package_src_dir):
                for filename in filter(lambda x: x.endswith('.uc'), filenames):
                    path = os.path.join(root, filename)
                    if os.stat(path).st_mtime >= manifest_mtime:
                        usp_files_scanned += 1
                        try:
                            result = parse_file(path)
                            if len(result['errors']) > 0:
                                for error in result['errors']:
                                    severity = error['severity']
                                    if severity == 'Error' or args.strict:
                                        usp_error_count += 1
                                    line = error['line']
                                    message = error['message']
                                    error_string = f'{severity}: {path} ({line}) : {message}'
                                    ucc_log_file.write(error_string + '\n')
                                    print(error_string)
                        except ScriptParseError as e:
                            print(path)
                            error_string = script_parse_error_to_string(path, e)
                            ucc_log_file.write(error_string + '\n')
                            print(error_string)
                            usp_error_count += 1
                        except UnicodeEncodeError as e:
                            ucc_log_file.write(f'Error: {path} (0) : {e}')
                            usp_error_count += 1
        usp_duration_ns = time.monotonic_ns() - usp_start_time
        ucc_log_file.close()

        if usp_files_scanned > 0:
            print(f"Processed {usp_files_scanned} file(s) in {humanfriendly.format_timespan(usp_duration_ns / 1000000000)}")

        if usp_error_count > 0:
            sys.exit(1)

        ucc_log_file = open(ucc_log_path, 'rb')
        ucc_log_contents = ucc_log_file.read()
        ucc_log_file.close()

    print_header('Build started for mod: {}'.format(args.mod))

    sorted_package_statuses = filter(
        lambda x: x + '.u' in package_statuses and package_statuses[x + '.u'] != PACKAGE_OK, packages)
    sorted_package_statuses = [(package, package_statuses[package + '.u']) for package in sorted_package_statuses]

    for package, status in sorted_package_statuses:
        print('{}: {}'.format(package, PACKAGE_STATUS_STRINGS[status]))

    # delete packages marked for compiling from both the root AND mod system folder
    for package in packages_to_compile:
        for package_dir in [sys_dir, mod_sys_dir]:
            package_path = os.path.join(package_dir, package)
            if os.path.isfile(package_path):
                try:
                    os.remove(package_path)
                except OSError:
                    print(
                        'error: failed to remove \'{}\' (is the client, server or editor running?)'.format(package))
                    sys.exit(1)

    os.chdir(sys_dir)

    if not os.path.exists(os.path.join(sys_dir, 'ucc.exe')):
        print('error: compiler executable not found (do you have the SDK installed?)')
        sys.exit(1)

    # run ucc make
    ucc_args = ['ucc', 'make', '-mod=' + args.mod, '-silentbuild']
    if args.debug:
        ucc_args.append('-debug')
    proc = subprocess.Popen(ucc_args)
    proc.communicate()

    # store contents of ucc.log before it's overwritten
    ucc_log_file = open(ucc_log_path, 'rb')
    ucc_log_contents = b'\n'.join([ucc_log_contents, ucc_log_file.read()])
    ucc_log_file.close()

    # move compiled packages to mod directory
    for root, dirs, filenames in os.walk(sys_dir):
        for filename in filenames:
            if filename in packages_to_compile:
                shutil.copy(os.path.join(root, filename), mod_sys_dir)
                os.remove(os.path.join(root, filename))
                compiled_packages.add(filename)

    # run dumpint on changed and compiled packages
    if args.dumpint:
        print('running dumpint (note: output may be garbled due to ucc writing to stdout in parallel)')
        processes = []
        for package in (compiled_packages & changed_packages):
            processes.append(subprocess.Popen(['ucc', 'dumpint', package, '-mod=' + args.mod]))

        [p.wait() for p in processes]

        # move localization files to mod directory
        for root, dirs, filenames in os.walk(sys_dir):
            for filename in filenames:
                if filename.replace('.int', '.u') in packages_to_compile:
                    shutil.copy(os.path.join(root, filename), mod_sys_dir)
                    os.remove(os.path.join(root, filename))

    # rewrite ucc.log to be the contents of the original ucc make command (so that WOTgreal can parse it correctly)
    ucc_log_file = open(ucc_log_path, 'wb')
    ucc_log_file.truncate()
    ucc_log_file.write(ucc_log_contents)
    ucc_log_file.close()

    did_build_succeed = len(compiled_packages) == len(packages_to_compile)

    for package_name in compiled_packages:
        package_name = os.path.splitext(package_name)[0]
        old_package_crcs[package_name] = package_crcs[package_name]

    # delete the CRCs of changed packages that failed to compile
    for package_name in ((packages_to_compile - compiled_packages) & changed_packages):
        package_name = os.path.splitext(package_name)[0]
        del old_package_crcs[package_name]

    # write package manifest
    try:
        with open(manifest_path, 'w') as f:
            json.dump(old_package_crcs, f)
    except OSError:
        print('could not write mod make manifest')

    print_header('Build: {} succeeded, {} failed, {} skipped, {} up-to-date'.format(
        len(compiled_packages),
        len(packages_to_compile) - len(compiled_packages),
        0,  # TODO: these are ones that didn't even get evaluated
        len(up_to_date_packages),
    ))

    # exit with an error code if the build fails
    if not did_build_succeed:
        sys.exit(1)

    # create build snapshot
    if args.snapshot:
        # TODO: make sure that all of the necessary files are here
        zf = zipfile.ZipFile(os.path.join(mod_dir, '{}.zip'.format(args.mod)), mode='w')
        zf.write(manifest_path, os.path.relpath(manifest_path, mod_dir))
        for package in default_packages:
            package_name = os.path.basename(package)
            package_path = os.path.join(mod_sys_dir, package_name + '.u')
            i18n_path = os.path.splitext(package_path)[0] + '.int'
            zf.write(package_path, os.path.relpath(package_path, mod_dir))
            try:
                zf.write(i18n_path, os.path.relpath(i18n_path, mod_dir))
            except:
                pass
        zf.close()


if __name__ == "__main__":
    main()
