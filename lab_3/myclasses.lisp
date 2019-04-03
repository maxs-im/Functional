(defun parse-age (val)
    (cond 
        ((<= val 1) "Baby")
        ((<= val 3) "Toddler")
        ((<= val 5) "Preschool")
        ((<= val 12) "Gradeschooler")
        ((<= val 18) "Teen")
        ((<= val 21) "Young Adult")
        (t "Adult")))

(defclass Toy ()
    ((price :reader read-price :initarg :price :initform 0)
        (name :accessor name :initarg :name :type string)
        (age :reader read-age :accessor age :initarg :age :initform 22)))
(defmethod get-age ((obj Toy))
    (parse-age (age obj)))
(defmethod get-name ((obj Toy))
    (format nil "~A (~S)" (name obj) (type-of obj)))
(defmethod toy2str ((obj Toy))
    (format nil "~A for ~S(up to ~D) with price ~D" 
        (get-name obj) (get-age obj) (read-age obj) (read-price obj)))

(defclass Ball (Toy)
    ())

(defclass Machine (Toy)
    ())

(defclass Constructor (Toy)
    ())
(defmethod get-name ((obj Constructor))
    (format nil "Constructor of ~A" (name obj)))

(defclass Doll (Toy)
    ())

; user data
(defparameter *storage* '())
(defparameter *budget* 10000)

(setf *storage* (list
    (make-instance 'Ball :name "llab1" :age 7 :price 100)
    (make-instance 'Machine :name "enicham1" :age 9 :price 2000)
    (make-instance 'Constructor :name "rotcurtsnoc1" :age 5 :price 150)
    (make-instance 'Doll :name "llod1" :age 15 :price 50)
    (make-instance 'Ball :name "llab1" :age 10 :price 250)
    (make-instance 'Machine :name "enicham1" :age 20 :price 100)
    (make-instance 'Constructor :name "rotcurtsnoc1" :age 3 :price 5)
    (make-instance 'Doll :name "llod1" :age 2 :price 250)))


; sorting functions
(defun sortbyprice (toys)
    (sort toys (lambda (t1 t2) (>= (read-price t1) (read-price t2)))))
(defun sortbyage (toys)
    (sort toys (lambda (t1 t2) (>= (read-age t1) (read-age t2)))))
(defun sortbyname (toys)
    (sort toys(lambda (t1 t2) (string>= (name t1) (name t2)))))

; filtering functions
(defun filterinprice (toys from to)
    (remove-if-not (lambda (t0) (and (>= (read-price t0) from) (<= (read-price t0) to))) toys))
(defun filterinage (toys from to)
    (remove-if-not (lambda (t0) (and (>= (read-age t0) from) (<= (read-age t0) to))) toys))
(defun filterinname (toys sub-name)
    (remove-if-not (lambda (t0) (search sub-name (name t0) :test 'char=)) toys))

; testing
(let ((m (make-instance 'Constructor :price 100 :name "lod" :age 5)))
    (print (get-name m)))

(print (filterinname *storage* "ll"))