pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface CToken {
    function redeemUnderlying(uint redeemAmount) external returns (uint);
    function exchangeRateStored() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function isCToken() external view returns(bool);
    function isCEther() external view returns(bool);
}

/// @title base class for a Compound PCV Deposit
/// @author Fei Protocol <<<<<
abstract contract CompoundPCVDepositBase is PCVDeposit {

    //Keep in mind that the Compound Finance Protocol is used through the pooled capital of all users for a given RfC, 
    //  but that relate it to the per account initial value deposit (after swap to DAI). So, you have to keep track of those
    //  initial deposit, and then just use that in whatever calculation (before transactions) requires it.

    CToken public cToken; //cDAI on Ropsten = "0xbc689667c13fb2a04f09272753760e38a95b998c";

    uint256 private constant EXCHANGE_RATE_SCALE = 1e18;

    /// @notice Compound PCV Deposit constructor
    /// @param _core Fei Core for reference
    /// @param _cToken Compound cToken to deposit
    constructor(
        address _core,
        address _cToken
    ) CoreRef(_core) {
        cToken = CToken(_cToken);
        require(cToken.isCToken(), "CompoundPCVDeposit: Not a cToken");
    }

    /// @notice withdraw tokens from the PCV allocation
    /// @param amountUnderlying of tokens withdrawn
    /// @param to the address to send PCV to
    function withdraw(address to, uint256 amountUnderlying)
        external
        override
        onlyPCVController
        whenNotPaused
    {
        require(
            cToken.redeemUnderlying(amountUnderlying) == 0,
            "CompoundPCVDeposit: redeem error"
        );
        _transferUnderlying(to, amountUnderlying);
        emit Withdrawal(msg.sender, to, amountUnderlying);
    }

    /// @notice returns total balance of PCV in the Deposit excluding the FEI
    /// @dev returns stale values from Compound if the market hasn't been updated
    function balance() public view override returns (uint256) {
        uint256 exchangeRate = cToken.exchangeRateStored();
        return cToken.balanceOf(address(this)) * exchangeRate / EXCHANGE_RATE_SCALE;
    }

    function _transferUnderlying(address to, uint256 amount) internal virtual;
}