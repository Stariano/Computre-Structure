.data
Matrix: .zero 100  # Reserve space for a 10x10 matrix (10*10 = 100 floating-point numbers * 4 bytes each = 400 bytes)

.text
.globl main
main:
    la      a0, Matrix       # Load address of the matrix
    li      a1, 5            # Set M = 5 (5x5 matrix)
    li      a2, 1            # p = 1
    li      a3, 2            # q = 2
    li      a4, 3            # r = 3

    # Call Integral_Matrix
    jal     ra, Integral_Matrix

    # Exit program
    li      a7, 10           # Syscall number for exit
    ecall

Integral_Matrix:
    # Arguments:
    # a0: Starting address of the matrix
    # a1: M (integer)
    # a2: p (integer)
    # a3: q (integer)
    # a4: r (integer)

    # Set constants
    li      t1, 100          # t1 = N = 100 (number of steps for accuracy)

    # Set up loop counter i = 0
    li      t2, 0              # t2 = i = 0

MatrixLoop:
    # Check if i >= M * M (i.e., all matrix elements covered)
    mul     t3, a1, a1         # t3 = M * M
    bge     t2, t3, EndMatrixLoop

    # Save ra before calling Compute_Integral
    addi    sp, sp, -4         # Allocate space on stack
    sw      ra, 0(sp)          # Save return address

    # Compute the address of the current element in the matrix
    slli    t4, t2, 2          # t4 = i * 4 (each float is 4 bytes)
    add     t5, a0, t4         # t5 = Address of Matrix[i]

    # Set integration interval [a, b]
    li      a5, 0              # a = 0
    li      a6, 1              # b = 1

    # Set arguments for Compute_Integral
    mv      a0, a5             # a
    mv      a1, a6             # b
    mv      a2, a2             # p (passed from function argument)
    mv      a3, a3             # q (passed from function argument)
    mv      a4, a4             # r (passed from function argument)
    mv      a5, t1             # N = 100

    # Call Compute_Integral
    jal     ra, Compute_Integral

    # Restore ra after calling Compute_Integral
    lw      ra, 0(sp)          # Restore return address
    addi    sp, sp, 4          # Deallocate space on stack

    # Store the result in the matrix element
    fsw     fa0, 0(t5)         # Store the result in Matrix[i]

    # Increment i
    addi    t2, t2, 1          # i += 1

    # Repeat loop
    j       MatrixLoop

EndMatrixLoop:
    ret

    
Compute_Integral:
    # Arguments:
    # a0: a (integer)
    # a1: b (integer)
    # a2: p (integer)
    # a3: q (integer)
    # a4: r (integer)
    # a5: N (integer)

    # Compute h = (b - a) / N

    # Convert b and a to floating-point numbers
    fcvt.s.w    ft0, a1        # ft0 = float(b)
    fcvt.s.w    ft1, a0        # ft1 = float(a)

    # Compute numerator h_numer = b - a
    fsub.s      ft2, ft0, ft1  # ft2 = ft0 - ft1 = b - a

    # Convert N to floating-point
    fcvt.s.w    ft3, a5        # ft3 = float(N)

    # Compute h = (b - a) / N
    fdiv.s      ft4, ft2, ft3  # ft4 = h

    # Initialize sum = 0.0 by loading a zero directly
    # Initialize sum = 0.0
    li          t1, 0           # Load integer 0 into t1
    fcvt.s.w    ft5, t1         # Convert integer 0 to float 0.0 in ft5


    # Initialize loop counter n = 0
    li          t0, 0          # t0 = n = 0

Loop:
    # Check if n >= N
    bge         t0, a5, EndLoop

    # Compute x = a + n * h
    fcvt.s.w    ft6, t0        # ft6 = float(n)
    fmul.s      ft6, ft6, ft4  # ft6 = n * h
    fadd.s      ft6, ft1, ft6  # ft6 = a + n * h = x

    # Compute f(x) = p * x^2 + q * x + r

    # x^2
    fmul.s      ft7, ft6, ft6  # ft7 = x^2

    # Convert coefficients to floating-point
    fcvt.s.w    fa0, a2        # fa0 = float(p)
    fcvt.s.w    fa1, a3        # fa1 = float(q)
    fcvt.s.w    fa2, a4        # fa2 = float(r)

    # p * x^2
    fmul.s      fa0, fa0, ft7  # fa0 = p * x^2

    # q * x
    fmul.s      fa1, fa1, ft6  # fa1 = q * x

    # Compute f(x) = (p * x^2) + (q * x) + r
    fadd.s      fa0, fa0, fa1  # fa0 = p * x^2 + q * x
    fadd.s      fa0, fa0, fa2  # fa0 = f(x)

    # Add f(x) to sum
    fadd.s      ft5, ft5, fa0  # ft5 = sum += f(x)

    # Increment n
    addi        t0, t0, 1      # n += 1

    # Repeat loop
    j           Loop

EndLoop:
    # Compute integral = h * sum
    fmul.s      fa0, ft4, ft5  # fa0 = h * sum

    # Return value in fa0
    ret

