// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
contract Trust{
    struct Kid{
        uint amount;
        uint maturity;
        bool paid;
    }
    
    mapping(address => Kid) public kids;
    address public admin;
// ghj
    constructor(){
        admin = msg.sender;
    }


// aha
    function addKid(address kid, uint timeToMaturity) external payable {
        require(msg.sender == admin,'only admin');
        require(kids[msg.sender].amount == 0, 'kid already exit');
        kids[kid] = Kid(msg.value, block.timestamp + timeToMaturity, false);
    }

    function withdraw(address kid) external{
        Kid storage kid = kids[msg.sender];
        require(kid.maturity <= block.timestamp,"too early");
        require(kid.amount >0, "only kid can withdraw");
        require(kid.paid == false,'paid already');
        kid.paid = true;
        payable(msg.sender).transfer(kid.amount);
    }
}