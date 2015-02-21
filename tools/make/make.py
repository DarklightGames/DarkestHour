import os
import sys
import argparse
import subprocess
import time
import ConfigParser
import shutil
from datetime import datetime
from collections import OrderedDict

class MultiOrderedDict(OrderedDict):
    def __setitem__(self, key, value):
        if isinstance(value, list) and key in self:
            self[key].extend(value)
        else:
            super(OrderedDict, self).__setitem__(key, value)

def main():
	#red orchestra directory
	ro_dir = os.environ.get('RODIR')

	if ro_dir == None:
		print 'error: environment variable RODIR is not defined'
		sys.exit(1)

	if not os.path.isdir(ro_dir):
		print 'error: environment variable RODIR is not a valid directory'
		sys.exit(1)

	#red orchestra system directory
	ro_sys_dir = os.path.join(ro_dir, 'System')

	if not os.path.isdir(ro_sys_dir):
		print 'error: could not resolve red orchestra system directory'
		sys.exit(1)

	#parse options
	argparser = argparse.ArgumentParser()
	argparser.add_argument('-mod', required=True)
	argparser.add_argument('-clean', required=False, action='store_true')
	argparser.add_argument('-dumpint', required=False, action='store_true')
	args = argparser.parse_args()

	#mod directory
	mod_dir = os.path.join(ro_dir, args.mod)

	if not os.path.isdir(mod_dir):
		print 'error: could not resolve mod directory'
		sys.exit(1)

	#mod system directory
	mod_sys_dir = os.path.join(mod_dir, 'System')

	if not os.path.isdir(mod_sys_dir):
		print 'error could not resolve mod system directory'
		sys.exit(1)

	#mod config path
	config_path = os.path.join(mod_sys_dir, args.mod + '.ini')
	
	if not os.path.isfile(config_path):
		print "error: could not resove mod config file"
		sys.exit(1)

	#parse config
	config = ConfigParser.RawConfigParser(dict_type=MultiOrderedDict)
	config.read(config_path)

	packages = config.get('Editor.EditorEngine', 'editpackages')

	packages_to_compile = []

	for package in packages:
		ro_sys_package_path = os.path.join(ro_sys_dir, package + '.u')

		if os.path.isfile(ro_sys_package_path):
			#compiled file exists in root system folder
			continue

		if args.clean:
			packages_to_compile.append(package + '.u')
			continue

		mod_sys_package_path = os.path.join(mod_sys_dir, package + '.u')

		#get package modified time
		package_mtime = 0.0

		if os.path.isfile(mod_sys_package_path):
			package_mtime = os.path.getmtime(mod_sys_package_path)

		should_compile_package = False
		package_src_dir = os.path.join(ro_dir, package, 'Classes')

		for root, dirs, files in os.walk(package_src_dir):
			for file in files:
				if not file.endswith('.uc'):
					continue

				filename = os.path.join(root, file)
				file_mtime = os.path.getmtime(filename)

				if os.path.getmtime(filename) > package_mtime:
					should_compile_package = True
					packages_to_compile.append(package + '.u')
					break

			if should_compile_package:
				break

	if len(packages_to_compile) == 0:
		print "no packages to compile"
		return

	# delete packages marked for compiling
	for package in packages_to_compile:
		package_path = os.path.join(mod_sys_dir, package)

		if os.path.isfile(package_path):
			try:
				os.remove(package_path)
			except:
				print 'error: failed to delete file ' + package + ' (do you have the game or editor running?)'
				sys.exit(1)

	# run ucc make
	proc = subprocess.Popen([os.path.join(ro_sys_dir, 'ucc'), 'make', '-mod=' + args.mod])
	proc.communicate()

	# move compiled packages to mod directory
	for root, dirs, files in os.walk(ro_sys_dir):
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
		for root, dirs, files in os.walk(ro_sys_dir):
			for file in files:
				if file.replace('.int', '.u') in packages_to_compile:
					shutil.copy(os.path.join(root, file), mod_sys_dir)
					os.remove(os.path.join(root, file))

if __name__ == "__main__":
   main()