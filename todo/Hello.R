cat("Hello from R\n")

doAdd <- function(a, b) {
    return(a + b)
}

cat(sprintf("a + b = %d\n", doAdd(1, 2)))
