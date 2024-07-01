#|
Returns a vector that is a map, with the index as the key, to a list of positions accessible by one kingmove from that square.
|#
(define
	(kingmoves height width)
	(let
		((area (* height width)))
		(list->vector
			(map
				(lambda
					(x)
					(let (
						(ue (>= x width))
						(de (< x (- area width)))
						(le (> (modulo x width) 0))
						(re (> (modulo (1+ x) width) 0)))
						
						(filter id
							(list
								(if (and ue le) (- x width 1) #f)
								(if (and ue) (- x width) #f)
								(if (and ue re) (- x width -1) #f)
								(if (and le) (- x 1) #f)
								(if (and re) (+ x 1) #f)
								(if (and de le) (+ x width -1) #f)
								(if (and de) (+ x width) #f)
								(if (and de re) (+ x width 1) #f)))))
				
				(range area)))))