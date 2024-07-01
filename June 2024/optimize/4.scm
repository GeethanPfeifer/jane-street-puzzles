#|
4.scm
Hill-climbing using pair swaps.

Auxiliary procedures: km->ups, km2->ups, km3->ups, up-range

opt5: Repeatedly improving a grid by swapping pairs of elements. It attempts this once for every pair given.
opt6: Hill-climbing using opt5. (Repeatedly running it until no improvement can be made.)
opt7: Hill-climbing using both opt3 and opt6.
|#


#|
Set of unordered pairs of elements in a grid which are one kingmove apart.
Limited by Chicken Scheme's argument limit.

Inputs:
	kingmoves
	
Mutability:
	None.
	
Returns:
	List of unordered pairs
|#
(define (km->ups kingmoves)
	(filter
		(lambda (x) (< (first x) (second x)))
		(apply append 				
			(vector->list
				(vector-map
					(lambda (i x)		
						(cartesian-product2 (list i) x))
					kingmoves)))))
					
#|
Inputs:
	grid
	kingmoves
	data
	swaps
	unorderedpairs:		List of unordered pairs to attempt swaps on.
	
Mutability:
	Mutates the grid.
	
Returns:
	A list of triples as per "describe" in score.scm
|#
(define (opt5 grid kingmoves data swaps unorderedpairs)
	(begin
		(let
			((iscore (score grid kingmoves data swaps)))
			
			(map
				(lambda (x)
					(begin
						(vector-swap! grid (first x) (second x))
						(if (> (score grid kingmoves data swaps) iscore) (print x) (vector-swap! grid (first x) (second x)))))
				unorderedpairs))
		(describe grid kingmoves data swaps)))
				
#|
Inputs:
	grid
	kingmoves
	data
	swaps
	unorderedpairs:		List of unordered pairs to attempt swaps on.
	
Mutability:
	Mutates the grid.
	
Returns:
	A triple as per "describe" in score.scm
|#
(define (opt6 grid kingmoves data swaps unorderedpairs)
	(let*
		(	(iscore (score grid kingmoves data swaps))
			(cscore (second (opt5 grid kingmoves data swaps unorderedpairs))))
		(if (= cscore iscore) (describe grid kingmoves data swaps) (opt6 grid kingmoves data swaps unorderedpairs))))



#|
Set of unordered pairs of elements in a grid which are two kingmoves apart.
Limited by Chicken Scheme's argument limit.

Inputs:
	kingmoves
	
Mutability:
	None.
	
Returns:
	List of unordered pairs
|#
(define (km2->ups kingmoves)
	(filter
		(lambda (x) (< (first x) (second x)))
		(delete-duplicates	
			(apply append
				(map
					(lambda (x)
						(cartesian-product2 (list (first x)) (vector-ref kingmoves (second x))))
					(km->ups kingmoves))))))

#|
Inputs:
	grid
	kingmoves
	data
	swaps
	alphabet
	unorderedpairs:		List of unordered pairs to attempt swaps on.
	
Mutability:
	Mutates the grid.
	
Returns:
	A triple as per "describe" in score.scm
|#
(define (opt7 grid kingmoves data swaps alphabet unorderedpairs)
	(let
		(	(iscore (score grid kingmoves data swaps))
			(cscore (opt6 (string->vector (opt3 grid kingmoves data swaps alphabet)) kingmoves data swaps unorderedpairs)))
		(if (> (second cscore) iscore)
			(opt7 (string->vector (car cscore)) kingmoves data swaps alphabet unorderedpairs)
			(describe grid kingmoves data swaps))))

#|
Set of unordered pairs of elements in a grid which are three kingmoves apart.
Limited by Chicken Scheme's argument limit.

Inputs:
	kingmoves
	
Mutability:
	None.
	
Returns:
	List of unordered pairs
|#
(define (km3->ups kingmoves)
	(filter
		(lambda (x) (< (first x) (second x)))
		(delete-duplicates		
			(apply append	
				(map
					(lambda (x)
						(cartesian-product2 (list (first x)) (vector-ref kingmoves (second x))))
					(km2->ups kingmoves))))))
					
#|
All pairs of integers (i, j) satisfying
	0 <= i < j < n
|#
(define (up-range n)
	(filter
		(lambda (x) (< (first x) (second x)))
		(cartesian-product2 (range n) (range n))))