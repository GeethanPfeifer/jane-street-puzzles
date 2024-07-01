#|
5.scm
Mutations based on 3-cycles.

Auxiliary procedures: threepaths, cyclify, threecycles, threecyclesv, cycle-vec!

opt8: Goes through a list of 3-cycles and makes any possible improvement to a given grid.
|#


#|
All integer triplets (a, b, c) with:
	0 <= a < b, c < n
|#
(define (threepaths n)
	(filter
		(lambda (x)
			(let
				((a (first x))
					(b (second x))
					(c (third x)))
				
				(and
					(not
						(or (= a b) (= a c) (= b c)	
							(> a b) (> a c))))))	
		(cartesian-product (range n) (range n) (range n))))

#|
Converts a list representing a path to a cycle (by appending the first element to the end of the list).
|#
(define (cyclify lis)
	(append lis (list (car lis))))

#|
threepaths' output, converted to cycles.
|#
(define (threecycles n)
	(map	
		cyclify
		(threepaths n)))


#|
threecycles' output, converted to vectors.
|#
(define (threecyclesv n)
	(map list->vector (threecycles n)))
	
	

#|
Takes a vector vec, and a cycle (of indices).
Modifies the vector, such that:
	vec_after[cycle[i]] = vec_before[cycle[i+1]]
	
(That is, the cycle is backwards. e.g. 1 <-- 2 <-- 4 <-- 1)
The output is vec_before[cycle[0]], not the vector.
|#
(define (cycle-vec! vec cycle)
	(cond
		((null? cycle) #f)
		((null? (cdr cycle)) (vector-ref vec (car cycle)))
		(#t (let
			((c (vector-ref vec (car cycle))))
			(begin
				(vector-set! vec (car cycle) (cycle-vec! vec (cdr cycle)))
				c)))))

#|
Inputs:
	grid
	kingmoves
	data
	swaps
	triplets			Not actually triplets, but 3-cycles.
	
Mutability:
	Mutates the grid.
	
Returns:
	A triple as per "describe" in score.scm
|#
(define (opt8 grid kingmoves data swaps triplets best)
	(if (null? triplets) best 
		(let ((cr #f))
			(begin
				(cycle-vec! grid (car triplets))
				(set! cr (describe grid kingmoves data swaps))
				(cond
					((> (second cr) (second best))
						(begin
							(print (car triplets))
							(opt8 grid kingmoves data swaps (cdr triplets) cr)))
					(#t (begin
						(cycle-vec! grid (reverse (car triplets)))
						(opt8 grid kingmoves data swaps (cdr triplets) best))))))))

