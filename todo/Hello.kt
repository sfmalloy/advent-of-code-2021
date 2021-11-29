// To compile: kotlinc <name>.kt -include-runtime -d <name>.jar
// To run: java -jar <name>.jar 

fun doAdd(a: Int, b: Int): Int {
    return a + b
}

fun main() {
    println("Hello from Kotlin!")
    println("a + b = ${doAdd(1, 2)}")
}
