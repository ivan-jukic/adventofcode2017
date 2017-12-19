// puzzle input
const strInput =
    /*`snd 1
    snd 2
    snd p
    rcv a
    rcv b
    rcv c
    rcv d`;*/

    `set i 31
    set a 1
    mul p 17
    jgz p p
    mul a 2
    add i -1
    jgz i -2
    add a -1
    set i 127
    set p 618
    mul p 8505
    mod p a
    mul p 129749
    add p 12345
    mod p a
    set b p
    mod b 10000
    snd b
    add i -1
    jgz i -9
    jgz a 3
    rcv b
    jgz b -1
    set f 0
    set i 126
    rcv a
    rcv b
    set p a
    mul p -1
    add p b
    jgz p 4
    snd a
    set a b
    jgz 1 3
    snd b
    set f 1
    add i -1
    jgz i -11
    snd a
    jgz f -16
    jgz a -19`;

//...

const getVal = (r, v) => v.match(/[a-z]{1}/gi) !== null ? r[v] : parseInt(v, 10);
const next = s => {
    s.current++;
    s.running = s.running && s.current < s.instructions.length;
    return s;
};

const set = (s, reg, val) => {
    s.registers[reg] = getVal(s.registers, val);
    return next(s);
};

const add = (s, reg, val) => {
    s.registers[reg] = s.registers[reg] + getVal(s.registers, val);
    return next(s);
}

const mul = (s, reg, val) => {
    s.registers[reg] = s.registers[reg] * getVal(s.registers, val);
    return next(s);
};

const mod = (s, reg, val) => {
    s.registers[reg] = s.registers[reg] % getVal(s.registers, val);
    return next(s);
};

const jgz = (s, x, y) => {
    x = getVal(s.registers, x);
    y = getVal(s.registers, y);
    s.current += x > 0 ? y : 1;
    s.running = s.current >= 0 && s.current < s.instructions.length;
    return s;
};

exports.getVal = getVal;
exports.next = next;
exports.getInstructions = (sndFn, rcvFn) =>
    strInput
        .split("\n")
        .map(ins => ins.trim())
        .map(ins => {
            const buildFn = (m, fn) => {
                const reg = m[1];
                const val = m[2];
                return s => fn(s, reg, val);
            };
            if (m = ins.match(/^set\s+([a-z]{1})\s+([\-0-9a-z]+)/i)) {
                return buildFn(m, set);
            }

            if (m = ins.match(/^add\s+([a-z]{1})\s+([\-0-9a-z]+)/)) {
                return buildFn(m, add);
            }

            if (m = ins.match(/^mul\s+([a-z]{1})\s+([\-0-9a-z]+)/)) {
                return buildFn(m, mul);
            }

            if (m = ins.match(/^mod\s+([a-z]{1})\s+([\-0-9a-z]+)/)) {
                return buildFn(m, mod);
            }

            if (m = ins.match(/^jgz\s+([-0-9a-z]+)\s+([\-0-9a-z]+)/)) {
                return buildFn(m, jgz);
            }

            if (m = ins.match(/^snd\s+([\-0-9a-z]{1})/)) {
                const reg = m[1];
                return s => {
                    if (typeof sndFn === 'function') {
                        return sndFn(s, reg);
                    } else {
                        s.lastPlayed = getVal(s.registers, reg);
                        return next(s);
                    }
                };
            }

            if (m = ins.match(/^rcv\s+([a-z]{1})/)) {
                const reg = m[1];
                return s => {
                    if (typeof rcvFn === 'function') {
                        return rcvFn(s, reg);
                    } else {
                        if (s.registers[reg] > 0) {
                            s.registers[reg] = s.lastPlayed;
                            s.running = false;
                        }
                        return next(s);
                    }
                }
            }
        });