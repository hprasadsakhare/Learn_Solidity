// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract lottery{
    address public owner;
    address payable[] public players;

    constructor(){
        owner = msg.sender;
    }


//enter function
    function enter() public payable{
        require(msg.value > .01 ether);
        players.push(payable(msg.sender));
    }
    
    function getRandomNumber() public view returns(uint){

    }
}