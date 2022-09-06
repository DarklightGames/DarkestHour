import os
import sys
import subprocess
import argparse
from typing import Iterable
from pathlib import Path

DEFAULT_MOD = 'DarkestHourDev'
PACKAGE_FLAGS = ['AllowDownload', 'ClientOptional', 'ServerSideOnly', 'BrokenLinks', 'Unsecure']
DESCRIPTION='''\
Wrapper for the UCC packageflag command.

flags:
  {packages}
'''.format(packages='\n  '.join(PACKAGE_FLAGS))


ro_path = Path(os.getenv('RODIR'))
ucc_path = ro_path.joinpath('System\\UCC.exe')

if not ucc_path.is_file():
    print('UCC.exe not found')
    sys.exit(1)


def run_packageflag(input_package: str, output_package: str = '\"\"', flag_line: str = '', mod: str = '') -> subprocess.Popen:
    cmd = 'ucc packageflag {input} {output}{flag_line}{mod}'.format(input=input_package,
                                                                    output=output_package,
                                                                    flag_line=f' {flag_line}' if flag_line else '',
                                                                    mod=f' -mod={mod}' if mod else '')
    # print('Running: ' + cmd)
    return subprocess.Popen(cmd, executable=ucc_path, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def read_stdout(process: subprocess.Popen) -> Iterable[str]:
    out = [ line.strip() for line in process.stdout.read().decode().splitlines() if line]
    # print(f'Output: {out}')
    return out

class Package():
    def __init__(self, path: str) -> None:
        self.path = Path(path)
        self.dir = Path(path.parent)
        self.name = self.path.name
        self.flags = []
        self.old_flags = []

    def get_relative_path(self, from_path: str) -> Path:
        return Path(os.path.relpath(self.path.resolve(), start=from_path))

    def check(self):
        ucc = run_packageflag(self.name, mod=mod)
        out = read_stdout(ucc)
        self.old_flags = self.flags
        self.flags = [*filter(lambda x: any(x in l for l in out), PACKAGE_FLAGS)]

    def apply_flags(self, flag_line: str, replace: bool = True):
        new_package_name = f'{self.path.stem}_new{self.path.suffix}'
        output_package = self.dir.joinpath(new_package_name)
        output_package_rel_path = os.path.relpath(output_package, start=ucc_path.parent)
        ucc = run_packageflag(self.name, output_package_rel_path, flag_line=flag_line, mod=mod)
        ucc.communicate()

        if replace and ucc.returncode == 0 and output_package.is_file():
            os.remove(self.path)
            os.rename(output_package, self.path)


# PARSE ARGUMENTS
parser = argparse.ArgumentParser(description=DESCRIPTION, formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('pattern', metavar='PACKAGE_GLOB', type=str, help='package glob pattern')
parser.add_argument('-a', '--add', dest='add_flags', default='', metavar='FLAGS', type=str, nargs='+', choices=PACKAGE_FLAGS)
parser.add_argument('-r', '--remove', dest='remove_flags', default='', metavar='FLAGS', type=str, nargs='+', choices=PACKAGE_FLAGS)
parser.add_argument('--mod', type=str, default=DEFAULT_MOD, help='game mod (default: DarkestHourDev)')

args = parser.parse_args()

pattern = args.pattern
mod = args.mod
mod_path = ro_path.joinpath(mod)
add_flags = args.add_flags
remove_flags = args.remove_flags
flag_line = ' '.join([ f'+{x}' for x in add_flags ] + [ f'-{x}' for x in remove_flags ])


# GATHER PACKAGES
found_paths = [*Path(mod_path).rglob(pattern)]
packages: Iterable[Package] = []

print('\nFound {n} packages:'.format(n=len(found_paths)))

for path in found_paths:
    package = Package(path)
    package.check()
    packages.append(package)
    print(f'{package.get_relative_path(mod_path)}: {package.flags}')

if not flag_line:
    sys.exit(0)


# PROMPT USER
print(f'\nFlags to apply: {flag_line}')
sys.stdout.write('\nDo you want to apply these flags to found packages? [y/n] ')

choice = input().lower()

if not choice == 'y':
    sys.exit(0)

print('')


# APPLY FLAGS
for package in packages:
    package.apply_flags(flag_line)
    package.check()
    print(f'{package.get_relative_path(mod_path)}: {package.old_flags} -> {package.flags}')

