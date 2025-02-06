// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract allowance{
    receive() payable external{

    }
    function checkBal() public view returns(uint){
        return address(this).balance;
    }
}