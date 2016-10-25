import argparse
import os
import fnmatch
import re
import shutil
import sys

argparser = argparse.ArgumentParser()
argparser.add_argument('dir', default='.', help='root directory')
argparser.add_argument('-mod', required=True, help='mod name')
args = argparser.parse_args(['../..', '-mod=DarkestHourDev'])

args.dir = os.path.abspath(args.dir)

content_path = os.path.join(os.path.dirname(__file__), 'sdk', 'tools', 'ContentBuilder', 'content')

if not os.path.exists(content_path):
    print 'unable to find content directory (%s)' % content_path
    sys.exit(1)


# delete everything in the content path
for fname in os.listdir(content_path):
    fpath = os.path.join(content_path, fname)
    try:
        shutil.rmtree(fpath)
    except OSError:
        os.remove(fpath)

steaminclude_path = os.path.join(args.dir, args.mod, '.steaminclude')

if not os.path.exists(steaminclude_path):
    print 'unable to find .steaminclude file'
    sys.exit(1)

# read include and ignore patterns
with open(steaminclude_path, 'rb') as f:
    include_patterns = []
    ignore_patterns = []
    for line in filter(lambda x: len(x) > 0, map(lambda x: x.strip(), f.read().splitlines())):
        m = re.match(r'\!(.+)', line)
        if m is not None:
            ignore_patterns.append(m.groups()[0])
        else:
            include_patterns.append(line)

# now walk directory and move files to the content directory
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
        # make sure subdiretories exist
        if not os.path.exists(os.path.join(content_path, os.path.dirname(relpath))):
            os.makedirs(os.path.join(content_path, os.path.dirname(relpath)))
        # copy file to 
        shutil.copy(os.path.join(args.dir, relpath), os.path.join(content_path, relpath))

# rename darkesthourdev to darkesthour in relevant places
# rename folders and content (OfficialMod, Default.ini)
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