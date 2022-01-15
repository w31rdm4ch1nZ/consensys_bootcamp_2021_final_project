/*
  The shell for decentralized proof of existence, enabling the verification
  of the existence of the content produced by the proivider. Then only it has 
  to pass a number of automated checks, derived from the RfC data structure/token.
*/
// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22 <0.9.0;

contract ProofOfExistence1 {      // state
      bytes32 public proof;

      // calculate and store the proof for a document
      // *transactional function*
      function notarize(string memory content) public {
        proof = proofFor(content);
      }

      // helper function to get a document's sha256
      // *read-only function*
      function proofFor(string memory content) public pure returns (bytes32) {
        return sha256(abi.encodePacked(content));
      }
}
