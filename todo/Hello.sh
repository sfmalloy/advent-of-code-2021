#!usr/bin/bash

doAdd() {
    return $(expr $1 + $2)
}

echo "Hello from Bash!"
doAdd 1 2
echo "a + b =" $?
