
    .text
    .globl main

main:
    # Load test values for Compute_Integral
    li      a0, 1           # a = 1
    li      a1, 3           # b = 3
    li      a2, 1           # p = 1 (x^2 coefficient)
    li      a3, 0           # q = 0 (x coefficient)
    li      a4, -1          # r = -1 (constant term)
    li      a5, 1000        # N = 1000 (number of steps for accuracy)

    # Manually "call" Compute_Integral
    jal     ra, Compute_Integral  # Jump and link to Compute_Integral

    # Result is now in fa0
    fcvt.w.s t0, fa0        # Convert floating-point result in fa0 to integer in t0

    # Exit program
    li      a7, 10          # Syscall number for exit
    ecall



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
