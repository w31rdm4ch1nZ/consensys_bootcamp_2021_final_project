# consensys_bootcamp_2021_final_project

ConsenSys Dev Bootcamp 2021 - Final Project repository

**Problem**:

- Migration of users from centralized streaming platforms to decentralized platforms for web3 potential realization. 
- Allowing local audivisual content creation economies to coordinate, capture value and retain a network effect / an audience - and ultimately more ways for the audience to engage with the form of ephemeral art forms though their digitization and NFTs-ike access, etc.

**Context and motivation**:

I will stick to centralized streaming model that stays pertinent so far to express some of my choices (the pay-per-view getting really old and dificult to maintain with the new digital users, except for some hybrid models that manage to remain efficient, but still out of my scope for now). 

- 1st, the Netflix and alike streaming platforms, mostly formed around already institutionnalized investments/productions and products/contents  catalogue (through markets or states institutions, depending on the location, the platform, and its targeted audience). 
- 2nd, the “free beer” streaming service of Youtube (and alike..?), that usually involves for the local economies I am targeting the use of several other tools (e.g. crowdfunding).

I aim at supporting the 2nd set of participants, temporary and local economies centered around what can take the form of a digital audiovisual content.
 
The dapp is targeting the local, and what I call “temporary autonomous organisations” directly referencing the Temporary Autonomous Zone (TAZ that I read early on and loved - https://en.wikipedia.org/wiki/Temporary_Autonomous_Zone ). 
The context of the dapp works around projects which, for a short time and/or a small scale economy (low capital concentration), unite around an audiovisual product/content/digitized event.

I want to target those local economies where small “underground” artistic movements for example, **mostly auto-produced**, are struggling to work passionnately and be rewarded for their contributions and their hard work. 

I want this dapp to empower them by enabling the **Ethereum DeFi ecosystem** to (at least) average their cost for streaming (storage, access content / streaming) close to a $0 cost, among other aspects already mentionned.  


**In short**: the idea is to develop a dApp that makes seamless the streaming of audiovisual content from an Ethereum account (and a wallet like Metamask), with almost or 0$ cost, and allow funding (producers) to directly leverage the Ethereum DeFi stack to lower costs and stick to the local area/ small scale economies I mentioned.


Ultimately, this would allow temporary autonomous organization to capture value and retain audiences and momentum through the digital decentralized protocol (my dapp...), like for an ephemeral performance made accessible through an NFT-like access right to its recording, and a pay structure based on such a setting (could also be a different setting - it is not the core of the logic of the dapp, just aiming at giviing an idea of the possibilities).

In my case, the focus is on creating a logic on top of a DeFi stack than makes look like the user can stream and access streaming for free. 

For that, I distinguish a scenario with at least *2 diffenrent types of users*, and *the dApp which acts as a decentralized platform to help coordination of the different stakeholders of a local economy aiming at producing and distributing short audiovisual contents* (short movies, short doumentaries, music movie clips): - a producer, 
- a consumer of the audiovisual content, 
- and a protocol facilitating the use of the streaming service of LivePeer network for both users (the actual dapp / final project).  

*The logic* allows a producer to connect to the Ethereum mainnet/testnet, and parameterize ones own distribution of a content (uploaded through the same frontend), its interaction with other participants, and never having to care about the stack DeFi/Ethereum/LivePeer to eventually reach a cost of almost 0$. 
As most users are now so used to the "free" content and access to this content via platforms like Youtube, it seems a good opportunity to leverage the incredibly versatile and powerful DeFi existing ecosystem. 


**For that, my dapp would**:

1. Use in the backend a DeFi stack that could allow the end-user a 0$ cost of accessing the streaming content, and minimize the cost of producers through the power of DeFi protocols.
2. Give the tools to local producers (meaning small capital - they can be the creator of the content, or different actors) to directly tap in the DeFi Ethereum stack, made simple through my frontend (I have in mind an MVP that will only integrate interactions wirth 1 DeFi component, so they can coordinate with local actors (such as equipment providers - camera, microphones, etc.), and settle payment in an intuitive way (Metamask at this point, potentially a Gnosis multi-sig safe as producers tend to be a collective of people... I will check if it brings unnecessary complexity in this 1st iteration).
(3. Conditional/Retroactive payments (mainly though Gnosis framework, from predictive markets to more generally the tokenized logic they developed to introduce rewards and punitive incentives in the producers and the platform cryptoeconomics).) 
4. In case of a funding from an instutional or private org outside the “producers” owning the account for the future content, a way to lock it and distribute it according to a logic that can be hardcoded (for the 1st iteration - would be obviously flexible and dynamic ultimately so it can adapt to the different sets and subsets of participants in the local economy / Temporary Autonomous Organization).


***For now***, this is about creating a dApp on Ethereum which:

1. leverages 1 DeFi protocol: 

  - for the purpose of the exercise I limited it to one, ideally that would be the possibility to leverage the DeFi ecosystem on Ethereum, depending on the use case developed, and made accessible trhough a contract that can be called by individual accounts, but any protocol's owned account eventually. 
I chose to interface my dApp with Alchemix (ALCX), which allows to tokenize user's deposited assets *future* yield - but this is meant to be more generic in the fully realized idea.
  
2. This feature will be made (relatively) easily accessible through *a web frontend* and requires *only the use of Metamask (from the end-user perspective)*.

3. The dApp allows a user to comsume or to make accessible some streamed content (streaming which actually is processed on the **LivePeer** decentralized streaming platform). 

The core logic of the dApp is to allow a user to publish a video for what seems a 0$ cost.
A web UI will be, with Metamask, the only thing with which the user interacts to publish his/her video (ultimately, I would like any entity to be able to call the contract, inlcuding other Ethereum dApps, protocols, etc.), and for the producer to interact and coordinate the funding of the event/audivisual content.


**Under the hood**, the dApp manages, and my work will focus on coding the logic automating this management:

1. the distribution / streaming fees of the LivePeer network.
2. the storage of the contents (IPFS).
3. the DeFi stack interactions that allow a seamless “closer to 0$ cost (than the already low-cost costs of LivePeer)” streaming model.
 

From the “**leveraging DeFi**” perspective, ultimately different strategies (and new ones will emerge) are possible through the DeFi so-called “*legos*” (the wonderful *composability* of Ethereum L1). 
Yield on on an idle asset (through borrowing/lending underlying mechanism), tokenizing future yield (like Alchemix protocol), and retro-active (re)payment of the user (possible predictive markets use to reward/punish accounts on a set of parameters defined in the dApp eventually). 
Eventually, it is aimed at contributing to get more people to use a decentralized streaming platform vs. a monopolistic one, by tackling firts this “free” acess and usage of streaming quality contents... 
