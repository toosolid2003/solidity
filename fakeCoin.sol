// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "node_modules/hardhat/console.sol";

contract Coin   {
    // Mot-cle "public" pour rendre variable accessible depuis d'autres contrats

    address public minter;
    mapping (address => uint) public balances;

    event Sent(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
        console.log("Money has been minted");
    }

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])   
        revert InsufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        });

        balances[msg.sender] -= amount;
        console.log("Sender's account updated");

        balances[receiver] += amount;
        console.log("Receiver's account updated");

        emit Sent(msg.sender, receiver, amount);
    }
}