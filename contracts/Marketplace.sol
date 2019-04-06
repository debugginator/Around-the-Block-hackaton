contract Marketplace {
    mapping(address => PrivateData) sellerToData;
    mapping(address => uint) sellerToId;
    address[] sellers;

    modifier isRegistered(address _seller) {
        require(sellerToId[_seller] > 0);
        _;
    }

    function registerAsSeller() public returns(uint) {
        require(sellerToId[msg.sender] == 0);
        uint id = sellers.push(msg.sender);
        sellerToId[msg.sender] = id;
        return id;
    }

    function deRegisterAsSeller() public {
        uint sellerId = sellerToId[msg.sender];
        delete sellerToId[msg.sender];
        delete sellers[sellerId];
        delete sellerToData[msg.sender];
    }

    function getSellers() public view returns(address[] memory) {
        return sellers;
    }

    function putDataOnMarket(PrivateData _data) public isRegistered(msg.sender) {
        sellerToData[msg.sender] = _data;
    }

    function getPriceFromSeller(address _seller) public view returns(uint) {
        return sellerToData[_seller].getPrice();
    }

    function buyFromSeller(address _seller) public payable returns(string memory) {
        PrivateData data = sellerToData[_seller];
        data.buyAccess.value(msg.value)();
        return data.getDataHash();
    }

}
