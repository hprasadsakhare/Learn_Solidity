// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


contract Immutable{
    address public immutable owner;
    address public constant owner2 = address(1);
    address public owner3 = address(1);

    constructor(address _owner){
        owner = _owner;

    }

    //function check() public{
    //    owner = address(1);
    //}
}