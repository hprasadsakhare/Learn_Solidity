// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract RealEstateAgreement {
    address private owner;
    uint256 public price;
    bool public sellerPaysClosingFees;

    constructor(uint256 _price) {
        owner = msg.sender;
        price = _price;
        sellerPaysClosingFees = false;
    }

    receive() external payable {} // ether

    fallback() external payable {} // ether + data

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "only the owner can update agreement terms."
        );
        _;
    }
    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }


    function setClosingFeeAgreement(bool _ownerPays) public virtual onlyOwner {
        sellerPaysClosingFees = _ownerPays;
    }
}
