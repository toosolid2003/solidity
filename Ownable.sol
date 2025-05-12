// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "node_modules/hardhat/console.sol";

contract Ownable    {
    address owner;
    constructor()   {
        owner = msg.sender;
    }

    modifier onlyOwner()    {
       require(msg.sender == owner, "Not allowed");
       _;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner() {
        require(newOwner != address(0), "Invalid address");
        owner = payable(newOwner);
    }
}

// Child contract: secure store, a storage contract that inherits from Ownable and restricts access

contract secureStore is Ownable {
    function withdraw() onlyOwner() public payable {
        (bool sent,) = payable(owner).call{value:msg.value}("");
        require(sent,"Transfer failed");
    }
}

