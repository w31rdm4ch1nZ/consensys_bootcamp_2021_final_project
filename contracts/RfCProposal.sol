// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract RfCProposal {

    //constant
    uint256 public immutable MIN_ESCROW_TIME = /* 30 days in either unix time or blocks estimation*/;

    RequestForContent public RfC;
    //bool public initialized = false;

    address participant;

    mapping (address => uint256) balance;

    uint256 amount;

    //specific to this contract is the matureTime - if in the context of a proposition, then matureTime should be of RfC proposal to CPs phase
    // minimum/standard (for now) duration + a hold (to prevent abuses) of 30 days hold on it (on which can be made some yield profit - TBD if 
    // those go to the procotol only, or some are given back to the user initiating a proposal).
    uint256 matureTime;

    // get from InvestorEscrow contract the value of minEscrowTime;

    //function proposal:
    function initiateProposalRfCRound(address _from, RequestFoContent _RfC, uint256 _RfCId, uint256 matureTime)


    //function public investors commit funds to signal their interest for the RfC in proposal (+ quadratic voting-like formula for the definition of teh shares
    //  allocated to every investors once the RfC is passed = passed if CPs answer the proposition as well with a funding proposition):
    
}