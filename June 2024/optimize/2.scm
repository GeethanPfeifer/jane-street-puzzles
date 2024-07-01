#|
2.scm
Hill-climbing using 1-character mutations.

opt3: (Steepest ascent) hill-climbing using opt2.
	Does not traverse equivalent-value nodes.
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
	A grid as a string.
|#
(define
	(opt3 grid kingmoves data swaps alphabet)
	(let
		((betters (opt2 grid kingmoves data swaps alphabet)))
		(cond
			#|
			Base Case: There are no better grids returned by opt2; i.e. we are at a local maxima.
			Return the original grid.
			|#
			((null? betters) (begin (print "Finished.") (vector->string grid)))
			#|
			Recursive Case: There are better grids, select the best one, and run the procedure again.
			|#
			(#t
				(begin
					(print (length betters))
					(let
						((best (maxp (lambda (x y) (< (second x) (second y))) betters)))
						(begin
							(print best)
							(opt3 (string->vector (car best)) kingmoves data swaps alphabet))))))))
