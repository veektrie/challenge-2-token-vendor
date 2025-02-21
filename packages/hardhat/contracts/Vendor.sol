pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

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

    // ToDo: create a sellTokens(uint256 _amount) function:
}
