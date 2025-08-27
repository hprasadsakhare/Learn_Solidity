// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Hostel {

    address public contractOwner;

    uint public no_of_rooms = 0;
    uint public no_of_agreement = 0;
    uint public no_of_rent = 0;

    constructor() {
        contractOwner = msg.sender;
    }

    struct Room {
        uint roomid;
        uint agreementid;
        string roomname;
        string roomaddress;
        uint rent_per_month;
        uint securityDeposit;
        uint timestamp;
        bool vacant;
        address payable landlord;
        address payable currentTenant;
    }

    mapping(uint => Room) public rooms;

    event RoomAdded(uint roomid, address landlord);
    event AgreementCreated(uint roomid, address tenant);
    event RentPaid(uint roomid, address tenant, uint amount);
    event DepositWithdrawn(uint roomid, address landlord);

    modifier onlyLandlord(uint roomid) {
        require(msg.sender == rooms[roomid].landlord, "Only landlord can call this");
        _;
    }

    modifier onlyTenant(uint roomid) {
        require(msg.sender == rooms[roomid].currentTenant, "Only tenant can call this");
        _;
    }

    // Add new room (Only landlord/owner can do)
    function addRoom(
        string memory _roomname,
        string memory _roomaddress,
        uint _rent_per_month,
        uint _securityDeposit
    ) public {
        no_of_rooms++;
        rooms[no_of_rooms] = Room({
            roomid: no_of_rooms,
            agreementid: 0,
            roomname: _roomname,
            roomaddress: _roomaddress,
            rent_per_month: _rent_per_month,
            securityDeposit: _securityDeposit,
            timestamp: 0,
            vacant: true,
            landlord: payable(msg.sender),
            currentTenant: payable(address(0))
        });

        emit RoomAdded(no_of_rooms, msg.sender);
    }

    // Tenant agrees to rent the room
    function createAgreement(uint _roomid) public payable {
        Room storage room = rooms[_roomid];
        require(room.vacant, "Room is already occupied");
        require(msg.value == room.securityDeposit, "Deposit must be equal to the security deposit");

        room.currentTenant = payable(msg.sender);
        room.timestamp = block.timestamp;
        room.vacant = false;
        no_of_agreement++;
        room.agreementid = no_of_agreement;

        emit AgreementCreated(_roomid, msg.sender);
    }

    // Tenant pays rent
    function payRent(uint _roomid) public payable onlyTenant(_roomid) {
        Room storage room = rooms[_roomid];
        require(!room.vacant, "Room is vacant");
        require(msg.value == room.rent_per_month, "Incorrect rent amount");

        room.landlord.transfer(msg.value);
        no_of_rent++;

        emit RentPaid(_roomid, msg.sender, msg.value);
    }

    // End agreement and release room
    function endAgreement(uint _roomid) public onlyLandlord(_roomid) {
        Room storage room = rooms[_roomid];
        require(!room.vacant, "Room already vacant");

        room.currentTenant.transfer(room.securityDeposit); // refund deposit
        room.currentTenant = payable(address(0));
        room.vacant = true;
        room.timestamp = 0;
        room.agreementid = 0;
    }

    // View room info
    function getRoomDetails(uint _roomid) public view returns (
        string memory roomname,
        string memory roomaddress,
        uint rent,
        uint deposit,
        bool isVacant,
        address tenant,
        address landlord
    ) {
        Room storage room = rooms[_roomid];
        return (
            room.roomname,
            room.roomaddress,
            room.rent_per_month,
            room.securityDeposit,
            room.vacant,
            room.currentTenant,
            room.landlord
        );
    }
}
