/* ANOTHER PLACEHOLDER and some already old notes...

*/

//To study more in depth so you can study mechanims specific to this multi-token contract

//Would allow to keep track for a subscription (user account and the CPs it "subscribed") of the different tokens (NFT to access content, 
//  art/PFP/other utility NFT token, Yield tokens (variable rate/fixed rate), ERC20 on escrow contract, ERC20 staked, deposited to a specific
//  protocol like Compound - maybe abstract this away with using 88mph as a Library for exactly that: 
//  the use of DeFi protocols to issue fixed and variable bonds/yield-tokens)

// Will be stored in the user's wallet (as for the LPs tokens to represent positions/liquidity provided to a pool => Liquidity Providing <=> Content Providing...
//  how far can go the analogy? far if you change the idea to make content providing incentivization the goal of your dapp. For now,
//  stick to a generalized digital content marketplace scaffholding on top of which can be built a frontend a la OpenSea, with 
//  HERE, only one realized use case, the Live Streaming content access (live and recorded for future accesses)) 

// Simple form: dedicated to art performers 
//  => performance is live streamed and accessed through what you already defined
//  => recorded/stored and accessed also through what you defined (a 2 tiers-access sort of)
//  => performers can use the medium (NFT minting and drops) to reach with several options their audience
//  => the users NFTs will have a crypto fundamental value, that don't stop speculation on the art represented: the ERC-1155 markets.


// The 2 SIDES of the incentivization:
//      1. --> user's side: the content
//      2. --> content providers (generalized word from encompassing creators): users' deposit for a specific type of content
//
//  1. 
//  => web ui listing
//  => themes (words/tags) for which users can signal an interest 
//      (by puting under escrow some amount of ERC20 tokens - let say ether for now)
//  => every user have an amount of "interest signal" tokens accrued over time acoording to this (roughly): the same amount for everyone 
//      (maybe requiring DId instead of email/passwd+Eth account/sig - there is a need to incentivize people to keep one account, once you solve
//      this, it's great::::) at subscription of an account, then accrued every week with a decreasing accrual multiplier every new week (a la 
//      quadratic voting) + a general reset every 2 months (arbitrary for now). This is used only for content's request (for now based on the top 5 trending topic on X (twitter?), 
//      there can then be proposals for sub-topics, submitted to all - then locked tokens (maybe incompatible with reset mechanism)) 
//

//  2.
//  => slight difference in the weight of CPs who answer to a theme request first/among the quickest.
//      It would correct the forseeable bad short term effect (of bad content quality for quickest answer bounty) by (a predictive market mechanisms
//      introducing) a retroactive fees/slashing mechanism on the CPs final payment (substracted or added)).
//  => 


// I could narrow down user requests (for now) to "I want to access a live streaming from {this.partOfTheWorld_location}" - and then mechanism paying the content 
// provider + top up with how trendy it becomes (formalize that in terms of logic and tokens), because once a CP answer the request, the CP stream is listed 
// on the web2 frontend (Browser UI)  
//      ==> generalized version would be close to a predictive market (gnosis tokenized logic): create a token ERC721 representing 
//      the logic defined by the request (or the request translated/encoded in a tokenized logic) => this logic-tokenized token is put 
//      on a marketplace-like browser UI, and then people vote/(stake tokens)/? in relation to this ERC721 token, minting an ERC1155
//      token (keeps track of all those states and tokens, and their access to be redeemed in the future (time set up in the ERC1155 contract) ), 
//      attached to the user's account.


// Interest in exploring "conditional tokens" (gnosis) as a way to achieve in certain use case 0-trust (that wouldn't be as possible/elegant w/o it)