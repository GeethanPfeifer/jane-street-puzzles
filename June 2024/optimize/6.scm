#|
6.scm
Simulated annealing (in conjunction with hill climbing.)

Auxiliary procedures: charmods, cyclemods3, opt9mods, randommutate, basicpe, basicpe2

opt9: Simulated annealing using mutations generated by opt9mods. Does not store best.
opt10: opt9, but stores best.
|#

#|
Inputs:
	area				Area of grid
	alphabet			
	
Mutability:
	None in the function itself.
	Returns functions that mutate.
	
Returns:
	Vector of all functions which change one character in a grid vector of area area to a character in alphabet.
|#
(define (charmods area alphabet)
	(list->vector
		(map
			(lambda (x)
				(lambda (grid)
					(let ((ngrid (vector-copy grid)))
						(begin (vector-set! ngrid (first x) (second x))
						ngrid))))
			(cartesian-product2
				(range area)
				(vector->list alphabet)))))
				
#|
Inputs:
	area			
	alphabet			
	
Mutability:
	None in the function itself.
	Returns functions that mutate.
	
Returns:
	Vector of all functions which mutate a grid vector according to some 3-cycle. (See 5.scm)
|#

(define (cyclemods3 area)
	(list->vector
		(map
			(lambda (x)
				(lambda (grid)
					(let ((ngrid (vector-copy grid)))
						(begin
							(cycle-vec! ngrid x)
							ngrid))))
			(threecycles area))))

#|
charmods and cyclemods3 together
|#
(define (opt9mods area alphabet)
	(vector-append (charmods area alphabet)(cyclemods3 area)))
	

#|
Inputs:
	grid			
	mods			vector of functions mutating a grid
	n				number of mutations to make
	
Mutability:
	Mutates the grid.
	
Returns:
	grid, with n random mutations from mods applied to it.
|#
(define
	(randommutate grid mods n)
	(let
		((selectedmods
			(map
				vector-random-element
				(make-list n mods))))
		(fold-right apply2 grid selectedmods)))
		

#|
This is a basic linear (w.r.t nscore) probability acceptance function.
	basicpe|(nscore = pscore) = 1
	basicpe|(nscore = pscore - 1e7 * (kmax - k)/kmax) = 0.
The formula itself was generated using xcas (transcribed by hand.)
|#
(define (basicpe pscore nscore k kmax)
	(+
		(* 
			kmax nscore (/ 1 1e7 (- kmax k)))
		(/
			(+ (* kmax pscore) (* 1e7 k) (* -1e7 kmax))
			(* 1e7 (- k kmax)))))
			
#|
The same as basicpe, but instead of 1e7, allows a different constant.
|#
(define (basicpe2 btm)
	(lambda (pscore nscore k kmax)
		(+
			(* 
				kmax nscore (/ 1 btm (- kmax k)))
			(/
				(+ (* kmax pscore) (* btm k) (* -1 btm kmax))
				(* btm (- k kmax))))))


#|
Inputs:
	grid
	kingmoves
	data
	swaps
	alphabet
	unorderedpairs
	mods
	n
	k				k iterator (simulated annealing)
	kmax			kmax constant (simulated annealing)
	pe				probability acceptance function. pe : pscore, nscore, k, kmax --> R
	
Mutability:
	Mutates the grid.
	
Returns:
	A triple as per "describe" in score.scm
|#
(define (opt9 grid kingmoves data swaps alphabet unorderedpairs mods n k kmax pe)
	(begin (print k)
		(cond
			#|Base Case: k = kmax, terminate.|#
			((= k kmax) (begin (print "Finished.") (describe grid kingmoves data swaps)))
			#|Recursive Case|#
			(#t
				(let*
					((pscore (score grid kingmoves data swaps))
						(ngrid (randommutate grid mods n))
						(nscore (score ngrid kingmoves data swaps)))
					(begin
						(print (vector->string ngrid))
						(cond
							#|Recursive Case A: Accept this new grid.|#
							((> (pe pscore nscore k kmax) (pseudo-random-real))
								(begin
									(print "Accept.")
									#|Hill Climb using opt7, and then recurse.|#
									(opt9	
										(string->vector (first (opt7 ngrid kingmoves data swaps alphabet unorderedpairs)))
										kingmoves
										data
										swaps
										alphabet
										unorderedpairs
										mods
										n
										(1+ k)
										kmax
										pe)))
							#|Recursive Case B: Decline this new grid (keep the old one.)|#
							(#t (opt9 grid kingmoves data swaps alphabet unorderedpairs mods n (1+ k) kmax pe)))))))))
							
#|
Inputs:
	grid
	kingmoves
	data
	swaps
	alphabet
	unorderedpairs
	mods
	n
	k				
	kmax			
	pe				
	best				description of best grid found
	
Mutability:
	Mutates the grid.
	
Returns:
	A triple as per "describe" in score.scm.
|#

(define (opt10 grid kingmoves data swaps alphabet unorderedpairs mods n k kmax pe best)
	(begin (print k)
		(cond
			((= k kmax) (begin (print "Finished.") best))
			(#t
				(let*
					((pscore (score grid kingmoves data swaps))
						(ngrid (randommutate grid mods n))
						(nscore (score ngrid kingmoves data swaps)))
					(begin
						(print (vector->string ngrid))
						(cond
							((> (pe pscore nscore k kmax) (pseudo-random-real))
								(begin
									(print "Accept.")
									(let
										((hc (opt7 ngrid kingmoves data swaps alphabet unorderedpairs)))
										(opt10	
											(string->vector (first hc))
											kingmoves
											data
											swaps
											alphabet
											unorderedpairs
											mods
											n
											(1+ k)
											kmax
											pe
											(cond
												((> (second hc) (second best)) hc)
												(#t best)
											
											)))))
							(#t (opt10 grid kingmoves data swaps alphabet unorderedpairs mods n (1+ k) kmax pe best)))))))))			






