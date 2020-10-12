;The three input for the system
(defrule inputs(initial-fact)
    =>
    (printout t crlf "INPUT VALUES")
    (printout t crlf "IN_A?(0,1):")
    (assert(IN 1 F 1 =(read)))
    (printout t crlf "IN_B?(0,1):")
    (assert(IN 2 F 1 =(read)))
    (printout t crlf "Carry_in(0,1):")
    (assert(IN 3 F 1 =(read))))


;Connections INPUT
;;First Input for X1 and A1
(defrule INPUT1-F1-X1-A1
    (IN 1 F 1 ?a)
    =>
    (assert(IN 1 X 1 ?a))
    (assert(IN 1 A 1 ?a)))

;; Input2 for X1 and A1
(defrule INPUT2-F1-X1-A1
    (IN 2 F 1 ?a)
    =>
    (assert(IN 2 X 1 ?a))
    (assert(IN 2 A 1 ?a)))

;;Carry input for X2 and A2
(defrule INPUT3-F1-X2-A2
    (IN 3 F 1 ?a)
    =>
    (assert(IN 1 A 2 ?a))
    (assert(IN 2 X 2 ?a)))


;OUTPUT
;;Output of X1 for X2 and A2
(defrule OUTPUTX1-X2-A2
    (OUT X 1 ?a)
    =>
    (assert(IN 1 X 2 ?a))
    (assert(IN 2 A 2 ?a)))

;;Output of A1 for O1
(defrule OUTPUTA1-O1
    (OUT A 1 ?a)
    =>(assert(IN 2 O 1 ?a)))

;;Output of A2 for O1
(defrule OUTPUTA2-O1
    (OUT A 2 ?a)
    =>
    (assert(IN 1 O 1 ?a)))

;OVERALL OUTPUT
;;Output of X2 as device output-1
(defrule OUTPUTX2-device1
    (OUT X 2 ?a)
    =>
    (assert(OUT 1 F 1 ?a)))

;;Output of O1 as device output-2
(defrule OUTPUTO1-device2
    (OUT O 1 ?a)
    =>
    (assert(OUT 2 F 1 ?a)))


;Creation of rules for each gate
;;FOR XOR GATE
(defrule X 
    (IN 1 X ?gate ?a1)
    (IN 2 X ?gate ?a2)
    =>
    (if
        (or
            (and
                (= ?a1 0) (= ?a2 0))
            (and
                (=?a1 1) (=?a2 1)))
        then
        (assert(OUT X ?gate 0))
        else
        (assert(OUT X ?gate 1))))

;;FOR AND GATE
(defrule A
    (IN 1 A ?gate ?a1)
    (IN 2 A ?gate ?a2)
    =>
    (if
        (and
            (=?a1 1) (=?a2 1))
        then
        (assert(OUT A ?gate 1))
        else
        (assert(OUT A ?gate 0))))

;;FOR OR GATE
(defrule O
    (IN 1 O ?gate ?a1)
    (IN 2 O ?gate ?a2)
    =>
    (if
        (and
            (=?a1 0) (=?a2 0))
        then
        (assert(OUT O ?gate 0))
        else
        (assert(OUT O ?gate 1))))


;OUTPUT RESULT
(defrule output
    (OUT 1 F 1 ?a1)
    (OUT 2 F 1 ?a2)
    =>
    (printout t crlf "OUTPUT RESULT:")
    (printout t crlf "Sum bit = "?a1"")
    (printout t crlf "C-Out = "?a2""))
(reset)
(run)
