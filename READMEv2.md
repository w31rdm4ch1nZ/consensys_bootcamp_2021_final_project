# My Consensys 2021 Bootcamp Final Project


After several iteration over my inital idea (and definitely spending too much time on ideation),
I came to freeze it for now - hardly... What follows describes in quite some details the frozen idea - I am seeking to define the implementation in several iterations, the 1st one being the scope for the Bootcamp Final Project, the others, are here to define what I'd like to expand in the coming months.

**[CURRENT CONTRACTS are empty shells with random notes and were taken before I go one more time through this design process]**

## For a bit of context on my motivations:


My 1st motivation is to research and experiment in the space where DeFi and content/information can be bridged to enable new business models.
 
Said in a different way, to experiment on ways to leverage DeFi in web3 so we can propose usable, viable, resilient, autonomous and decentralized 
protocols tat can be alternatives to monopolistic web2 platforms such as Youtube, Twitter, FB, etc. able to onboard any user and potentially create network effects, in a comparable way to the web2 except that those are decentralized first and offer a vision of what the designer thinks might be the right/fair way to align incentives for all participants to the protocol defined below.

Also, being able to use another protocol and leverage the so-called "composability" has been appealing from the start for me. That is why, regarding
the DeFi aspect, I might call some external contract of an already existing DeFi protocol present on a public testnet (Pendle, 88mph, Aave, Compound, ...). 

I also wanted to experiment on pieces of tech in crypto that I am fascinated with, and understand them from the first principles. 
It includes: 

1/ ERC1155 token standard and its capacity to represent/tokenize complex users' positions and enable in an efficient manner complex txs (multi-token and different ones at once), and 

2/ the Gnosis Conitional Token or Predictive Market tokens that I take as a model and inspiration, also (to my knowledge) built on the ERC1155 in the current version of the Conditional Token Framework defined by Gnosis, *to tokenize relatively complex logic (eg. outcomes of a predictive markets)*. 
For this second part, I am aware that a bounty mechanism would work as well. I've chosen a path and tried to go all the way down with it - so, I might have missed some obvious better choice, it might prove to be inefficient/too costly overall for any use case, but exploring this tech was part of my initial motivation and inspiration. 

3/ I was contemplating the value and motivations for designing a specific stablecoin at the center of the protocol, and doing so understanding more in-depth what the choices I've seen in other project are not arbitrary at all, and part of the tokenomics. It has been a very rewarding experience from the design perspective (I never tackled such a thing so far, and exploring that part of a project in web3 is already very satisfying for me as I can see my understanding of what already exists reach levels I had no real idea).

The result is the first draft of the design of a general web3 Content Delivery decentralized protocol. It actually comes closer from my initial ambition of a platform enabling "crowdjournalism", on which jounalism institutions such as NYT, individuals, and more informal orgs like Bellingcat can be part of it and use  this protocol to coordinate, source, curate, distribute tasks, incentivize and provide qualitative contents in all categories.

## The 3 users/participants of/to the protocol


This protocol involves *3 main users* (user-investors, CPs, any user-consumers once content delivered), interacting through smart contracts via 2 UIs.
Those users I call *"user-investor" and "Content Provider" (abreviated CP) / creators*. I might use both CP and creator in different contexts, but
without impliying any different flow or business logic.


## High-level description of the protocol:


The user-investor and CPs interact and define my 2 main workflow.
But the flows that describe the current use case are actually involving at least those 2 users:

1. The content creation process that goes from a request by users to its delivery and distribution to the users, going through the Content Providers work flow.
2. The use of DeFi as the second core logic embedded in my main contract, an escrow contract that retains and manage the funds of both users and CPs, based on the scenarii defined below. The contract automatically leverage some DeFi protocol(s) to generate some yield on the funds deposited, which is then used in the way the content production is funded, and is split in a part that user-investors can configure, and another dedicated to CPs configurations. Those configurations do not offer limitless options, but will be added and the set of parameters to take *as input and recorded byt the core contracts* will be predefined, mostly a selection trying to fit DeFi protocols with the type of content required, and the time-to-delivery the content has been defined to be accceptable by the users-investors.  

