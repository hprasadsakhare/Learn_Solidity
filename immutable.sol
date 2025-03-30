// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;


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
    
    
    function I() public view returns(address){
        return owner;
    }
    function c() public pure returns(address){
        return owner2;
    }
    function s() public view returns(address){
        return owner3;
    }

}