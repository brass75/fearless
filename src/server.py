#!/usr/bin/env python3
from flask import Flask
import requests
import os
import json
import sys

app = Flask(__name__)

######################################################################################
#                                                                                    #
#                                      Constants                                     #
#                                                                                    #
######################################################################################

HTML_DIR = os.path.realpath(os.path.join(os.path.dirname(__file__), '..', 'html'))
STYLE_DIR = os.path.realpath(os.path.join(os.path.dirname(__file__), '..', 'styles'))
CONFIG_FILE = os.path.realpath(os.path.join(os.path.dirname(__file__), '..', 'config.json'))
DEFAULT_PORT = 3000
DEFAULT_KEY = "1ccb732e-b55a-4404-ad3f-0f99c02fe44e"
DEFAULT_NS = "dmstest"

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

######################################################################################
#                                                                                    #
#                                Server Functions                                    #
#                                                                                    #
######################################################################################

@app.route('/')
def counter_page():
    '''
    Function to read and return counter.html
    '''
    if not os.path.exists(os.path.join(HTML_DIR, 'counter.html')):
        eprint('ERROR: Unable to open counter.html! Exiting!')
        return('Internal server error', 500)
    with open(os.path.join(HTML_DIR, 'counter.html')) as f:
        return f.read()

@app.route('/get_auth')
def get_key():
    '''
    Function to return the key and namespace
    '''
    return json.dumps({'port': port, 'key': key, 'namespace': namespace})

@app.route('/styles/<file>')
def get_style(file):
    '''
    Function to read and return a stylesheet file
    '''
    if os.path.exists(os.path.join(STYLE_DIR, file)):
        with open(os.path.join(STYLE_DIR, file)) as f:
            return f.read()
    return (f'Unable to find {file}', 404)


if __name__ == '__main__':
    config = {}
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE) as f:
            config = json.load(f)
    port = config.get('port', DEFAULT_PORT)
    key = config.get('key', DEFAULT_KEY)
    namespace = config.get('namespace', DEFAULT_NS)
    app.run('0.0.0.0', port, debug=False)
