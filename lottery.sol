// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract lottery{
    address public owner;
    address payable[] public players;

    constructor(){
        owner = msg.sender;
    }


function getBalance()public view returns(uint){
    return address(this).balance;
}

function getPlayer()public view return(address payable[] memory){
    return players;
}

//enter function
    function enter() public payable{
        require(msg.value > .01 ether);
        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    
    function getRandomNumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public{
       
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        //result the state of contract

        players = new address payable[](0);

    }

    //new 
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
}