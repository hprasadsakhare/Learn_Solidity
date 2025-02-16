// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Allowance {
    receive() external payable {}

    mapping(address => uint) public allowances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier hasAllowance(uint amt) {
        require(allowances[msg.sender] >= amt, "Insufficient allowance");
        _;
    }

    function checkBal() external view returns (uint) {
        return address(this).balance;
    }

    function setAllowance(address _to, uint amt) external onlyOwner {
        allowances[_to] = amt;
    }

    function withdraw(uint amt) external hasAllowance(amt) {
        require(address(this).balance >= amt, "Contract balance too low");
        allowances[msg.sender] -= amt;
        payable(msg.sender).transfer(amt);
    }

    function adjustAllowance(address _to, uint amt, bool increase) external onlyOwner {
        if (increase) {
            allowances[_to] += amt;
        } else {
            require(allowances[_to] >= amt, "Allowance too low");
            allowances[_to] -= amt;
        }
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}
