import Text.Printf

doAdd :: Int -> Int -> Int
doAdd a b = a + b

main :: IO()
main = do
    putStrLn "Hello from Haskell!"
    printf "a + b = %d\n" (doAdd 1 2)
