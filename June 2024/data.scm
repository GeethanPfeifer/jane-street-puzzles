#|
Transcribed by hand from https://en.wikipedia.org/wiki/2020_United_States_census#State_rankings
This should be public domain.
|#
(define
	statepops-raw
	'(
		("california" 39538223)
		("texas" 29145505)
		("florida" 21538187)
		("newyork" 20201249)
		("pennsylvania" 13002700)
		("illinois" 12812508)
		("ohio" 11799448)
		("georgia" 10711908)
		("northcarolina" 10439388)
		("michigan" 10077331)
		("newjersey" 9288994)
		("virginia" 8631393)
		("washington" 7705281)
		("arizona" 7151502)
		("massachusetts" 7029917)
		("tennessee" 6910840)
		("indiana" 6785528)
		("maryland" 6177224)
		("missouri" 6154913)
		("wisconsin" 5893718)
		("colorado" 5773714)
		("minnesota" 5706494)
		("southcarolina" 5118425)
		("alabama" 5024279)
		("louisiana" 4657757)
		("kentucky" 4505836)
		("oregon" 4237256)
		("oklahoma" 3959353)
		("connecticut" 3605944)
		("utah" 3271616)
		("iowa" 3190369)
		("nevada" 3104614)
		("arkansas" 3011524)
		("mississippi" 2961279)
		("kansas" 2937880)
		("newmexico" 2117522)
		("nebraska" 1961504)
		("idaho" 1839106)
		("westvirginia" 1793716)
		("hawaii" 1455271)
		("newhampshire" 1377529)
		("maine" 1362359)
		("rhodeisland" 1097379)
		("montana" 1084225)
		("delaware" 989948)
		("southdakota" 886667)
		("northdakota" 779094)
		("alaska" 733391)
		("vermont" 643077)
		("wyoming" 576851)))
	
(define statepops
	(map
		(lambda
			(x)
			(list
				(string->list (first x))
				(second x)))
		statepops-raw))
		
(define alphabet
	(string->vector "qwertyuiopasdfghjklzxcvbnm"))
	
#| The letter 'q' does not appear in any state's name, so we can omit it. |#
(define alphabet-o1
	(string->vector "wertyuiopasdfghjklzxcvbnm"))
	
	
#|
State populations, sorted by:
	Population / (# of unique chars - 1)
max to min.
|#
(define statepops-h1
	(let*
		(	(h1 (lambda (x)
				(/ (second x) (countunique (first x)))))
			(c1 (lambda (x y)
				(> (h1 x) (h1 y))))) #| we want reverse order, i.e. max first |#
		(list-sort c1 statepops)))
		
#|
The same as above, but without California.
|#
(define statepops-h1-nocalifornia
	(let*
		(	(h1 (lambda (x)
				(/ (second x) (countunique (first x)))))
			(c1 (lambda (x y)
				(> (h1 x) (h1 y)))))
		(list-sort c1 (cdr statepops))))