/* test/sample-test.js */
//the test is mocking putting the nft in the market place and expecting to purchase by someone
describe("NFTMarket", function () {
  it("Should create and execute market sales", async function () {
    /* deploy the marketplace */
    const NFTMarketplace = await ethers.getContractFactory("NFTMarketplace");
    const nftMarketplace = await NFTMarketplace.deploy();
    await nftMarketplace.deployed();

    let listingPrice = await nftMarketplace.getListingPrice();
    listingPrice = listingPrice.toString();

    const auctionPrice = ethers.utils.parseUnits("1", "ether");

    /* create two tokens */
    await nftMarketplace.createToken(
      "https://www.mytokenlocation.com",
      auctionPrice,
      { value: listingPrice }
    );
    await nftMarketplace.createToken(
      "https://www.mytokenlocation2.com",
      auctionPrice,
      { value: listingPrice }
    );
      //we can destructure however many addr we want in that [] from ethers
    const [_, buyerAddress] = await ethers.getSigners(); //in this case the 1st addr is the deployer's

    /* execute sale of token to another user */
    await nftMarketplace
      .connect(buyerAddress)
      .createMarketSale(1, { value: auctionPrice });

    /* resell a token */
    await nftMarketplace
      .connect(buyerAddress)
      .resellToken(1, auctionPrice, { value: listingPrice }); // 1 - tokenID

    /* query for and return the unsold items */
    items = await nftMarketplace.fetchMarketItems();
    //lets map the array of all items
    items = await Promise.all( //promise.all allows us to do async mapping
      items.map(async (i) => {
        const tokenUri = await nftMarketplace.tokenURI(i.tokenId);
        let item = {
          price: i.price.toString(), //returns BN so ve to cast
          tokenId: i.tokenId.toString(),
          seller: i.seller,
          owner: i.owner,
          tokenUri,
        };
        return item;
      })
    );
    console.log("items: ", items); // will returns the array[2] of unsold items
  });
});
