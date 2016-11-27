all: first second third

first: 1.o
	ld -melf_x86_64 -s 1.o -o 1

1.o:
	as --64 1.s -o 1.o

second: 2.o
	ld -melf_x86_64 -s 2.o -o 2

2.o:
	as --64 2.s -o 2.o

third: 3.o
	ld -melf_x86_64 -s 3.o -o 3

3.o:
	as --64 3.s -o 3.o

clean:
	rm *.o [0-9] > /dev/null
