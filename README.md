# Microprocessor and Microcontroller Lab

This repository contains Assembly language code and instructions for the Microprocessor and Microcontroller lab sessions. The code is designed to run in a Linux environment and provides hands-on practice with fundamental concepts.

### Prerequisites  
Ensure you have the following installed on your Linux-based system:
- **NASM** (Netwide Assembler)  
- **LD** (GNU Linker)  
- **A Linux-based operating system**

### Getting Started  
Follow these steps to assemble, link, and execute the program:
1. **Assemble the code**:  
    ```sh
    nasm -f elf hello.asm -o hello.o
    ```
2. **Link the object file**:  
    ```sh
    ld -m elf_i386 -s -o hello hello.o
    ```
3. **Run the executable**:  
    ```sh
    ./hello
    ```
**Note:** Ensure that your system supports 32-bit binaries if you encounter compatibility issues.

### Lab Exercises  
- Each lab exercise is organized in its respective directory.  
- Exercises are sequentially numbered for better understanding.  
- The [`LAB_B`](./LAB_B) folder contains additional lab work and sample codes.

### Contributing  
We welcome contributions! If you find any issues or have suggestions for improvements:
- Open an issue in this repository.  
- Submit a pull request with a clear description of the changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
