// Install dotnet-sdk and dotnet-runtime
// Run with dotnet-script Hello.csx

Console.WriteLine("Hello from C#!");

int DoAdd(int a, int b) {
    return a + b;
}

Console.WriteLine($"a + b = {DoAdd(1, 2)}");
