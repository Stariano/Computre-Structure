.text
    .globl main

main:
    # Test values
    li      a0, -5           # p = 3
    li      a1, 3000          # q = 2
    li      a2, -3           # r = 1

    # Load the float value directly into fa0
    li      t0, 2.5            # Load integer 2 into t0 (assuming x = 2.0)
    fcvt.s.w fa0, t0         # Convert integer 2 to float and store in fa0

    # Call the function f
    jal     ra, f            # Call f(p, q, r, x)

    # After the call, fa0 contains the result of f
    # (For testing purposes, you might want to store the result or use it further)

    # Exit the program (for simulators or emulators)
    li      a7, 10           # a7 = 10 for exit system call
    ecall                     # Make the system call to exit

f:
    # Function Prologue
    addi    sp, sp, -20        # Adjust stack pointer to make room for ra, p, q, r, x
    sw      ra, 16(sp)         # Save return address
    sw      a0, 12(sp)         # Save p
    sw      a1, 8(sp)          # Save q
    sw      a2, 4(sp)          # Save r
    fsw     fa0, 0(sp)         # Save x

    # Prepare arguments for pow
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
