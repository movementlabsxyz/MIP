# MD-2: Create MOVE fungible asset on Bitcoin using runes
- **Description**: 
- **Authors**: [Andy Golay](mailto:andy.golay@movementlabs.xyz)

## Overview
Create MOVE fungible asset on Bitcoin using runes. This will allow users an experience comparable to ERC-20 tokens on Ethereum.

## Definitions

## Desiderata

### D1: As there will be a MOVE ERC-20 token on Ethereum, there should be a MOVE fungible asset on Bitcoin. Runes is the best solution.
**User Journey**: Users can use MOVE on Bitcoin in a manner similar to how users use ERC-20 tokens to interact with Ethereum dApps.

**Justification**: Since mid-2023, NFT trading volume on Bitcoin has rivaled and, many weeks, been greater than Ethereum NFT volume. [Source: The Block](https://www.theblock.co/data/nft-non-fungible-tokens/nft-overview/nft-trade-volume-by-chain) 

Bitcoin's market cap is over 1 trillion USD while Ethereum's is under 300 billion USD. [Source: CoinMarketCap](https://coinmarketcap.com/)

This signifies tremendous growth potential for commercial activity on Bitcoin.

Bitcoin fungible asset protocol BRC-20 has been overshadowed in popularity by [runes](https://docs.ordinals.com/runes.html), a protocol that uses Bitcoin transaction outputs to create fungible assets on Bitcoin. 

The Bitcoin community has embraced runes. The runestone NFT was airdropped to ordinals holders by community figure Leonidas, who then airdropped multiple runes to runestone holders. Many communities in Bitcoin have launched runes for their brand. No other fungible asset protocol on Bitcoin has a comparable way of storing protocol messages in Bitcoin transaction outputs. Both technically and community-wise, runes are the most native fungible asset protocol on Bitcoin (as contrasted with inefficient protocols like BRC-20 that rely on ordinal inscriptions, which are NFTs clevery disguised as fungible assets). 

Runes was developed by Casey Rodarmor, author of the command runner `just` which we use in Suzuka. Rodarmor invented ordinals, which are fairly certainly here to stay. 

There will be FUD always, and new protocols continually developed. For example, [Udi Wertheimer's CATNIP protocol](https://x.com/udiWertheimer/status/1833667484915737034) appears to have recent support. However, CATNIP relies on [OP_CAT](https://github.com/bip420/bip420) being restored as a Bitcoin opcode. So it's not even part of Bitcoin yet. And Udi claims [CatVM will support runes](https://x.com/udiWertheimer/status/1833685416362336476), so even if CATNIP becomes the dominant protocol, runes will still be supported.

People claiming that runes are dead ought to understand that in general, on-chain activity it at a low point and so NFTs and fungible assets are all performing underwhelmingly. (See the NFT volume comparison from The Block in the first paragraph of this Justification section. Markets are just low-volume right now.) The reality is that runes will be supported in the future. Movement could potentially migrate Bitcoin fungible assets to another protocol should it seem reasonable to do so. For now and the foreseeable future, runes are the best bet for MOVE on Bitcoin.

As an example of runes being very much well and alive, [Pups token recently announced](https://x.com/PupsToken/status/1832831489840443579) migrating their Solana and Bitcoin (BRC-20) assets to runs.

**Guidance and suggestions**:
- Etch MOVE rune on Bitcoin testnet 
- add capability for the Movement atomic bridge to swap MOVE on Bitcoin for MOVE on Movement

## Errata

