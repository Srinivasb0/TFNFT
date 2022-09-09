// SPDX-License-Identifier: MIT
/**
 * @file fractionalNFT.sol
 * @author Jackson Ng <jackson@jacksonng.org>
 * @date created 13th Mar 2022
 * @date last modified 20th Mar 2022
 */

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract FNFToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("FNFToken", "FNT") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}