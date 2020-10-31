"""
This script clears up [WindowPositions] settings from User.ini files as
a workaround for the jumbled up interface bug that occurs in the editor.
"""

import os
import sys
import argparse
import re

def main():
    # parse arguments
    argparser = argparse.ArgumentParser(description=__doc__)
    argparser.add_argument('config', nargs=1, help='path to the config file')
    args = argparser.parse_args()

    try:
        config_path = os.path.abspath(args.config[0])
    except IndexError:
        print('error: missing or invalid argument')
        sys.exit(1)

    if not os.path.isfile(config_path):
        print('error: could not resolve the config file')
        sys.exit(1)

    # remove the WindowPositions section
    with open(config_path, 'r+') as config_file:
        data = config_file.read()
        config_file.seek(0)
        config_file.write(re.sub('\[WindowPositions\](\n.*?)*?\n(?=\[)', '', data, flags=re.MULTILINE))
        config_file.truncate()

if __name__ == "__main__":
    main()
