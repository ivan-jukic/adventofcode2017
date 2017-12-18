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
        .map(ins => ins.trim())
        .map(ins => {
            const buildFn = (r, m, fn) => {
                const reg = m[1];
                const val = parseInt(m[2], 10);
                return fn(r, reg, val);
            };
            if (m = ins.match(/^set\s+([a-z]{1})\s+([0-9]+)/)) {
                return r => buildFn(r, m, set);
            }

            if(m = ins.match(/^add\s+([a-z]{1})\s+([0-9]+)/)) {
                return r => buildFn(r, m, add);
            }

            if(m = ins.match(/^mul\s+([a-z]{1})\s+([0-9]+)/)) {
                const register = m[1];
                const amount = parseInt(m[2], 10);
                return r = add(r, register, amount);
            }
        });