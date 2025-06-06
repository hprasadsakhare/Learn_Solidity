// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Trust {
    struct Kid {
        uint amount;
        uint maturity;
        bool paid;
    }

    mapping(address => Kid) public kids;
    address public admin;

    event KidAdded(address indexed kid, uint amount, uint maturityTime);
    event Withdrawal(address indexed kid, uint amount);

    constructor() {
        admin = msg.sender;
    }


    // Function to add a kid's trust
    function addKid(address kid, uint timeToMaturity) external payable {
        require(msg.sender == admin, "Only admin can add kids");
        require(kids[kid].amount == 0, "Kid already exists");
        require(msg.value > 0, "Must send ETH");

        kids[kid] = Kid({
            amount: msg.value,
            maturity: block.timestamp + timeToMaturity,
            paid: false
        });

        emit KidAdded(kid, msg.value, block.timestamp + timeToMaturity);
    }


    // Function for kids to withdraw after maturity
    function withdraw() external {
        Kid storage kidData = kids[msg.sender];
        require(kidData.amount > 0, "No funds assigned");
        require(block.timestamp >= kidData.maturity, "Too early to withdraw");
        require(!kidData.paid, "Already withdrawn");

        kidData.paid = true;
        payable(msg.sender).transfer(kidData.amount);

        emit Withdrawal(msg.sender, kidData.amount);
    }

    // View function to get remaining time for a kid
    function timeLeft(address kid) external view returns (uint) {
        if (block.timestamp >= kids[kid].maturity) {
            return 0;
        } else {
            return kids[kid].maturity - block.timestamp;
        }
    }
    

    // Allow admin to check kid's status
    function getKidDetails(address kid) external view returns (uint, uint, bool) {
        Kid memory k = kids[kid];
        return (k.amount, k.maturity, k.paid);
    }
}
