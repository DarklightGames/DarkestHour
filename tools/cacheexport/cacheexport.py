import configparser
import os
import shutil
import argparse


def main():
    argparser = argparse.ArgumentParser()
    argparser.add_argument('directory', default='.', help='cache directory')
    args = argparser.parse_args()

    root = os.path.abspath(args.directory)

    # load the cache file
    config = configparser.ConfigParser()
    cache_path = os.path.join(root, "cache.ini")

    if not os.path.exists(cache_path):
        print(f'Cache file does not exist in directory {root}')
        exit(1)

    config.read(cache_path)
    section = config["Cache"]

    # define the cache directory
    export_dname = "export"
    export_dir = os.path.join(root, export_dname)
    os.makedirs(export_dir)

    # Copying and renaming the cache files
    for key, value in section.items():
        filename = key + ".uxx"
        src = os.path.join(root, filename)
        dst = os.path.join(export_dir, value)

        if os.path.exists(src):
            shutil.copyfile(src, dst)
            print(f"{value} has been exported")
        else:
            print(f"Cache file for {value} doesnt exist")


if __name__ == '__main__':
    main()