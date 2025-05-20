import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";

import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

describe("Vault", function()  {
  
  // Create test fixture for further reuse
  async function deployVault()  {
    // Generate random address
    const [owner, otherAccount] = await hre.ethers.getSigners();

    // Amount locked in the contract
    const lockedAmount = ethers.parseEther("1.0");

    // Deploy the contract
    const vault = await hre.ethers.deployContract("Vault", {
      value: lockedAmount,
    });

    return { vault, owner, otherAccount, lockedAmount};
  }

  // Test 1: only owner is allowed to withdraw
  it("should not allow anyone but the owner to withdraw", async function()  {
    
    const { vault, otherAccount } = await loadFixture(deployVault);
    
    await expect(vault.connect(otherAccount).withdraw()).to.be.revertedWith("User not allowed");
  })

// Test 2: it should accept deposits from anyone
  it("should allow anyone to deposit funds", async function() {
    const { vault, otherAccount } = await loadFixture(deployVault);

    const depositAm = ethers.parseEther("1.0");
    const tx = await vault.connect(otherAccount).deposit( {value: depositAm});
    await tx.wait();

    const balance = await vault.checkBalance();
    expect(balance).to.equal(ethers.parseEther("2.0"));
  })

  

// Test 3: balance check
  it("should return the balance of the contract", async function()  {
    const { vault } = await loadFixture(deployVault);
    const balance = await vault.checkBalance();
    expect(balance).to.equal(ethers.parseEther("1.0"));
  })

// Test 4: withdraw allowed for owner
  it("should allow the owner to withdraw the funds", async function () {
    const { vault, owner } = await loadFixture(deployVault);
    
    const tx = await vault.connect(owner).withdraw();
    const receipt = tx.wait();

    const contractBalance = await vault.checkBalance();
    expect(contractBalance).to.equal(0);
  })

// Test 5: it should allow multiple users to deposit funds
it("should allow multiple users to deposit funds", async function() {
  const [ user1, user2, user3 ] = await hre.ethers.getSigners();
  const  { vault } = await loadFixture(deployVault);

  const deposit1 = await vault.connect(user1).deposit({ value: ethers.parseEther("0.5")});
  const deposit2 = await vault.connect(user2).deposit({ value: ethers.parseEther("0.5")});
  const deposit3 = await vault.connect(user3).deposit({ value: ethers.parseEther("0.5")});

  const contractBalance = await vault.checkBalance();
  expect(contractBalance).to.equal(ethers.parseEther("2.5"));
})
})
