// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

// withdraw

contract HelloSimple    {
    
    // mapping adresses et balances
    mapping(address => uint) public balances;

    error InsufficientBalance(uint requested, uint available);
    event Sent(uint amount, address sender, address receiver);

    function deposit(address to, uint _amount) public   {
        if (balances[msg.sender] < _amount)
        revert InsufficientBalance({
            requested: _amount,
            available: balances[msg.sender]
        });

        balances[msg.sender] -= _amount;
        balances[to] += _amount;    
        emit Sent(_amount, msg.sender, to);
    }

}