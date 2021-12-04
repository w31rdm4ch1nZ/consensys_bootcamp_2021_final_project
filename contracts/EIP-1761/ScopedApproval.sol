pragma solidity >=0.4.22 <0.9.0;

/**
    Note: The ERC-165 identifier for this interface is 0x30168307.

    Might come handy for your different ERC1155 tokens' users (investors, CPs, consumers) [NOT COMPLETELY SURE, BUT surely worth checking + look at Conditional Tokens 
    implementation]..? => allows you to differentiate for the same ERC1155 token among the sets of ERC20 and ERC721 token ids, so you can then apply/define 
    different operations on it.

    => found there - read the synopsis: https://eips.ethereum.org/EIPS/eip-1761
*/
interface ScopedApproval {
    /**
        @dev MUST emit when approval changes for scope.
    */
    event ApprovalForScope(address indexed _owner, address indexed _operator, bytes32 indexed _scope, bool _approved);

    /**
        @dev MUST emit when the token IDs are added to the scope.
        By default, IDs are in no scope.
        The range is inclusive: _idStart, _idEnd, and all IDs in between have been added to the scope.
        _idStart must be lower than or equal to _idEnd.
    */
    event IdsAddedToScope(uint256 indexed _idStart, uint256 indexed _idEnd, bytes32 indexed _scope);

    /**
        @dev MUST emit when the token IDs are removed from the scope.
        The range is inclusive: _idStart, _idEnd, and all IDs in between have been removed from the scope.
        _idStart must be lower than or equal to _idEnd.
    */
    event IdsRemovedFromScope(uint256 indexed _idStart, uint256 indexed _idEnd, bytes32 indexed _scope);

    /** @dev MUST emit when a scope URI is set or changes.
        URIs are defined in RFC 3986.
        The URI MUST point a JSON file that conforms to the "Scope Metadata JSON Schema".
    */
    event ScopeURI(string _value, bytes32 indexed _scope);

    /**
        @notice     Returns the number of scopes that contain _id.
        @param _id  The token ID
        @return     The number of scopes containing the ID
    */
    function scopeCountForId(uint256 _id) public view returns (uint32);

    /**
        @notice             Returns a scope that contains _id.
        @param _id          The token ID
        @param _scopeIndex  The scope index to  query (valid values are 0 to scopeCountForId(_id)-1)
        @return             The Nth scope containing the ID
    */
    function scopeForId(uint256 _id, uint32 _scopeIndex) public view returns (bytes32);

    /**
        @notice Returns a URI that can be queried to get scope metadata. This URI should return a JSON document containing, at least the scope name and description. Although supplying a URI for every scope is recommended, returning an empty string "" is accepted for scopes without a URI.
        @param  _scope  The queried scope
        @return         The URI describing this scope.
    */
    function scopeUri(bytes32 _scope) public view returns (string memory);

    /**
        @notice Enable or disable approval for a third party ("operator") to manage the caller's tokens in the specified scope.
        @dev MUST emit the ApprovalForScope event on success.
        @param _operator    Address to add to the set of authorized operators
        @param _scope       Approval scope (can be identified by calling scopeForId)
        @param _approved    True if the operator is approved, false to revoke approval
    */
    function setApprovalForScope(address _operator, bytes32 _scope, bool _approved) external;

    /**
        @notice Queries the approval status of an operator for a given owner, within the specified scope.
        @param _owner       The owner of the Tokens
        @param _operator    Address of authorized operator
        @param _scope       Scope to test for approval (can be identified by calling scopeForId)
        @return             True if the operator is approved, false otherwise
    */
    function isApprovedForScope(address _owner, address _operator, bytes32 _scope) public view returns (bool);
}