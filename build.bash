#!/usr/bin/env bash

declare BUILD_IMAGE="${BUILD_IMAGE:-treetagger-builder}"
declare BUILD_PREFIX="${BUILD_PREFIX:-treetagger-build-}"
declare OPTIONS="${OPTIONS:-versions/**/options}"

build() {
	declare build_files="${*:-$OPTIONS}"
	: "${build_files:?}"

	docker build -t "$BUILD_IMAGE" builder

	for file in ${build_files}; do
		( source "${file}"
		local release="${RELEASE}"
		local build="${BUILD_PREFIX}${release}"
		local build_options="${BUILD_OPTIONS}"
		local version_dir="$(dirname "${file}")"
		local tags="${TAGS}"

		: "${build:?}" "${tags:?}" "${build_options:?}" "${release:?}"

		docker rm "$build" 2>/dev/null || true

		docker run --rm "$BUILD_IMAGE" ${build_options} > "./${version_dir}/treetagger.tar.gz" || true

        for tag in ${tags}; do
            docker build -t "${tag}" "${version_dir}"
            if [[ "${CIRCLE_BUILD_NUM}" ]]; then
                mkdir -p images \
                && docker tag -f "$tag" "${tag}-${CIRCLE_BUILD_NUM}" \
                && docker save "${tag}-${CIRCLE_BUILD_NUM}" | gzip -c > "images/${tag//\//_}-${CIRCLE_BUILD_NUM}.tar.gz" \
                && docker rmi "${tag}-${CIRCLE_BUILD_NUM}" || true
            fi
        done )
	done
}

testall() {
	declare build_files="${*:-$OPTIONS}"
	declare -a test_files
	for file in ${build_files}; do
		source "${file}"
		local tag
		tag="$(echo "${TAGS}" | cut -d' ' -f1)"
		tag="${tag//:/-}"
		tag="${tag//\//_}"
		test_files+=("test/test_${tag}.bats")
	done
    bats "${test_files[@]}"
}

push() {
	declare build_files="${*:-$OPTIONS}"
	for file in ${build_files}; do
		( source "$file"
		for tag in ${TAGS}; do
			[[ ${PUSH_IMAGE} ]] && docker push ${tag}
		done
		exit 0 )
	done
}

main() {
	set -eo pipefail; [[ "$TRACE" ]] && set -x
	declare cmd="$1"
	case "$cmd" in
		test)	shift;	testall "$@";;
		push)	shift;	push "$@";;
		*)		        build "$@";;
	esac
}

main "$@"