// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract RealEstateAgreement {
    address payable public owner;
    address public buyer;
    uint256 public price;
    bool public sellerPaysClosingFees;
    bool public isSold;

    event AgreementUpdated(uint256 newPrice, bool sellerPaysFees);
    event PropertyPurchased(address indexed buyer, uint256 price);
    event FundsWithdrawn(address indexed to, uint256 amount);

    constructor(uint256 _price) {
        owner = payable(msg.sender);
        price = _price;
        sellerPaysClosingFees = false;
        isSold = false;
    }

    // Allow the contract to receive Ether
    receive() external payable {}
    fallback() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can update agreement terms.");
        _;
    }

    modifier notSold() {
        require(!isSold, "Property already sold.");
        _;
    }

    function setPrice(uint256 _price) public onlyOwner notSold {
        price = _price;
        emit AgreementUpdated(price, sellerPaysClosingFees);
    }

    function setClosingFeeAgreement(bool _ownerPays) public onlyOwner notSold {
        sellerPaysClosingFees = _ownerPays;
        emit AgreementUpdated(price, sellerPaysClosingFees);
    }

    function buyProperty() public payable notSold {
        require(msg.value == price, "Incorrect payment amount.");
        buyer = msg.sender;
        isSold = true;
        emit PropertyPurchased(buyer, msg.value);
    }

    function withdrawFunds() public onlyOwner {
        require(isSold, "Property not sold yet.");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw.");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed.");
        emit FundsWithdrawn(owner, balance);
    }


    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
