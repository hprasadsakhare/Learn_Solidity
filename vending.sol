// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract vandingMachine{
    address public owner;
    mapping (address => uint) public dounutBalance;
    constructor(){
        owner = msg.sender;
        dounutBalance[address(this)] = 100;
    }


    function getVendingMachineBalance() public view returns (uint) {
        return dounutBalance[address(this)];
    }
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine.");
        donutBalance[address(this)] += amount;
    }
// new function a

    function purchase(uint amount) public payable{
        require(msg.value >= amount * 2 ether,"You must pay 2 ether per dountu");
        require(donutBalance[address(this)] >= amount, "There are not enough donuts available");
        donutBalance[address(this)] -= amount;
        donutBalance[msg.sender] += amount;
    }//new funciton
}

