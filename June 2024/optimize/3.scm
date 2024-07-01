#|
3.scm
Generating an initial grid using a greedy method.

Auxiliary procedures: numunique, roam

opt4: Takes a grid (initially filled with #f) and repeatedly adds the most valuable states, while adding the least characters, changing no existing characters, and passing over the state if such a thing is impossible.
|#


#|
Number of unique characters in string that are not in grid.

Inputs:
	grid
	string
	
Mutability:
	None.
	
Returns:
	#{c | c appears in string, c does not appear in grid}
|#
(define (numunique grid string)
	(let	
		#|SRFI-69 uses cdr alists, not cadr alists.|#
		((gridm (alist->hash-table (cartesian-product2 (vector->list grid) '(#t)))))
		(countunique
			(filter
				(lambda
					(x)
					(not (hash-table-ref/default gridm x #f)))
				string))))

#|
Recursively adds a string to the grid.
Uses backtracking.

There is some code duplication.

Inputs:
	grid		
	kingmoves
	swaps
	string
	poss				List of positions to look at.
	val:				Number of changed characters at current node.
	bestval:			Best possible "val" of a terminal success. (Not the best found)
	bestfound:		Best terminal success.
	
Mutatibility:
	None, as far as I can tell.
	
Output:
	#f or a pair (grid, val), where "grid" is a vector and "val" is the number of characters added to the grid.
|#
(define (roam grid kingmoves swaps string poss val bestval bestfound)
	(cond
		#|Base Case 0: val > best found val: terminate.|#
		((and bestfound (> val (second bestfound))) bestfound)
		#|Base Case 1: poss is empty: terminate|#
		((null? poss) bestfound)
		#|Base Case 2: string is empty: return (grid, val)|#
		((null? string) (list (vector-copy grid) val)) #| only time I need to copy a vector I think. |#
		#|
		Recursive Case 1: grid[poss[0]] = string[0].
		There is no need to swap characters, just recursively try all nodes stemming from poss[0], and all other nodes in poss.
		|#
		((eqv? (vector-ref grid (car poss)) (car string))
			(let ((res
				(roam
					grid
					kingmoves
					swaps
					(cdr string)
					#| This is potentially inefficient as list-sort is being run often, and unnecessarily.
					However, the length of the list is at most 8. |#
					(list-sort
						(comparator
							(lambda
								(x)
								(cond
									((or (null? (cdr poss)) (null? (cdr string))) 0) #| Order doesn't matter when it's either the terminal element of poss or string. |#
									((eqv? (vector-ref grid (cadr poss)) (cadr string)) 1) #| Best case: we do not need to alter/add a character |#
									((vector-ref grid (cadr poss)) 2) #| 2nd Best Case: we need to alter a character. |#
									(#t 3)))) #| 3rd Best Case: we need to add a new character |#
						(vector-ref kingmoves (car poss)))
					val
					bestval
					bestfound)))
				(cond
					((not res) (roam grid kingmoves swaps string (cdr poss) val bestval bestfound)) #|If this node returns #f, try the next node in poss.|#
					((<= (second res) bestval) res) #|If the best possible value is found, return it and terminate.|#
					((or (not bestfound) (< (second res) (second bestfound))) #|If the result is better than bestfound, replace it.|#
						(roam grid kingmoves swaps string (cdr poss) val bestval res))
					(#t (roam grid kingmoves swaps string (cdr poss) val bestval bestfound)))))#|Otherwise, just move to the next node in poss.|#
		
		#|
		Recursive Case 2: We need to write a new character. We will recurse as in Case 1, but increase val by 1.
		|#
		((not (vector-ref grid (car poss)))
			(let
				((res #f))
				(begin
					(vector-set! grid (car poss) (car string))
					(set! res
						(roam
							grid
							kingmoves
							swaps
							(cdr string)
							(list-sort
								(comparator
									(lambda
										(x)
										(cond
											((or (null? (cdr poss)) (null? (cdr string))) 0)
											((eqv? (vector-ref grid (cadr poss)) (cadr string)) 1)
											((vector-ref grid (cadr poss)) 2)
											(#t 3))))
								(vector-ref kingmoves (car poss)))
							(1+ val)
							bestval
							bestfound))
					(vector-set! grid (car poss) #f)
					(cond
						((not res) (roam grid kingmoves swaps string (cdr poss) val bestval bestfound))
						((<= (second res) bestval) res)
						((or (not bestfound) (< (second res) (second bestfound)))
							(roam grid kingmoves swaps string (cdr poss) val bestval res))
						(#t (roam grid kingmoves swaps string (cdr poss) val bestval bestfound))))))
		
		#|
		Base Case 4: We need to alter the current character in the grid. Unfortunately, swaps are not available.
		I may have overlooked looking at the other positions in poss.
		|#
		((= swaps 0) bestfound)
		#|Recursive Case 3: We need to alter the current character in the grid. Swaps are available.|#
		((> swaps 0)
			(let 
				((res
					(roam
						grid
						kingmoves
						(1- swaps)
						(cdr string)
						(list-sort
							(comparator
								(lambda
									(x)
									(cond
										((or (null? (cdr poss)) (null? (cdr string))) 0)
										((eqv? (vector-ref grid (cadr poss)) (cadr string)) 1)
										((vector-ref grid (cadr poss)) 2)
										(#t 3))))
							(vector-ref kingmoves (car poss)))
						val
						bestval
						bestfound)))
				(cond
					((not res) (roam grid kingmoves swaps string (cdr poss) val bestval bestfound))
					((<= (second res) bestval) res)
					((or (not bestfound) (< (second res) (second bestfound)))
						(roam grid kingmoves swaps string (cdr poss) val bestval res))
					(#t (roam grid kingmoves swaps string (cdr poss) val bestval bestfound)))))))

#|
Inputs:
	grid
	kingmoves
	data
	swap
	
Mutability:
	None, as far as I can tell.
	
Returns:
	Description of grid generated by repeatedly running roam for all states, replacing all empty spaces with 'z'.
	This description is broken, in that it doesn't return the number of states or the score. But it returns the grid fine.
|#
(define (opt4 grid kingmoves data swaps)
	(begin
		(if (null? data) #f (print (list->string (caar data))))
		(print (list->string (map (lambda (x) (if x x #\space)) (vector->list grid))))
		(cond
			#|Base Case 1: No states left: return description of grid|#
			((null? data) (describe (vector-map (lambda (i x) (if x x #\z)) grid) kingmoves data swaps))
			#|Recursive Case 1: Head state is already in grid: move on to next state|#
			((stringingrid? grid kingmoves (caar data) swaps)
				(opt4 grid kingmoves (cdr data) swaps))
			#|Recursive Case 2: Try to add head state to the grid. If it is possible, update the grid.|#
			(#t
				(opt4
					(or
						(car
							(or (roam
									grid
									kingmoves
									swaps
									(caar data)
									(range (vector-length grid))
									0
									(numunique grid (caar data))
									#f)
								'(#f)))
						grid)
					kingmoves
					(cdr data)
					swaps)))))
