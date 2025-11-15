# Assembly & Arithmetic Lab 1

This project collects the lab 1 deliverables for the Computer Structure course. It focuses on manipulating simple programs in x86-style assembly to compute powers, handle matrices, and generate the exercises requested in the assignment brief.

## Files worth highlighting
- `Exercise1.s` and `Exercise2.s` are the handwritten assembly routines that solve the two exercises described in `practica1-2024-2025-en.pdf`.
- `FINALPOW.s`, `WORKINGPOW.s`, and `pow.o` track the evolution of the power computation helper.
- `wokringmatrix.s` and `WORKINGFINALVERSIONCOMPUTE.s` explore the matrix exercise from the lab.
- `Report.pdf` contains the official write-up; use `assignment_report_template.*` to reference the format requested by the instructor.

## Notes for future viewers
- The `.s` files are ready to be assembled using GNU `as` or a similar assembler used in the course.
- Keep `pow.o` if you want to link it as a prebuilt object; otherwise, assemble everything again on your build machine.
- Mention in your GitHub description that this folder evidences low-level arithmetic and matrix handling via assembly.
