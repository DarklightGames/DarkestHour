from ast import xucc
import os
import argparse

argparser = argparse.ArgumentParser()
argparser.add_argument('dir', default='.', help='root directory')
argparser.add_argument('package')
argparser.add_argument('-mod', required=True, help='mod name')
argparser.add_argument('-clean', required=False, action='store_true', help='compile all packages')
args = argparser.parse_args(['C:\Users\colin_000\Documents\GitHub\DarkestHour', 'DH_GerPlayers', '-mod', 'DarkestHour'])

package_dir = os.path.join(args.dir, args.package)
package_classes_dir = os.path.join(package_dir, 'Classes')
package_intermediate_dir = os.path.join(package_dir, 'UCPP')

try:
    os.mkdir(package_intermediate_dir)
except WindowsError:
    pass

# ucpp package ?

for filename in filter(lambda x: x.endswith('.uc'), os.listdir(package_classes_dir)):
    print 'Parsing ' + filename
    s = xucc.compile(open(os.path.join(package_classes_dir, filename)).read())
    with open(os.path.join(package_intermediate_dir, filename), 'w+') as f:
        f.write(s)
