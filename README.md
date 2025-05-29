# PP6

## Goal

In this exercise you will:

* Learn how to produce text output to the terminal in four different environments:

  1. **Bash** shell scripting
  2. **GNU Assembler** (GAS) using system calls
  3. **C** via the standard library
  4. **Python 3** using built‑in printing functions

**Important:** Start a stopwatch when you begin and work uninterruptedly for **90 minutes**. When time is up, stop immediately and record exactly where you paused.

---

> **⚠️ WARNING:** The **workflow** steps have been **updated** for PP6. Please review the new workflow below carefully before proceeding.

## Workflow

1. **Fork** this repository on GitHub
2. **Clone** your fork to your local machine
3. Create a **solutions** directory at the repository root: `mkdir solutions`
4. For each task, add your solution file into `./solutions/` (e.g., `[solutions/print.sh](./solutions/print.sh)`)
5. **Commit** your changes locally, then **push** to GitHub
6. **Submit** your GitHub repository link for review

---

## Prerequisites

* Several starter repos are available here:
  [https://github.com/orgs/STEMgraph/repositories?q=SSH%3A](https://github.com/orgs/STEMgraph/repositories?q=SSH%3A)

---

> **Note:** Place all your solution files under the `solutions/` directory in your cloned repo.

## Tasks

### Task 1: Bash Printing & Shell Prompt

**Objective:** Use both `echo` and `printf` to format and display text and variables, and customize your shell prompt and login/logout messages.

1. In `./solutions/`, create a file named `print.sh` based on the template below.
2. At the top of `print.sh`, add the shebang:

   ```bash
   #!/usr/bin/env bash
   ```
3. Implement at least three functions:

   * `print_greeting`: prints `Hello from Bash!` using `echo`.
   * `print_vars`: declares two variables (e.g., `name="Bash"`, `version=5.1") and prints them with `printf\` using format specifiers.
   * `print_escape`: demonstrates escape sequences: newline (`\n`), tab (`\t`), and ANSI color codes (e.g., `\e[32m` for green).
4. Make the script executable and verify it runs:

   ```bash
   chmod +x solutions/print.sh
   ./solutions/print.sh
   ```
5. Modify your **`~/.bashrc`** on your local machine to:

   * Change the `PS1` prompt to include your username and current directory (e.g., `export PS1="[\u@\h \W]\$ "`).
   * Display a **welcome** message on login (e.g., `echo "Welcome, $(whoami)!"`).
   * Display a **goodbye** message on logout (add a `trap` for `EXIT` to echo `Goodbye!`).
6. Reload your shell (`source ~/.bashrc`) and demonstrate the prompt, greeting, and exit message.

**Template for `solutions/print.sh`**

```bash
#!/usr/bin/env bash

print_greeting() {
    # TODO: echo "Hello from Bash!"
}

print_vars() {
    local name="Bash"
    local version=5.1
    # TODO: printf "Using %s version %.1f\n" "$name" "$version"
}

print_escape() {
    # TODO: printf "This is a newline:\nThis is a tab:\tDone!\n"
    # TODO: printf "\e[32mGreen text\e[0m and normal text\n"
}

# Call your functions:
print_greeting
print_vars
print_escape
```

**Solution Reference**
Place your completed `print.sh` in `solutions/` and commit. Then link it here:

```
[print.sh](https://github.com/279789/PP6/blob/master/solutions/print.sh)
```

#### Reflection Questions

1. **What is the difference between `printf` and `echo` in Bash?** *While both echo and printf are commands to display string onto the terminal, echo is simpler to script, but has also less control on the output then printf.*
2. **What is the role of `~/.bashrc` in your shell environment?** *The .bashrc is nothing other than an shellscript, that is always accessable from the command line. Normal use is to put scripts in here that shauld be easily executable*
3. **Explain the difference between sourcing (`source ~/.bashrc`) and executing (`./print.sh`).** *The main difference between sourcing and executing is the "place" where it's done. For example, executing is done in a new shell(sub-shell)all things that are done have no influence on the actual shell, while sourcing is done in the same shell, that did the command. That means changes have an influence on the actual shell.*

---

### Task 2: GAS Printing (32‑bit Linux)

**Objective:** Use the Linux `sys_write` and `sys_exit` system calls in GAS to write text, while ensuring your repo only contains source files.

1. At the repository root, create a file named `.gitignore` that ignores:

   * Object files (`*.o`)
   * Binaries/executables (e.g., `print`, `print_c`)
   * Any editor or OS-specific files
     Commit this `.gitignore` file.
     **Explain:** Why should compiled artifacts and binaries not be committed to a Git repository? *The main reason for that is, that it wouldn't make that much sens to do this. One reason for that is, that compiled code is OS and architecture dependent. For example, if you compile some code on a 64 bit processor, that code would not work on a 32 bit prozessor. If you work on a big project with many other people, and all would upload their binaries, much memory is waisted and the overview gets lost.
2. In `./solutions/`, create a file named `print.s` using the template below.
3. Define a message in the `.data` section (e.g., `msg: .ascii "Hello from GAS!\n"`, `len = . - msg`).
4. In the `.text` section’s `_start` symbol, invoke `sys_write` (syscall 4) and then `sys_exit` (syscall 1) via `int $0x80`.
5. Assemble and link in 32‑bit mode:

   ```bash
   as --32 -o print.o solutions/print.s
   ld -m elf_i386 -o print print.o
   ```
6. Run `./print` and verify it outputs your message.

**Template for `solutions/print.s`**

```asm
    .section .data
msg:    .ascii "Hello from GAS!\n"
len = . - msg

    .section .text
    .global _start
_start:
    movl $4, %eax        # sys_write
    movl $1, %ebx        # stdout
    movl $msg, %ecx
    movl $len, %edx
    int $0x80

    movl $1, %eax        # sys_exit
    movl $0, %ebx        # status 0
    int $0x80
```

**Solution Reference**

```
[print.s](https://github.com/279789/PP6/blob/master/solutions/print.s)
```

#### Reflection Questions

1. **What is a file descriptor and how does the OS use it?** *A filedescriptor is a very important part of the syscall, it's main purpuse is to define The in and or output. For example, if you want to print a message to the terminal with asm, you have to define the fd 1 , wich stands for standardout, wich is the terminal buffer. I think a easy short description of the fd is: Where should I do the syscall*
2. **How can you obtain or duplicate a file descriptor for another resource (e.g., a file or socket)?** *If you want to execute your syscall to a file, for example, reading from a file , or writing at a file., you have to open the file first, save the file descriptor of the file to the ram and than use the address of the ram as your file descriptor for your read or write syscall.*
3. **What might happen if you use an invalid file descriptor in a syscall?** *If you use an invalide fd, than there is not defined where the syscall should be executed. For example if you add an fd of 99 to an write syscall, nothing happens, because the syscall has wrong information about where it should be executed.*

---

### Task 3: C Printing

**Objective:** Use `printf` and `puts` from `<stdio.h>` to display formatted data.

1. In `./solutions/`, create `print.c` based on the template below.
2. Implement `main()` to print a greeting, an integer, a float, and a string via `printf`, then use `puts`.
3. Compile and run:

   ```bash
   gcc -std=c11 -Wall -o print_c solutions/print.c
   ./print_c
   ```

**Template for `solutions/print.c`**

```c
#include <stdio.h>

int main(void) {
    printf("Hello from C!\n");
    printf("Integer: %d, Float: %.2f, String: %s\n", 42, 3.14, "test");
    puts("This is puts output");
    return 0;
}
```

**Solution Reference**

```
[print.c](https://github.com/279789/PP6/blob/master/solutions/print.c)
```

#### Reflection Questions

1. **Use `objdump -d` on `print_c` to find the assembly instructions corresponding to your `printf` calls.** *
2. **Why is the syntax written differently from GAS assembly? Compare NASM vs. GAS notation.** *To understand why there are more than one syntax is, that the assambler language is heavily dependet on the architecture of your prozessor. Gas uses an kind of old syntyx from AT&T, it's also used in some older generation assemblers. NASM uses the intel syntax wich is used by the majority of assemblers. But today, modern versions of Gas also support the intel syntax.
3. **How could you use `fprintf` to write output both to `stdout` and to a file instead? Provide example code.** I'm honestly, i found no way to write from one fprintf command to two "outputs" without a "custom function". So I did it in two lines. : #include <stdio.h>

int main(void) {
        printf("Hello there this is C.\n\n");
        printf("Integer: %i\tFloat: %f\t String:%s\n\n",1,2.1,"Mulm");
        puts("I didn't know puts before.\n");

        //Test section for Reflection Question 3
        FILE *test;
        test = fopen("test.txt","w");
        fprintf(test,"Super hat geklappt\n");
        fclose(test);
        fprintf(stdout,"Super hat geklappt\n");






        return 0;



}
~                                                                                                                                         ~                                                                                                                                         ~                                                                                                                                         ~                              

---

### Task 4: Python 3 Printing

**Objective:** Use Python’s `print()` function with various parameters and f‑strings.

1. In `./solutions/`, create `print.py` using the template below.
2. Implement `main()` to print a greeting, multiple values with custom `sep`/`end`, and an f‑string expression.
3. Make it executable and run:

   ```bash
   chmod +x solutions/print.py
   ./solutions/print.py
   ```

**Template for `solutions/print.py`**

```python
#!/usr/bin/env python3

def main():
    print("Hello from Python3!")
    print("A", "B", "C", sep="-", end=".\n")
    value = 2 + 2
    print(f"Two plus two equals {value}")

if __name__ == "__main__":
    main()
```

**Solution Reference**

```
[print.py](https://github.com/279789/PP6/blob/master/solutions/print.py)
```

#### Reflection Questions

1. **Is Python’s print behavior closer to Bash, Assembly, or C? Explain.** *I think it's somewhere between bash and c,
 but more on the bash side. The print behavior is more simplified than the behaviour from c, but also while giving the user more function.
This is my firsttime useing python, but it feels somehow similar to bash.*
###Point of 90 Minutes
2. **Can you inspect a Python script’s binary with `objdump`? Why or why not?** *Thats not possible, because the python script is not a classical script. It's source code, thats rendered on a vm. It's interpreted on runtime.*

---

**Remember:** Stop working after **90 minutes** and document where you stopped.
