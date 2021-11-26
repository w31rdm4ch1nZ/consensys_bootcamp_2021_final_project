/*
Past notes of a past overall scaffholding

Mint this NFT (1155) as either:
    - the content itself (case of work of art, PFP project, Proof of ownership on a certain asset, etc.);
    - a way to access to a live content;
    - a readeemable token for accessing the content through one of the decentralized storage solutions without paying any of the fees assoicated;
    - a hybrid of ERC20 tokens record (redeemable at some point in time under certain conditions encoded through the contract logic) and
    the art NFT token itself, all encoded and existing through the same ERC1155 token. 
    - a NFT retaining the native tokens of the app to access content (Audius?, etc.);
    - same logic than the following to cover any cost on a platform as LivePeer, including infrastructure. 

    => ALWAYS (so meaning: NEVER BURNED), always tied to the participants to a RfC that succeeds - at least partially): 
    represent the share of ownership of the user-vestor and of the CPs on the content that has been produced and delivered.
*/

/* The following are past notes that I keep for now:

// 2 of this kind: 
//  - one that allows NFT art creations
//  - second that is there to represent a future yield tokenized (cf. 88mph): split between features on 
//              on a *fixed* rate yield and 2/ variable rate yield (on which is the main mechanism I want 
//              to work on - indeed, my purpose would be different from 88mph, as it would focus
//              on CPs ability to sustainably (from an econnomics perspective) propose perks to their users/
//              config their business model to retain/compensate/retribute/reward users)
//          ====>>> could me merged in one: the proprieties of the Yield Token part becomes impossible to use (a bool set to false, 
//                  or an enum Status) once the Yield Token is redeemed for a stablecoin.

// NFT ERC721
// usual features + access modifiers (role access interface/contract to link and use)

*/