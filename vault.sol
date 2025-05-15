// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "node_modules/hardhat/console.sol";

contract Vault  {
    address owner;

    event Deposit(address contributor, uint amount);
    event Withdraw(uint amount);

    constructor()   {
        owner = msg.sender;
    }
    modifier onlyOwner()    {
        require(msg.sender == owner, "User not allowed");
    }

    // Withdraw: only owner can withdraw
    function withdraw() public payable onlyOwner()  {

        (bool _sent,) = payable(owner).call{value: msg.value}("");
        require(_sent, "Withdrawal failed");
        emit Withdraw(msg.value);
    }

    // Deposit: public function, anyone can contribute
    receive() external payable  {
        emit Deposit(contributor, amount);
    }

    // Fallback next

    // checkbalance to return the current contract balance
    function checkBalance() public view returns(uint256)  {
        return address(this).balance;
    }
}