pragma circom 2.0.0;

include "../functions/getMaze.circom"
include "../../../node_modules/circomlib/circuits/comparators.circom";
include "../../../node_modules/circomlib/circuits/poseidon.circom"

template Maze() {
    
    // Public Inputs
    /*
    0 - up
    1 - down
    2 - right
    3 - left
    */
    signal private input move;
    signal private input x;
    signal private input y;
    signal input hash;
    signal output pubHash;

    var maze[25] = getMaze();
    var pos = x + 5*(4 - y);

    component c[4];
    if(move == 0){
        component c[0] = LessThan(32);
        c[0].in[0] <== y;
        c[0].in[1] <== 4;
        c[0].out === 1;
        var pos1 = x + 5*(4 - (y + 1));
        maze[pos1] === 0;
    }

    if(move == 1){
        component c[1] = GreaterThan(32);
        c[1].in[0] <== y;
        c[1].in[1] <== 0;
        c[1].out === 1;
        var pos2 = x + 5*(4 - (y - 1));
        maze[pos2] === 0;
    }

    if(move == 2){
        component c[2] = LessThan(32);
        c[2].in[0] <== x;
        c[2].in[1] <== 4;
        c[2].out === 1;
        var pos3 = (x + 1) + 5*(4 - y);
        maze[pos3] === 0;
    }

    if(move == 3){
        component c[3] = GreaterThan(32);
        c[3].in[0] <== x;
        c[3].in[1] <== 0;
        c[3].out === 1;
        var pos4 = (x - 1) + 5*(4 - y);
        maze[pos4] === 0;
    }

    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== x;
    poseidon.inputs[1] <== y;
    poseidon.inputs[2] <== move;
    pubHash <== poseidon.out;
    hash === pubHash;

}

component main = Main();