## Diving-in: Use case, user scenarii and the flows that the protocol aim at enabling - and a bit of anticipation on where the implementation should go

[The usual routine of Metamask account connection to the dapp and enabling txs, and have a web3.js interface ready to handle main interactions between browser UI and Ethereum smart contracts backend]

- *Users-investors* are able to access content through a web interface (web (html/css/js) listing of currently available content (examples will be provided), under production (with possibility to click and get current data on the state of the RfC and the funds management tracked), the RfC being not yet tokenized adn their status: under vote/commit/vesting by the user-investors, CPs signaling their interest too could be added but not rn, and CPs vesting to answer the RfC - those are the status to track);
- They are able *to make "Request for Content"* (more to come, but a bit of context for a better understanding: tokenized on the model of the Continional token, except it does not represetn any probability/correlation between the set of ellements it is formed of, but the possibility to split the token in a way that allows several Content Providers to coordinate to provide the content requested and to share the reward/bounty for their work/resources spent on it).
*The making* of a relatively complex RfC *involves the number of attributes/properties defined and asked by the users-investors, with a first set of categories, pointing to different platforms that can mint/distribute the content*. So video stream would involve by default LivePeer as being tokenized as a part of the Request for Content. *Then a set of properties (for now KISS) can be added, defining the RfC token to be minted*: location (of the live streaming), length of the recording, time of the day it starts, number of streams expected (for trusting sources if that's a requirement regarding the specific content), time for delivery - that will be all for now.   
- "Request for Content" (RfC) are propositions that an erc20 voting (only) token allow all participants of the platform to vote for the pieces/labels
that are going to form the fully fleshed RfC token. If the signal passes a certain threshold, it is then listed for the CPs to commit to to do it;
- *CPs access the RfC and the signals, associated with data that allows to roughly have an idea of the "intensity" of users interest for a specific RfC, through a dashboard*.
- *CPs can commit (vesting under an escrow contract a amount of Ethers) to fulfill the RfC*; 
- *OR they can choose to signal to other CPs their ability to deliver part of the content* (through *vesting tokens for a short amount of time* during which, if no other CPs answer to commit on the other aspect to deliver the whole content, then the erc20/Ethers are sent back to the CP - *an escrow contract handling the different vesting period of time and cases for vesting should be one of the core contract and seems to require to be a separate contract, for modularity and 
a clear business logic in the design*). The *vesting period is in by default 3 days, but cand be more if a CP wants it* (because of a the likelyhood of a more complex content production process, or scarcity of skills/capacities required to deliver);
- CPs have the *possibility to delegate (by staking part of the Ethers they first put under the escrow contract) part of the content production and distribution* at their discretion, but they *bear most of the slashing menace (bigger ratio if slashing occur as they extend the risk by involving more actors in the final product)* if the content is not delivered (and not on time, all parameters that impact differently the ratio of the amount being slashed from the initial vesting). *The delegatees (?) must also commit some amount of ethers to take the deal, the same way the CPs did it in the first round* (it can be seen as a 2nd round of a market for content/information production, and *aim at keeping the incentive alignment designed with the first mechanism*). It leads to the RfC token to be split in more parts, tracking the rewards payment to automatically satisfy the different parties involved, "basically" exposing each to reward/slashing mechanism, through the amount vested by ech CP on a RfC, and the delivery outcome as a quality content end-users vote mechanism that can apply post-delivery/retro-actively.
- CPs signal when the content can be accessed and how (through a simple boolean in the ERC1155 contract for the token to be redeemed by users/investors and a redeem function including in input the link (or equivalent) to access content, broadcast it, etc.);
- Users are are signaled in their own dashboard when a content is made available, and when a content they vested for is no ready to be accessed (or can redeem their position (ERC1155 token) to access the content once delivered);
- The *phase for content's quality curating* starts - once a sufficient threshold of the users having vested on the RfC have accessed the content (POAP or equivalent) and "accept" the content as delivered (a token similar to CTs for predictive markets outcomes that is yes/no, where the "yes" token is representing the agreement of users/investors on the content having been delivered - they can consider it not good enough - decide if it goes through a collective assessment phase, or on a per indivividual mechanism??) sending back to the CPs "yes" and "no" tokens, which results in their vesting tokens as being partly liquidated (following "no" tokens - won't solve for now the potential attack on a CP by other CPs that do it intentionally to slash the capital of the CP, but future iterations should of course) and rewarded according to the "yes" token => yet to define the math formula to make it fair to both parties;
- The *content becomes available on a market/listed on a web UI* where *anyone* can access the content *for a given amount of Ethers*, *or for tasks they are commited to do* to *enrich the content*, or commit to *maintain/widen its distribution (eg. through Filecoins/Proof of content replication on IPFS* - vesting Ethers to the contract that then takes care of swapping it for Filecoin and making it more available and guarantiing future access and censorship-resilience).
- initial users who vested in the RfC are entitled to get a share of the fees to access the content by the user (those fees decrease over time according to a math formula to be defined yet) - or a majority can decide to renounce it so it can be accessed to all w/o additional cost, through redeeming their YieldBearingToken (delivered by the escro contract), or CPs can use (part of) their YieldBearingToken to make it immediately universally available.

