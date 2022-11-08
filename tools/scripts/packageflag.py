import os
import sys
import subprocess
import argparse
from enum import Enum
from struct import unpack
from typing import Iterable 
from pathlib import Path

class Flag(Enum):
    AllowDownload: int = 1  # Allow downloading package.
    ClientOptional: int = 2 # Purely optional for clients.
    ServerSideOnly: int = 4 # Only needed on the server side.
    BrokenLinks: int = 8    # Loaded from linker with broken import links.
    Unsecure: int = 16      # Not trusted.

    def names() -> Iterable[str]:
        return [ flag.name for flag in __class__]
    
    def from_str(*flags: str) -> int:
        return sum([ __class__[f].value for f in flags])

    def from_mask(bitmask: int) -> Iterable[str]:
        return [ f.name for f in __class__ if bitmask & f.value ]
    
    def pretty_from_mask(bitmask: int) -> str:
        return f'[{bitmask}] {", ".join(__class__.from_mask(bitmask)) if bitmask > 0 else ""}'

    
DEFAULT_MOD = 'DarkestHourDev'
DESCRIPTION='''\
Wrapper for the UCC packageflag command.

flags:
  {packages}
'''.format(packages='\n  '.join(Flag.names()))


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
        self.path_relative_to_mod = os.path.relpath(self.path, start=mod_path)
        self.dir = Path(path.parent)
        self.name = self.path.name
        self.flags = 0
        self.old_flags = 0

    def check(self, show_old_flags: bool = False) -> None:
        with open(self.path, 'rb') as f:
            data = f.read(12)
            self.old_flags = self.flags
            self.flags = unpack(b'<IHHI', data)[3]

            pretty_output = '{pkg}: {old}{cur}'.format(pkg=self.path_relative_to_mod,
                                                       old=f'{Flag.pretty_from_mask(self.old_flags)} -> ' if show_old_flags else '',
                                                       cur=Flag.pretty_from_mask(self.flags))
            print(pretty_output)

    def apply_flags(self, flag_line: str, replace: bool = True) -> None:
        if self.flags & (add_mask & ~remove_mask) == self.flags:
            print(f'{self.path_relative_to_mod}: No changes')
            return

        new_package_name = f'{self.path.stem}_new{self.path.suffix}'
        output_package = self.dir.joinpath(new_package_name)
        output_package_rel_path = os.path.relpath(output_package, start=ucc_path.parent)
        ucc = run_packageflag(self.name, output_package_rel_path, flag_line=flag_line, mod=mod)
        ucc.communicate()

        if ucc.returncode != 0:
            print(f'{self.path_relative_to_mod}: Failed')
            return
        
        if replace and ucc.returncode == 0 and output_package.is_file():
            os.remove(self.path)
            os.rename(output_package, self.path)

        self.check(show_old_flags=True)


# PARSE ARGUMENTS
parser = argparse.ArgumentParser(description=DESCRIPTION, formatter_class=argparse.RawDescriptionHelpFormatter)
parser.add_argument('pattern', metavar='PACKAGE_GLOB', type=str, help='package glob pattern')
parser.add_argument('-a', '--add', dest='add_flags', default='', metavar='FLAGS', type=str, nargs='+', choices=Flag.names())
parser.add_argument('-r', '--remove', dest='remove_flags', default='', metavar='FLAGS', type=str, nargs='+', choices=Flag.names())
parser.add_argument('--mod', type=str, default=DEFAULT_MOD, help='game mod (default: DarkestHourDev)')

args = parser.parse_args()

pattern = args.pattern
mod = args.mod
mod_path = ro_path.joinpath(mod)
flag_line = ' '.join([ f'+{x}' for x in args.add_flags ] + [ f'-{x}' for x in args.remove_flags ])
add_mask = Flag.from_str(*args.add_flags)
remove_mask = Flag.from_str(*args.remove_flags) 

# GATHER PACKAGES
found_paths = [*Path(mod_path).rglob(pattern)]
packages: Iterable[Package] = []

print('\nFound {n} packages:'.format(n=len(found_paths)))

for path in found_paths:
    package = Package(path)
    package.check()
    packages.append(package)

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
