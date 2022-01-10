// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/** 

  - ERC20 tokens minted by FundsManager contract through a call to ERC1155 batchMint function
  - can be exchanged (based on the calculation of the share and its ERC20 equivalent)
  - the share is actually updated when investors or CPs decide to sell their share of 
    the content created
  - those shares, during the content content cration, are actually under the hood changing also 
  with the cToken coumpounded earned interests. (I still think the protocol would be much more 
  powerful if I could use Pendle or Alchemix to give users a way to redeem quickly some of their funds,
  to the CPs to tap in some of the future liquidity, etc. => brings the flexibility I want for it
  to be both interesting for participants, and for the protocol to have a stream of revenue) 


**/


contract ContentShare is ERC20 {

  address public tokenAddress;
  
  mapping(uint256 => uint256) public startingContentShare; //  dynamic state, contrarily to the others: how
                                                        // to make it work => likely use the entry value
                                                        // and calculation happens on the frontend based
                                                        // on the updated share in the core FundsManager 
                                                        // contract where the states are updated.
  
  //This token contract should then be tradable on uniswap (ultimately Pendle so the yield
  //  is part of the AMM)

  constructor(
    string memory name,
    string memory symbol,
    uint256 initialSupply
  ) ERC20(name, symbol) {
    _mint(msg.sender, initialSupply);
  }
  
}
