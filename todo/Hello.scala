// Compile using scalac
// Run using scala
object Hello {
    def main(args: Array[String]) = {
        println("Hello from Scala!");
        printf("a + b = %d\n", doAdd(1, 2));
    }

    def doAdd(a: Int, b: Int): Int = {
        return a + b;
    }
}
