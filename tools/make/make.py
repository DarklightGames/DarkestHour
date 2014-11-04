import os
import sys
import getopt
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

def print_usage():
	print "usage: make.py --mod=<ModName>"

def main(argv):
	argv = ["--mod=DarkestHourDev"]

	#red orchestra directory
	ro_dir = os.environ.get('RODIR')

	if ro_dir is None:
		print "error: environment variable RODIR is not defined"
		return

	if not os.path.isdir(ro_dir):
		print "error: environment variable RODIR is not a valid directory"
		return

	#red orchestra system directory
	ro_sys_dir = ro_dir + '\\System'

	if not os.path.isdir(ro_sys_dir):
		print "error: could not resolve red orchestra system directory"
		return

	#parse options
	try:
		opts, args = getopt.getopt(argv, "", ["mod=", "clean"])
	except:
		print_usage()
		system.exit(1)

	mod = None

	for opt, arg in opts:
		if opt == "--mod":
			mod = arg

	if mod is None:
		print "error: could not resolve mod"
		print_usage()
		return

	#mod directory
	mod_dir = ro_dir + "\\" + mod

	if not os.path.isdir(mod_dir):
		print "error: could not resolve mod directory"
		return

	#mod system directory
	mod_sys_dir = mod_dir + "\\System"

	if not os.path.isdir(mod_sys_dir):
		print "error could not resolve mod system directory"
		return

	#mod config path
	config_path = mod_sys_dir + "\\" + mod + ".ini"
	
	if not os.path.isfile(config_path):
		print "error: could not resove mod config file"
		return

	#parse config
	config = ConfigParser.RawConfigParser(dict_type=MultiOrderedDict)
	config.read(config_path)

	packages = config.get("Editor.EditorEngine", "editpackages")

	packages_to_compile = []

	for package in packages:
		ro_sys_package_path = os.path.join(ro_sys_dir, package + ".u")

		if os.path.isfile(ro_sys_package_path):
			#compiled file exists in root system folder
			continue

		mod_sys_package_path = os.path.join(mod_sys_dir, package + ".u")

		#get package modified time
		package_mtime = 0.0

		if os.path.isfile(mod_sys_package_path):
			package_mtime = os.path.getmtime(mod_sys_package_path)

		should_compile_package = False
		package_src_dir = os.path.join(ro_dir, package, "Classes")

		for root, dirs, files in os.walk(package_src_dir):
			for file in files:
				if not file.endswith(".uc"):
					continue

				filename = os.path.join(root, file)
				file_mtime = os.path.getmtime(filename)

				if os.path.getmtime(filename) > package_mtime:
					should_compile_package = True
					packages_to_compile.append(package + ".u")
					break

			if should_compile_package:
				break

	if len(packages_to_compile) == 0:
		print "no packages to compile"
		return

	for package in packages_to_compile:
		package_path = os.path.join(mod_sys_dir, package)

		if os.path.exists(package_path):
			try:
				os.remove(package_path)
			except:
				print "error: failed to delete file " + package_filename + " (do you have the game or editor running?)"
				return

	proc = subprocess.Popen(['ucc', 'make', '-mod=' + mod])
	proc.communicate()

	for root, dirs, files in os.walk(ro_sys_dir):
		for file in files:
			if file in packages_to_compile:
				shutil.copy(os.path.join(root, file), mod_sys_dir)
				os.remove(os.path.join(root, file))

if __name__ == "__main__":
   main(sys.argv[1:])