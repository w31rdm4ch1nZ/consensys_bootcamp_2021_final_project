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

//Maybe, as those roles will be used in both core contracts (RfC and FundsManager), it could become an abstract contract or an interface: 
// go back to those to see if it fits your design.

contract UserRoles {

    //I would like to explore how to make this a separate, or if it is actually better to have a separate contract for it, or even if an openzeppelin 
    // library contract exists, or a template?

    // It does not replace a multi-sig account for all or most of these roles

    // user types for the ERC1155 token management (take into account they might be both at the same time)

    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    // TO DO (v1): create a specific role like this (same 'power') dedicated to a CLAIM (for instance, there are reasonnable doubts of CPs trying 
    // to game the protocol) -> enters an emergency round for vote on continuing or not, AND (then, the vote has to allow several outcomes, having
    // several different consequences - like for the Condition Tokens in a predictive markets where several events can be voted on happening both, 
    // or in a certain order, etc. => *the general idea of Gnosis from complex structured knowledge to be tokenized* (digression => in my mind, 
    // this tokenization alows a pre-agreement or element of consensus that lets much less work/subject to debate afterwards and doing so, 
    // reduce the overhead and the need for trust that an off-chain DAO, or even a central third-party, would require otherwise.)
    //bytes32 public constant PAUSER_ALL_TXS_FOR_EMERGENCY_CLAIM_ROLE = keccak256("EMERGENCY_PAUSE_FOR_CLAIM_ROUND");  
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");


    //mapping (addr => UserType);

}