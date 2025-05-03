// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

// withdraw

contract HelloSimple    {
    
    // Making sure the contract can receive funds
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}
    
    function getFunds() public view returns(uint)   {
        return address(this).balance;
    }
    // Sending funds from owner to someone else

    mapping(address => uint) public balances;

    error InsufficientBalance(uint requested, uint available);
    event Sent(uint amount, address sender, address receiver);

    function deposit(address to, uint _amount) public   {
        if (balances[owner] < _amount)
        revert InsufficientBalance({
            requested: _amount,
            available: balances[owner]
        });

        balances[owner] -= _amount;
        balances[to] += _amount;    
        emit Sent(_amount, owner, to);
    }

}