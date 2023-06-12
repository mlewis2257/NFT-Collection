//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
        /**
      * @dev Matt _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
      * token will be the concatenation of the `baseURI` and the `tokenId`.
      */
    string _baseTokenURI;
    // Price per token
    uint256 public _price = 0.01 ether;
    // Used to pause the contract in case of emergency
    bool public _paused;
    // max # of tokens
    uint256 public maxTokenIds = 20;
    // Total number of token Ids minted
    uint256 public tokenIds;
    // Whitelist contract instance
    IWhitelist whitelist;
    bool public presaleStarted;
    // Timestamp for presale ending
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract is currently paused");
        _;
    }
    constructor (string memory baseURI, address whitelistContract) ERC721("CryptoDevs", "CD"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner{
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }
    function presaleMint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp < presaleEnded, "Presale has not started yet");
        require(whitelist.whitelistedAddresses(msg.sender), "This address is not whitelisted");
        require(tokenIds < maxTokenIds, "Exceeded the max CryptoDevs supply");
        require(msg.value >= _price, "Not correct amount of Ether sent");
        tokenIds++;
        _safeMint(msg.sender, tokenIds);


    }
    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet");
        require(tokenIds < maxTokenIds, "Exceeded the max CryptoDevs supply");
        require(msg.value >= _price, "Not correct amount of Ether sent");
        tokenIds++;
        _safeMint(msg.sender, tokenIds);
    }
    function _baseURI()internal view virtual override returns(string memory){
        return _baseTokenURI;
    }
    function setPaused(bool val) public onlyOwner{
        _paused = val;
    }
    function withdraw() public onlyOwner{
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

          // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}





