pragma solidity ^0.6.0;

contract ItemManager {

    enum SupplyChainState{Created, Paid, Delivered}

    struct Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint => Item) public items;
    uint itemIndex;

    event SupplyChainStage(uint _itemIndex, uint _step);

    function createItem(string memory _identifier, uint _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStage(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice == msg.value, "Not the price of the item!");
        require(items[_itemIndex]._state == SupplyChainState.Created, "You have already paid for this!");

        items[_itemIndex]._state = SupplyChainState.Paid;
    }  

    function triggerDelivery(uint _itemIndex) public {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is either not paid for or further in the chain!");
        items[_itemIndex]._state = SupplyChainState.Delivered;
    }
}