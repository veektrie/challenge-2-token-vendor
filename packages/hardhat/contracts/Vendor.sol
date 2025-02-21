pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    // Removed the extra parentheses here
    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    // Payable function to allow users to buy tokens
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");

        // Calculate the number of tokens to send: msg.value (in wei) * tokensPerEth
        uint256 amountOfTokens = msg.value * tokensPerEth;

        // Transfer tokens from Vendor's balance to msg.sender
        bool sent = yourToken.transfer(msg.sender, amountOfTokens);
        require(sent, "Token transfer failed");

        // Emit the event with purchase details
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    // ToDo: create a sellTokens(uint256 _amount) function:
}
