// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

interface IFakeToken {
    function transfer(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
}

contract AirdropToken {
    
    event AirdropTransfer(address indexed to, uint256 amount);
    event AirdropTransferFrom(address indexed from, address indexed to, uint256 amount);

    /**
     * @notice Performs airdrop by transferring tokens directly from contract's balance.
     */
    function airdropWithTransfer(
        IFakeToken _token,
        address[] memory _addressArray,
        uint256[] memory _amountArray
    ) public {
        require(_addressArray.length == _amountArray.length, "Mismatched arrays");

        for (uint256 i = 0; i < _addressArray.length; i++) {
            require(_token.transfer(_addressArray[i], _amountArray[i]), "Transfer failed");
            emit AirdropTransfer(_addressArray[i], _amountArray[i]);
        }
    }

    /**
     * @notice Performs airdrop by transferring tokens from msg.sender using allowance.
     */
    function airdropWithTransferFrom(
        IFakeToken _token,
        address[] memory _addressArray,
        uint256[] memory _amountArray
    ) public {
        require(_addressArray.length == _amountArray.length, "Mismatched arrays");

        for (uint256 i = 0; i < _addressArray.length; i++) {
            require(_token.transferFrom(msg.sender, _addressArray[i], _amountArray[i]), "TransferFrom failed");
            emit AirdropTransferFrom(msg.sender, _addressArray[i], _amountArray[i]);
        }
    }
}
