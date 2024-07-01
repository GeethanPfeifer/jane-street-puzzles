#|
This is a sample script showing how one could use the code in my program.
This is not how I used the program. (I used it as an interactive REPL.)

This is not deterministic, and will take a long time to run. You are not guaranteed to get a good solution as well.
When the script says "Finished." ignore it. The script is not done until it actually terminates.
|#
(begin
	#| Generates initial solution according to greedy heuristic. |#
	(define km (kingmoves 5 5))
	(define data statepops-h1)
	(define swaps 1)
	(define res1 (opt4 (make-vector 25 #f) km data swaps))
	(print res1)
	
	#| Optimizes this solution with basic hill-climbing.|#
	(define unorderedpairs (up-range 25))
	(define res2 (opt7 (string->vector (first res1)) km data swaps alphabet-o1 unorderedpairs))
	(print res2)
	
	#|Simulated Annealing|#
	(define mods (opt9mods 25 alphabet-o1))
	(define n 2)
	(define k 0)
	(define kmax 1000)
	(define pe (basicpe2 5e7))
	(define res3 (opt10 (string->vector (first res2)) km data swaps alphabet-o1 unorderedpairs mods n k kmax pe res2))
	(print res3))
