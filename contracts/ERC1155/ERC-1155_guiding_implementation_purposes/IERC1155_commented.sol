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

//https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md:

pragma solidity ^0.5.9;

/**
    @title ERC-1155 Multi Token Standard
    @dev See https://eips.ethereum.org/EIPS/eip-1155
    Note: The ERC-165 identifier for this interface is 0xd9b67a26.
 */
interface ERC1155 /* is ERC165 */ {
    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
        The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `_from` argument MUST be the address of the holder whose balance is decreased.
        The `_to` argument MUST be the address of the recipient whose balance is increased.
        The `_id` argument MUST be the token type being transferred.
        The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).        
    */
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);

    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).      
        The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `_from` argument MUST be the address of the holder whose balance is decreased.
        The `_to` argument MUST be the address of the recipient whose balance is increased.
        The `_ids` argument MUST be the list of tokens being transferred.
        The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).                
    */
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);

    /**
        @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).        
    */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    /**
        @dev MUST emit when the URI is updated for a token ID.
        URIs are defined in RFC 3986.
        The URI MUST point to a JSON file that conforms to the "ERC-1155 Metadata URI JSON Schema".
    */
    event URI(string _value, uint256 indexed _id);

    /**
        @notice Transfers `_value` amount of an `_id` from the `_from` address to the `_to` address specified (with safety call).
        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
        MUST revert if `_to` is the zero address.
        MUST revert if balance of holder for token `_id` is lower than the `_value` sent.
        MUST revert on any other error.
        MUST emit the `TransferSingle` event to reflect the balance change (see "Safe Transfer Rules" section of the standard).
        After the above conditions are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call `onERC1155Received` on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).        
        @param _from    Source address
        @param _to      Target address
        @param _id      ID of the token type
        @param _value   Transfer amount
        @param _data    Additional data with no specified format, MUST be sent unaltered in call to `onERC1155Received` on `_to`
    */
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external;

    /**
        @notice Transfers `_values` amount(s) of `_ids` from the `_from` address to the `_to` address specified (with safety call).
        @dev Caller must be approved to manage the tokens being transferred out of the `_from` account (see "Approval" section of the standard).
        MUST revert if `_to` is the zero address.
        MUST revert if length of `_ids` is not the same as length of `_values`.
        MUST revert if any of the balance(s) of the holder(s) for token(s) in `_ids` is lower than the respective amount(s) in `_values` sent to the recipient.
        MUST revert on any other error.        
        MUST emit `TransferSingle` or `TransferBatch` event(s) such that all the balance changes are reflected (see "Safe Transfer Rules" section of the standard).
        Balance changes and events MUST follow the ordering of the arrays (_ids[0]/_values[0] before _ids[1]/_values[1], etc).
        After the above conditions for the transfer(s) in the batch are met, this function MUST check if `_to` is a smart contract (e.g. code size > 0). If so, it MUST call the relevant `ERC1155TokenReceiver` hook(s) on `_to` and act appropriately (see "Safe Transfer Rules" section of the standard).                      
        @param _from    Source address
        @param _to      Target address
        @param _ids     IDs of each token type (order and length must match _values array)
        @param _values  Transfer amounts per token type (order and length must match _ids array)
        @param _data    Additional data with no specified format, MUST be sent unaltered in call to the `ERC1155TokenReceiver` hook(s) on `_to`
    */
    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external;

    /**
        @notice Get the balance of an account's tokens.
        @param _owner  The address of the token holder
        @param _id     ID of the token
        @return        The _owner's balance of the token type requested
     */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);

    /**
        @notice Get the balance of multiple account/token pairs
        @param _owners The addresses of the token holders
        @param _ids    ID of the tokens
        @return        The _owner's balance of the token types requested (i.e. balance for each (owner, id) pair)
     */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);

    /**
        @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
        @dev MUST emit the ApprovalForAll event on success.
        @param _operator  Address to add to the set of authorized operators
        @param _approved  True if the operator is approved, false to revoke approval
    */
    function setApprovalForAll(address _operator, bool _approved) external;

    /**
        @notice Queries the approval status of an operator for a given owner.
        @param _owner     The owner of the tokens
        @param _operator  Address of authorized operator
        @return           True if the operator is approved, false if not
    */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}