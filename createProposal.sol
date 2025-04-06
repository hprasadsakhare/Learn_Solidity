// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract ProposalContract {
    struct Proposal {
        string title;
        address proposer;
    }
    
    Proposal[] public proposals;

    function createProposal(string memory _title) public {
        proposals.push(Proposal(_title, msg.sender));
    }
}
