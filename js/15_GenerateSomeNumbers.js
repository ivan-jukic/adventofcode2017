
const factorA = 16807;
const factorB = 48271;
const divide = (Math.pow(2, 31)) - 1;
const mask = (Math.pow(2, 16)) - 1;

let loop = 5 * Math.pow(10, 6);
let count = 0;
let prevA = 722;
let prevB = 354;

const getGenNum = (prev, factor, multipleOf) => {
    let gen = (prev * factor) % divide;
    return gen % multipleOf === 0 ? gen : getGenNum(gen, factor, multipleOf);
}

for (i = 0; i < loop; i++) {
    let genA = getGenNum(prevA, factorA, 4);
    let genB = getGenNum(prevB, factorB, 8);
    let bitA = genA & mask;
    let bitB = genB & mask;

    if (bitA == bitB) {
        count++;
    }
    
    prevA = genA;
    prevB = genB;
}

console.log(count);