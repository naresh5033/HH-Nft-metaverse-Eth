// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; //the counter for incrementing the nfts
    Counters.Counter private _itemsSold; //lly for the items sold
    //we can consider this as matic which also has 18 decimals
    uint256 listingPrice = 0.025 ether; //initial listing price
    address payable owner; // the owner of the contract makes comission on everyone's tx
    //itemId to marketitme(struct)
    mapping(uint256 => MarketItem) private idToMarketItemMap;

    struct MarketItem {
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event MarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    constructor() ERC721("Metaverse Tokens", "METT") ReentrancyGuard() {
        owner = payable(msg.sender);
    }

    /* Updates the listing price of the contract */
    function updateListingPrice(uint _listingPrice) public payable {
        require(
            owner == msg.sender,
            "Only marketplace owner can update listing price."
        );
        listingPrice = _listingPrice;
    }

    /* Returns the listing price of the contract */
    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    /* Mints a token and lists it in the marketplace */
    function createToken(
        string memory tokenURI,
        uint256 price
    ) public payable returns (uint) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI); //fn from 721uristrg.sol
        createMarketItem(newTokenId, price);
        return newTokenId; //this is also for the frontend purpose
    }

    function createMarketItem(
        uint256 tokenId,
        uint256 price
    ) private nonReentrant {
        require(price > 0, "Price must be at least 1 wei");
        require(
            msg.value == listingPrice, //msg.val -> no.of wei sent with the tx/msg
            "Price must be equal to listing price"
        );
        //map (tokenId) = sruct
        idToMarketItemMap[tokenId] = MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this)),
            price,
            false //not sold yet
        );
        //transfer the ownership of the nft to this contract
        _transfer(msg.sender, address(this), tokenId);
        emit MarketItemCreated(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );
    }

    /* allows someone to resell a token they have purchased */
    function resellToken(uint256 tokenId, uint256 price) public payable {
        require(
            idToMarketItemMap[tokenId].owner == msg.sender,
            "Only item owner can perform this operation"
        );
        require(
            msg.value == listingPrice,
            "Price must be equal to listing price"
        );
        idToMarketItemMap[tokenId].sold = false;
        idToMarketItemMap[tokenId].price = price;
        idToMarketItemMap[tokenId].seller = payable(msg.sender);
        idToMarketItemMap[tokenId].owner = payable(address(this));
        _itemsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
    }

    /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */
    function createMarketSale(uint256 tokenId) public payable nonReentrant {
        uint price = idToMarketItemMap[tokenId].price;
        address seller = idToMarketItemMap[tokenId].seller;
        require(
            msg.value == price,
            "Please submit the asking price in order to complete the purchase"
        );
        idToMarketItemMap[tokenId].owner = payable(msg.sender); //update the map the owner is now the buyer
        idToMarketItemMap[tokenId].sold = true;
        idToMarketItemMap[tokenId].seller = payable(address(0));
        _itemsSold.increment();
        _transfer(address(this), msg.sender, tokenId); //transrer the ownership from this contract to the buyer
        payable(owner).transfer(listingPrice); // the contract owner will get the comission/listing price
        payable(seller).transfer(msg.value); //pay the iten price to the seller
    }

    /* Returns all unsold market items */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _tokenIds.current();
        uint unsoldItemCount = itemCount - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) { //the unsold item in this contract
            if (idToMarketItemMap[i + 1].owner == address(this)) { //when we create for map we set the addr to empty addr to begin with, the only time the addr is populated with actual addr is if the item has sold
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItemMap[currentId]; //insert the current item into the storage[]
                items[currentIndex] = currentItem; //current indx =0
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns only items that a user has purchased */
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItemMap[i + 1].owner == msg.sender) { //
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {  
            if (idToMarketItemMap[i + 1].owner == msg.sender) { //current call, which is basically mine
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItemMap[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /* Returns only items a user has listed */
    function fetchItemsListed() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;
//this is sim as the last fn except except the owner is the sender, instead seller to be the sender
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItemMap[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItemMap[i + 1].seller == msg.sender) {
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItemMap[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
