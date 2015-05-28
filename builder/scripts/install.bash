#!/usr/bin/env bash

# Installation script (call me from directory containing sources)
# @author   leodido   <leodidonato@gmail.com>

mkdir -p cmd
mkdir -p lib
mkdir -p bin
mkdir -p doc

PARAM_DIR=params
CPARAM_DIR=chunkerparams
VERSION="$@"
COMMAND_FILES=${PWD}/cmd/*

if [ -z ${VERSION} ]; then
    echo 'No version string provided.'
    exit 1
fi

# Install TreeTagger
if [ -r tree-tagger-linux-${VERSION}.tar.gz ]; then
    gzip -cd tree-tagger-linux-${VERSION}.tar.gz | tar -xf -
    echo 'TreeTagger installed.'
else
    echo 'Assuming TreeTagger already installed.'
fi

# Install tagging scripts
if [ -r tagger-scripts.tar.gz ]; then
    gzip -cd tagger-scripts.tar.gz | tar -xf -
    echo 'Tagging scripts installed.'
else
    echo 'Assuming tagging scripts already installed.'
fi

# Install parameter files
for PARAM in $(find ${PARAM_DIR} -type f -name "*.bin.gz"); do
    PARAM=$(basename ${PARAM})
    NAME=$(echo ${PARAM} | sed -r -e "s/-par-linux-${VERSION}(-utf8)?.bin.gz//g")
    OUTPUT="${NAME^} parameter file"
    if [ $(echo ${PARAM} | grep "utf8") ]; then
        NAME="${NAME}-utf8"
        OUTPUT="${OUTPUT} (UTF8)"
    fi
    gzip -cd ${PARAM_DIR}/${PARAM} > lib/${NAME}.par
    echo "${OUTPUT} installed. Path: lib/${NAME}."
done

# Install chunker parameter files
for CPARAM in $(find ${CPARAM_DIR} -type f -name "*.bin.gz"); do
    CPARAM=$(basename ${CPARAM})
    LANG=${CPARAM%%-*}
    NAME=$(echo ${CPARAM} | cut -d '-' -f 1,2)
    OUTPUT="${LANG^} chunker parameter file"
    if [ $(echo ${CPARAM} | grep "utf8") ]; then
        NAME="${NAME}-utf8"
        OUTPUT="${OUTPUT} (UTF8)"
    fi
    gzip -cd ${CPARAM_DIR}/${CPARAM} > lib/${NAME}.par
    echo "${OUTPUT} installed. Path: lib/${NAME}"
done

# Edit path variables of tagging scripts
FINAL_DIR=/usr/local
for file in ${COMMAND_FILES}
do
    awk '$0=="BIN=./bin"{print "BIN='"${FINAL_DIR}"'/bin";next}\
         $0=="CMD=./cmd"{print "CMD='"${FINAL_DIR}"'/cmd";next}\
         $0=="LIB=./lib"{print "LIB='"${FINAL_DIR}"'/lib";next}\
         {print}' "${file}" > "${file}.tmp";
    mv "${file}.tmp" "${file}";
done
echo 'Path variables modified in tagging scripts.'
echo 'Done.'
