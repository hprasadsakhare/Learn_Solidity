// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract RealEstateAgreement{
    uint256 public price;
    bool public sellerPaysClosingFees;

    constructor(uint256 _price) {
        price = _price;
        sellerPaysClosingFees = false;
    }

    function setPrice(uint _price) public{
        price = _price;
    }

    function setClosingFeeAgreement(bool _ownerPays) public{
        sellerPaysClosingFees = _ownerPays;
    }

}