# Microprocessors and Macro Controllers Lab

This repository contains the code and instructions for the Microprocessors and Micro Controllers lab sessions. The code is written in Assembly language and is intended to run on a Linux environment.

## Prerequisites

- NASM (Netwide Assembler)
- LD (GNU Linker)
- A Linux-based operating system

## Getting Started

To run the code, follow these steps:

1. Assemble the code:
    ```sh
    nasm -f elf hello.o
    ```

2. Link the object file:
    ```sh
    ld -s -o hello hello.o
    ```
    OR
    ```sh
    ld -m elf_i386 -s -o hello hello.o
    ```

3. Execute the program:
    ```sh
    ./hello
    ```

## Lab Exercises

Each lab exercise is contained in its own directory with codes numbered in order. Note that the [`LAB_B`](./LAB_B) folder contains the code for the other lab work.

## Contributing

If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
