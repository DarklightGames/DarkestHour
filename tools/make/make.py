import os
import sys
import argparse
import subprocess
import ConfigParser
import shutil
import json
import tempfile
import re
from pprint import pprint
from binascii import crc32
from collections import OrderedDict


class MultiOrderedDict(OrderedDict):
    def __setitem__(self, key, value):
        if isinstance(value, list) and key in self:
            self[key].extend(value)
        else:
            super(OrderedDict, self).__setitem__(key, value)

def main():
    # parse options
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir')
    argparser.add_argument('-mod', required=True)
    argparser.add_argument('-clean', required=False, action='store_true')
    argparser.add_argument('-dumpint', required=False, action='store_true')
    args = argparser.parse_args()

    if not os.path.isdir(args.dir):
        print 'error: "{dir}" is not a directory'.format(dir)
        sys.exit(1)

    # system directory
    sys_dir = os.path.join(args.dir, 'System')

    if not os.path.isdir(sys_dir):
        print 'error: could not resolve System directory'
        sys.exit(1)

    # mod directory
    mod_dir = os.path.join(args.dir, args.mod)

    if not os.path.isdir(mod_dir):
        print 'error: could not resolve mod directory'
        sys.exit(1)

    # mod system directory
    mod_sys_dir = os.path.join(mod_dir, 'System')

    if not os.path.isdir(mod_sys_dir):
        print 'error could not resolve mod system directory'
        sys.exit(1)

    config = ConfigParser.RawConfigParser(dict_type=MultiOrderedDict)

    # mod config path
    config_path = os.path.join(mod_sys_dir, '.ini')

    if os.path.isfile(config_path):
        config.read(config_path)
        packages = config.get('Editor.EditorEngine', 'editpackages')
    else:
        # mod config has not been generated, use default configuration
        config_path = os.path.join(mod_sys_dir, 'Default.ini')
        if os.path.isfile(config_path):
            config.read(config_path)
            packages = config.get('Editor.EditorEngine', '+editpackages')
        else:
            print "error: could not resove mod config file"
            sys.exit(1)

    packages_to_compile = []
    package_crcs = dict()

    manifest_filename = '{0}.manifest'.format(args.mod)

    try:
        with open(manifest_filename, 'r') as f:
            package_crcs = json.load(f)
    except:
        pass

    for package in packages:
        sys_package_path = os.path.join(sys_dir, package + '.u')

        if os.path.isfile(sys_package_path):
            # compiled file exists in root system folder
            continue

        if args.clean:
            packages_to_compile.append(package + '.u')
            continue

        mod_sys_package_path = os.path.join(mod_sys_dir, package + '.u')

        should_compile_package = False
        package_src_dir = os.path.join(args.dir, package, 'Classes')
        package_crc = 0

        for root, dirs, files in os.walk(package_src_dir):
            for file in filter(lambda x: x.endswith('.uc'), files):
                filename = os.path.join(root, file)

                with open(filename, 'rb') as f:
                    package_crc = crc32(f.read(), package_crc)

        if package not in package_crcs or package_crcs[package] != package_crc:
            should_compile_package = True

        if should_compile_package:
            packages_to_compile.append(package + '.u')

        package_crcs[package] = package_crc

    try:
        with open(manifest_filename, 'w') as f:
            json.dump(package_crcs, f)
    except:
        print 'could not write mod make manifest'

    if len(packages_to_compile) == 0:
        print 'no packages to compile'
        sys.exit(0)

    package_paths = dict()

    print 'compiling the following packages:'

    pprint(packages_to_compile)

    # delete packages marked for compiling
    for package in packages_to_compile:
        package_dirs = [sys_dir, mod_sys_dir]

        for package_dir in package_dirs:
            package_path = os.path.join(package_dir, package)

            if os.path.isfile(package_path):
                try:
                    os.remove(package_path)
                except:
                    print 'error: failed to remove file {} (do you have the client, server or editor running?)'.format(package)
                    sys.exit(1)

    os.chdir(sys_dir)

    # run ucc make
    proc = subprocess.Popen(['ucc', 'make', '-mod=' + args.mod])
    proc.communicate()

    # store contents of ucc.log before it's overwritten
    ucc_log_file = open('ucc.log', 'rb')
    ucc_log_contents = ucc_log_file.read()
    ucc_log_file.close()

    # move compiled packages to mod directory
    for root, dirs, files in os.walk(sys_dir):
        for file in files:
            if file in packages_to_compile:
                shutil.copy(os.path.join(root, file), mod_sys_dir)
                os.remove(os.path.join(root, file))

    # run dumpint on compiled packages
    if args.dumpint:
        for package in packages_to_compile:
            proc = subprocess.Popen(['ucc', 'dumpint', package, '-mod=' + args.mod])
            proc.communicate()

        # move localization files to mod directory
        for root, dirs, files in os.walk(sys_dir):
            for file in files:
                if file.replace('.int', '.u') in packages_to_compile:
                    shutil.copy(os.path.join(root, file), mod_sys_dir)
                    os.remove(os.path.join(root, file))

    # rewrite ucc.log to be the contents of the original ucc make command (so that WOTgreal can parse it correctly)
    ucc_log_file = open('ucc.log', 'wb')
    ucc_log_file.truncate()
    ucc_log_file.write(ucc_log_contents)
    ucc_log_file.close()

if __name__ == "__main__":
    main()
