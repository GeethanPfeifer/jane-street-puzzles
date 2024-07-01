# Jane Street Puzzle, June 2024

This directory contains the code that I used to solve Jane Street's June 2024 puzzle. I have edited it to add some (albeit unsatisfactory) comments, remove unnecessary comments, and to remove files containing scratch work or alternate solutions. I haven't actually modified any of the code in this repository (except in adding a sample script), and there is still a lot of redundant/bad code. If this was a real program, I would do things differently: but the code here is mostly "throwaway". Still, you may find some procedures that are useful here.

To use the code in this directory, make sure you have chicken scheme installed and eggs required for the imports as in "full.scm". Then, just load "full.scm". Nothing here is meant to be compiled; it is all designed to be used directly with the Chicken Scheme Interpreter in a REPL environment.

I have included a sample script, which will generate a solution from scratch. Load "sample.scm" after loading "full.scm" in order to run it. This script will take a very long time to run, and is not guaranteed to generate a good solution (it is not deterministic.) When it prints `Finished.`, it isn't actually finished; the script actually finishes when it returns to the REPL. This sample script is not how I generated my actual submission: I just shuffled grids in an ad-hoc manner between text files and the various procedures I've written, and I primarily used data with California excluded. I wrote the sample script after submitting my solution, to demonstrate how one could use the code I've written, as it's not exactly obvious.

## Heuristics and general progress.

All the files used to actually work on solutions are found in `optimize/`.

After I had written and used:

* `optimize/3.scm` I had a solution that could be submitted to the leaderboard.

* `optimize/4.scm` I had a solution that qualified for NOCAL

* `optimize/6.scm` I had a solution that qualified for NOCAL and 200M.

The heuristics I used were: greedy, hill-climbing, and simulated annealing methods.

Simulated annealing was kind of a gimmick, but it pushed me over the 200M mark.

## My submission

My goal was to simultaneously complete the challenges NOCAL and 200M.

My final solution was `tvasweliniarodnkmaeguchwp` with a score of `207606644`, and completed challenges 20S, 200M, PA, and NOCAL.

The states in this solution are `("texas" "florida" "newyork" "pennsylvania" "illinois" "ohio" "georgia" "northcarolina" "virginia" "arizona" "indiana" "maryland" "wisconsin" "colorado" "alabama" "louisiana" "oregon" "utah" "iowa" "nevada" "arkansas" "kansas" "idaho" "hawaii" "maine" "montana" "delaware" "alaska" "vermont")`.

## Licensing

Everything in this directory (including this README) and all subdirectories contained within is licensed under the Unlicense. See `LICENSE` for a copy of said license.

The gist of the license is that I'm placing this code in the public domain: that means that you do _not_ (legally, you still may be required to in order to avoid plagiarism for academic work) have to attribute any code in this directory (though I would appreciate it if you did), and you may use it for any purpose.
