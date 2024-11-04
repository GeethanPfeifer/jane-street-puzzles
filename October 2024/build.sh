#!/bin/sh

mkdir bin
g++ src/bf.cpp -o bin/bf
g++ src/bf1.cpp -o bin/bf1
g++ src/verify.cpp -o bin/verify
cp src/bf_threaded.py bin/bf_threaded.py
