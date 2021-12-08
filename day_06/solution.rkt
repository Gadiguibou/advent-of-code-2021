#lang typed/racket

(: count (All (A) (-> (-> A Boolean) (Listof A) Integer)))
(define (count proc list)
  (foldl (lambda ([x : A] [acc : Integer]) (+ acc (if (proc x) 1 0))) 0 list))

(: prepend (All (A) (-> (Listof A) (Listof A) (Listof A))))
(define (prepend l1 l2)
  (foldl (lambda ([x : A] [acc : (Listof A)]) (cons x acc)) l2 (reverse l1)))

(: repeat (All (A) (-> A Integer (Listof A))))
(define (repeat x n)
  (letrec ([repeat-aux : (-> Integer (Listof A) (Listof A))
                       (lambda (n acc)
                         (if (= n 0)
                             acc
                             (repeat-aux (- n 1) (cons x acc))))])
    (repeat-aux n '())))

(define (update-lanternfishes [lanternfishes : (Listof Integer)]) : (Listof Integer)
  (let ([ready-lanternfishes (count (lambda ([x : Integer]) (= x 0)) lanternfishes)]
        [updated-lanternfishes
         (map (lambda ([x : Integer])
                (if (= x 0)
                    6
                    (- x 1)))
              lanternfishes)])
    (prepend (repeat 8 ready-lanternfishes) updated-lanternfishes)))

(: napply (All (A) (-> (-> A A) Integer A A)))
(define (napply proc n x)
  (if (= n 0)
      x
      (napply proc (- n 1) (proc x))))

(: update-lanternfishes-n-times (-> Integer (Listof Integer) (Listof Integer)))
(define (update-lanternfishes-n-times n lanternfishes)
  (napply update-lanternfishes n lanternfishes))

(: parse-lanternfishes (-> String (Listof Integer)))
(define (parse-lanternfishes s)
  (map (lambda ([x : String]) (assert (string->number x) exact-integer?))
       (string-split s ",")))

(: zip (All (A B) (-> (Listof A) (Listof B) (Listof (Pair A B)))))
(define (zip la lb)
  (letrec ([zip-aux : (-> (Listof A) (Listof B) (Listof (Pairof A B)) (Listof (Pairof A B)))
                    (lambda (la lb acc)
                      (if (and (not (null? la)) (not (null? lb)))
                          (zip-aux (rest la) (rest lb) (cons (cons (first la) (first lb)) acc))
                          acc))])
    (reverse (zip-aux la lb '()))))

(: update-lanternfish-table (-> (HashTable Integer Integer) (HashTable Integer Integer)))
(define (update-lanternfish-table lanternfish-table)
  (let* ([ready-lanternfishes (hash-ref lanternfish-table 0 (lambda () 0))]
         [rotated-lanternfishes
          (make-immutable-hash (hash-map
                                lanternfish-table
                                (lambda ([k : Integer] [v : Integer])
                                  (cons (- k 1) v))))]
         [updated-lanternfishes
          (hash-remove (hash-update
                        rotated-lanternfishes
                        6
                        (lambda ([x : Integer])
                          (+ x (hash-ref rotated-lanternfishes -1 (lambda () 0))))
                        (lambda () 0)) -1)])

    (hash-update updated-lanternfishes 8 (lambda ([x : Integer]) (+ x ready-lanternfishes)) (lambda () 0))))

(: update-lanternfish-table-n-times (-> Integer (HashTable Integer Integer) (HashTable Integer Integer)))
(define (update-lanternfish-table-n-times n lanternfish-table)
  (napply update-lanternfish-table n lanternfish-table))

(: make-lanternfish-table (-> (Listof Integer) (HashTable Integer Integer)))
(define (make-lanternfish-table lanternfishes)
  (: initial-table (Immutable-HashTable Integer Integer))
  (define initial-table (hash))
  (foldl (lambda ([x : Integer]
                  [table : (Immutable-HashTable Integer Integer)])
           (hash-update table x add1 (lambda () 0)))
         initial-table
         lanternfishes))

(let* ([lanternfishes
        (parse-lanternfishes (port->string))]
       [lanternfish-table
        (make-lanternfish-table lanternfishes)])
  (printf "Part 1: ~a~nPart2: ~a~n"
          (length (update-lanternfishes-n-times 80 lanternfishes))
          (foldl
           (lambda ([x : (Pair Integer Integer)] [acc : Integer]) (+ acc (cdr x)))
           0
           (hash->list (update-lanternfish-table-n-times 256 lanternfish-table)))
          ))
