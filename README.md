This project provides a suite of functions for performing advanced matrix operations with a focus on parallel computation. The implementation leverages `superpose` and `collapse` to parallelize tasks where possible.

The project is organized into three main functional areas:

1.  **Matrix Row Normalization (L2 Norm)**
2.  **Upper and Lower Triangular Matrix Extraction**
3.  **Parallel Trace of Matrix Powers**

-----

## 📜 File Structure

The library is composed of the following files:

  * **`triangular_matrix.metta`**: Contains logic for extracting upper and lower triangular matrices .
  * **`trace_matrix.metta`**: Implements functions for matrix transposition, multiplication, exponentiation, and trace calculation .
  * **`row_normalization.metta`**: Provides tools for normalizing matrix rows using the L2 norm .

-----

## ✨ Core Functionalities

### 1\. Matrix Row Normalization (L2 Norm)

This feature normalizes each row of a given matrix, ensuring that each row vector has an L2 norm (length) of 1.

#### Key Functions

  * **`calc_l2_norm $row`**: Computes the L2 norm for a single row vector. It squares all elements in parallel using `superpose`, sums the results, and then takes the square root .
  * **`normalize_row $row`**: Normalizes a single row by dividing each of its elements by the row's L2 norm .
  * **`normalize $matrix`**: Applies the `normalize_row` function to every row in the input matrix to produce the final normalized matrix .

#### Example

Normalizing a 2x2 matrix:

```metta
!(normalize
   (
      (3 4)
      (1 2)
   )
)

; Expected output: (
                     (0.6      0.8) 
                     (0.447..  0.894...)
                  )
```

-----

### 2\. Upper and Lower Triangular Matrix Extraction

These functions create a new matrix containing only the upper or lower triangular part of a given square matrix, setting all other elements to zero .

#### Key Functions

  * **`to_upr_matrix $matrix`**: **(Generates Upper Triangular)** This function processes a matrix and replaces elements below the main diagonal with zeros, effectively creating an upper triangular matrix .
  * **`to_lwr_matrix $matrix`**: **(Generates Lower Triangular)** This function processes a matrix and replaces elements above the main diagonal with zeros, creating a lower triangular matrix .

#### Examples

  * **Generating an Upper Triangular Matrix** (using `to_upr_matrix`):

    ```metta
    !(to_upr_matrix (
       (1 2 3 4)
       (4 5 6 7)
       (7 8 9 2)
       (4 8 2 9)
    ))

    ; Output: (
         (1 2 3 4)
         (0 5 6 7)
         (0 0 9 2)
         (0 0 0 9)
      )
    ```

  * **Generating a Lower Triangular Matrix** (using `to_lwr_matrix`):

    ```metta
    !(to_lwr_matrix (
       (1 2 3 4)
       (4 5 6 7)
       (7 8 9 2)
       (4 8 2 9)
    ))

    ; Output: (
         (1 0 0 0) 
         (4 5 0 0) 
         (7 8 9 0) 
         (4 8 2 9)
      )
    ```

-----

### 3\. Parallel Trace of Matrix Powers

This functionality computes the trace (the sum of the diagonal elements) of a matrix raised to the k-th power, i.e., $Trace(A^k)$.

#### Key Functions

  * **`matrix_mul $m1 $m2`**: Multiplies two matrices. Parallelization is achieved by transposing the second matrix and using `superpose` to calculate the products of all corresponding row-column pairs simultaneously .
  * **`matrix_power $m $k`**: Raises a matrix `$m` to the power of `$k` by recursively applying the parallel `matrix_mul` function .
  * **`calc_trace $matrix $power`**: The main function that orchestrates the operation. It first computes the matrix power using `matrix_power` and then sums the diagonal elements of the resulting matrix to find the trace .

#### Example

Calculate the trace of a matrix raised to the power of 2:

```metta
!(calc_trace ((1 2) (3 4)) 22)

; This first computes A^2 =  ((7 10) (15 22))
; Then, it computes the trace = 7 + 22 = 29
```
---
&copy; Aug 2025 - Built by [Haileiyesus Mesafint](https://github.com/hal-29) as part of iCog-Labs AGI Internship.