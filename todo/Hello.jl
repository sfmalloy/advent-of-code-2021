print("Hello from Julia!\n")

function do_add(a, b)
    a + b
end

println("a + b = $(string(do_add(1, 2)))")