This YieldBearingToken minting and mechanism is to be described in the next section. 
But, again, for a bit of context, the funds put at work by both users and CPs (managed by the Escrow contract, at least passed by it to a DeFi protocol and minting those token or equivalent), lead to cover the cost of content production and access for CPs and users-investors. 

There lie the potential and space for different content delivery busines models, and different choices regarding the collective value (is it to be considered a common good?) of the content created and madde accessible.

The protocol might have to create a native token to incentive both parties to agree on a content to actually be considered a common good and put it out there for free to everyone. That is yet (another idea) to be defined and fully explored.

    ==> That concludes the business logic from a content providing/creating perspective (at this point).
        There is still to describe how our escrow contract acts as more than an escrow for idle funds, by embedding the logic to using DeFi protocols (that eventually can be chosen by CPs as best fit for the kind of content production process a RfC involves, or even will be hard-coded in the RfC, as another round between user-investors and CPs).


## The Content delivery cycle described above is meant to run on top of the DeFi Ethereum stack - here comes the Escrow contract on steroids

Which leads us to this current description of our "Escrow smart contract" funds usage encoded logic, that users and CPs are both aware of (as there is a transparency made very easy to follow through the web3 interface (our future frontend pluged on the contracts events), events being emitted to "follow the money", in near real time - a block time actually for most of the events, more when the information requires it). 

One core element to take into account is *the RfC token and its spliting property* (all that happening in an ERC1155, or wrapped in this standardized interface), so the initial fund shares can be tracked and updated between the first vesting of users to RfC and when the potential end-state is reached (meaning our last point above, the outsourcing of the content to any users, and the access mean being now ready for the world).

*Escrow contract (likely an ERC1155 API + business logic specific to my protocol)*:

