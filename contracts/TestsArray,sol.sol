pragma solidity ^0.8.0;

contract DynamicArrayExample {
    uint256[] public dynamicArray;

    function addElement(uint256 element) public {
        dynamicArray.push(element);
    }

        function reduceElem() public {
        delete dynamicArray[1];
    }

    function getWhole() public view returns(uint256[] memory) {
        return dynamicArray;
    }
}