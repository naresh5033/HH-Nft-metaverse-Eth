## NFT Metaverse marketplace

This project was build on ethereum scalability solution - polygon.\
Since in Ethereum the tx are bit expensive and quite a while to complete.\
But with the scalability solns like polygon or arbitrum they offer faster and cheaper txs. so it would make a lot of sense to build an app where the trading in assets are relatively low cost for the txs in these scalable(layer 2 or side chain) chains.\

## Next js app

This is a next js application `npx create-next-app nft-metaverse-marketplace`

## Hardhat

For the smart contract part, I used hardhat framework for this project
And the dependencies are ```yarn add hardhat hardhat-shorthand ethers @nomiclabs/hardhat-waffle chai ethereum-waffle hardhat-deploy @nomiclabs/hardhat-ethers web3modal @openzeppelin/contracts ipfs-http-client axios```

## NftMarketplace.sol

The contract NftMarketplace.sol is Erc721URIStroage.sol 
The contract deployed in the polygon mumbai testnet and the deployed addr is "0x6263464bFf66E971abcDA5Ef0b980fdFaBc88A2c" and verified

This is a [Next.js](https://nextjs.org/) project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `pages/index.js`. The page auto-updates as you edit the file.

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.js`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
