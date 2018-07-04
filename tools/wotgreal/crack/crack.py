#!/usr/bin/env python

import winreg
import binascii
import argparse
import os
import shutil
import re
from sys import exit

#!/usr/bin/env python
def fail(code):
    print('[ERROR] Crack was not applied.')
    exit(code)


def patch(file, dif, revert=False):
    code = open(file, 'rb').read()
    dif = open(dif, 'r').read()
    m = re.findall('([0-9a-fA-F]+): ([0-9a-fA-F]+) ([0-9a-fA-F]+)', dif)
    for offset, orig, new in m:
        o, orig, new = int(offset, 16), bytes.fromhex(orig), bytes.fromhex(new)
        if revert:
            if code[o:o+1] == new:
                code = code[:o] + orig + code[o + 1:]
            else:
                raise Exception("patched byte at %s is not %02X" % (offset, ord(new)))
        else:
            if code[o:o+1] == orig:
                code = code[:o] + new + code[o + 1:]
            else:
                raise Exception("original byte at %s is not %02X" % (offset, ord(orig)))
    open(file, 'wb').write(code)


def main():
    argparser = argparse.ArgumentParser()
    argparser.add_argument('-path', required=False, default=None, help='WOTgreal.exe path')
    # args = argparser.parse_args(['-path', 'C:\Program Files (x86)\Harmon Enterprizes\WOTgreal\WOTgreal - uncracked.exe'])
    args = argparser.parse_args()

    print('WOTgreal 3.005 crack by Colin Basnett of Darklight Games')
    print('-' * 80)

    # If no path is specified, we will attempt to automatically
    if not args.path:
        print('No path specified, searching for WOTgreal installation...')
        try:
            key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, 'Software\\HARMONENT\\WOTgreal')
            value, type = winreg.QueryValueEx(key, 'WOTgrealExeDir')
        except Exception as e:
            print('WOTgreal installation could not be found!')
            fail(1)
        print('WOTgreal installation detected ({})'.format(value))
        args.path = os.path.join(value, 'WOTgreal.exe')

    # Check that the path exists.
    if not os.path.exists(args.path):
        print('Executable does not exist ({})'.format(args.path))
        fail(2)

    # Check that the path is a file.
    if not os.path.isfile(args.path):
        print('The specified path ({}) is not a file.'.format(args.path))
        fail(3)

    with open(args.path, 'rb') as f:
        crc = binascii.crc32(f.read())

    # This is the CRC32 for the original WOTgreal 3.005 executable
    WOTGREAL_ORIGINAL_EXE_CRC = 0x5D379B53

    # This is the CRC32 for the cracked WOTgreal 3.005 executable
    WOTGREAL_CRACKED_EXE_CRC = 0x6A378A51

    if crc == WOTGREAL_CRACKED_EXE_CRC:
        print('The executable file ({}) is already cracked!'.format(args.path))
        fail(4)
    elif crc != WOTGREAL_ORIGINAL_EXE_CRC:
        print('The path specified is not original WOTgreal v3.005 executable!')
        fail(5)

    print('Crack will be applied to the following executable:')
    print(args.path)

    confirmation_input = input('Enter \'y\' to apply the crack, or anything else to cancel:')

    if confirmation_input != 'y':
        print('Cancelled.')
        fail(6)

    # Make a backup copy of the original executable.
    backup_executable_path = os.path.join(os.path.dirname(args.path), 'WOTgreal-original.exe')
    print('Creating a backup copy ({})...'.format(backup_executable_path))
    shutil.copyfile(args.path, backup_executable_path)
    patch(args.path, 'WOTgreal.dif')

    print('[SUCCESS] Crack successfully applied.')

if __name__ == '__main__':
    main()