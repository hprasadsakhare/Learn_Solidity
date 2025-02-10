// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CrowdFunding{
    address public owner;
    mapping(address => uint) public funders;
    uint public goal;
    uint public minAmount;
    uint public noOfFunders;
    uint public fundsRaised;
    uint public timePeriod;

    constructor(uint _goal, uint _timePeriod){
        goal = _goal;
        timePeriod = block.timestamp + _timePeriod;
        owner = msg.sender;
        minAmount = 1000 wei;
    }

    function Contribute() public payable {
        require(block.timestamp < timePeriod, "Funding Time is Over!");
        require(msg.value >= minAmount, "Minimum amount criteria not satisfy");

        if(funders[msg.sender] == 0){
            noOfFunders++;
        }

        funders[msg.sender] += msg.value;
        fundsRaised += msg.value;
    }

    receive() external payable {
        Contribute();
    }
}
