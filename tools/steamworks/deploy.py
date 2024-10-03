import argparse
import os
import fnmatch
import re
import shutil
import sys
import subprocess


# Get the git tag, branch and commit hash.
def get_git_info():
    p = subprocess.Popen(['git', 'tag', '--points-at', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    tag, err = p.communicate()
    tag = tag.decode().strip()
    if p.returncode != 0:
        print('Unable to get git tag')
        sys.exit(1)
    tag = tag if tag != '' else None

    p = subprocess.Popen(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    branch, err = p.communicate()
    branch = branch.decode().strip()
    if p.returncode != 0:
        print('Unable to get git branch')
        sys.exit(1)

    p = subprocess.Popen(['git', 'rev-parse', '--short', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    commit, err = p.communicate()
    commit = commit.decode().strip()
    if p.returncode != 0:
        print('Unable to get git commit')
        sys.exit(1)

    return tag, branch, commit


def write_vdf(vdf: dict, path: str):
    def write_vdf_recursive(key: str, value: dict | str, indent: int) -> str:
        indent_str = ' ' * indent
        if isinstance(value, dict):
            return (f'{indent_str}"{key}"\n'
                    f'{indent_str}{{\n'
                    f'{"".join([write_vdf_recursive(k, v, indent + 1) for k, v in value.items()])}'
                    f'{indent_str}}}\n')
        else:
            return f'{indent_str}"{key}" "{value}"\n'
    contents = ''.join([write_vdf_recursive(k, v, 0) for k, v in vdf.items()])
    with open(path, 'w') as file:
        file.write(contents)


if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('dir', default='.', help='Root directory')
    argparser.add_argument('-mod', required=True, help='Mod name')
    argparser.add_argument('-username', required=True, help='Steam username')
    argparser.add_argument('-password', required=True, help='Steam password')
    argparser.add_argument('-dry', action='store_true', help='Dry run')
    args = argparser.parse_args()

    args.dir = os.path.abspath(args.dir)

    contentbuilder_path = os.path.join(os.path.dirname(__file__), 'sdk', 'tools', 'ContentBuilder')
    content_path = os.path.join(contentbuilder_path, 'content')
    steamcmd_path = os.path.join(contentbuilder_path, 'builder', 'steamcmd.exe')

    os.makedirs(content_path, exist_ok=True)

    # Delete everything in the content path.
    print('Cleaning content path')

    for fname in os.listdir(content_path):
        fpath = os.path.join(content_path, fname)
        try:
            shutil.rmtree(fpath)
        except OSError:
            os.remove(fpath)

    # Find the .steaminclude file
    steaminclude_path = os.path.join(args.dir, args.mod, '.steaminclude')

    if not os.path.exists(steaminclude_path):
        print('unable to find .steaminclude file')
        sys.exit(1)

    print('Found .steaminclude file')

    # Read include and ignore patterns.
    with open(steaminclude_path, 'rb') as f:
        include_patterns = []
        ignore_patterns = []
        for line in filter(lambda x: len(x) > 0, map(lambda x: x.decode().strip(), f.read().splitlines())):
            m = re.match(r'!(.+)', line)
            if m is not None:
                ignore_patterns.append(m.groups()[0])
            else:
                include_patterns.append(line)

    # Walk directory and move files to the content directory.
    print('Copying files to content path')
    for root, dirs, filenames in os.walk(args.dir):
        for filename in filenames:
            is_included = False
            relpath = os.path.relpath(os.path.abspath(os.path.join(root, filename)), args.dir)
            for include_pattern in include_patterns:
                if fnmatch.fnmatch(relpath, include_pattern):
                    is_included = True
                    break
            if not is_included:
                continue
            for ignore_pattern in ignore_patterns:
                if fnmatch.fnmatch(relpath, ignore_pattern):
                    is_included = False
            if not is_included:
                continue
            # Make sure subdirectories exist.
            if not os.path.exists(os.path.join(content_path, os.path.dirname(relpath))):
                os.makedirs(os.path.join(content_path, os.path.dirname(relpath)))
            # Copy file to content path.
            shutil.copy(os.path.join(args.dir, relpath), os.path.join(content_path, relpath))

    # Rename DarkestHourDev to DarkestHour in relevant places.
    for root, dirs, filenames in os.walk(content_path):
        for dir in filter(lambda x: x == 'DarkestHourDev', dirs):
            os.rename(os.path.join(root, dir), os.path.join(root, 'DarkestHour'))

    for root, dirs, filenames in os.walk(content_path):
        for filename in filter(lambda x: os.path.splitext(x)[1] == '.ini', filenames):
            with open(os.path.join(root, filename), 'r+') as f:
                c = f.read().replace('DarkestHourDev', 'DarkestHour')
                f.seek(0)
                f.truncate()
                f.write(c)

    tag, branch, commit = get_git_info()
    build_description = f'{branch}@{commit}'

    if tag is not None:
        build_description = f'{tag}-{build_description}'

    app_1280 = {
        'appbuild': {
            'appid': 1280,
            'desc': build_description,
            'buildoutput': '../output/',
            'contentroot': '../content/',
            'setlive': '',
            'preview': '0',
            'local': '',
            'depots': {
                '1281': 'depot_build_1281.vdf',
                '1282': 'depot_build_1282.vdf',
            }
        }
    }
    app_1290 = {
        'appbuild': {
            'appid': 1290,
            'desc': build_description,
            'buildoutput': '../output/',
            'contentroot': '../content/',
            'setlive': '',
            'preview': '0',
            'local': '',
            'depots': {
                '1291': 'depot_build_1291.vdf',
            }
        }
    }

    # Write the app_build files to the scripts directory in the VDF format.
    write_vdf(app_1280, os.path.join(contentbuilder_path, 'scripts', 'app_build_1280.vdf'))
    write_vdf(app_1290, os.path.join(contentbuilder_path, 'scripts', 'app_build_1290.vdf'))

    # Actually do the thing!
    if not args.dry:
        steamcmd_args = [
            'steamcmd.exe',
            '+login', args.username, args.password,
            '+run_app_build', '../scripts/app_build_1280.vdf',
            '+run_app_build', '../scripts/app_build_1290.vdf',
            '+quit'
        ]

        p = subprocess.Popen(steamcmd_args, executable=steamcmd_path)
        p.wait()
        sys.exit(p.returncode)
    else:
        print('Dry run, not actually deploying')
        sys.exit(0)
