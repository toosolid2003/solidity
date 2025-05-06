// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
import "node_modules/hardhat/console.sol";


contract simpleStorage  {
    uint storedData;

    event Stored(uint x);

    function set(uint x) public {
        storedData = x;
        console.log("Adding x to storedData");
        emit Stored(x);
    }

    function get() public view returns (uint)   {
        return storedData;
    }
}