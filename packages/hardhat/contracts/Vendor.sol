pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    // (Optional) You may add an event for selling tokens as well, for example:
    // event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    // Constructor initializes the Vendor with the address of YourToken.
    // Ownable is initialized with msg.sender as the owner.
    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // Payable function to allow users to buy tokens
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");

        // Calculate the number of tokens to send: for each 1 ETH (in wei) sent,
        // the buyer receives tokensPerEth tokens.
        uint256 amountOfTokens = msg.value * tokensPerEth;

        // Transfer tokens from Vendor's balance to msg.sender
        bool sent = yourToken.transfer(msg.sender, amountOfTokens);
        require(sent, "Token transfer failed");

        // Emit the event with purchase details
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // Withdraw function that lets the owner withdraw ETH from the contract
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH available to withdraw");
        (bool success, ) = payable(owner()).call{ value: balance }("");
        require(success, "Withdrawal failed");
    }

    // sellTokens function to allow users to sell tokens back to the Vendor.
    // Users must first call approve() on YourToken to allow the Vendor to spend their tokens.
    function sellTokens(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");

        // Calculate the amount of ETH to send back:
        // For every tokensPerEth tokens, the seller receives 1 ETH.
        uint256 ethAmount = _amount / tokensPerEth;

        // Ensure that the Vendor contract has enough ETH to pay the seller.
        require(address(this).balance >= ethAmount, "Vendor contract has insufficient ETH");

        // Transfer tokens from the seller to the Vendor contract.
        // This requires that the seller has already approved the Vendor contract.
        bool received = yourToken.transferFrom(msg.sender, address(this), _amount);
        require(received, "Token transfer failed");

        // Send ETH to the seller.
        (bool sent, ) = payable(msg.sender).call{ value: ethAmount }("");
        require(sent, "ETH transfer failed");
    }
}
