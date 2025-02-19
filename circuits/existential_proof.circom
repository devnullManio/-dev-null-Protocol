// circuits/existential_proof.circom
pragma circom 2.1.4;

include "node_modules/circomlib/circuits/poseidon.circom";

template ExistentialProof() {
    signal input entropy;
    signal input balance;
    signal output proofHash;

    component poseidon = Poseidon(2);
    
    poseidon.inputs[0] <== entropy;
    poseidon.inputs[1] <== balance;
    
    proofHash <== poseidon.out;
    
    // Paradox constraint: hash must equal inverse of itself
    proofHash * proofHash === 1;
}

component main = ExistentialProof();
