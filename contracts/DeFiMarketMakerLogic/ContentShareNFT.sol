// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/** 

  - Minted by FundsManager contract through a call to ERC1155 batchMint function
  - Redeem is also done trough ERC1155 standard => "redeem" function for investors
  will mean cToken for a given RfC are redeemed by FundsManager <-> Compound, then 
  sent to InvestorEscrow contract, then can be redeemed by every user.

**/
contract ContentShareNFT {

   uint256 public RfCcounter = 0;

  // NFT data
  mapping(uint256 => uint256) public amount;
  mapping(uint256 => uint256) public matureTime;
  mapping(uint256 => uint256) public startingContentShare; //  dynamic state, contrarily to the others: how
                                                          // to make it work => likely use the entry value
                                                          // and calculation happens on the frontend based
                                                          // on the updated share in the core FundsManager 
                                                          // contract where the states are updated.
  constructor() ERC721("ContentShareNFT", "ShareESCRW") {
  }
  
  function mint(address _recipient, uint256 _amount, uint256 _matureTime, uint256 _share) public onlyOwner returns (uint256) {
    _mint(_recipient, tokenCounter);

    // set values
    amount[tokenCounter] = _amount;
    matureTime[tokenCounter] = _matureTime;
    startingContentShare[] = _share;
    
    // increment counter
    tokenCounter++;

    return tokenCounter - 1; // return ID
}

}
