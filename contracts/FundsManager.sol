// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;

//the abicoder-v2, to allow for arbitrary nested arrays and structs to be encoded and decoded in calldata. => to research.
//pragma abicoder v2;

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
    //event WalletFundsApproved();
    
    event FundsReceived(address account);

    //event investorsFundsPooled();
    
    //event CPsFundsPoooled();

    //event FundsSwappedToStablecoin();


    //constructor

    /*
    //fallback and ..? functions
    //Not sure I'll keep this function - should handle every tx sending ethers more gracefully
    function () external payable {
        revert();
    }
    */

    //>>>>Same, not sure I keep this direct call from any user on this contract...<<<<
    /// @notice a user can read the value of funds held by the contract (before they are put in the "management cycle")
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      // 1. A SPECIAL KEYWORD prevents function from editing state variables;
      //    allows function to run locally/off blockchain
      // 2. Get the balance of the sender of this transaction
      return balances[msg.sender];
    }

    // approval functions for the contract to manage the funds and 1st interact with a wallet (here Metamask) => maybe off-chain, through metamask

    //TBD: commit scheme to signal interest and intensity of this interest for a RfC by investors

    //1. sent funds contract receiving function (the 'commit event' in cases of investors and CPs):
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

    //2. swap (all) pooled funds for stablecoin, that has to be supported by Compound atm (for investors and CPs use case - except all cases where instant payment can take place, so no need for swap 
    //  and gas price to happen ) once an RfC is tokenized/minted (adding a modifier RfCTokenMinted()):
        // The question of a protocol native stablecoin is still TBD in the next developments, as it has its rationale, but adds too much complexity rn
    function swapToStablecoin(
        string _tickerStablecoin,       //only FEI or USDC for now
        uint _amount, 
        uint _pooledFundsId/* not sure how to implement the pool yet*/
        ) 
        internal returns(uint amountUSDStablecoin) {

            //TO DO

            //call to Uniswap contract? Check if there is a way to do it all in Compound
            if (msg.value > 0) {
                convertEthToExactFEI(paymentAmountInDai);
            } else {
                require(feiToken.transferFrom(msg.sender, address(this), swapEthAmountInFEI));
            }

            //pool the DAI for one specific RfC once this RfC has been accepted, then deposit in Compound:

            //for local tests - just a simple quotation based on a fixed ether price and only ETH -> FEI

            //event emitted on successful swap
            emit StablecoinswapSuccess();

            //pooled capital state updated to reflect the "frozen value"/stablecoin value

            //return this value and the address to 
        }
    
    //function using Uniswapv3 to swap Eth payment (by investors and CPs) to DAI (I'd like FEI if Compound takes it):
    // code taken from (https://soliditydeveloper.com/uniswap3)
    function convertEthToExactDai(uint256 daiAmount) external payable {
        require(daiAmount > 0, "Must pass non 0 DAI amount");
        require(msg.value > 0, "Must pass non 0 ETH amount");
        
        uint256 deadline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
        address tokenIn = WETH9;
        address tokenOut = multiDaiKovan;        // check for a public testnet easy to use (can have Eth easily) and have an instance of Uniswap and Compound
        uint24 fee = 3000;
        address recipient = msg.sender;
        uint256 amountOut = daiAmount;
        uint256 amountInMaximum = msg.value;
        uint160 sqrtPriceLimitX96 = 0;          // Can be used to determine limits on the pool prices which cannot  be exceeded by the swap. If you set it to 0, it's ignored.
        
        // The SwapRouter will be a wrapper contract provided by Uniswap that has several safety mechanisms and convenience functions. 
        //  You can instantiate it using ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564) for any main or testnet.
        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams(    // should require inporting Uniswap ISwapRouter contract
            tokenIn,
            tokenOut,
            fee,
            recipient,
            deadline,
            amountOut,
            amountInMaximum,
            sqrtPriceLimitX96
        );
        
        uniswapRouter.exactOutputSingle{ value: msg.value }(params);
        uniswapRouter.refundETH();
        
        // refund leftover ETH to user
        (bool success,) = msg.sender.call{ value: address(this).balance }("");
        require(success, "refund failed");
    }

    //function used by the frontend to give users the exact amount of Ether needed for a given amount in DAI/FEI:
    function getEstimatedETHforDAI(uint daiAmount) external payable returns (uint256) {
        address tokenIn = WETH9;
        address tokenOut = multiDaiKovan;
        uint24 fee = 500;
        uint160 sqrtPriceLimitX96 = 0;

        return quoter.quoteExactOutputSingle(
            tokenIn,
            tokenOut,
            fee,
            daiAmount,
            sqrtPriceLimitX96
        );
    }
    /** 
        >>>>>PREVIOUSLY THOUGHT TO BE PART OF A SEPARATE CONTRACT (named SwapFundsForCompoundCToken), now integrated - see below<<<<<

    This step is the fundamental previous step to use Pendle contracts.

    + It might be an occasion to use the Compound.js wrappers presented in during the bootcamp.

            ==> output: the user-investors and CPs funds put under escrow are send to Compound protocol, then it returns the cTokens for each position.
                    ==> you have to determine once and for all if it works individually or collectively. What I think would work best:
                        ==> Figure out how to use ERC-1155 to get 2 cTokens (save gas and management seems more easy - but you can change of idea
                        later on in the actual implementation of course), 1 for user-investors pooled funds (but have a mechanism to get back yield for individuals
                        once they can exit so they don't lose it) and 1 PER CP (as the RfC to be split for cooperation or delegation of some tasks)
                        ==> Also define how (/why it is used and what does it enable them protocol to do) it (yields on funds used as collateral) works to benefit the 
                        active participants, the protocol itself, and the future access to the content for the user-investors, some protocol's incentivization specifically
                        towards CPs (through sending some of protocol's revenue on all transactions to those CPs), also some part is sent according to the overall shares
                        of ownership on contents produced through the platform.



    // Tests to be done with the Rinkeby/Topsten Testnet contracts addresses of Comppound and Pendle (check for compatibility of testnets of both Pendle and Compound - 
    // should be fine as Pendle is built on top of money markets as Compound and Aave)


    //This contract could be an interface designed for our FundsManager contract to interact with Compound (interesting pattern thinking here
    // it might indeed be easier to maintain as Compound and our Dapp core contract evolves (upgrades management)?).

    //It also could handle the swap of a crypto-currency such as Ether for a stablecoin such as DAI or FEI. 

    **/


    /*
    //3. Call to compound contract to deposit stablecoin and earn on it - which returns cTokens, kept under escrow by this contract 
    //  Take a closer look at the Compound.js wrappers to see if you can do it in the most simple way.
    //      => https://github.com/compound-finance/compound-js
    //          => See in particular: https://compound.finance/docs/compound-js#cToken
    // OR use the Compound (lower-level) API: https://compound.finance/docs/api
    // Also see the Consensys demo github repo: https://github.com/ajb413/consensys-academy-compound-js
    const main = async () => {
    const account = await Compound.api.account({
        "addresses": "0xB61C5971d9c0472befceFfbE662555B78284c307",
        "network": "ropsten"
    });

    let daiBorrowBalance = 0;
    if (Object.isExtensible(account) && account.accounts) {
        account.accounts.forEach((acc) => {
        acc.tokens.forEach((tok) => {
            if (tok.symbol === Compound.cDAI) {
            daiBorrowBalance = +tok.borrow_balance_underlying.value;
            }
        });
        });
    }

    console.log('daiBorrowBalance', daiBorrowBalance);
    }

    main().catch(console.error);
    */

    //4. Call to/from RfC contract to makes those pooled cTokens part of the RfC token (maybe using the ownable token interface in proposition state)
    
     

    //user-investors functions related to funds management is initiated through the investors' web UI and Metamask confirmation (sig)
    function manageInvestorsFunds(address _sender, uint256 _amount) external payable isInvestor returns() {
        //metadata recording to facilitate the management of the funds of the user-investors,
        // and the tracking of the investors position through an NFT minted
        timeOfDeposit = time.?;
        ...


    };

    function manageCPsFunds(address _sender, uint256 _amount) external payable isContentProvider returns() {
        //specific metadata reagrding the deposit so the fund management automation can be done properly, 
        // and the tracking of the CP position through an NFT minted



    };

    function poolingFunds() internal returns() {};

    //5.1  if RfC delivered successfully,

    //5.1.1 mint content NFT or access to content NFT for the investors + shares on content earned by the investors (tracked through same mechanism as 
    //  Uniswap LPs share NFT mechanism) granted because of their contribution

    //  (a second function - might also encoded in the same function - regards
    //  providing acces to any users => likely separately so you implement the flow for a user to access content (simple payment, access token (NFT)
    //  and distribution of the payment between investors shares on this content, CP(s) involved in the content production, and fees for the actual
    //  platform(s) hosting the content (filecoin/IPFS, LivePeer, etc.)))  

    //5.1.2. CPs payment once content minted and accessed by investors + get some of the yield gained through cTokens with which they can 
    //  tune up a bit their business model (perks for investors, perks for future users accessing the content, etc. => a limited /contrained and 
    //  trustless amount of options proposed through their web UI/dashboard)
    function payCPs(uint256 _amountFundsXyield, address CPaddr) internal returns(bool successPayment) {

        //Calculate CP payment (cf. what you already defined to foactor in that calculation)

        //One CP payment once content is delivered

        //Case of a part or all content delivery **delegated** by the CP who first commited for RfC mint  
        // TO DO for next iteration

    };

    // 5.2 The RfC is not delivered or accepted:

    // 5.2.1 Redeem investors funds

    // 5.2.2 Slash a part of the CPs capital commited to this contract

    /*
        >>>>>
            LAST IMPORTANT PIECE OF YOUR 1ST ITERATION:
            THE "PROTOCOL CONTROLLED VALUE" (PCV), OR THE VALUE ACCRUED
            BY THE PROTOCOL OVER TIME THROUGH A RATIO TAKEN ON SOME TRANSACTIONS
            (BE VERY CAREFUL AT HOW THAT MIGHT IMPACT THE INCENTIVE OF THE
            ESSENTIAL PARTICIPANTS TO THE PROTOCOL - INVESTORS AND CONTENT PROVIDERS) 
                => see how it is implemented in FEI protocol
        <<<<<
    */
    
    //6.1. redeem investors payments and yield earned to the protocol as "Protocol Controled Value" (cf. FEI contract if you have time) (which
    //  will mostly be used for granting access to everyone to a specific content, deemed to belong "the common"/public (a common good)) 
    function transferToProtocolFundsControlled() internal {
        //TO DO
    }

    //6.2 In the event of 5.2, distribute CPs slashed funds between investors and PCV 
        //  (TBD in next iteration: or propose a new proposition to CPs round for the RfC to be accepted 
        //  + the case for RfC enrichment/content or information added to a specific RfC or even a set of RfC 
        // (case of investigative journalism/crowdjournalism/open journalism))
    function distributeSlashedCPsFunds() internal {
        //TO DO
    }

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
    

    function splitCPsFundsForDelegatees(RequestFoContent ) internal resturns() {
        //TO DO for next iteration
    };

   



}