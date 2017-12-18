// Dutet...
const strInput =
    `set a 1
    add a 2
    mul a a
    mod a 5
    snd a
    set a 0
    rcv a
    jgz a -1
    set a 1
    jgz a -2`;

const instructions =
    strInput
        .split("\\n")
        .map(ins => {
            if (matches = ins.trim().match(/^set\s+([a-z]{1})\s+([0-9]+)/)) {
                console.log(matches);
            }
        });