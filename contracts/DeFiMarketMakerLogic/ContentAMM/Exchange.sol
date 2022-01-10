// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract SharesExchange is ERC20 {
    address public tokenAddress;

    constructor(address _token) ERC20("RfC-Pool-Id", "RFC-V1") {
        require(_token != address(0), "invalid token address");

        tokenAddress = _token;
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function addFundsForRfC(uint256 _tokenAmount)
        public
        payable
        returns (uint256)
    {
        //RfCFunding a simple function to know the funding (balance of a given instance of
        //  the RfC NFT contract) of an RfC
        if (RfCFunding() == 0) {
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);

            uint256 liquidity = address(this).balance;
            _mint(msg.sender, liquidity);

            return liquidity;
        } else {
            uint256 ethReserve = address(this).balance - msg.value;
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(_tokenAmount >= tokenAmount, "insufficient token amount");

            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), tokenAmount);

            uint256 liquidity = (msg.value * totalSupply()) / ethReserve;
            _mint(msg.sender, liquidity);

            return liquidity;
        }
    }
    
    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
}