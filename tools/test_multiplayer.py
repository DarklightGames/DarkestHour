import argparse
import subprocess
import pprint
import os
import shutil
from multiprocessing import Process


def spawn_client(args, index):
    cloned_client_path = f'{os.path.splitext(args.client_path)[0]}_{index}.exe'
    shutil.copyfile(args.client_path, cloned_client_path)
    client_args = [
        # 'start',
        cloned_client_path,
        args.multihome,
        f'-mod={args.mod}',
        "-log=DHClient_%RANDOM%.log"
    ]
    subprocess.Popen(client_args)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mod')
    parser.add_argument('--server_path', default='System\\ucc.exe')
    parser.add_argument('server_args')
    parser.add_argument('--client_path', default='System\\RedOrchestraLargeAddressAware.exe')
    parser.add_argument('--multihome', default='127.0.0.1')
    parser.add_argument('--pktlag', default=0)
    parser.add_argument('--pktloss', default=0)
    parser.add_argument('--unsafe', default=False)
    args = parser.parse_args()

    # get input from the about how many users they want to test
    while True:
        try:
            number_of_clients = int(input('Enter the number of clients you would like to spawn:'))
            if not args.unsafe and number_of_clients > 3:
                print('Number of clients is too high in unsafe mode. Use --unsafe to unlock unlimited client spawning')
            break
        except ValueError as e:
            print('Unrecognized number, try again.')

    server_args = [
        args.server_path,
        'server',
        args.server_args,
        f'-mod={args.mod}',
        f'-ini={args.mod}.ini',
        f'pktlag={int(args.pktlag)}',
        f'pktloss={int(args.pktloss)}'
    ]

    rodir = os.environ['RODIR']
    os.chdir(rodir)
    p = subprocess.Popen(server_args)

    if not os.path.exists(args.client_path):
        raise RuntimeError('Client path does not exist')

    client_processes = []
    for client_index in range(number_of_clients):
        client_process = Process(target=spawn_client, args=(args, client_index))
        client_processes.append(client_process)
        client_process.run()

    p.communicate()

    for client_process in client_processes:
        client_process.kill()


if __name__ == '__main__':
    main()
