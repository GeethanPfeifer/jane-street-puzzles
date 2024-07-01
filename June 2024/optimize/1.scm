#|
1.scm
1-character mutations.

opt1: Improves a grid by doing all 1-character mutations in the grid, and selecting the best resultant grid.
opt2: opt1, but more efficient. (Should be twice as fast.)
|#



#|
Inputs:
	grid
	kingmoves
	data
	swap
	alphabet:		vector of replacement characters
	
Mutability:
	This procedure mutates the grid, but reverts it to its original state.
	
Returns:
	A list of triples as per "describe" in score.scm, which are improvements on the original grid.
|#
(define
	(opt1 grid kingmoves data swaps alphabet)
	(let	(
		(iscore (score grid kingmoves data swaps))
		(mutates (cartesian-product2 (range (vector-length grid)) (vector->list alphabet))))
		
		(filter
			(lambda (x) (> (second x) iscore))
			(map
				(lambda (x)
					(let
						((res #f) (org (vector-ref grid (first x))))
						(begin
							(print x)
							(vector-set! grid (first x) (second x))
							(set! res (list
								(vector->string grid)
								(score grid kingmoves data swaps)
								(statesin grid kingmoves data swaps)))
							(vector-set! grid (first x) org)
							res)))
				mutates))))


(define
	(opt2 grid kingmoves data swaps alphabet)
	(let	(
		(iscore (score grid kingmoves data swaps))
		(mutates (cartesian-product2 (range (vector-length grid)) (vector->list alphabet))))
		
		(filter
			(lambda (x) (> (second x) iscore))
			(map
				(lambda (x)
					(let
						((res #f) (org (vector-ref grid (first x))))
						(begin
							
							(print x)
							(vector-set! grid (first x) (second x))
							(set! res (describe grid kingmoves data swaps))
							(vector-set! grid (first x) org)
							res)))
				mutates))))

