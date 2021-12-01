// SPDX-License-Identifier: GPL-3.0-only

 
/* 

>>>>>>> RETHINK WITH THE ReqForContentToken_Divisible_and_Stakable.sol Contract so those 2
EMBEDS THE CONTENT DELIVERY PROTOCOL CORE LOGIC IN A CLEAN (NON REDUNDANT, ..?) WAY 
>>>>>>>


1. Receive funds
 
2. Pools funds once a RfC has gone through the validation process, keeping track separately (2 mapping state variable probably)
    for user-investors and CPs.

3. Call Pendle functions to handle the pooled funds and use the mechanism for FutureYield tokens and their AMM. 
    => Swap it according to a logic linked to the inputs (check Pendle's ABI and the function's inputs accordingly):
      - "starting time of the deposit for yield of tokens", 
      - "time to maturity/redeem"
      - "amount"
      - "..."
 
4. Receive what Pendle returns under a tokenized form yet to be defined - by going through their doc and testing what you
    can do with their ABI.

5. - Tokens distribution Logic for User-investore in case of failing to deliver on teh CPs side
   - Symmetric Logic applying to the CPs commited = slashing a ratio of what they have commited.

6. - Token distribution Logic for the CPs when the outcome is "yes/true", that is the content was delivered.
   - Corresponding Logic with the funds escrowed by user-investors.

7. *[maybe for another iteration as it introduces new pbs/challenges linked to voting mechanisms and threat vectors for CPs against competing CPs, etc.]*
    In case of completion ("yes/true"), once the last round of distribution happened, the remaining CPs funds are to be 
    subject to a last round of satisfaction (vote signaling) by the user-investors 


*/

// See for the compiler you should use
pragma solidity ^0.8.2;
//the abicoder-v2, to allow for arbitrary nested arrays and structs to be encoded and decoded in calldata. => to research.
pragma abicoder v2;


//import ERC1155.sol and IERC1155 from OpenZeppelin library, or more likely: use it as a template, and configuren for the need of RfC

//import required by Pendle:
import './IPendleRouter.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

/* [[Check the design as the ERC1155 inehirted contract should bear most of the heavy lifting, including all minting. 
    Maybe only when RfC comes to be minted, then it takes full control over the mechanisms]]
*/

