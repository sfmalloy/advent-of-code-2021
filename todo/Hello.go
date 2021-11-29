package main

import "fmt"

func doAdd(a int, b int) int {
	return a + b
}

func main() {
	fmt.Println("Hello from Go!")
	fmt.Printf("a + b = %d\n", doAdd(1, 2))
}
