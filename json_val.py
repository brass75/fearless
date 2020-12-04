#!/usr/bin/env python3

import json
import argparse
import os
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def get_val_from_json(filename, field):
    if not os.path.exists(filename):
        eprint(f'ERROR: {filename} not found!')
        sys.exit(1)
    with open(filename) as f:
        data = json.load(f)
    if field not in data:
        eprint(f'ERROR: {field} not present in {filename}')
        sys.exit(2)
    return data[field]

def get_args(args):
    parser = argparse.ArgumentParser(prog='JSON Retriever',
                                     description='Applcation to retrieve a field from a JSON file',)
    parser.add_argument('-f', '--filename', type=str,
                        help='The name of the JSON file.')
    parser.add_argument('-d', '--field', type=str,
                        help='The field to retrieve from the JSON file.')
    return parser.parse_args(args[1:])
    

if __name__ == '__main__':
    args = get_args(sys.argv)
    print(get_val_from_json(args.filename, args.field))