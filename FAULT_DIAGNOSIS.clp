(deftemplate MAIN::problem_X2_gate
   "(Implied)" 
   (multislot __data))

(deftemplate MAIN::problem_O1_gate
   "(Implied)" 
   (multislot __data))

;Fault Diagnosis
(defrule fault_diagnosis
    (initial-fact)
    =>
    (printout t crlf "INPUT VALUES")
    (printout t crlf "IN_A?(0,1):")
    (assert(IN 1 F 1 =(read)))
    (printout t crlf "IN_B?(0,1):")
    (assert(IN 2 F 1 =(read)))
    (printout t crlf "Carry_in?(0,1):")
    (assert(IN 3 F 1 =(read)))
    
    (printout t crlf "DESIRED OUTPUTS")
    (printout t crlf "Sum_bit?(0,1):")
    (assert(OUT 1 F 1 =(read)))
    (printout t crlf "C-Out?(0,1):")
    (assert(OUT 2 F 1 =(read))))

(defrule fault
    (IN 1 F 1 ?IN_1)
    (IN 2 F 1 ?IN_2)
    (IN 3 F 1 ?Carry_in)
    (OUT 1 F 1 ?Sum_bit)
    (OUT 2 F 1 ?C-Out)
    =>

;;If there is any error in the sum bit, 
;;the error should be detected starting with X2 and focus o the other outputs that were an input to X2
    (if
        (or 
            (and
                (= ?IN_1 ?IN_2)
                (= ?Carry_in 1)
                (= ?Sum_bit 0))
            (and
                (= ?IN_1 ?IN_2)
                (= ?Carry_in 0)
                (= ?Sum_bit 1))
            (and
                (neq ?IN_1 ?IN_2)
                (= ?Carry_in 0)
                (= ?Sum_bit 0))
            (and
                (neq ?IN_1 ?IN_2)
                (= ?Carry_in 1)
                (= ?Sum_bit 1)))
        then
        (assert(problem_X2_gate)))
    
    
;;If there is any error in the Carry-out,
;;the error should be detetcted starting with O1 and focus on the other outputs that were an input to O1
    (if 
        (or
            (and
                (= ?IN_1 ?IN_2 1)
                (= ?C-Out 0))
            (and
                (= ?IN_1 ?IN_2 0)
                (= ?C-Out 1))
            (and
                (neq ?IN_1 ?IN_2)
                (neq ?C-Out ?Carry_in)))
        then
        (assert(problem_O1_gate))))

(defrule print_problem_sum_bit
    (problem_X2_gate)
    =>
    (printout t crlf "There is a fault detection in X2 gate which could be as a result of the presence of fault in X1 and/or X2." crlf))

(defrule print_problem_Carry_out
    (problem_O1_gate)
    =>
    (printout t crlf "There is a fault detection in O1 gate which could be as a result of the presence of fault in A1, A2, X1 and/or O1"))

(defrule problem_with_X2_and_O1_gates
    (problem_X2_gate)
    (problem_O1_gate)
    =>
    (printout t crlf "There are errors in both the Sum bit and the Carry-Out. Check below for more information:"))

(reset)
(run)