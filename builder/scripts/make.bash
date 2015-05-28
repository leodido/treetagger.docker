#!/usr/bin/env bash

# Build script
# @author   leodido   <leodidonato@gmail.com>

declare HOME_URL=${HOME_URL:-http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data}
declare PARAMS_URL=${PARAMS_URL:-https://dl.dropboxusercontent.com/u/8459129}
declare STDOUT=1

set -eo pipefail; [[ "$TRACE" ]] && set -x

[[ "$(id -u)" -eq 0 ]] || {
	printf >&2 '%s requires root\n' "$0" && exit 1
}

usage() {
	printf >&2 '%s -r release\n' "$0" && exit 1
}

output_redirect() {
	if [[ "$STDOUT" ]]; then
		cat - 1>&2 # redirect stdout to stderr
	else
		cat -
	fi
}

build() {
    if [ -z $1 ]; then
        exit 1
    fi
    declare version="$1"
    local dest="$(mktemp -d "${TMPDIR:-/var/tmp}/treetagger-${version}-XXXXXXXXXX")"
    # download
    curl -sSL "${HOME_URL}/tree-tagger-linux-${version}.tar.gz" | tar xz -C ${dest} | output_redirect
    curl -sSL "${HOME_URL}/tagger-scripts.tar.gz" | tar xz -C ${dest} | output_redirect
    curl -k -sSL "${PARAMS_URL}/treetagger-params-${version}.tar.gz" | tar xz -C ${dest} | output_redirect
    # installation
    (cd ${dest} && /install.bash ${version}) | output_redirect
    # clean up
    rm -rf ${dest}/params/ ${dest}/chunkerparams/
    # save
    tar -p -z -f /treetagger.tar.gz --numeric-owner -C "${dest}" -c .
    if [[ "$STDOUT" ]]; then
	    cat /treetagger.tar.gz
	else
	    return 0
	fi
}

main() {
    while getopts ":r:" opt; do
        case ${opt} in
            r) VERSION="$OPTARG";;
            *) usage;;
        esac
    done
    build "$VERSION"
}

main "$@"
