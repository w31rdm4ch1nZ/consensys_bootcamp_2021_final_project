//From FEI Protocol contract ERC20CompoundPCVDeposit is CompoundPCVDepositBase

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface Erc20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);
}
interface CErc20 {
    function mint(uint256 amount) external returns (uint256);

    function underlying() external returns (address);

    function borrow(uint256) external returns (uint256);

    function borrowRatePerBlock() external view returns (uint256);

    function borrowBalanceCurrent(address) external returns (uint256);

    function repayBorrow(uint256) external returns (uint256);
}

interface Comptroller {
    function markets(address) external returns (bool, uint256);

    function enterMarkets(address[] calldata)
        external
        returns (uint256[] memory);

    function getAccountLiquidity(address)
        external
        view
        returns (uint256, uint256, uint256);
}


interface PriceFeed {
    function getUnderlyingPrice(address cToken) external view returns (uint);
}

/// @title ERC-20 implementation for a Compound PCV Deposit
/// @author Fei Protocol
contract ERC20CompoundFundsManagerDeposit {

    /// @notice the token underlying the cToken
    IERC20 public token;

    /// @notice Compound ERC20 PCV Deposit constructor
    /// @param _core Fei Core for reference
    /// @param _cToken Compound cToken to deposit
    constructor(
        address _core,
        address _cToken
    ) CompoundPCVDepositBase(_core, _cToken) {
        token = IERC20(CErc20(_cToken).underlying());
    }

    /// @notice deposit ERC-20 tokens to Compound
    function deposit()
        external
        override
        whenNotPaused
    {
        uint256 amount = token.balanceOf(address(this));

        token.approve(address(cToken), amount);

        // Compound returns non-zero when there is an error
        require(CErc20(address(cToken)).mint(amount) == 0, "ERC20CompoundPCVDeposit: deposit error");
        
        emit Deposit(msg.sender, amount);
    }

    function _transferUnderlying(address to, uint256 amount) internal override {
        SafeERC20.safeTransfer(token, to, amount);
    }

    /// @notice display the related token of the balance reported
    function balanceReportedIn() public view override returns (address) {
        return address(token);
    }
}