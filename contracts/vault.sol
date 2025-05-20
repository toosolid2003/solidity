// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard  {
    address owner;

    event Deposit(address contributor, uint amount);
    event Withdraw(uint amount);

    constructor() payable {
        owner = msg.sender;
    }
    modifier onlyOwner()    {
        require(msg.sender == owner, "User not allowed");
        _;
    }

    bool public paused;
    modifier whenNotPaused()    {
        require(!paused, "Contract is paused. Try again later");
        _;
    }

    // Withdraw: only owner can withdraw
    function withdraw() public onlyOwner() nonReentrant {

        uint256 contractBalance = address(this).balance;
        (bool _sent,) = payable(owner).call{value: contractBalance}("");
        require(_sent, "Withdrawal failed");
        emit Withdraw(contractBalance);
    }

    // Deposit: public function, anyone can contribute
    // this one needs to be called explicitly
    function deposit() external payable whenNotPaused nonReentrant {
        require(msg.value > 0, "Must contain ethers");
        require(msg.value <= 2 ether, "Deposit value too high");

        emit Deposit(msg.sender, msg.value);
    }

    receive() external payable  {
        emit Deposit(msg.sender, msg.value);
    }

    // Fallback next

    // checkbalance to return the current contract balance
    function checkBalance() public view returns(uint256)  {
        return address(this).balance;
    }
}