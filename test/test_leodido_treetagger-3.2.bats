#!/usr/bin/env bats

setup() {
    docker history "leodido/treetagger:3.2" >/dev/null 2>&1
    shortcuts=(bulgarian dutch english estonian finnish french galician german italian latin polish portuguese portuguese-finegrained russian slovak spanish swahili)
    params=("bulgarian-utf8" "dutch-utf8" "dutch2-utf8" "english-utf8" "estonian-utf8" "finnish-utf8" "french-utf8" "galician" "german-utf8" "italian-utf8" "latin" "latinIT" "mongolian" "polish-utf8" "portuguese-utf8" "russian-utf8" "slovak-utf8" "slovak2-utf8" "spanish-utf8" "swahili")
    cparams=("english-chunker-utf8" "french-chunker-utf8" "german-chunker-utf8")
}

@test "parameter files are available" {
    for p in "${params[@]}"
    do
        run docker run --rm "leodido/treetagger:3.2" test -e /usr/local/lib/${p}.par
        [ ${status} -eq 0 ]
    done
}

@test "chunker parameter files are available" {
    for cp in "${cparams[@]}"
    do
        run docker run --rm "leodido/treetagger:3.2" test -e /usr/local/lib/${cp}.par
        [ ${status} -eq 0 ]
    done
}

@test "main executable is available" {
    run docker run --rm "leodido/treetagger:3.2" which tree-tagger
    expected="/usr/local/bin/tree-tagger"
    [ ${output} = ${expected} ]
}

@test "version is correct" {
    run docker run --rm "leodido/treetagger:3.2" tree-tagger -version
    [ ${status} -eq 0 ]
    [ ${output} = "Program version is 3.2.1" ]
}

@test "trainer executable is available" {
    run docker run --rm "leodido/treetagger:3.2" which train-tree-tagger
    expected="/usr/local/bin/train-tree-tagger"
    [ ${output} = ${expected} ]
}

@test "shortcut executables are available and have 755 permissions" {
    for name in "${shortcuts[@]}"
    do
        run docker run --rm "leodido/treetagger:3.2" which "tree-tagger-${name}"
        expected="/usr/local/cmd/tree-tagger-${name}"
        [ ${output} = ${expected} ]
        [ ${status} -eq 0 ]
        run docker run --rm "leodido/treetagger:3.2" stat -c "%a" ${expected}
        [ ${output} = 755 ]
    done
}
