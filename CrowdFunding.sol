// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract CrowdFunding {
    address public owner;
    mapping(address => uint) public funders;
    uint public goal;
    uint public minAmount;
    uint public noOfFunders;
    uint public fundsRaised;
    uint public timePeriod;

    constructor(uint _goal, uint _timePeriod) {
        goal = _goal;
        timePeriod = block.timestamp + _timePeriod;
        owner = msg.sender;
        minAmount = 1000 wei;
    }

    function Contribute() public payable {
        require(block.timestamp < timePeriod, "Funding Time is Over!");
        require(msg.value >= minAmount, "Minimum amount criteria not satisfied");

        if (funders[msg.sender] == 0) {
            noOfFunders++;
        }

        funders[msg.sender] += msg.value;
        fundsRaised += msg.value;
    }

    receive() external payable {
        Contribute();
    }

    function getReffund() public {
        require(block.timestamp > timePeriod, "Funding is still On!");
        require(fundsRaised < goal, "Funding was Successful");
        require(funders[msg.sender] > 0, "Not a funder");

        payable(msg.sender).transfer(funders[msg.sender]);
        fundsRaised -= funders[msg.sender];
        funders[msg.sender] = 0;
    }

    struct Requests {
        string description;
        uint amount;
        address payable reciver;
        uint noOfVoters;
        mapping(address => bool) votess;
        bool Completed;
    }

    mapping(uint => Requests) public AllRequests;
    uint public numReq;

    function createRequest(string memory _description, uint _amount, address payable _reciver) public {
        require(msg.sender == owner, "You are not the owner");
        Requests storage newRequest = AllRequests[numReq];
        numReq++;

        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.reciver = _reciver;
        newRequest.Completed = false;
        newRequest.noOfVoters = 0;
    }
}
