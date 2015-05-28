treetagger.docker
=================

This repository contains docker images to build and ship ready to use [TreeTagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/) instances.

You will not have to manually install TreeTagger in your system again.

What it is
----------

**A tool for annotating text with part-of-speech** ([POS tagging](http://en.wikipedia.org/wiki/Part-of-speech_tagging)) **and lemma information**.

TreeTagger consists of two programs:

1. `train-tree-tagger`

    Creates a parameter file from a lexicon and a handtagged corpus. 
    
2. `tree-tagger` 

    Annotates the text with part-of-speech tags, given a parameter file and a text file as arguments.

This image contains:

- training program at `train-tree-tagger`

- tagger program at `tree-tagger`       

- program for tokenization (used by the shell scripts) at `separate-punctuation`

- shell scripts (shortcuts) which simplify tagging and chunking:

    e.g., `tree-tagger-italian`, `tree-tagger-german`, `tagger-chunker-english`, ...
    
- parameter files, chunker parameter files, and abbreviations

- documentaion and language tagsets references


See yourself them:

```bash
$ docker run -i -t leodido/treetagger:latest ls /usr/local
```

Installation
------------

Directly pull this image from the docker index.

```
$ docker pull leodido/treetagger:latest
```

Usage
-----

### Tagging

Suppose you want to (tokenize and) tag an Italian text.

The script to use is `tree-tagger-italian <file>*`.

It expects UTF8 encoded input files as arguments. If no files have been specified, input from stdin is expected.

```bash
$ echo 'Proviamo semplicemente a eseguire un test di prova.' | docker run --rm -i leodido/treetagger:latest tree-tagger-italian
```

Outputs:

```
Proviamo	    VER:pres	provare
semplicemente	ADV	        semplicemente
a	            PRE	        a
eseguire	    VER:infi	eseguire
un	            DET:indef	un
test	        NOM	        test
di	            PRE	        di
prova	        NOM	        prova
.	            SENT	    .
```

Now, try with some Portuguese.

```bash
$ echo 'Qual é o seu nome?' | docker run --rm -i leodido/treetagger:latest tree-tagger-portuguese
```

Results:

```
Qual	PT0	    qual
é	     VMI	 ser
o	    DA0	    o
seu	    DP3	    seu
nome	NCMS	nome
?	    Fit	?
```

```bash
$ echo 'Qual é o seu nome?' | docker run --rm -i leodido/treetagger:latest tree-tagger-portuguese-finegrained
```

Results:

```
Qual	PT0CS000	qual
é       VMIP3S0	 ser
o	    DA0MS0	    o
seu	    DP3MSS	    seu
nome	NCMS000	    nome
?	    Fit	        ?
```

And so on for other supported languages.


### Chunking

Suppose you want to tokenize, tag and annotate a German text with nominal and verbal chunks.

```bash
$ echo 'Das ist ein Test.' | docker run -i leodido/treetagger:latest tagger-chunker-german
```

Outputs:

```xml
<NC>
Das	    PDS	    die
</NC>
<VC>
ist	    VAFIN	sein
</VC>
<NC>
ein	    ART	    eine
Test	NN	    Test
</NC>
.	    $.	    .
```

Supported languages
-------------------

1. Bulgarian
2. Dutch
3. English
4. Estonian
5. Finnish
6. French
7. Galician
8. German
9. Italian
10. Latin
11. Portuguese
12. Polish
13. Russian
14. Slovak
15. Spanish
16. Swahili
17. Mongolian (only parameter file provided, no scripts)

Todos
-----

- Add support for Chinese, and Spoken French.

Credits
-------

- Helmut Schmid, University of Stuttgart, Germany - [TreeTagger](http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger).

_Last update: 28/05/2015_

---

[![Analytics](https://ga-beacon.appspot.com/UA-49657176-1/treetagger.docker)](https://github.com/igrigorik/ga-beacon)
