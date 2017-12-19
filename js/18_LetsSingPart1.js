// Dutet...
const puzzleInput = require('./components/18_Instructions.js');

let state =
    { current: 0
    , lastPlayed: -1
    , running: true
    , registers: {}
    , instructions: puzzleInput.getInstructions()        
    };

// Execute instructions...
while(state.running) {
    state = state.instructions[state.current](state)
}

// Print out last played
console.log("Solution", state.lastPlayed);