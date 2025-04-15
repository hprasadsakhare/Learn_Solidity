// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Escrow {
    address public buyer;
    address public seller;
    address public arbiter; // A third party who resolves disputes
    uint256 public amount;
    bool public buyerApproval;
    bool public sellerApproval;

    enum EscrowState { AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE, DISPUTED }
    EscrowState public state;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function.");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function.");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only the arbiter can call this function.");
        _;
    }

    modifier inState(EscrowState _state) {
        require(state == _state, "Invalid state for this action.");
        _;
    }

    constructor(address _buyer, address _seller, address _arbiter) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        state = EscrowState.AWAITING_PAYMENT;
    }

    // Buyer deposits funds into escrow
    function deposit() external payable onlyBuyer inState(EscrowState.AWAITING_PAYMENT) {
        require(msg.value > 0, "Deposit amount must be greater than 0.");
        amount = msg.value;
        state = EscrowState.AWAITING_DELIVERY;
    }

    // Buyer approves the release of funds
    function approveDelivery() external onlyBuyer inState(EscrowState.AWAITING_DELIVERY) {
        buyerApproval = true;
        finalize();
    }

    // Seller confirms the transaction is complete
    function confirmDelivery() external onlySeller inState(EscrowState.AWAITING_DELIVERY) {
        sellerApproval = true;
        finalize();
    }

    // Arbiter resolves disputes
    function resolveDispute(bool releaseToSeller) external onlyArbiter inState(EscrowState.DISPUTED) {
        if (releaseToSeller) {
            payable(seller).transfer(amount);
        } else {
            payable(buyer).transfer(amount);
        }
        state = EscrowState.COMPLETE;
    }

    // Mark contract as disputed (only buyer or seller can do this)
    function dispute() external {
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can dispute.");
        state = EscrowState.DISPUTED;
    }

    // Finalize the transaction if both parties approve
    function finalize() internal {
        if (buyerApproval && sellerApproval) {
            payable(seller).transfer(amount);
            state = EscrowState.COMPLETE;
        }
    }

    // Refund the buyer if the seller fails to deliver
    function refundBuyer() external onlyBuyer inState(EscrowState.AWAITING_DELIVERY) {
        payable(buyer).transfer(amount);
        state = EscrowState.COMPLETE;
    }
}