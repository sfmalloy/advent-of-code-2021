#include <stdio.h>

int do_add(int a, int b);

int main() {
    printf("Hello from C!\n");
    printf("a + b = %d\n", do_add(1, 2));
    return 0;
}

int do_add(int a, int b) {
    return a + b;
}
