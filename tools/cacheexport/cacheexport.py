import os
import argparse
import configparser
import shutil

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('path')
    parser.add_argument('--outputdir', default=r'.\Export')
    args = parser.parse_args([r'D:\Steam\steamapps\common\Red Orchestra\Cache'])
    config = configparser.RawConfigParser()
    config.read(os.path.join(args.path, 'cache.ini'))
    for key, name in config.items('Cache'):
        outputdir = os.path.join(args.path, args.outputdir)
        if not os.path.exists(outputdir):
            os.mkdir(outputdir)
        src = os.path.join(args.path, key.upper() + '.uxx')
        dst = os.path.join(outputdir, name)
        try:
            shutil.copyfile(src, dst)
            print(src, dst)
        except IOError:
            print('Failed to copy {}'.format(key))
