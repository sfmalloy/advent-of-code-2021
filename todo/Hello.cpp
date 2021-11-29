#include <iostream>

template <typename T>
T do_add(T a, T b);

int main() {
    std::cout << "Hello from C++!\n";
    std::cout << "a + b = " << do_add(1, 2) << '\n';
    return 0;
}

template <typename T>
T do_add(T a, T b) {
    return a + b;
}
