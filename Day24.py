from collections import deque

def arg(reg: dict[str, int], symbol: str):
    if symbol.isalpha():
        return reg[symbol]
    return int(symbol)


def run(prog: list[str], inp: list[int]):
    reg = {
        'w': 0,
        'x': 0,
        'y': 0,
        'z': 0
    }
    iptr = 0
    for line in prog:
        match line.split():
            case ['inp', r]:
                reg[r] = inp[iptr]
                iptr += 1
            case ['add', a, b]:
                reg[a] += arg(reg, b)
            case ['mul', a, b]:
                reg[a] *= arg(reg, b)
            case ['div', a, b]:
                reg[a] //= arg(reg, b)
            case ['mod', a, b]:
                reg[a] %= arg(reg, b)
            case ['eql', a, b]:
                reg[a] = 1 if reg[a] == arg(reg, b) else 0
    return reg


def main():
    with open('inputs/Day24.in') as f:
        block_strings = f.read().split('inp w\n')[1:]
        blocks = []
        for b in block_strings:
            blocks.append(['inp w', 'inp z'] + b.splitlines())
    w_checks = [
        None,
        None,
        None,
        lambda z: z % 26 - 5,
        None,
        None,
        None,
        lambda z: z % 26 - 14,
        lambda z: z % 26 - 8,
        None,
        lambda z: z % 26,
        lambda z: z % 26 - 5,
        lambda z: z % 26 - 9,
        lambda z: z % 26 - 1
    ]
    w = [9]
    z = [0]
    p = 0
    while True:
        if p == len(blocks) and z[-1] < 2000:
            if z[-1] == 0:
                print(w, z)
                break
            print(w, z[-1])
        while (w[p] < 1 or w[p] > 9) or (p == len(blocks) and z != 0):
            w.pop()
            z.pop()
            w[-1] -= 1
            p -= 1
        z.append(run(blocks[p], [w[p], z[p]])['z'])
        if w_checks[p]:
            w.append(w_checks[p](z[p]))
        else:
            w.append(9)
        p += 1

if __name__ == '__main__':
    main()
