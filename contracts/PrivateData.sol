pragma solidity ^0.5.0;

contract PrivateData {
    // Constants
    address owner;
    string private dataHash;

    // Variables
    uint dataPrice;

    // Structures
    mapping(address => bool) buyerToAccess;

    //Events

    //Modifiers
    modifier hasAccess (address _buyer) {
        require(buyerToAccess[_buyer]);
        _;
    }

    modifier isOwner (address user) {
        require(owner == user);
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

    function buyAccess() public payable {
        require(msg.value >= dataPrice);
        _grantAccess(msg.sender);
    }

    function getDataHash() public view hasAccess(msg.sender) returns (string memory) {
        return dataHash;
    }

    // Internal functions

    function _revokeAccess(address _buyer) internal {
        buyerToAccess[_buyer] = false;
    }

    function _grantAccess(address _buyer) internal {
        buyerToAccess[_buyer] = true;
    }

    // constraints like payment or privacy requirements
    // data decryption key privately?? stored by this contract
    // privatley - idea: sign decrytpion key with your public key and this contract decrypts it
}