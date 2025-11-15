f:
    addi    sp, sp, -20        # Adjust stack pointer to make room for ra, p, q, r, x
    sw      ra, 16(sp)         # Save return address
    sw      a0, 12(sp)         # Save p
    sw      a1, 8(sp)          # Save q
    sw      a2, 4(sp)          # Save r
    fsw     fa0, 0(sp)         # Save x

    # arguments for pow
    # First argument 'a' is already in fa0 (x)
    li      a0, 2              # Load immediate 2 into a0 for exponent 'b'

    # Call pow function
    jal     ra, pow            # Call pow; result x^2 is in fa0

    # Compute p * x^2
    lw      a1, 12(sp)         # Load p into a1
    fcvt.s.w fa1, a1           # Convert integer p to float in fa1
    fmul.s  fa2, fa1, fa0      # fa2 = p * x^2

    # Compute q * x
    lw      a1, 8(sp)          # Load q into a1
    fcvt.s.w fa3, a1           # Convert integer q to float in fa3
    flw     fa4, 0(sp)         # Load original x from stack into fa4
    fmul.s  fa5, fa3, fa4      # fa5 = q * x

    # Sum the products: (p * x^2) + (q * x)
    fadd.s  fa6, fa2, fa5      # fa6 = fa2 + fa5

    # Add r to the sum
    lw      a1, 4(sp)          # Load r into a1
    fcvt.s.w fa7, a1           # Convert integer r to float in fa7
    fadd.s  fa0, fa6, fa7      # fa0 = fa6 + fa7 (final result)

    # Function Epilogue
    lw      ra, 16(sp)         # Restore return address
    addi    sp, sp, 20         # Restore stack pointer
    jr      ra                 # Return to caller

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
