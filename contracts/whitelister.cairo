// SPDX-License-Identifier: MIT

%lang starknet

// ##
// inspired from: https://github.com/ncitron/cairo-merkle-distributor/blob/master/contracts/distributor.cairo
// ##

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address

from contracts.merkletree import verify

@storage_var
func merkle_root() -> (root: felt){
}

@storage_var
func whitelisted_users(account : felt) -> (is_whitelisted: felt) {
}

@event
func whitelisted_user(account: felt, is_whitelisted: felt) {
}

@constructor
func constructor{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        root: felt,
    ){
    merkle_root.write(value=root);
    return ();
    }

@external
func whitelist{
        syscall_ptr: felt*,
        pedersen_ptr: HashBuiltin*,
        range_check_ptr
    }(
        recipient: felt,
        proof_len: felt,
        proof: felt*
    ) {

    let (leaf) = hash2{hash_ptr=pedersen_ptr}(recipient);

    // check that leaf has not been claimed
    let (claimed) = has_claimed.read(leaf);
    assert claimed = 0;

    // check that proof is valid
    let (root) = merkle_root.read();
    local root_loc = root;
    let (proof_valid) = verify(leaf, root, proof_len, proof);

    assert proof_valid = 1;

    // do whatever you want here (token transfer, whitelisting, etc.)
    let (sender_address) = get_caller_address();
    whitelisted_users.write(sender_address, 1);

    // mark leaf as claimed
    has_claimed.write(leaf, 1);

    // emit whitelisted_user
    whitelisted_user.emit(sender_address, 1);

    return ();
}