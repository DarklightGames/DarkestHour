import subprocess
import re
import argparse
import os
import tempfile
from typing import Dict, List


class Asset:
    def __init__(self, type_: str, size: int, name: str):
        self.type_ = type_
        self.size = size
        self.name = name

    def __repr__(self):
        return f'{self.name} ({self.type_})'


class Package:
    def __init__(self):
        self.assets: Dict[str, Asset] = {}


DIFF_ADDED = 0
DIFF_MODIFIED = 1
DIFF_DELETED = 2


def get_diff_type_string(type_: int) -> str:
    if type_ == DIFF_DELETED:
        return '-'
    elif type_ == DIFF_MODIFIED:
        return '~'
    elif type_ == DIFF_ADDED:
        return '+'


class Diff:
    def __init__(self, asset: Asset, type_: int):
        self.asset = asset
        self.type_ = type_


class Log:
    f = lambda color: lambda string: print(color + string + "\33[0m")

    black = f("\33[30m")
    red = f("\33[31m")
    green = f("\33[32m")
    yellow = f("\33[33m")
    blue = f("\33[34m")
    magenta = f("\33[35m")
    cyan = f("\33[36m")
    white = f("\33[37m")


def diff_packages(lhs: Package, rhs: Package) -> List[Diff]:
    diffs = []
    # TODO: set diff
    lhs_asset_names = set(lhs.assets.keys())
    rhs_asset_names = set(rhs.assets.keys())

    for name in lhs_asset_names.difference(rhs_asset_names):
        diffs.append(Diff(lhs.assets[name], DIFF_ADDED))

    for name in rhs_asset_names.difference(lhs_asset_names):
        diffs.append(Diff(rhs.assets[name], DIFF_DELETED))

    for name in rhs_asset_names.intersection(lhs_asset_names):
        if lhs.assets[name].size != rhs.assets[name].size:
            diffs.append(Diff(lhs.assets[name], DIFF_MODIFIED))

    return diffs


def load_package(path: str, commit: str):
    path = path.replace('\\', '/')
    with tempfile.NamedTemporaryFile(delete=False) as f:
        show_process = subprocess.Popen(['git', 'show', f'{commit}:{path}'], stdout=subprocess.PIPE)
        lfs_process = subprocess.Popen(['git', 'lfs', 'smudge'], stdin=show_process.stdout, stdout=subprocess.PIPE)
        f.write(lfs_process.stdout.read())
        f.close()

        output = subprocess.Popen(['umodel.exe', '-list', f.name], stdout=subprocess.PIPE)
        lines = output.stdout.read().decode().splitlines(keepends=False)
        irrelevant_types = {'Package', 'Polys', 'KMeshProps', 'Model', 'ROPawnSoundNotify', 'ROWeaponSoundNotify'}
        pattern = r'^\s*(\d+)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+(\w+)\s+(\w+)$'
        regex = re.compile(pattern)

        package = Package()

        for match in filter(lambda m: m and m.group(4) not in irrelevant_types, map(lambda line: regex.match(line), lines)):
            asset = Asset(
                size=int(match.group(3), 16),
                type_=match.group(4),
                name=match.group(5)
            )
            package.assets[asset.name] = asset

        os.remove(f.name)

        return package


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('path')
    parser.add_argument('commit1')
    parser.add_argument('commit2')
    args = parser.parse_args()

    package1 = load_package(args.path, args.commit1)
    package2 = load_package(args.path, args.commit2)

    diffs = diff_packages(package1, package2)

    print(f'{os.path.abspath(args.path)}')
    print(f'{len(diffs)} diffs between {args.commit1} and {args.commit2}')
    added = sum(1 for x in diffs if x.type_ == DIFF_ADDED)
    deleted = sum(1 for x in diffs if x.type_ == DIFF_DELETED)
    modified = sum(1 for x in diffs if x.type_ == DIFF_MODIFIED)
    print(f'{added} added, {modified} modified, {deleted} deleted')

    for diff in diffs:
        string = f'{get_diff_type_string(diff.type_)} {diff.asset.name} [{diff.asset.type_}]'
        if diff.type_ == DIFF_MODIFIED:
            Log.cyan(string)
        elif diff.type_ == DIFF_ADDED:
            Log.green(string)
        elif diff.type_ == DIFF_DELETED:
            Log.red(string)


if __name__ == '__main__':
    main()
