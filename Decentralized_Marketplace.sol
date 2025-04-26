// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


contract DecentralizedMarketplace {
    struct Item {
        uint id;
        string name;
        string description;
        uint price;
        uint quantity;
        address payable seller;
    }

    mapping(uint => Item) public items;
    mapping(address => uint[]) public sellerItems;
    uint public itemCount;



    event ItemListed(uint indexed id, string name, uint price, uint quantity, address indexed seller);
    event ItemPurchased(uint indexed id, address indexed buyer, uint quantity);
    event ItemUpdated(uint indexed id, string name, uint price, uint quantity);
    event ItemDeleted(uint indexed id);

    error NotSeller();
    error ItemDoesNotExist();
    error InsufficientFunds();
    error NotEnoughQuantity();
    error InvalidPrice();
    error InvalidQuantity();

    modifier onlySeller(uint _id) {
        if (items[_id].seller != msg.sender) revert NotSeller();
        _;
    }

    function listItem(string memory _name, string memory _description, uint _price, uint _quantity) external {
        if (_price <= 0) revert InvalidPrice();
        if (_quantity <= 0) revert InvalidQuantity();
        
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _description, _price, _quantity, payable(msg.sender));
        sellerItems[msg.sender].push(itemCount);
        
        emit ItemListed(itemCount, _name, _price, _quantity, msg.sender);
    }

    function buyItem(uint _id, uint _quantity) external payable {
        Item storage item = items[_id];
        if (item.id == 0) revert ItemDoesNotExist();
        if (item.quantity < _quantity) revert NotEnoughQuantity();
        if (msg.value < item.price * _quantity) revert InsufficientFunds();
        
        item.seller.transfer(msg.value);
        item.quantity -= _quantity;
        
        emit ItemPurchased(_id, msg.sender, _quantity);
    }

    function editItem(uint _id, string memory _name, string memory _description, uint _price, uint _quantity) external onlySeller(_id) {
        Item storage item = items[_id];
        item.name = _name;
        item.description = _description;
        item.price = _price;
        item.quantity = _quantity;
        
        emit ItemUpdated(_id, _name, _price, _quantity);
    }


    function deleteItem(uint _id) external onlySeller(_id) {
        delete items[_id];
        emit ItemDeleted(_id);
    }
}
