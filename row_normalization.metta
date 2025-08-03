;;; Calculates the L2 norm of a row vector.
(= (calc_l2_norm $row)(
   let $squared (collapse (pow-math (superpose $row) 2))
      (sqrt-math (foldl-atom $squared 0 $acc $x (+ $acc $x)))
))

;;; Normalizes a row by dividing each element by the L2 norm of that row.
(= (normalize_row $row)(
   let $l2 (calc_l2_norm $row) 
      (map-atom $row $x (/ $x $l2))
))


;;; Normalizes each row of a matrix by applying the normalize_row function to each row.
(= (normalize $matrix)
   (map-atom $matrix $x (normalize_row $x))
)

!(normalize
   (
      (3 4)
      (1 2)
   )
)  ; Expected output: ((0.6 0.8) (0.4472135954999579 0.894427190999916))