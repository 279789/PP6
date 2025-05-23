.section .data
msg: .ascii "This is an professional environment.\n"
len = . - msg

.section .text
.globl _start

_start:
movl $4, %eax	#syscall in write mode
movl $99, %ebx   # file director 1 (where the msg should be writen 1 = stdout = terminal)
movl $msg, %ecx #from where the message should be written, in our case it's the address of the first char from the Message.
movl $len, %edx #size of the message, thats needed, so that there is an definition of how long shauld be written.
int $0x80       #execution of the syscall


movl $1, %eax   #syscall for exiting the prozess
movl $0 ,%ebx   # giving status 0 to the parentprocess
int $0x80

