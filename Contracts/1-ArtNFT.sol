// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArtToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("ArtToken", "ATK") {}

    // Total number of NFT available for creation
    uint256 public maxSupply = 100;

    // Cost to be paid for each NFT Token
    uint256 public cost = 0.0001 ether;

    // Owner and its property in the Metaverse
    mapping (address => NFTDetails []) NFTOwners;

    // Metaverse Building
    struct NFTDetails {
        string name;
        string details;
        string attr1;
        string attr2;
        string attr3;
        string attr4;
    }


    function safeMint(address to, string memory uri, string memory name, string memory details, 
    string memory attr1, string memory attr2, string memory attr3, string memory attr4) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        NFTDetails memory _newNFT = NFTDetails(name, details, attr1, attr2, attr3, attr4);
        NFTOwners[msg.sender].push(_newNFT);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Obtain a user's Metaverse buildings
    function getNFTDetails() public view returns (NFTDetails [] memory){
        return NFTOwners[msg.sender];
    }
}