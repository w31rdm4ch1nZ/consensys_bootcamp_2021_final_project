// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract RfCProposal is ERC721Burnable, ERC721Enumerable, Ownable  {
    
    // NFT data
    mapping(uint256 => uint256) public amount;
    

    //specific to this contract is the matureTime - if in the context of a proposition, then matureTime should be of RfC proposal to CPs phase
    // minimum/standard (for now) duration + a hold (to prevent abuses) of 30 days hold on it (on which can be made some yield profit - TBD if 
    // those go to the procotol only, or some are given back to the user initiating a proposal).
    mapping(uint256 => uint256) public matureTime;

    address participant;

    mapping (address => uint256) balance;

    //Properties and components of an RfC: => check the RequestForContent contract:

    //uint256 public RfCcounter = 0;


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



    /** 
        TO DO
    // enum being the equivalent of the drop lists in the frontend the user can choose => same
    //  possible (and restricted to what the protocol allows currently) values:
    enum ...

    // then all defined properties are put together in this struct RfC data structure so it can 
    //  be manipulated further, like in some split function, or merge one.
    struct RequestForContent{

    }

    **/
    
    //Have a constructor that enables initializing this contract with some of those values
    //  determined by the proposal's bearer input => then it's minted, and if it is passed
    //  it can be added to an escrow, with the funds in cToken allocated to this RfC, the
    //  shares that will be eventually (once the cToken redeemed) taken from the content 
    //  pooled capital. And that's it.

    /** 
        TO DO
    **/

    // get from InvestorEscrow contract the value of minEscrowTime;

    //function proposal:
    function initiateProposalRfCRound(address _from, RequestFoContent _RfC, uint256 _RfCId, uint256 matureTime)


    //function public investors commit funds to signal their interest for the RfC in proposal (+ quadratic voting-like formula for the definition of teh shares
    //  allocated to every investors once the RfC is passed = passed if CPs answer the proposition as well with a funding proposition):
    
}