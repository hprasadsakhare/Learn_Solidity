// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IFakeToken {
    function transfer(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
}

contract AirdropToken {
    function airdropWithTransfer(
        IFakeToken _token,
        address[] memory _addressArray,
        uint256[] memory _amountArray
    ) public {
        require(_addressArray.length == _amountArray.length, "Mismatched arrays");

        for (uint256 i = 0; i < _addressArray.length; i++) {
            require(_token.transfer(_addressArray[i], _amountArray[i]), "Transfer failed");
        }
    }



    function airdropWithTransferFrom(
        IFakeToken _token,
        address[] memory _addressArray,
        uint256[] memory _amountArray
    )
    


     public {
        require(_addressArray.length == _amountArray.length, "Mismatched arrays");

        for (uint256 i = 0; i < _addressArray.length; i++) {
            require(_token.transferFrom(msg.sender, _addressArray[i], _amountArray[i]), "TransferFrom failed");
        }
    }
}
