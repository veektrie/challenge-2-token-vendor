pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor {
    // event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    YourToken public yourToken;

    // Price: tokens per ETH
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");

        // Calculate the amount of tokens: for each 1 ETH (1e18 wei) sent, buyer gets tokensPerEth tokens (scaled by 1e18).
        uint256 amountOfTokens = msg.value * tokensPerEth;

        // Transfer tokens to msg.sender from the Vendor contract's balance
        bool sent = yourToken.transfer(msg.sender, amountOfTokens);
        require(sent, "Token transfer failed");

        // Emit event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens)
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    // ToDo: create a sellTokens(uint256 _amount) function:
}
