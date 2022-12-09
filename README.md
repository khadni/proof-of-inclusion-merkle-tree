# StarkNet tutorial - How to prove inclusion with a Merkle tree?

## Introduction

### Merkle tree 101

A Merkle tree is a **data structure used to check the consistency of data**. It achieves this by letting a person simply and rapidly **demonstrate that a certain piece of data is part of a wider set of data**.

Here's how it works: imagine you have a large set of data, such as a collection of documents. You want to be able to demonstrate that a certain document is included in this collection without having to share the complete set of data with the person to whom you're attempting to prove it.

To do this, you would construct a Merkle tree from the data. This entails collecting all of the data and applying a cryptographic hash function to generate a sequence of "hash values" for each piece of data. These hash values are then combined in a certain way to form a tree-like structure, with each hash value at the bottom of the tree combined with other hash values to form a new hash value further up the tree.

The figure below illustrates a Merkle tree in which every single letter represents a hash of a document. The combined letters represent concatenated hashes that have been joined and hashed to form a new hash.

```
 Merkle Root: ABCDEFGH
        /    \
     ABCD     EFGH
     / \      / \
    AB  CD   EF  GH
   / \  / \  / \ / \
   A B  C D  E F G H
```

### The Merkle proof: demonstrate the inclusion of a specific piece of data

After you've generated the tree, you may use it to demonstrate the inclusion of a specific piece of data. To accomplish this, just send the hash value for the exact piece of data you wish to verify is included, as well as the "Merkle proof" for that data, to the person you're attempting to prove it.

**The Merkle proof consists of a succession of hash values from the tree that demonstrate how the hash value for a given piece of data is obtained from the other hash values in the tree**. The person you're trying to prove it to may easily and quickly verify that the specific piece of data is included in the wider collection of data by starting with the specific piece of data and following the path through the tree represented by the Merkle proof.

Take a look at the Merkle tree from above. What do we need to verify that B belongs in this tree?

We just need `A`, `CD`, and `EFGH` to calculate `AB`, `ABCD`, and `ABCDEFGH`. The result may then be compared to the expected root `ABCDEFGH`.

So we just need three items out of an eight-element tree to verify that an element belongs in the tree. The average case for verification, as a rule, is log2(n), where n is the number of elements in the tree.

### Conclusion

A Merkle tree enables you to demonstrate the inclusion of a single piece of data in a larger amount of data without having to provide the full set of data. This can be beneficial in a number of scenarios. This is for instance used to verify transaction integrity in blockchains.

## Tutorial: how to design a contract that whitelists the addresses in a Merkle tree?

XXX
