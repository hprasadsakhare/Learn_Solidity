// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract lottery{
    address public owner;
    address payable[] public players;

    constructor(){
        owner = msg.sender;
    }

    function enter() public payable{
        
    }
}