// SPDX-License-Identifier: MIT

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math_cmp import is_le_felt

@contract_interface
namespace IMerkleTree {

    func verify(leaf: felt, merkle_root: felt, proof_len: felt, proof: felt*) -> (res: felt) {
    }

    func calculate_root(
        curr: felt, proof_len: felt, proof: felt*) -> (res: felt) {
    }
}