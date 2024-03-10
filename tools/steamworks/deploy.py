import argparse
import os
import fnmatch
import re
import shutil
import sys
import subprocess

argparser = argparse.ArgumentParser()
argparser.add_argument('dir', default='.', help='root directory')
argparser.add_argument('-mod', required=True, help='mod name')
argparser.add_argument('-username', required=True, help='steam username')
argparser.add_argument('-password', required=True, help='steam password')
args = argparser.parse_args()

args.dir = os.path.abspath(args.dir)

contentbuilder_path = os.path.join(os.path.dirname(__file__), 'sdk', 'tools', 'ContentBuilder')
content_path = os.path.join(contentbuilder_path, 'content')
steamcmd_path = os.path.join(contentbuilder_path, 'builder', 'steamcmd.exe')

if not os.path.exists(content_path):
    print('unable to find content directory ({})'.format(content_path))
    sys.exit(1)

# Delete everything in the content path.
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

# Get the git tag, branch and commit hash.
def get_git_info():
    p = subprocess.Popen(['git', 'describe', '--tags'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    tag, err = p.communicate()
    tag = tag.decode().strip()
    if p.returncode != 0:
        print('unable to get git tag')
        sys.exit(1)

    p = subprocess.Popen(['git', 'rev-parse', '--abbrev-ref', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    branch, err = p.communicate()
    branch = branch.decode().strip()
    if p.returncode != 0:
        print('unable to get git branch')
        sys.exit(1)

    p = subprocess.Popen(['git', 'rev-parse', '--short', 'HEAD'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    commit, err = p.communicate()
    commit = commit.decode().strip()
    if p.returncode != 0:
        print('unable to get git commit')
        sys.exit(1)

    return tag, branch, commit

tag, branch, commit = get_git_info()

build_description = f'{tag}-{branch}@{commit}'

# Actually do the thing!
args = ['steamcmd.exe',
        '+login', args.username, args.password,
        '+run_app_build', '../scripts/app_build_1280.vdf',
        '+run_app_build', '../scripts/app_build_1290.vdf',
        '+quit']

p = subprocess.Popen(args, executable=steamcmd_path)
p.wait()

sys.exit(p.returncode)
