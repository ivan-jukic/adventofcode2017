// ...

const puzzleSteps = 348;

const part1 = steps => {
    let buffer = [ 0 ];
    let value = 1;
    let current = 0;
    let remaining = 2017;
    
    while (remaining > 0) {
        const len = buffer.length;
        const newCurrent = (current + steps) % len;
        buffer.splice(newCurrent + 1, 0, value);
        value++;
        remaining--;
        current = newCurrent + 1;
    }

    const idx = buffer.findIndex(v => v === 2017);
    console.log(buffer[idx + 1]);
}

const part2 = steps => {
    let value = 1;
    let current = 0;
    let remaining = 5 * Math.pow(10, 7);
    let insertAfterZero = 0;

    while (remaining > 0) {
        const newCurrent = (current + steps) % value;
        insertAfterZero = newCurrent == 0 ? value : insertAfterZero;
        value++;
        remaining--;
        current = newCurrent + 1;
    }

    console.log(insertAfterZero);
}

part1(puzzleSteps);
part2(puzzleSteps);