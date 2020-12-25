"""
This script clears up [WindowPositions] settings from User.ini files as
a workaround for the jumbled up interface bug that occurs in the editor.
"""

import os
import sys
import argparse
import re

def main():
    argparser = argparse.ArgumentParser(description=__doc__)
    argparser.add_argument('config', nargs=1, help='path to the config file')
    args = argparser.parse_args()

    try:
        config_path = os.path.abspath(args.config[0])
    except IndexError:
        print('Error (1): Missing argument')
        sys.exit(1)

    try:
        with open(config_path, 'r+') as config_file:
            data = config_file.read()
            config_file.seek(0)
            config_file.write(re.sub('\[WindowPositions\](\n.*?)*?\n(?=(\[|\Z))', '', data, flags=re.MULTILINE))
            config_file.truncate()
    except IOError as err:
        print('Error (', err.errno, '): ', err.strerror, sep='')
        sys.exit(1)

if __name__ == "__main__":
    main()
