#!/bin/bash

# Set default vars here - or pass in from command line
JOBSERVER="jj"
SOURCE="asd"
DEST="asd"
PASSWORD=""

# Run with default opts
if [ -z "$JOBSERVER" ] && [ -z "$SOURCE" ] && [ -z "$TARGET" ] && [ -z "$PASSWORD" ]; then

 while [[ $# -gt 1 ]]
 do
 key="$1"
 case $key in
    -s|--source)
    SOURCE="$2"
    shift # past argument
    ;;
    -t|--target)
    DEST="$2"
    shift # past argument
    ;;
    -j|--jobserver)
    JOBSERVER="$2"
    shift # past argument
    ;;
    -p|--password)
    PASSWORD="$2"
    shift
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
 esac
 shift # past argument or value
 done	

else

 echo "Using Default Variables"

fi

echo PASSS = "$PASSWORD"
echo JOBS  = "$JOBSERVER"
echo DEST     = "$DEST"
echo SOURCE    = "$SOURCE"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