//This contract acts like a bank (more than an escrow) where clients are investors and CPs, on steroids because using crypto money markets for yields.
contract FundsManager {

    //set of amount states value necessary for our various use cases that will be used as input to mint our RfC 1155 tokens
    // (ex: minting an NFT and somr ERC-20 and sending both to a user for an art project that wants to give back to the investors
    // through the artwork + some of the benefits made during the drop, or after; ):
    uint256 public investorBalance;
    uint256 public investorTotalPooledFunds;    // defined only for 1 RfC for now (might rethink later the mechanics so the logic would be extended over different 
                                                // pools for a single investor - more capital efficient for each investor (like pooled txs, compounded rewards,
                                                // lower fees, etc.))

    //for all individual partcipant account state tracking:
    address public protocolParticipant;

    //1st, simple, deposit to the contract (also an event):
    //to "get" the addresses of users with deposits in the contract:
    mapping (address => bool) public userHaveFundsDeposited;

    //

    //to distinguish among the participants between our 3 types of participant (all users will be qualified based on tghe transactions conducted, implying 
    // some funds commitment - so that it is safe to assume they are Investor, or simple Consumer)
    struct UserType{
        address Investor;
        address ContentProvider;
        address ContentConsumer;
    }

    mapping (address => uint256) balances;

    //instantiation of the RfC contract to use it in relation to the fund management logic (rewards payment, splitted RfC payment calculation
    // and distribution, backing RfC with ERC20, etc.)
    RequestForContent public RfC;           // maybe call throuhgh an interface (making it easier to upgrade and callable by other contracts: 
                                            // IRequestForContent public immutable RfC)

    //MODIFIERS

    // Those three will enable a control over the feature accessed by our different type of users, both for use and security reasons:
    modifier isInvestor{
        require(protocolParticipant == UserType.Investor, "It requires a user being an 'investor' to make this transaction");
        _;
    }

    modifier isContentProvider{
        require(protocolParticipant == UserType.ContentProvider, "It requires a user to be a 'Content Provider' to make this transaction");
        _;
    }

    modifier isContentConsumer{
        require(protocolParticipant == UserType.ContentConsumer, "It requires a user to be a 'Content Consumer' to make this transaction");
        _;
    }

    //EVENTS
    event WalletFundsApproved();
    
    event FundsReceived();

    event FundsDepositedToPool();

    event FundsSwappedToX();

    event YieldTokenized();

    event PendleCalledSuccess(uint256 numberOfYT, uint256 YTvalueAtTimeOfDeposit, ...);

    //constructor

    
    //fallback and ..? functions
    //Not sure I'll keep this function - should handle every tx sending ethers more gracefully
    function () external payable {
        revert();
    }
    
    //>>>>Same, not sure I keep this direct call from any user on this contract...<<<<
    /// @notice a user can read the value of funds held by the contract (before they are put in the "management cycle")
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      // 1. A SPECIAL KEYWORD prevents function from editing state variables;
      //    allows function to run locally/off blockchain
      // 2. Get the balance of the sender of this transaction
      return balances[msg.sender];
    }

    // approval functions for the contract to manage the funds and 1st interact with a wallet (here Metamask)

    function receiveFunds() public payable returns (bool depositSuccess) {
        //1st function to handle every deposit = before any user's classification, or any swap or tapping in any yield protocol.
        // Simple purpose: receive safely any deposit, and having it ready to be usable (pulled by other more advanced functions)
        userHaveFundsDeposited[msg.sender] = true;
        emit FundsReceived(msg.sender);

        /*
        Logic that allows to distinguish between users eventually, but first between the type of transaction asked (all tx return a message to the user for 
        their confirmation so they know what type of tx they commit to):
            - commit for RfC proposal (-> user gets type investor);
            - commmit for RfC acceptation (instead of voting, it is a "ready_to_stake scheme", or staging for commit to invest directly in a specific RfC ->
                user gets type investor);
            - commit for minting the RfC ERC1155 token (-> user gets type investor);
            - commit for being responsible for the content creation (-> user gets type Content Provider - 1st agree on time to deliver, type/medium of content at
                delivery, storage requirement of the content => it defines on what specifics the slashing/punishment will happen for the CP if they don't 
                respect one of the following components/requirements of the request);
            - commit to handle a subset of the RfC components and requirements attached (-> user gets type Content Provider);
        */
        
        return userHaveFundsDeposited[msg.sender];
    } 

    //user-investors functions related to funds management is initiated through the investors' web UI and Metamask confirmation (sig)
    function receiveInvestorsFunds(address _sender, uint256 _amount) external payable isInvestor returns() {
        //metadata recording to facilitate the management of the funds of the user-investors,
        // and the tracking of the investors position through an NFT minted
        timeOfDeposit = time.?;
        ...


    };

    function receiveCPsFunds(address _sender, uint256 _amount) external payable isContentProvider returns() {
        //specific metadata reagrding the deposit so the fund management automation can be done properly, 
        // and the tracking of the CP position through an NFT minted



    };

    function poolingFunds() internal returns() {};

    function payCPs(uint256 _amountFundsXyield, address CPaddr) internal returns(bool successPayment) {

        //One CP payment once content is delivered

        //Case of a part or all content delivery **delegated** by the CP who first commited for RfC mint  


    };

        /*
        Coordination mechanism for Content Providers when several accounts-CPs answer the RfC proposition:
          
          - Based on the possibility for 2 CPs to trigger the execution of the function splitRfC() so one takes
          ownership of a part of the RfC and of the completion of the aspect(s) of the content; 
                ==> in the RfC is IERC1155 contract
          - and on a delegate proof-of-stake mechanism (look and take for model something already existing - maybe
          FEI protocol? and what the nice added to make it a compound staking? or more in the Tezos spirit (of delegation)
          or something close and then try to implement you way - likely naive but who cares?)
                ==> maybe a separate contract, or (more simple to deploy) in the ManageFunds.sol core contract
        Make sure no 2 CP are working on the same tasks (at least unknowingly - if they 
        to compete, they might as well do it)

        The ERC20 staking delegation machanism to the escrow contracts is the core aspect
        of this mechanism

        Have to decide for CP choice:
            - a first comes first serve simple selection?
            - a round of commit + an investors' vote + a possible coordination through delegation
            of the main CP contributor (biggest stake for now - KISS, please, KISS)?
                ==> Stick to the "no fully fledged DAO implementation" on 1st iteration, 
                so the choice holds to it.


    */

    //For now, simplified to biggest stake commited in the proposition round (in the idea that
    // it can become then a delegator as it has the capital to cover the start, etc.)

    // Write functions for the Delegation proof-of-satke mechanism,
    //  to have several CPs coordinating on different aspect of the RfC

    // Design of the CP(s) commit phase:
    function CPCommitSignal(address _CP,uint256 _amount) internal returns() {
        //TO DO

        //lock amount for 3 days (the actual lasting of a full proposal RfC round + 1 week)
        // + if RfC is not minted (or CP not accepted as CP by investors => no DAO implementation
        // so far, so will stick to the simplest case and mechanism for now))
    }

    //functions associated with the split RfC Token function. 
    // Can be:
    // proposal ends up having several CPs answering -> RfC split proposition (then exact split has to be accepted by
    // every CPs deciding to commit, with an order of importance (deciding of the dPOS: delegator -> delegatee) that goes
    // from mandatory fields to properties a-z ->  


    function splitCPsFundsForDelegatees(RequestFoContent ) internal resturns() {};

    
    /*
        >>>>>
            LAST IMPORTANT PIECE OF YOUR 1ST ITERATION:
            THE "PROTOCOL CONTROLLED VALUE" (PCV), OR THE VALUE ACCRUED
            BY THE PROTOCOL OVER TIME THROUGH A RATIO TAKEN ON SOME TRANSACTIONS
            (BE VERY CAREFUL AT HOW THAT MIGHT IMPACT THE INCENTIVE OF THE
            ESSENTIAL PARTICIPANTS TO THE PROTOCOL - INVESTORS AND CONTENT PROVIDERS) 
        <<<<<
    */


    //<<<<<<Pendle functions contract ABI calls>>>>> - see docs (if the AMM is not worth it, maybe better to do it by yourself directly working with Compound or 
    // Aave tokens and tokenized future yields)
    /*
        SUPER IMPORTANT TO CONTINUE THAT ROAD, their contracts address on the Kovan testnet: 
        https://docs.pendle.finance/docs/addresses/kovan

        SDK reference to build on Pendle:
        https://docs.pendle.finance/docs/reference/intro

        ANOTHER IMPORTANT ASPECT for testing to work:
        As Pendle is reliant on other other DeFi protocols like Aave and Compound for their yield tokens, it is important 
        to have these protocols set up in your test environment during development. Hence, to avoid having to deploy 
        these protocols from scratch, and to best simulate mainnet conditions, we recommend using Hardhat's mainnet forking feature."

    */

    //https://docs.pendle.finance/docs/guides/tokenizing-yield-tokens:

    //Here we create our contract called Examples, and declare an immutable public variable pendleRouter of type IPendleRouter. 
    // This allows us to call functions in the IPendleRouter interface.
    IPendleRouter public immutable pendleRouter;

    //As this is just an example and for simplicity, let us hardcode the yield-bearing token contract address of type IERC20 
    // to be used for tokenization. Let us hardcode the forge ID as well. In production, you would likely use an input parameter 
    // for this in the function, allowing you to change what the pools and tokens you are interacting with on a per transaction basis.
    IERC20 public constant AUSDC = 0xBcca60bB61934080951369a648Fb03DF4F96263C;
    bytes32 public constant FORGE_ID = 0x41617665;

    //maybe deal with all the Pendle mechanics in a separate contract that acts as a proxy and is callable only by our FundsManager contract?
    // here is a constructor dedicated to the IPendleRouter contract
    constructor(IPendleRouter _pendleRouter) {
        pendleRouter = _pendleRouter;
    }

    //Do not forget the step that is assumed in the Pendle example. You should try to make also possible the minting of a yield-bearing asset 
    // such as aX (for Aave) or cY for Compound.

    //New yield token and ownership token contracts will be created on-chain by the Forge when the newYieldContracts() 
    // function in the PendleRouter is called - aUSDC is just an example here:
    function newContracts(uint256 expiry) public return (address ot, address yt) {
        (ot, yt) = pendleRouter.newYieldContracts(FORGE_ID, address(AUSDC), expiry);
    }

    // The tokenization sends the minted YT and OT directly back to the caller of the function (msg.sender).
    function tokenize(uint256 expiry, uint256 amount) public returns (address ot, address yt, uint256 amountMinted) {
        require(AUSDC.transferFrom(msg.sender, (address(this), amount), 'failed token transfer'));
        require(AUSDC.approve(address(pendleRouter), amount), 'approve failed');

        (ot, yt, amountMinted) = pendleRouter.tokenizeYield(
            FORGE_ID,
            address(AUSDC),
            expiry,
            amount,
            msg.sender
        );
    }

    // For this example, we simply return the redeemed interests back to the caller of the function.

    function redeemInterest(uint256 expiry) public returns (uint256 interestRedeemed) {
        interestRedeemed = pendleRouter.redeemDueInterests(
            FORGE_ID,
            address(AUSDC),
            expiry,
            msg.sender
        );
    }

    //In this case, for each OT used to redeem, there must be an equivalent amount of YT (of the same yield contract and expiry). 
    // The YT and OT will be burned, and the underlying yield-bearing asset will be returned to the user.
    function redeemUnderlying(uint256 expiry, uint256 amount, IERC20 yt, IERC20 ot) public returns (uint256 redeemedAmount) {
        // Transfer the YT and OT to this contract to be used for redemption
        require(yt.transferFrom(msg.sender, (address(this), amount), 'failed token transfer'));
        require(yt.approve(address(pendleRouter), amount), 'approve failed');
        require(ot.transferFrom(msg.sender, (address(this), amount), 'failed token transfer'));
        require(ot.approve(address(pendleRouter), amount), 'approve failed');

        redeemedAmount = pendleRouter.redeemUnderlying(
            FORGE_ID,
            address(AUSDC),
            expiry,
            amount
        );
    }

    //I choose to ignore for the sake opf simplicity the case of an expired YT contract

    //After the yield contract has expired or reached the maturity date, instead of redeeming back the underlying yield-bearing asset, 
    // we can renew the yield contract to a new expiry date. Underneath it all, the function is basically just a proxy call to redeemAfterExpiry() 
    // and tokenizeYield() in the PendleRouter. We specify the renewalRate as well, which is a fixed point number that indicates how much of the 
    // total redeemed underlying yield-bearing asset amount will be used for tokenization for the new expiry. In this example, we simply use a 
    // renewalRate of 1 to make use of the full renewed amount. Using a value greater than 1 means increasing your position in the new yield contract.
    function renewYieldContract(uint256 oldExpiry, uint256 newExpiry) public returns (
        uint256 redeemedAmount,
        uint256 amountRenewed,
        address ot,
        address xyt,
        uint256 amountTokenMinted
    ) {
        // Transfer the whole OT balance to this contract to be used for renewal
        uint256 balance = ot.balanceOf(msg.sender);
        require(ot.transferFrom(msg.sender, (address(this), balance), 'failed token transfer'));
        require(ot.approve(address(pendleRouter), balance), 'approve failed');

        (redeemedAmount, amountRenewed, ot, xyt, amountTokenMinted) = pendleRouter.renewYield(
            FORGE_ID,
            oldExpiry,
            address(AUSDC),
            newExpiry,
            1
        );
    }

    /*
    https://docs.pendle.finance/docs/guides/performing-a-swap

    Executing the Swap - Examples​
    We will cover 2 scenarios:

        1. An exact swap of 100 USDC to YT-aUSDC-29Dec2022
        2. An exact swap of USDC to 100 YT-aUSDC-29Dec2022
    
    Before swapping, the contract should be in possession of USDC. The caller can either send the tokens beforehand, 
    or give allowance to the contract to call the transferFrom method. The short code snippet below showcases the latter. 
    Lastly, remember that because our contract is a contract itself and not an extension of the caller (which is you), 
    you must also make sure to provide token allowance to the PendleRouter.

    */

    /* IDEA:
    Create YT markets for each services you think might be interesting for content creation to distribution: Filecoin, Arweave, LivePeer, Audius, etc.
    Then add the logic here that enables to:
        1. Tokenize Yield Tokens 
        2. Performing a swap (YT and other ERC20 tokens)
        3. Provisioning Liquidity (creatin a future yield token markets on Pendle, mostly for the protocols tokens that will be used for content delivery
            => most liekly don't have a yield-bearing tokens on Aave or Compound - still worth verifying)

        Then, it would lead to different set-up to play with.
    */  


    //commit scheme to signal interest and intensity of this interest for a RfC:




}