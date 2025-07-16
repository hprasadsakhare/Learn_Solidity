// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VendingMachine {
    address public owner;
    mapping(address => uint) public donutBalance;
    uint public constant DONUT_PRICE = 2 ether;
    uint public constant SELLBACK_PRICE = 1 ether; // Half price for selling back

    event DonutsPurchased(address indexed buyer, uint amount);
    event DonutsRestocked(uint amount);
    event DonutsSoldBack(address indexed seller, uint amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event WithdrawalCompleted(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
        donutBalance[address(this)] = 100;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    function getVendingMachineBalance() public view returns (uint) {
        return donutBalance[address(this)];
    }

    function getUserBalance(address user) public view returns (uint) {
        return donutBalance[user];
    }

    function restock(uint amount) public onlyOwner {
        donutBalance[address(this)] += amount;
        emit DonutsRestocked(amount);
    }

    function purchase(uint amount) public payable {
        require(msg.value >= amount * DONUT_PRICE, "You must pay 2 ether per donut");
        require(donutBalance[address(this)] >= amount, "There are not enough donuts available");
        donutBalance[address(this)] -= amount;
        donutBalance[msg.sender] += amount;
        
        // Refund excess payment if any
        uint excess = msg.value - (amount * DONUT_PRICE);
        if (excess > 0) {
            (bool success, ) = payable(msg.sender).call{value: excess}("");
            require(success, "Failed to refund excess payment");
        }
        
        emit DonutsPurchased(msg.sender, amount);
    }

    function sellBack(uint amount) public {
        require(donutBalance[msg.sender] >= amount, "You don't have enough donuts");
        require(address(this).balance >= amount * SELLBACK_PRICE, "Contract doesn't have enough ETH to buy back");
        
        donutBalance[msg.sender] -= amount;
        donutBalance[address(this)] += amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount * SELLBACK_PRICE}("");
        require(success, "Failed to send ETH");
        
        emit DonutsSoldBack(msg.sender, amount);
    }

    function withdrawFunds() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Failed to withdraw funds");
        
        emit WithdrawalCompleted(owner, balance);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner cannot be zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}