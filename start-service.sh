#!/usr/bin/env bash

set -o nounset
readonly SCRIPT=${0##*/}

function cleanup() { return 0 ; }
trap cleanup EXIT
function die() { echo $@ ; exit 1 ; }

IMG_NAME="purple-cows"

DOCKER_ID_FILE=".running"
SERVICE_DATA_PATH=${SERVICE_DATA_PATH:-"/code/data"}
SERVICE_PORT=${SERVICE_PORT:-8080}

function usage()
{
    cat <<-HELP
    USAGE: $SCRIPT [start | stop | restart ]

    start   - Starts the Purple Cow Counter
    stop    - Stops the Purple Cow Counter
    restart - Stops the Purple Cow Counter and starts it.
    enter   - Enters the running container with a command prompt

    To set the port for the Purple Cow Counter, set the env variable SERVICE_DATA_PATH
    To set the data directory for the Purple Cow Counter, set the env variable SERVICE_PORT

    For more detailed information on using the Purple Cow Counter please read README.md
HELP
}

function start()
{

    if [[ -f ${DOCKER_ID_FILE} ]]; then
        local containter_id=$(cat ${DOCKER_ID_FILE})
        for id in $(docker ps -q); do
            if [[ ${containter_id} =~ ${id} ]]; then
                echo "ERROR: It appears that there's already a container running."
                echo
                usage
                exit 1 
            fi
        done
        rm ${DOCKER_ID_FILE}
    fi         
    port=$(./json_val.py -f config.json -d port)   
    port=${port:-3000}
    docker build -t ${IMG_NAME} . || die "ERROR: Unable to build docker image!"
    mkdir -p $(pwd)/data $(pwd)/log
    docker run -d -p ${port}:${port} \
        -v $(pwd)/data:/code/data \
        -v $(pwd)/log:/code/log \
        -e SERVICE_DATA_PATH=${SERVICE_DATA_PATH} \
        -e SERVICE_PORT=${SERVICE_PORT} \
        ${IMG_NAME} > ${DOCKER_ID_FILE}|| die "ERROR while running the Purple Cow Counter"
}

function stop()
{
    if [[ -f ${DOCKER_ID_FILE} ]]; then
        local containter_id=$(cat ${DOCKER_ID_FILE})
        for id in $(docker ps -q); do
            if [[ ${containter_id} =~ ${id} ]]; then
                docker kill ${id} &> /dev/null || die "ERROR: Unable to stop Purple Cow Counter"
            fi
        done
        rm ${DOCKER_ID_FILE}
    fi   
}

function enter()
{
    if [[ -f ${DOCKER_ID_FILE} ]]; then
        local containter_id=$(cat ${DOCKER_ID_FILE})
        for id in $(docker ps -q); do
            if [[ ${containter_id} =~ ${id} ]]; then
                docker exec -it ${id} /bin/bash
            fi
        done
    else
        die "ERROR: Can't enter a container that is not running!"
    fi   
}

function restart()
{
    if [[ ! -f ${DOCKER_ID_FILE} ]]; then
        echo "ERROR: Purple Cow Counter is not running!"
        echo
        usage
        exit 1
    fi
    stop
    docker run -d -p 8080:8080 -v $(pwd)/data:/code/data ${IMG_NAME} > ${DOCKER_ID_FILE}|| die "ERROR while running the Purple Cow Counter"
}

[[ $# -ne 1 ]] && usage && exit 0

case "$1" in
    start   ) start ;;
    stop    ) stop ;;
    restart ) restart ;;
    enter   ) enter ;;
    test    ) test ;;
    *       ) echo "'$1'is an invalid option."; echo; usage; exit 1
esac