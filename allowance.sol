// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Allowance {
    receive() external payable {}

    function checkBal() public view returns (uint) {
        return address(this).balance;
    }

    mapping(address => uint) public allowances;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _;
    }

    function addAllowances(address _to, uint amt) public onlyOwner {
        allowances[_to] += amt;
    }

    function withdraw(uint amt) public {
        require(allowances[msg.sender] >= amt, "Insufficient allowance");
        require(address(this).balance >= amt, "Contract balance too low");
        
        allowances[msg.sender] -= amt;
        payable(msg.sender).transfer(amt);
    }

    function reduceAllowance(address _to, uint amt) public onlyOwner {
        require(allowances[_to] >= amt, "Allowance too low");
        allowances[_to] -= amt;
    }

    function resetAllowance(address _to) public onlyOwner {
        allowances[_to] = 0;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}
