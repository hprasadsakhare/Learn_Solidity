// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract VendingMachine {
    address public owner;
    mapping(address => uint) public donutBalance;

    constructor() {
        owner = msg.sender;
        donutBalance[address(this)] = 100;
    }

    
    function getVendingMachineBalance() public view returns (uint) {
        return donutBalance[address(this)];
    }

    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine.");
        donutBalance[address(this)] += amount;
    }

    function purchase(uint amount) public payable {
        require(msg.value >= amount * 2 ether, "You must pay 2 ether per donut");
        require(donutBalance[address(this)] >= amount, "There are not enough donuts available");
        donutBalance[address(this)] -= amount;
        donutBalance[msg.sender] += amount;
    }
}