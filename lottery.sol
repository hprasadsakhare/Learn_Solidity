// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Lottery {
    address public owner;
    address payable[] public players;

    constructor() {
        owner = msg.sender;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // Enter the lottery
    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum entry fee is 0.01 ether");
        players.push(payable(msg.sender));
    }

    // Generate a pseudo-random number (not secure for production)
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    // Pick a winner and transfer the balance
    function pickWinner() public onlyOwner {
        require(players.length > 0, "No players in the lottery");
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        // Reset the players array
        players = new address payable[](0);
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}