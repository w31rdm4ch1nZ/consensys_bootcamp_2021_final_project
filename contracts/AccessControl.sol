//Define the roles and authorizations (mostly through modifiers - so maybe an abstract contract inherited 
// by the ones needing this RBAC definition) of:
//  - the users (anyone => 0 other trust mechanisms than the one you'll implement in this smart contract)
//  - the Content Providers (on LivePeer, and if I abstract it enough, for any CP on any platform 
//          - I would make a separate interface/contract to integrate the 
//              base features offered to CPs to define their business model + specific contract for each
//              new content provider protocol supported/integrated, eg. LivePeer, Audius, 
//              Social Media messaging platform, etc.)
//  - dapp administrator, mostly for upgrades if for anything else (planning on having at the very least a multi-sig change/upgrade scheme,
//              and eventually automate enough so most can't be touched by anyone - actually achieving 0-trust).
//      => check OpenZeppelin Upgradable pattern


/*

>>>>>>>>>Either a variation of the Ownable.sol contract from OpenZeppelin, or you import this contract. Your call.

*/