# Jane Street Puzzle, October 2024

This directory contains the code that I used to solve Jane Street's October 2024 puzzle. I have only made slight edits, mostly in actually organising the files and giving them sane names. (Trust me, they were worse before.)

To compile the code, run ```build.sh```.

## verify.cpp

The first program I made was a program for verifying whether a solution is valid. This was also the last program I modified, as I forgot to add in checks for whether a square is visited multiple times.

## bf1.cpp

This was the second program I made, which was an experiment to see whether it was a viable option to brute force every path. It took almost two hours to enumerate all paths from one corner to another, so I figured that this would be a viable option, assuming that the optimal A+B+C is small, and if I use threading.

## bf.cpp

This program tries to find a valid solution for a given A, B, and C. 

## bf_threaded.py

I figured that it would be easiest to try to do the threading in python instead of in C++, as I'm new to C++.

This program spawns multiple subprocesses of bf, which each run bf for different values of A, B, and C.

After running this program, I found out that bothering with threading was a waste of time, because it found solutions very quickly. I assume that backtracking after getting a score over 2024 makes a huge difference with the number of paths that need to be searched.

## My submission

I submitted ```1,3,2,a1,b3,a5,c6,e5,c4,d6,b5,d4,e2,c3,a2,b4,c2,a3,b1,d2,e4,f6,a6,c5,e6,d4,c6,a5,b3,c1,a2,b4,d5,f6,e4,d6,c4,e5,d3,e1,c2,e3,f1```, which is (obviously) an optimal solution.

## What I learned

This is the first non-trivial thing I have written in C++. I would be surprised if I had written over 20 lines of C++ prior to doing this puzzle. Next time, maybe I should actually do OOP. I also learned a bit about python subprocesses and threading in general, even though it turned out to be pointless in the end.

## Licensing

Everything in this directory (including this README) and all subdirectories contained within is licensed under the Unlicense. See `LICENSE` for a copy of said license.

The gist of the license is that I'm placing this code in the public domain: that means that you do _not_ (legally, you still may be required to in order to avoid plagiarism for academic work) have to attribute any code in this directory (though I would appreciate it if you did), and you may use it for any purpose.

