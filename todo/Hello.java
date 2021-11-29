public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
        System.out.printf("a + b = %d\n", doAdd(1, 2));
    }

    public static int doAdd(int a, int b) {
        return a + b;
    }
}
