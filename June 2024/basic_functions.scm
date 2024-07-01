(define (1+ x) (+ 1 x))
	
(define (1- x) (- x 1))

(define (id x) x)
	
#| Integers from 0 to n-1, inclusive. |#
(define
	(range n)
	(letrec
		((range*
			(lambda (n c)
				(cond
					((= n c) '())
					(#t (cons c (range* n (1+ c))))))))
		(range* n 0)))
		
#|
Sequentially applies func to the ith element of each list in "in" until a non-false value is returned.
If no non-false value is returned, return #f.
|#
(define ormap
	(lambda
		(func . in)
		(if (null? (car in)) #f 
			(or
				(apply func (map car in))
				(apply ormap (cons func (map cdr in)))))))

(define string->vector
	(lambda (str)
		(list->vector (string->list str))))
		
(define vector->string
	(lambda
		(vec)
		(list->string (vector->list vec))))
		

#|
Cartesian product of two lists.
Limited by Chicken Scheme's argument limit.
|#
(define cartesian-product2
	(lambda
		(l1 l2)
		(apply
			append
			(map
				(lambda (x)
					(map (lambda (y) (list x y)) l2))
				l1))))
				
#|
Max of lis, with comparator proc.
|#
(define (maxp proc lis)
	(letrec
		((maxp* (lambda (proc lis best)
			(cond
				((null? lis) best)
				((proc best (car lis)) (maxp* proc (cdr lis) (car lis)))
				(#t (maxp* proc (cdr lis) best))))))
		(maxp* proc (cdr lis) (car lis))))

#|
Max of lis, with comparator comp, but stops on a value if bestp applied to it returns true.
|#
(define (maxpb comp bestp lis)
	(letrec
		((maxpb* (lambda (comp bestp lis best)
			(cond
				((null? lis) best)
				((bestp (car lis)) (car lis))
				((comp best (car lis)) (maxpb* comp bestp (cdr lis) (car lis)))
				(#t (maxpb* comp bestp (cdr lis) best))))))
		(maxpb* comp bestp (cdr lis) (car lis))))

#|
Counts the number of unique elements in a list.
|#
(define (countunique lis)
	(hash-table-size (alist->hash-table (cartesian-product2 lis '(#t)))))

#|
Counts the number of unique elements in a vector.
|#
(define (countuniquev lis)
	(countunique (vector->list lis)))
	
#|
Takes a value function and returns a comparator.
|#
(define (comparator valuef)
	(lambda (x y)
		(if (< (valuef x) (valuef y)) #t #f)))

#|
Equality predicate supporting #f and all characters.
|#
(define (char+=? x y)
	(cond
		((and (not x) (not y)) #t)
		((or (not x) (not y)) #f)
		(#t (char=? x y))))
		
#|
Generic cartesian product.
|#
(define (cartesian-product . x)
	(cond
		((null? x) '(()))
		(#t
			(fold-right append '() (map
				(lambda (y)
					(map
						(lambda (z) (cons y z))
						(apply cartesian-product (cdr x))))
				(car x))))))

#|
Random element from a vector.
|#
(define (vector-random-element vec)
	(vector-ref vec (pseudo-random-integer (vector-length vec))))

#|
Applies first argument to second.
|#
(define (apply2 a b) (a b))







