import Foundation

let errorValues = [
    Character(")"): 3,
    Character("]"): 57,
    Character("}"): 1197,
    Character(">"): 25137
]

let autocompleteValues = [
    Character("("): 1,
    Character("["): 2,
    Character("{"): 3,
    Character("<"): 4
]

let opposite = [
    Character("("): Character(")"),
    Character("["): Character("]"),
    Character("{"): Character("}"),
    Character("<"): Character(">")
]

let lines = try! String(contentsOfFile: "inputs/Day10.in").split(separator: "\n")
var errorScore = 0
var autocompleteScores: [Int] = []
for line in lines {
    var stack: [Character] = []
    var valid: Bool = true
    for c in line {
        if opposite[c] != nil {
            stack.append(c)
        } else {
            if opposite[stack[stack.count - 1]] == c {
                stack.removeLast()
            } else {
                errorScore += errorValues[c]!
                valid = false
                break
            }
        }
    }

    if valid {
        var currScore = 0
        for i in stride(from: stack.count-1, through: 0, by: -1) {
            let value = autocompleteValues[stack[i]]!
            currScore = (5 * currScore) + value
        }
        autocompleteScores.append(currScore)
    }
}

print(errorScore)
autocompleteScores.sort()
print(autocompleteScores[autocompleteScores.count / 2])
