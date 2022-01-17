/* contract taken from th FEI protocol and adapted to my dapp needs to implement the access control role-based logic 
in my core contracts */ 

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "./IPermissions.sol";

/// @title Access control module for Core
/// @author Fei Protocol
contract Permissions is IPermissions, AccessControlEnumerable {
    
    bytes32 public constant override MINTER_ROLE = keccak256("MINTER_ROLE");
    //bytes32 public constant override PCV_CONTROLLER_ROLE = keccak256("PCV_CONTROLLER_ROLE");
    bytes32 public constant override GOVERN_ROLE = keccak256("GOVERN_ROLE");

    constructor() {
        // Appointed as a governor so guardian can have indirect access to revoke ability
        _setupGovernor(address(this)); // => the account that mint/deploy the contracts first => a multi-sig account eventually

        _setRoleAdmin(MINTER_ROLE, GOVERN_ROLE);// =>FundsManager contract
        //_setRoleAdmin(PCV_CONTROLLER_ROLE, GOVERN_ROLE); => Have yet to implement in next iteration the protocol's treasury logic
        //_setRoleAdmin(GOVERN_ROLE, GOVERN_ROLE);  // for now is FundsManager role to allow for more secure inter-contracts call logic => "operator authorized" in ERC1155 logic
    }

    modifier onlyGovernor() {
        require(
            isGovernor(msg.sender),
            "Permissions: Caller is not a governor"
        );
        _;
    }

    /// @notice creates a new role to be maintained
    /// @param role the new role id
    /// @param adminRole the admin role id for `role`
    /// @dev can also be used to update admin of existing role
    function createRole(bytes32 role, bytes32 adminRole)
        external
        override
        onlyGovernor
    {
        _setRoleAdmin(role, adminRole);
    }

    /// @notice grants minter role to address
    /// @param minter new minter
    function grantMinter(address minter) external override onlyGovernor {
        grantRole(MINTER_ROLE, minter);
    }

    /// @notice grants governor role to address
    /// @param governor new governor
    function grantGovernor(address governor) external override onlyGovernor {
        grantRole(GOVERN_ROLE, governor);
    }

    /// @notice revokes minter role from address
    /// @param minter ex minter
    function revokeMinter(address minter) external override onlyGovernor {
        revokeRole(MINTER_ROLE, minter);
    }

    /// @notice revokes governor role from address
    /// @param governor ex governor
    function revokeGovernor(address governor) external override onlyGovernor {
        revokeRole(GOVERN_ROLE, governor);
    }

    /// @notice revokes a role from address
    /// @param role the role to revoke
    /// @param account the address to revoke the role from
    function revokeOverride(bytes32 role, address account)
        external
        override
        onlyGuardian
    {
        require(role != GOVERN_ROLE, "Permissions: Guardian cannot revoke governor");

        // External call because this contract is appointed as a governor and has access to revoke
        this.revokeRole(role, account);
    }


    /// @notice checks if address is a minter
    /// @param _address address to check
    /// @return true _address is a minter
    function isMinter(address _address) external view override returns (bool) {
        return hasRole(MINTER_ROLE, _address);
    }

    function _setupGovernor(address governor) internal {
        _setupRole(GOVERN_ROLE, governor);
    }
}