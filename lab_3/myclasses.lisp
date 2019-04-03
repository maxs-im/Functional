(defconstant *PATH* #P"lab_3/data.txt")

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
    ((price :reader read-price :initarg :price :initform 0 :type number)
        (name :accessor name :initarg :name :type string)
        (age :reader read-age :accessor age :initarg :age :initform 22 :type fixnum)))
(defmethod get-age ((obj Toy))
    (parse-age (age obj)))
(defmethod get-name ((obj Toy))
    (format nil "~A (~S)" (name obj) (type-of obj)))
(defmethod toy2str ((obj Toy))
    (format nil "~A for ~S(up to ~D) with price ~D" 
        (get-name obj) (get-age obj) (read-age obj) (read-price obj)))
(defmethod description ((obj Toy))
    "Toy for children garden")

(defclass Ball (Toy)
    ())
(defmethod description((obj Ball))
    "Sport equipment")

(defclass Machine (Toy)
    ())
(defmethod description((obj Machine))
    "Boys loved it")

(defclass Constructor (Toy)
    ())
(defmethod description((obj Constructor))
    "Are you an architect?")

(defclass Doll (Toy)
    ())
(defmethod description((obj Doll))
    "Girls loved it")

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

#|
; testing
(let ((m (make-instance 'Constructor :price 100 :name "lod" :age 5)))
    (print (description m)))

(print (filterinname *storage* "ll"))
|#


; create/delete toy in storage
(defun add-toy (toy name age price)
    (setq *storage* (cons (make-instance toy :name name :age age :price price) *storage*)))
(defun delete-toy ()
    (setq *storage* (cdr *storage*)))

#|
(defun read-data-from-file ()
    (with-open-file (stream *PATH* :direction :input)
        (loop for toy-t = (read stream nil nil)
            while toy-t
                collect (let* (
                    (name (read stream nil nil))
                    (age (read stream nil nil))
                    (price (read stream nil nil)))
                    (make-instance toy-t 
                        :name name
                        :age age
                        :price price)))))
                    

(defun set-data()
    (let ((data (read-data-from-file)))
        (if data 
            (setq *storage* data))))

(defun save-data-to-file ()
    (with-open-file (stream *PATH* :direction :output
            :if-does-not-exist :create
            :if-exists :supersede)
        (loop for item in *storage* do
            ; NOTE: use return for windows
            (format stream "~A ~A ~D ~D~C~&" (type-of item) (name item) (read-age item) (read-price item) #\return))))


(save-data-to-file)
(print *storage*)
(set-data)
(print "____________________")
(print *storage*)
(save-data-to-file)
|#
