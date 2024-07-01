#|
Determines whether "string" is in "grid" (vector) starting at "pos" with pre-generated "kingmoves" and "swaps" alterations available.
|#
(define
	(stringatpos? grid kingmoves string pos swaps)
	(cond
		#| Base Case 1: String is empty. |#
		((null? string) #t)
		#| Base Case 2: grid[POS] != string[0], and there are 0 alterations available.|#
		((and
			(not (eqv? (vector-ref grid pos) (car string)))
			(= swaps 0))
			#f)
		#| Recurisve Case 1: grid[POS] = string[0] |#
		((eqv? (vector-ref grid pos) (car string))
			(let* ((kingmoves* (vector-ref kingmoves pos))
				(lenk (length kingmoves*))) 
				(ormap
					stringatpos?
					(make-list lenk grid)
					(make-list lenk kingmoves)
					(make-list lenk (cdr string))
					kingmoves*
					(make-list lenk swaps))))
					
						
		#| Recursive Case 2: grid[POS] != string[0], but there are alterations available. |#
		(#t
			(let* ((kingmoves* (vector-ref kingmoves pos))
				(lenk (length kingmoves*))) 
				(ormap
					stringatpos?
					(make-list lenk grid)
					(make-list lenk kingmoves)
					(make-list lenk (cdr string))
					kingmoves*
					(make-list lenk (1- swaps)))))))
#|
Determines whether "string" is in "grid" (vector) at any position with pre-generated "kingmoves" and "swaps" alterations available.
|#
(define
	(stringingrid? grid kingmoves string swaps)
	(let
		((leng (vector-length grid)))
		(ormap
			stringatpos?
			(make-list leng grid)
			(make-list leng kingmoves)
			(make-list leng string)
			(range leng)
			(make-list leng swaps))))
#|
Determines the score of "grid", with pregenerated "kingmoves", "data" as per data.scm, and "swaps" alterations allowed per state.
Limited by Chicken Scheme's argument limit.
|#
(define
	(score grid kingmoves data swaps)
		(apply +
			(map second
				(filter
					(lambda (x)
						(stringingrid? grid kingmoves (first x) swaps))
				data))))

#|
The same as above, but determines the score in the grid, not the score.
|#
(define
	(statesin grid kingmoves data swaps)
	(map (lambda (x) (list->string (first x)))
		(filter
			(lambda (x)
				(stringingrid? grid kingmoves (first x) swaps))
		data)))

#|
Generates a 3-tuple (str, score, states) where:
	str		is the grid as a string.
	score	is the score as per "score"
	states	is the states as per "statesin"
|#
(define
	(describe grid kingmoves data swaps)
	(let ((filtered
		(filter
			(lambda (x)
				(stringingrid? grid kingmoves (first x) swaps))
		data)))
		
		(list (vector->string grid)
			(apply + (map second filtered))
			(map (lambda (x) (list->string (first x))) filtered))))
