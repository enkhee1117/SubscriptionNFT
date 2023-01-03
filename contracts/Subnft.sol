// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SubNFT is ERC721, Ownable {
    uint256 private constant TOTAL_SUPPLY = 1000;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 nftPrice;
    address _paymentTokenAddr;

    // TokenURI for metadata:
    string private baseTokenURI;

    constructor(address tokenAddress) ERC721("CP PREMIUM SUBSCRIPTION", "CP") {
        _paymentTokenAddr = tokenAddress;
        baseTokenURI = "";
        nftPrice = 20000000000000000000000;
    }
    // Changes the NFT price in case we have to change it in the future. 
    function setNFTPrice(uint256 _nftPrice) public onlyOwner{
        nftPrice = _nftPrice;
    }
    /*
        Increase allowance in ERC20 token you are using for the payment, before attempting to mint with erc20 token. 
    */

    function erc20Mint(uint256 amount) public returns(uint256){
        require(amount == nftPrice,"Wrong Price!");
        uint256 tokenId = _tokenIds.current();
        require(tokenId < totalSupply(), "TOTAL SUPPLY HAS REACHED!");
        IERC20 token = IERC20(_paymentTokenAddr);
        token.transferFrom(msg.sender, address(token), amount);
        _tokenIds.increment();
        uint256 newNftId = _tokenIds.current();
        _mint(msg.sender, newNftId);
        return newNftId;
    }
    /*
        POOP-eer bish $-oor subscription hudaldaj avsan humuustee NFT-g ni mint hiij uguy!
    */

    function mintFor(address receiver) public onlyOwner returns(uint256){
        uint256 tokenId = _tokenIds.current();
        require(tokenId < totalSupply(), "TOTAL SUPPLY HAS REACHED!");
        _tokenIds.increment();
        uint256 newNftId = _tokenIds.current();
        _mint(receiver, newNftId);
        return newNftId;
    }

    function totalSupply() public pure returns(uint256){
        return TOTAL_SUPPLY;
    }

    // BaseURI:
    function _baseURI() internal view virtual override returns (string memory){
        return baseTokenURI;
    }
    // Point to image on IPFS:
    function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner{
        baseTokenURI = _baseTokenURI;
    }
    // Override TOKENURI: 
    function tokenURI(uint256 tokenId) public view override returns (string memory){
         _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        // Not concatenating token ID anymore:
        return bytes(baseURI).length > 0 ? baseURI : "";
    }
}

/*
    Deployment note: 

    Rocket image on IPFS:
    https://gateway.pinata.cloud/ipfs/Qmast8bUfgbdeh3q5yrqkh26wDPhBtY8AnGRrgDMe8UdH6

    PUujin token on Goerli:
    0x655DB1A9ddAc3ee455fB6eeA2e4A25d4Dfdc1853

    SubNFT on Goerli:
    0xadF42CfF3b2c45d33f01B7b1D9b619f9050934Ff

    SUBNFT on FANTOM:
    
*/

