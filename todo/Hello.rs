// Compile using rustc
// Run executable binary
fn do_add(a: i32, b: i32) -> i32 {
    return a + b;
}

fn main() {
    println!("Hello from Rust!");
    println!("a + b = {}", do_add(1, 2));
}
