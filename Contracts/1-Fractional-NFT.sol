// SPDX-License-Identifier: MIT
/**
 * @file fractionalNFT.sol
 * @author Jackson Ng <jackson@jacksonng.org>
 * @date created 13th Mar 2022
 * @date last modified 20th Mar 2022
 */

// address : 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./1-FNFToken.sol";

contract FractionalNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct _fnft{
        uint256 tokenId;
        address fractionalToken;

    }

    mapping(uint256 => _fnft) public FNFT;
    constructor() ERC721("FractionalNFT", "FNFT") {}

    function safeMint(address to) public onlyOwner{
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal
        whenNotPaused
        override(ERC721, ERC721Enumerable){

    }

    function _burn(uint256 tokenID) internal override(ERC721, ERC721URIStorage) {

    }

    function supportsInterface(bytes4 interfaceId) public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool){
            return super.supportsInterface(interfaceId);
    }

    function transferFNFToken(
        address to, 
        uint256 tokenURI_, 
        uint256 amount) 
        onlyOwner()
        private
        //isNFTOwner(_tokenURI)
    {
        FNFToken _fnftoken = FNFToken(FNFT[tokenURI_].fractionalToken);
        _fnftoken.transfer(to, amount);

    }

    function tokenURI(uint256 tokenID) public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory){

    }

    function mint(
        address to,
        string memory tokenURI_,
        uint256 totalFractionalTokens
    ) external onlyOwner(){
        _safeMint(to, _tokenIdCounter.current());
        _setTokenURI(_tokenIdCounter.current(), tokenURI_);

        //Create a ERC20 Token Contract for this newly minted NFT
        FNFToken _fnftoken = (new FNFToken)();
        _fnftoken.mint(msg.sender, totalFractionalTokens * 1000000000000000000);
        _fnft memory fnft;
        fnft.tokenId = _tokenIdCounter.current();
        fnft.fractionalToken = address(_fnftoken);
        FNFT[_tokenIdCounter.current()]  = fnft; 
        _tokenIdCounter.increment();
    }
}