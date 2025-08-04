;;; Replaces zeros in a row vector upto a given index from the left.
;;; Parameters: $n - an index upto which zeros are replaced
;;;            $row - the row vector to process
;;; E.g, (replace_zeros_left 2 (1 2 3 4)) returns (0 0 3 4)
(= (replace_zeros_left $n $row)(
   if (== $n 0) $row
      ( let $t (replace_zeros_left (- $n 1) (cdr-atom $row))
               (cons-atom 0 $t)
      )
))

;;; Replaces zeros in a row vector starting from a given index.
;;; Parameters: $n - the last number of elements to replace
;;;            $row - the row vector to process
;;; E.g, (replace_zeros_right 2 (1 2 3 4)) returns (1 2 0 0)
(= (replace_zeros_right $n $row)(
   if (== $row ()) () (
       let* (
         (($h $t)(decons-atom $row))
         ($replaced ( if (> (size-atom $row) $n) $h 0))
         ($rest (replace_zeros_right $n $t))
       ) (cons-atom $replaced $rest)
      )
))

;;;; Generates an upper triangular matrix from a given matrix.
;;; Parameters: $matrix - the matrix to process
;;; Returns: An upper triangular matrix with zeros replaced in the appropriate positions.
(= (to_upr_matrix $matrix)(collapse (_to_upr_matrix $matrix)))
(= (_to_upr_matrix $matrix)(_to_upr_matrix $matrix 0))
(= (_to_upr_matrix $matrix $index)(
        if (== $index (size-atom $matrix))
            (empty)
            (_to_upr_matrix $matrix (+ $index 1))
))
(= (_to_upr_matrix $matrix $index)(
   replace_zeros_left $index (index-atom $matrix $index) 
))

;;;; Generates a lower triangular matrix from a given matrix.
;;;; Parameters: $matrix - the matrix to process
;;;; Returns: A lower triangular matrix with zeros replaced in the appropriate positions.
(= (to_lwr_matrix $matrix)(collapse (_to_lwr_matrix $matrix)))
(= (_to_lwr_matrix $matrix)(_to_lwr_matrix $matrix 0))
(= (_to_lwr_matrix $matrix $index)(
        if (== $index (size-atom $matrix))
            (empty)
            (_to_lwr_matrix $matrix (+ $index 1))
))
(= (_to_lwr_matrix $matrix $index)(
   replace_zeros_right (- (- (size-atom $matrix) $index) 1) (index-atom $matrix $index) 
))

;;; Example usage of the to_upr_matrix function
!(to_upr_matrix (
   (1 2 3 4)
   (4 5 6 7)
   (7 8 9 2)
   (4 8 2 9)
)) ; ((1 2 3 4) (0 5 6 7) (0 0 9 2) (0 0 0 9))

!(to_lwr_matrix (
   (1 2 3 4)
   (4 5 6 7)
   (7 8 9 2)
   (4 8 2 9)
)) ; ((1 0 0 0) (4 5 0 0) (7 8 9 0) (4 8 2 9))

