pragma solidity ^0.5.1;

contract PrivateData {
    // Constants
    address owner;
    string private dataHash; // IPFS

    // Variables
    uint dataPrice;

    // Structures
    mapping(address => bool) buyerToAccess;

    //Events
    event dataAccessGranted(address _buyer);
    event dataAccessRevoked(address _buyer);

    //Modifiers
    modifier hasAccess (address _buyer) {
        require(buyerToAccess[_buyer]);
        _;
    }

    modifier isOwner (address _address) {
        require(owner == _address);
        _;
    }

    constructor (string memory _dataHash, uint _price) public {
        owner = msg.sender;
        dataHash = _dataHash;
        dataPrice = _price;

        _grantAccess(owner);
    }

    // Public functions (API)

    function getPrice() public view returns(uint) {
        return dataPrice;
    }

    function setPrice(uint _price) public isOwner(msg.sender) {
        dataPrice = _price;
    }

    function getOwner() public view returns(address) {
        return owner;
    }

    function buyAccess() public payable {
        require(msg.value >= dataPrice);
        _grantAccess(msg.sender);
    }

    function revokeAccess(address _buyer) public isOwner(msg.sender) {
        _revokeAccess(_buyer);
    }

    function getDataHash() public view hasAccess(msg.sender) returns (string memory) {
        return dataHash;
    }

    // Internal functions

    function _revokeAccess(address _buyer) internal {
        buyerToAccess[_buyer] = false;
        emit dataAccessRevoked(_buyer);
    }

    function _grantAccess(address _buyer) internal {
        buyerToAccess[_buyer] = true;
        emit dataAccessGranted(_buyer);
    }
}