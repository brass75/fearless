# Take Home Test - Fearless
- Dan Shernicoff
- 12/4/2020
- Solution in:
    - HTML/JavaScript (JQuery)
    - CSS
    - Python
    - bash
- Tested with 
    - Chrome 86 
    - Safari 14 
    - Python 3.9 
    - MacOS 11

# Building the Solution 

There are no steps required to build the solution. 

# Running the Solution

## To run in Docker

On a computer with bash run `./start-service.sh start` to start the server and `./start-service.sh stop` to stop the server from the directory with the solution.

## To run on a local machine without Docker

To run on the local machine the server can be run by running `src/server.py`. If this fails due to a `ModuleNotFoundError` the modules specified in `requirements.txt` must be installed. The easiest way to do this is to run `pip3 install -r requirements.txt`

## Configuration

All configuration is done in the [`config.json`](config.json) file in the root directory of the solution.

### Port

Set the `port` field to the port you wish to use. If this field is not set, the default port, `3000`, will be used.

#### NOTE:

Changing the default port requires changing bother [`server.py`](src/server.py) and [`start-service.sh`](start-service.sh).

### API Key

Set the `key` field to the API key to be used. If this field is not set, the default API key, `1ccb732e-b55a-4404-ad3f-0f99c02fe44e`, will be used.

### Namespace

Set the `namespace` field to the namespace to be used. If this field is not set, the default namespace, `dmstest`, will be used.

# Design considerations, assumptions, and future features

This was done as a simple project to give access to 1 counter. With minor modifications it could server as a portal to multiple counters.

In part due to the time constraint and the desire to reduce complexity, static CSS and HTML pages were used instead of templates. 

While the key is not secret (it's part of the address so it can't be) I felt it to be more secure to have the webpage query the server to retrieve the key and namespace rather than embedding it in the page. Beyond security, this also allows for the simple webpage to be used for more than one counter by simply modifying the underlying Python that is the server.

Some ideas for future features:

- Multiple counters programatically determined through the configuration file
- Configurable color schemes
- Configurable page header
- Use of countapi.xyz APIs beyond `hit` 