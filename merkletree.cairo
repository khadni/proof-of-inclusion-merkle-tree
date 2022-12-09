// SPDX-License-Identifier: MIT

%lang starknet

// Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math_cmp import is_le_felt

namespace MerkleTree {

    // ##
    // The verify function takes three inputs: a leaf value, a merkle_root value, and an proof_len value that indicates the length of an array of proof values.
    // The function calculates the root of the Merkle tree using the calculate_root function and compares it to the provided merkle_root value.
    // >> If the two values are equal, the function returns 1, indicating that the proof is valid.
    // >> Otherwise, it returns 0, indicating that the proof is not valid.
    // ref: https://github.com/ncitron/cairo-merkle-distributor/blob/master/contracts/merkle.cairo
    // @param leaf
    // @param proof_len
    // @param proof
    // ##
    func verify{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        leaf: felt, merkle_root: felt, proof_len: felt, proof: felt*
    ) -> (res: felt) {
        alloc_locals;

        let (calc_root) = calculate_root(leaf, proof_len, proof);
        // check if calculated root is equal to expected
        if (calc_root == merkle_root) {
            return (1,);
        }
        return (0,);
    }

    // ##
    // The calculate_root function takes a curr value, an proof_len value, and an array of proof values.
    // >> If the proof_len is 0, the function simply returns the curr value.
    // >> Otherwise, the function calculates the next node in the Merkle tree by concatenating the curr and proof values
    // and hashing the result using the hash2 function, which is imported from the starkware.cairo.common.hash module.
    // The function then recursively calls itself to calculate the root of the subtree rooted at the current node, and returns the result.
    // ref: https://github.com/ncitron/cairo-merkle-distributor/blob/master/contracts/merkle.cairo
    // @param curr
    // @param proof_len
    // @param proof
    // ##
    func calculate_root{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        curr: felt, proof_len: felt, proof: felt*
    ) -> (res: felt) {
        alloc_locals;

        if (proof_len == 0) {
            return (curr,);
        }

        local node;
        local proof_elem = [proof];
        let le = is_le_felt(curr, proof_elem);

        if (le == 1) {
            let (n) = hash2{hash_ptr=pedersen_ptr}(curr, proof_elem);
            node = n;
        } else {
            let (n) = hash2{hash_ptr=pedersen_ptr}(proof_elem, curr);
            node = n;
        }

        let (res) = calculate_root(node, proof_len - 1, proof + 1);
        return (res,);
    }
}

// ##
// In summary, the verify function uses the calculate_root function to verify the validity of a proof of inclusion for a leaf value in a Merkle tree,
// and the calculate_root function calculates the root of a Merkle tree given a leaf value and a proof of inclusion.
// ##