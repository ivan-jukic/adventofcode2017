// Dutet...
const puzzleInput = require('./components/18_Instructions.js');
const redis = require('redis');

const channel = "aoc";
const sub = redis.createClient();
const pub = redis.createClient();
sub.on('error', err => console.log("sub", err));
pub.on('error', err => console.log("pub", err));

const initCommunication = s => {
    if (!s.init) {
        pub.publish(channel, JSON.stringify({ sender: s.id, cmd: "init"}));
    }
};

const askIfReceiving = s => {
    const data =
        { sender: s.id
        , cmd: 'receiving'
        }
    pub.publish(channel, JSON.stringify(data));
};

const sndFn = (s, reg) => {
    //console.log('send data or from reg', reg);
    const data =
        { sender: s.id
        , cmd: "data"
        , payload: puzzleInput.getVal(s.registers, reg)
        };

    pub.publish(channel, JSON.stringify(data));
    state.sent++;
    console.log("sent", state.sent);
    return puzzleInput.next(s);
};

const rcvFn = (s, reg) => {
    if (s.queue.length == 0) {
        //console.log('waiting for data', s.sent);
        s.running = false;
        askIfReceiving(s);
        return s;
    } else {
        //console.log('receive data from queue and store it in reg', reg);
        s.registers[reg] = s.queue[0];
        s.queue.splice(0, 1);
        return puzzleInput.next(s);
    }
};

const pid = parseInt(process.argv[2], 10);
let state =
    { id: pid
    , init: false
    , current: 0
    , lastPlayed: -1
    , running: true
    , registers: {'p': pid}
    , instructions: puzzleInput.getInstructions(sndFn, rcvFn)
    , sent: 0
    , queue: []     
    };


const run = () => {    
    // Execute instructions...
    while(state.running) {
        state = state.instructions[state.current](state);
    }
};

sub.subscribe(channel);
sub.on("message", (ch, msgStr) => {
    const msg = JSON.parse(msgStr);

    if (msg.sender !== state.id) {
        switch(msg.cmd) {
            case 'init':
                if (!state.init) {
                    initCommunication(state);
                    state.init = true;
                    run();
                }
                break;

            case 'data':
                state.queue.push(msg.payload);
                //console.log('received data', state.queue, state.running);
                if (!state.running) {
                    state.running = true;
                    run();
                }
                break;

            case 'receiving':
                //console.log('prog asked if receiving', !state.running);
                const data =
                    { sender: state.id
                    , cmd: 'receivingResponse'
                    , payload: !state.running
                    }
                pub.publish(channel, JSON.stringify(data));
                if (!state.running) {
                    //console.log("terminate");
                    //process.exit();
                }

            case 'receivingResponse':
                if (msg.payload) {
                    //console.log("terminate");
                    //process.exit();
                } else {
                    setTimeout(() => {
                        if(!state.running) askIfReceiving(state);
                    }, 5000);
                }
        }
    }
});

// Init process communication...
initCommunication(state);
