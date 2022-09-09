// SPDX-License-Identifier: MIT
/* Custom functions written for minting of tokens 
Added payable function to transfer the cost of ether*/

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArtToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    Counters.Counter private supply;

    constructor() ERC721("ArtToken", "ATK") {}

    // Total number of NFT available for creation
    uint256 public maxSupply = 2;

    // Cost to be paid for each NFT Token
    uint256 public cost = 1000 wei;

    // Owner and its property in the Metaverse
    mapping (address => NFTDetails []) NFTOwners;

    // NFT structure
    struct NFTDetails {
        string name;
        string details;
        string attr1;
        string attr2;
        string attr3;
        string attr4;
    }

    // Current supply of NFT Tokens
    function totalSupply() public view returns (uint256) {
        return supply.current();
    }

    function deposit(uint256 amount) public payable {}

    // Function to mint payable NFT's
    function safeMint(string memory uri, string memory name, string memory details, 
    string memory attr1, string memory attr2, string memory attr3, string memory attr4) public payable  {
        require(supply.current() <= maxSupply, "Max supply exceeded!");
        require(msg.value >= cost, "Insufficient funds");
        uint256 tokenId = _tokenIdCounter.current();
        // deposit the ether to contract
        deposit(cost);
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId); 
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

    // Extraction of ether from smart contract to the owner
    function withdraw() external payable onlyOwner {
        // get the amount of ether stored in this contract
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);

    }

    // Obtain a user's NFT Details
    function getNFTDetails() public view returns (NFTDetails [] memory){
        return NFTOwners[msg.sender];
    }
}