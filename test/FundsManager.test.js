const { catchRevert } = require("./exceptionsHelpers.js");
var FundsManager = artifacts.require("./FundsManager.sol");
var RfC = artifacts.require("./RequestForContentToken.sol");
var VoteStake = artifacts.require("./VoteAndDelegateCoordinationMechanisms");
var SwapForCToken = artifacts.require("./SwapFundsForCompoundCToken");

//>>>>> Add the Compound and Pendle Rinkeby contract addresses <<<<<

if (typeof window.ethereum !== 'undefined') {
    console.log('MetaMask is installed!');
}

contract("FundsManager", function (accounts) {
  const [contractOwner, alice] = accounts;
  //toBN => to big numer; 2 is for 2 accounts (?)
  const deposit = web3.utils.toBN(2);

  beforeEach(async () => {
    instance = await FundsManager.new();
  });

  /*example of a typical javascript test:

  it("ready to be solved!", async() => {
    const eth100 = 100e18;
    assert.equal(await web3.eth.getBalance(alice), eth100.toString());
  });

  */

  // => I am going to start thinking about a series of tests for this smart contract SPECIFICALLY, in the order of the user flow as I imagine
  // it. I will start describing the test in plain english.

  //is the account's address well formated?
  //is it not 0x addr? (don't know if it makes sense in this direction)
  //is the user connected to the right network?
  //is the user's metamask connected to the Dapp?
  //can the user's funds be sent with another (arbitrary) account?
      //>>>>more user's account test to come with the workflow defined:
      //>>is the user registered as an investor/has some funds commited to the contract? => intended behavior following a 'true' output of this test
        //                                        is to have the frontend to dynamically emphasize in the listing of some RfC with "processing" status 
        //                                        that this user (investor or CP) is commit in.
          
          //>>>> if the user has indeed funds committed to the contract:
             
            //>> is the value of the funds commited by the user to an RfC readable? => right visibility, get() public
            //>> does the user have several RfC she's engaged in?
            //>> When the funds for each RfC were 1st commited?
            //>> How much at the time?
            //>> How much now?
            //>> How much projected based on the Content Delivery expiration/deadline delivery? 
            //              = (initial payment + yield) - (protocol's fee + CP payment) + (unclaimed shares ratio on content they have been
            //                an investor or a CP in the past that is now accessed by other participants of the platform)
                            // ==> remember that as our end product is not a financial product, I choose to use only one type of collateral,
                            //      a few "trusted", "battle-tested" stablecoins. (to KISS rn, just require one stablecoin, so you don't add
                            //      another internal swap mechanics - if you can do it though for Ether to DAI/FEI, that would be great!, but if complex,
                            //      keep it for later) 
            //>>>prepare to flesh those with tests for the Compound and Pendle use, from the call on external functions (and security precautions
            //    taken) to the actual state that you can read from those Dapps (likely there are wrappers developped by both Dapps that you can
            //    use to deliver more information on the state of the funds of the user), and use it to deliver the estimated projected funds (
            //    including the variable yield at the current time the user is on the app)
            // ...
        //>> what is (/are) the share of the user in the investor's (if investor) pooled funds in % => translate in ownership on the future content,
        //                                               and possibly into a future stream of revenue for this user. (one of the big incentive to be
        //                                                an investor instead of only accessing the content later once it has been produced!)
        //>>can anyone see the shares of anyone?
        //>>
        
        //FINAL SECURITY TESTS on this part (user's funds):
        //    >> can any other account change/tamper the state of any of the user's funds related states?



  //>>>tests designed for the defining the right (and spotting the wrong behaviors) when FundsManager actually interacts 
  //    with the RequestForContent contract (ERC-1155 token)
  //    => BUT, keep in mind that another set of tests will be run on this RequestForContent contract!

});