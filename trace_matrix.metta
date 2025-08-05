;;; Reverses a list
;;; Parameters: $list - the list to reverse
;;; Returns: A new list with elements in reverse order.
;;; E.g, (reverse (1 2 3)) -> (3 2 1)
(= (reverse $list) (reverse $list ()))
(= (reverse $list $acc) (
   if (== $list ()) $acc (
      let $curr (car-atom $list) (reverse (cdr-atom $list) (cons-atom $curr $acc))
   )
))

;;; A helper function that accumulates elements into a list until the size of the each element is less than specified dimension.
;;; Parameters: $acc - the accumulated list
;;;            $x - the current element to process
;;;            $dim - the dimension to check against
;;; Returns: A new list with elements accumulated until the size of each element is less than $dim.
;;; E.g, (accumulate ((2)) 3 2) ->  ((3 2))
;;;      (accumulate ((3 2)) 5 2) ->  ((5)(3 2))
(= (accumulate $acc $x $dim)(
   if (== $acc ()) (($x)) (
      let* (
         (($h $t) (decons-atom $acc))
         ($h_new (union-atom $h ($x)))
      ) (
         if (< (size-atom $h) $dim)
            (cons-atom $h_new $t)
            (cons-atom ($x) $acc)))
))

;;; Converts a list into a matrix of specified column dimension.
;;; Parameters: $list - the list to convert
;;;            $dim - the number of columns in the resulting matrix
;;; Returns: A matrix where each row contains $dim elements from the list.
;;; E.g, (to_matrix (1 2 3 4 5 6 7 8 9) 2) -> ((1 2 3) (4 5 6)(7 8 9))
(= (to_matrix $list $dim) (reverse (_to_matrix $list $dim)))
(= (_to_matrix $list $dim)(
   foldl-atom $list ()
     $acc $x (accumulate $acc $x $dim)
))

;;; Gets the element at a specific index from a matrix.
;;; Parameters: $matrix - the matrix to process
;;;            $index - the index of the column to retrieve
;;; Returns: The column at the specified index.
;;; E.g, (index-atom ((1 2 3) (4 5 6) (7 8 9)) 1) -> (2 5 8)
(= (get_col $matrix $index)(
   map-atom $matrix $x (index-atom $x $index)
))

;;; Transposes a square matrix.
;;; Parameters: $matrix - the square matrix to transpose
;;; Returns: A new square matrix where rows and columns are swapped.
;;; E.g, (matrix_transp ((1 2 3) (4 5 6) (7 8 9))) -> ((1 4 7) (2 5 8) (3 6 9))
(= (matrix_transp $matrix)(matrix_transp $matrix 0))
(= (matrix_transp $matrix $index)(
   if (>= $index (size-atom $matrix))()(
      let*  (
         ($curr (get_col $matrix $index)) 
         ($rem (matrix_transp $matrix (+ $index 1)))
      ) (cons-atom $curr $rem)
   )
))

;;; Joins every element of two row lists into a single row vector.
;;; Parameters: $row1 - the first row vector
;;;            $row2 - the second row vector
;;; Returns: A new row list of pairs where each pair consists of corresponding elements from $row1 and $row2.
;;; E.g, (join_rows (1 2 3) (4 5 6)) -> ((1 4) (2 5) (3 6))
(= (join_rows $row1 $row2)(
   if (or (== $row1 ()) (== $row2 ())) () (
      let* (
      ($joined ((car-atom $row1) (car-atom $row2)) )
      ($rest  (join_rows (cdr-atom $row1) (cdr-atom $row2))) 
      ) (cons-atom $joined $rest))
))

;;; Multiplies two rows element-wise.
;;; Parameters: $row1 - the first row vector
;;;            $row2 - the second row vector
;;; Returns: The sum of the products of corresponding elements in the two rows.
;;; E.g, (multiply_rows (1 2 3) (4 5 6)) -> 32
(= (multiply_rows $row1 $row2)(let $list (collapse (_multiply_rows $row1 $row2)) (foldl-atom $list 0 $acc $x (+ $acc $x))))
(= (_multiply_rows $row1 $row2)(
   let* (
      ($joined (join_rows $row1 $row2))
      (($n1 $n2) (superpose $joined))
      ($product (* $n1 $n2))
   ) $product
))


;;; Multiplies two square matrices.
;;; Parameters: $m1 - the first matrix
;;;            $m2 - the second matrix
;;; Returns: A new matrix that is the product of the two matrices.
;;; E.g, (matrix_mul ((1 2) (3 4)) ((5 6) (7 8))) -> ((19 22) (43 50))
(= (matrix_mul $m1 $m2)
   (to_matrix (collapse (_matrix_mul $m1 $m2)) (size-atom $m2)))
(= (_matrix_mul $m1 $m2)(
   let* (
      ($m2_rev (matrix_transp $m2))
      ($multiplied (
        (multiply_rows (superpose $m1) (superpose $m2_rev))
      ))
   ) (car-atom $multiplied)
))

;;; Calculates kth power of a matrix.
;;; Parameters: $m - the matrix to raise to power
;;;            $k - the power to raise the matrix to
;;; Returns: The matrix raised to the kth power.
;;; E.g, (matrix_power ((1 2) (3 4)) 2) -> ((7 10) (15 22))
(= (matrix_power $m $k) (if (== $k 1) $m (matrix_mul $m (matrix_power $m (- $k 1)))))


;;; Calculates the trace (sum of diagonal elements) of a matrix raised to a given power.
;;; Parameters: $matrix - the matrix to process
;;;            $power - the power to raise the matrix to
;;; Returns: The trace of the matrix raised to the specified power.
;;; E.g, (calc_trace ((1 2) (3 4)) 2) -> 29
(= (calc_trace $matrix $power) (
   let $multiplied (matrix_power $matrix $power) (_calc_trace $multiplied 0)
))
(= (_calc_trace $matrix $i)(
   if (>= $i (size-atom $matrix)) 0
      ( 
         let* (
            ($row (index-atom $matrix $i))
            ($curr (index-atom $row $i))
         )
         (+ $curr (_calc_trace $matrix (+ $i 1)))
      )
))

!(matrix_power 
  (
    (3 5 6)
    (3 5 6)
    (3 5 6)
  )
  5
)