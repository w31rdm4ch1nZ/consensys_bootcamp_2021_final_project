const { catchRevert } = require("./exceptionsHelpers.js");
var FundsManager = artifacts.require("./FundsManager.sol");
var RfC = artifacts.require("./RequestForContentToken.sol");
var VoteStake = artifacts.require("./VoteAndDelegateCoordinationMechanisms");
var SwapForCToken = artifacts.require("./SwapFundsForCompoundCToken");
var SwapForCToken = artifacts.require("./ERC1155/*");   //maybe I can't do that...


if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
}

contract("RequestForContentToken", function (accounts) {
  const [contractOwner, alice] = accounts;
  //toBN => to big numer; 2 is for 2 accounts (?)
  const deposit = web3.utils.toBN(2);

  beforeEach(async () => {
    instance = await RequestForContentToken.new();
  });

  //Tests:
  // No new tests on metamask
  
  //Tests related to events triggered automatically by the FundsManager contract (without any direct user-investor's 
  // possibility to intervene here), but maybe it will require the CPs to do so (I'd like not, preferring using FundsManager as a proxy for all interactions
  // with the RfC mechanics (the "trustless" enforcement..?) - and actually, the heavy lifting is mostly done by FundsManager. 
  // It should be all set so this RequestForContentToken contract is called for minting according 
  // to the logic encoded in FundsManager once every states (tokens supplies, type of token, funds accounts tracking, etc.)
  // has been defined) ==> TBD (if CPs need to interact directly with this contract)

  


});