- receives users funds as signal for some pieces of content and records/tracks;
- start yield if time for answer to the request is long enough and the deposit large enough to generate yield (compared to gas cost) => defining a threshold at which funds are transferred to a DeFi protocol;
- *same logic* happens for after the mint of the RfC, always factoring the start time, current APY of underlying protocol, and end-date defined in the RfC;
- this logic could be defined based upon the Pendle protocol, so future yield can be traded at *any time* through their AMM, and doing so allow flexibility and liquidity on the user-investors and CPs side.
- calculate part of the funds to be withdrawn/transferred for both, but at this stage only the oustanding yield accumulated (?)- a part of any return made by the user-investors is going, after CfR event, to the CPs with the funds to pay the entity/account;
- ERC20s deposited in the escrow contract are being distributed according to:
  - the formulas to be defined above (but already kind of narrowed down to their utility): ;
  - the reward/slashing mechanism (yes/no delivery outcome tokens);
  - the CPs reward/slashing is calculated based on the delagation (staking contract) state;
  - all participants get a ratio of the overall yield made on a specific RfC;
  - there are 2 pools, user-investors and CPs, that are disctinct (or maybe just a state variable tracking the yield for user-investors and CPs independently through the ERC1155 possibilities?) and their yield (and FutureYield sold on the Pendle AMM) will be *tokenized in different ways*. *It means it can become an art NFT/collectible for some users if the CPs is able to provide that kind of creation on top of the content, or swapped for Ether,, etc. or reinvested on another RfC* (likely not implemented in the 1st iteration - but *interesting from crowdjournalism use case perspective*, as it enables a second category of RfC, the one that asks for more information, or even verification of the content through some other content confirming or infirming the previous content/information - it becomes a richer information curating market, working with demand/supply mechanisms, intensity of interest, and possible anti-counterfactual/anti-deepfake mechanism that can form on top of the previous RfC and through those interactions;   
  - 
  - 
  - ...
  - It all happens at the Escrow contract level, meaning it works on a secured push pattern (see OpenZeppelin contract library), allowing trustless transactions between the particpants and the underlying protocols. 

        ==> having a stablecoin at the center ot the protocol (a la Alchemix) would protect it and the participants from the volatility of Ether, or any other asset  used in the transaction for the content production, which in this case is desirable as participants are not explicitly engaged in a speculative activity except for the underlying variable yield protocol used.
        To clarify, speculation will be part of the protocol output in most cases (be it a collectible, a pfp project, a gen art project or any on-chain art minting project), but the protocol itself does not require this, and actually for the production of the content itself, it is not desirable at all - again, except for the leverage of the future yield. But for this core DeFi mechanism, we are using Pendle, which AMM limits speculation for the protocol and is actually used to make a relatively small return on the vested funds. So, it sort of substracts the speculative activity to secure future yield under the form of bonds-like tokens that can be (and will be) redeemed by the contract for either a stablecoin that workd for the protocol, or home-made stablecoin, or a basket of cryptocurrencies on which all participants could agree on (if the protocol were to be run by a DAO).

(*User-consumer:*) The use case here is broadly speaking all that pertains to the access information modalities: 

- simple url like ipfs:, minting an NFT that can then be used to access a live content (performance, event, etc.) or giving the user an ownership on the content, once a user-investor has agreed to sell part or totality of its share on the content.
This "share" mechanism could be done through the use of an ERC721/NFT contract that would be minted by the user-investors in the end of a successful RfC to keep track of the shares (like an ERC721 does it to represent an account's share on a liquidity pool).
    => that creates another market mechanism, leading (a bit like fractional, but generalized to any content) to make accessing and owning the content a community experience, instead of a one-sided payment subscription (for instance) one. The market on content's shares also enable other contetn use case, like NFTs collectibles obviously, but also can allow to tie it to an AMM that allows 1/discovery value to be less related to pure speculation on illiquid assets, to create some liquidity. Why not defining a unit for this share/fractional ownership that would be an ERC20 token (maybe the stablecoin mentioned above - think about *what would be the best/most efficient/most useful stablecoin (mechanism on which it is based/minted/integrated to the platform and made usable across its already defined mechanisms)* for our decentralized content production and distribution platform?)


## Defining the 1st iteration

In order to do that, I will take every core element of the business logic, and implement a minimal functional part of it, that can still display a full RfC -> Content delivery cycle, and the simplest interactions involved, to be able to next iterate to add the layers of features and flexibilty I thought of.

I might have to drop a few mechanisms, or simplify them a lot to be just a very simplistic version of what they could achieve, but still exposing the potential to come with it/being ready to be enriched and fully featured through several consecutive iterations.

I want the idea/use case to be manifest, despite the simplistic version delivered for the Final Project.