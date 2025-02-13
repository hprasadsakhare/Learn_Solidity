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

    function getRefund() public {
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
        address payable receiver;
        uint noOfVoters;
        mapping(address => bool) votes;
        bool completed;
    }

    mapping(uint => Requests) public AllRequests;
    uint public numReq;

    modifier isOwner(){
        require(msg.sender == owner, "You are not owner");
        _;
    }

    function createRequest(string memory _description, uint _amount, address payable _receiver) isOwner public {
        Requests storage newRequest = AllRequests[numReq];
        numReq++;

        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.receiver = _receiver;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function votingForRequest(uint reqNum) public {
        require(funders[msg.sender] > 0, "Not a Funder");
        Requests storage thisRequest = AllRequests[reqNum];

        require(thisRequest.votes[msg.sender] == false, "Already Voted");
        thisRequest.votes[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint reqNum) public{
         
    }
}
