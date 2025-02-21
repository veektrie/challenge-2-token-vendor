pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("Gold", "GLD") {
        // Mint 1000 tokens (with 18 decimals) to the deployer address (msg.sender)
        _mint(0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0, 1000 * 10 ** 18);
    }
}
