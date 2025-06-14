// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPFSHashStorage {
    address private owner;
    string private ipfsHash;

    event HashSet(address indexed setter, string hash);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function setIPFSHash(string memory _ipfsHash) public onlyOwner {
        ipfsHash = _ipfsHash;
        emit HashSet(msg.sender, _ipfsHash);
    }

    function getIPFSHash() public view returns (string memory) {
        return ipfsHash;
    }
}
