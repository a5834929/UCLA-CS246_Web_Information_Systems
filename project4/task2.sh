#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "usage: task2.sh <corpus dir> <number of topics>"
    exit 1
fi

INPUT_DIR=$1
NUM_TOPICS=$2

mallet import-dir --input $INPUT_DIR --output topic-input.mallet --keep-sequence --remove-stopwords

mallet train-topics --input topic-input.mallet --num-topics $NUM_TOPICS --output-topic-keys topic-words.txt --output-doc-topics doc-topics.txt