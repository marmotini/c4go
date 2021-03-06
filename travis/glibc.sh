#!/bin/bash

set -e

# These steps are from the README to verify it can be installed and run as
# documented.
go build

export C4GO_DIR=$GOPATH/src/github.com/Konstantin8105/c4go
export C4GO=$C4GO_DIR/c4go

# Variable for location of temp files
export GLIBC_TEMP_FOLDER="/tmp/GLIBC"
mkdir -p $GLIBC_TEMP_FOLDER

export GLIBC_VERSION=glibc-2.27

export GLIBC_FILE="qsort"
export GLIBC_FILE_LOCATION="stdlib"

# Download/unpack if required.
if [ ! -e $GLIBC_TEMP_FOLDER/$GLIBC_VERSION.tar.gz ]; then
    curl https://ftp.gnu.org/gnu/glibc/$GLIBC_VERSION.tar.gz > $GLIBC_TEMP_FOLDER/$GLIBC_VERSION.tar.gz
	tar -xvzf $GLIBC_TEMP_FOLDER/$GLIBC_VERSION.tar.gz -C $GLIBC_TEMP_FOLDER/
fi

# Clean generated files. This should not be required, but it's polite.
rm -f $GLIBC_TEMP_FOLDER/$GLIBC_FILE.go

# Transpile files.
echo "Transpiling $GLIBC_FILE.c..."
$C4GO transpile -o=$GLIBC_TEMP_FOLDER/$GLIBC_FILE.go $GLIBC_TEMP_FOLDER/$GLIBC_VERSION/$GLIBC_FILE_LOCATION/$GLIBC_FILE.c

# Show amount "Warning" in Go codes
GLIBC_WARNINGS=`cat $GLIBC_TEMP_FOLDER/$GLIBC_FILE.go | grep "^// Warning" | sort | uniq | wc -l`
echo "In file $GLIBC_FILE summary : $GLIBC_WARNINGS warnings."
