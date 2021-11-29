const { catchRevert } = require("./exceptionsHelpers.js");
var FundsManager = artifacts.require("./FundsManager.sol");
var RfC = artifacts.require("./RequestForContentToken.sol");
var VoteStake = artifacts.require("./VoteAndDelegateCoordinationMechanisms");
var SwapForCToken = artifacts.require("./SwapFundsForCompoundCToken");
var SwapForCToken = artifacts.require("./ERC1155/*");   //maybe I can't do that...


if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
}

contract("VoteAndDelegateCoordinationMechanisms", function (accounts) {
  const [contractOwner, alice] = accounts;
  //toBN => to big numer; 2 is for 2 accounts (?)
  const deposit = web3.utils.toBN(2);

  beforeEach(async () => {
    instance = await VoteAndDelegateCoordinationMechanisms.new();
  });

  //Tests on vote mechanism, including gaming the outcome of the vote both through the low-level features, and from an economical level
        // See if there are some tools out there to test the cryptonomics of a protocol (also a nice to have, not mandatory at this point 
        //  - except for the search of those tools :) )

  // Tests for the different use case currently involving a vote - the RfC acceptation (if accepted, then protocol rolls, if not, automatically
  //    passed in "CLAIM" status, and back to a vote, but this time to ask for RfC new round/cycle, ), proposal of a content from an accepted RfC
  //    to be enriched (with the perks describe somewhere else in this repo - compounded yield, gas feed reduction, growing shares in the protocol,
  //    **opportunity for new comers to gain some shares on the content** (careful all that add some attack surface and new ways to game the 
  //    protocol end-goal - decentralized, censor-resistant, low-cost/capital efficient, quality content creation)) ...     
  //        ==> {!!!!!] make sure you border the use cases of the vote, and the stakes realtions, so you don't overcomplexify it (DAO-minimized) and 
  //            you can implement it w/o a full-fledged DAO (that can come later on the Dapp development).

});