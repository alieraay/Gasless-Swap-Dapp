// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract GaslessNFT is ERC721 {
    uint256 private _nextTokenId;


    constructor()
        ERC721("GaslessNFT", "GSLS")
    {}

    function safeMint(address to) public  {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
    }
}