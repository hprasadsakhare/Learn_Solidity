// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CrowdFunding{
    address public owner;
    mapping(address => uint) funders;
    uint public goal;
    uint public minAmount;
    uint public noOfFunders;
    uint public fundsRaised;
    uint public timePeriod;

    constructor(uint _goal,uint _tiemPeriod){
        goal = _goal;
        timePeriod = block.timestamp + _tiemPeriod;
        owner = msg.sender;
        minAmount = 1000 wei;
    }
}