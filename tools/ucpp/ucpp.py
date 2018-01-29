from ast import ucpp
import os
import argparse
from binascii import crc32
import json

argparser = argparse.ArgumentParser()
argparser.add_argument('dir', default='.', help='root directory')
argparser.add_argument('package')
argparser.add_argument('-mod', required=True, help='mod name')
argparser.add_argument('-clean', required=False, action='store_true', help='compile all packages')
args = argparser.parse_args(['C:\Users\colin_000\Documents\GitHub\DarkestHour', 'UCore', '-mod', 'DarkestHour', '-clean'])

package_dir = os.path.join(args.dir, args.package)
package_classes_dir = os.path.join(package_dir, 'Classes')
package_intermediate_dir = os.path.join(package_dir, 'UCPP')

try:
    os.mkdir(package_intermediate_dir)
except WindowsError:
    pass

# Read CRC manifest
manifest_path = os.path.join(package_intermediate_dir, '.ucpp')
crcs = dict()

if not args.clean:
    try:
        with open(manifest_path) as f:
            crcs = json.loads(f.read())
    except IOError:
        print 'No .ucpp file, rebuilding all...'
        pass

skip_count = 0
preprocess_count = 0

# Iterate through all files in the package.
for filename in filter(lambda x: x.endswith('.uc'), os.listdir(package_classes_dir)):
    print filename
    path = os.path.join(package_classes_dir, filename)
    contents = open(path).read()
    # Run CRC32 on the contents of the file
    crc = crc32(contents)
    if crcs.has_key(filename) and crcs[filename] == crc and os.path.exists(os.path.join(package_intermediate_dir, filename)):
        # The file has been unchanged since the last pre-processor run, skip pre-processing
        skip_count += 1
        continue
    # Update the file's CRC record
    crcs[filename] = crc
    # Run pre-processor
    ast = ucpp.compile(contents)
    s = ucpp.render(ast)
    preprocess_count += 1
    # Write pre-processed output to file
    with open(os.path.join(package_intermediate_dir, filename), 'w+') as f:
        f.write(s)

# Write CRC manifest
with open(manifest_path, 'w+') as f:
    f.write(json.dumps(crcs))