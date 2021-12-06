// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

//MAYBE NO UPSIDE TO PROCESS SEPARATELY CPs AND  INVESTORs FUNDS => same cDAI for all committed participants, but issuance of bond-like tokens that allows
// to further differentiate uses. 

//This contract acts like a bank (more than an escrow) where clients are investors and CPs, on steroids because using crypto money markets for yields.
contract FundsManager {

    //set of amount states value necessary for our various use cases that will be used as input to mint our RfC 1155 tokens
    // (ex: minting an NFT and somr ERC-20 and sending both to a user for an art project that wants to give back to the investors
    // through the artwork + some of the benefits made during the drop, or after; ):
    address public immutable contractAddr = address(this);  // used mainly to txs initiated by this contract (with the Uniswap and Compound ones, and any PCV-like mechanics)
    address public immutable testnetWETH = "";   //hardcoding for now the eth erc20 wrapper contract adress on the testnet used

    address public account;

    mapping (address => uint256) balances;

    //1st, simple, deposit to the contract (also an event):
    //to "get" the addresses of users with deposits in the contract. Used also to have a list of users addr using the protocol:
    mapping (address => bool) public userHaveFundsDeposited;

    //set as soon as funds are sent from the account address for all participants. To be used for a modifier or authorization role
    mapping (address => bool) isProtocolParticipant;

    //Either this or the following struct to distinguish between differerent types of users
    mapping (address => bool) isInvestor;
    mapping (address => bool) isContentProvider;
    mapping (address => bool) isContentProviderDelegatee;   // allows less users to access possibly sensitive functions (a subset of the CPs functions and actions)
    mapping (address => bool) isContentConsumer;

    /* obsolete for now => I can't really say why I would choose one over the other option... 
    //to distinguish among the participants between our 3 types of participant (all users will be qualified based on tghe transactions conducted, implying 
    // some funds commitment - so that it is safe to assume they are Investor, or simple Consumer)
    struct UserType{
        address Investor;
        address ContentProvider;
        address ContentConsumer;
    }
    */

    //used to differentiate accounts linked to a specific RfC token so we can pool those funds together
    mapping (address => uint) accountRfCIdCommited;

    //output from the pooling funds function TBD:
    uint256 public investorTotalPooledFunds;    // defined only for 1 RfC for now (might rethink later the mechanics so the logic would be extended over different 
                                                // pools for a single investor - more capital efficient for each investor (like pooled txs, compounded rewards,
                                                // lower fees, etc.))

    //instantiation of the RfC contract to use it in relation to the fund management logic (rewards payment, splitted RfC payment calculation
    // and distribution, backing RfC with ERC20, etc.)
    RequestForContent public RfC;           // maybe call throuhgh an interface (making it easier to upgrade and callable by other contracts: 
                                            // IRequestForContent public immutable RfC)        DM me for details


    // Those three will enable a control over the feature accessed by our different type of users, both for use and security reasons:
    modifier isInvestor{
        require(isInvestor == false, "It requires a user being an 'investor' to make this transaction");
        _;
    }

    modifier isContentProvider{
        require(isContentProvider == false, "It requires a user to be a 'Content Provider' to make this transaction");
        _;
    }

    modifier isContentConsumer{
        require(isContentConsumer == false, "It requires a user to be a 'Content Consumer' to make this transaction");
        _;
    }

    //EVENTS
    //event WalletFundsApproved();
    
    event FundsReceived(address account);

    event AmountReceivedInEth(uint256 amount);

    event investorsFundsPooled(bool poolingSuccess, uint256 amount);
    
    //event CPsFundsPoooled();
    //event InvestorsFundsPooled(); => ether swapped for DAI, then deposited for cDAI

    event FundsSwappedToStablecoin(bool success);


    //constructor definition:


    /*
    //fallback and ..? functions
    //handle control on conditions for contract receiving the funds: only eth for now (and the usual != 0)
    function () external payable {
        revert();
    }
    */

    //>>>>Same, not sure I keep this direct call from any user on this contract...<<<<
    /// @notice a user can read the value of funds held by the contract (before they are put in the "management cycle")
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      // 2. Get the balance of the sender of this transaction
      return balances[msg.sender];
    }

    function getSpecificAccountBalance(address _account) public view returns(uint) {
        require(_user == isParticipant, "this account is not active in this protocol");
        return balances[_account];
    }

    //not necessary but added for clarity, get the contract FundsManager total balance (likely the one before cTokens and any fund used in RfC being processed):
    function getContractBalance() public view returns(uint) {
        return balance(address(this));      // address(this) refers to the current contract address (instance deployed)
    }


    //TBD: commit scheme to signal interest and intensity of this interest for a RfC by investors

    //1. sent funds contract receiving function (the 'commit event' in cases of investors and CPs):

    //Think how to write this logic in a more readable way - think as the user => so write a function for the different types of txs a user could do (among ur diff types of users):

    //tx for user to become investor on a specific content request (pb: avoiding that only one user would be the investor in one RfC). 
    // I think it leads to use several steps instead of one (deposit money):
        //
    function 

    function receiveFunds(address _from, uint _amount) public payable {
        //1st function to handle every deposit = before any user's classification, or any swap or tapping in any yield protocol.
        // Simple purpose: receive safely any deposit, and having it ready to be usable (pulled by other more advanced functions)
        userHaveFundsDeposited[msg.sender] = true;
        emit FundsReceived(msg.sender);
        emit AmountReceivedInEth(msg.value);

        /*
        Logic that allows to distinguish between users eventually, but first between the type of transaction asked (all tx return a message to the user for 
        their confirmation so they know what type of tx they commit to):
            (- commit for RfC proposal (-> user gets type investor = not really, particpant is making a proposal, should be kept separately);)
            - CPs answer with a quote (through the reverse auctions = cf. VoteAndDelegate contract where it is defined - first to accept an amount is winning
                the RfC "binding agreement" (in code)) => once winner commit a substantial amount of ether, isContentProvider = true;
            - investors have 2 to 14 days to fund entirely the RfC and this one to be minted;
                => commmit for RfC acceptation (instead of voting, it is a "ready_to_stake scheme", or staging for commit to invest directly in a specific RfC ->
                user gets type investor);
                => accepting more investors once passed the fund amount agreement, as those funds compound yield will be used as an insurance sort of special fund;
                    => get them smaller shares on the future content (but same redeeming policy in case content is not delivered)   
            - minting the RfC ERC1155 token (-> user gets type investor) => users' funds allocated get the investor's status (isInvestor);
            - commit for being responsible for the content creation (-> user gets type Content Provider - 1st agree on time to deliver, type/medium of content at
                delivery, storage requirement of the content => it defines on what specifics the slashing/punishment will happen for the CP if they don't 
                respect one of the following components/requirements of the request);
            - commit to handle a subset of the RfC components and requirements attached (-> user gets type Content Provider delegartee/sub-contractor );
        */

    } 

    //POOLING FUNDS HAS TO BE DONE FOR EACH AND EVERY RfC (so the logic apply sperately and the different outcomes can be processed independently)
    //  => ideally, no. You'll have a dynamic NFT that tracks those different positions across several RfC, and allows for higher and more gas efficient
    //  compounded interest rate
    function poolingFunds(RfC _RfCId) internal returns() {};

    //2. swap (all) pooled funds for stablecoin, that has to be supported by Compound atm (for investors and CPs use case - except all cases where instant payment can take place, so no need for swap 
    //  and gas price to happen ) once an RfC is tokenized/minted (adding a modifier RfCTokenMinted()):
        // The question of a protocol native stablecoin is still TBD in the next developments, as it has its rationale, but adds too much complexity rn
    function swapToStablecoin(
        //uint256 _ether,       //to be swapped for (reduced to eth => control only eth can be sent to the contract to avoid loss of funds and stay simple so far)
        uint256 _ethAmount, 
        uint _pooledFundsId/* not sure how to implement the pool yet*/
        ) 
        internal returns(uint amountDAI) {

            //TO DO

            //call to Uniswap contract? Check if there is a way to do it all in Compound
            require(
            _ether.balanceOf(address(this)) >= _ethAmount,
            "Core: Not enough ether, or simply wrong currency. We take only ether for now"
            );
            
            if (msg.value > 0) {
                convertEthToExactDAI(paymentAmountInDai);
            } else {
                require(daiToken.transferFrom(msg.sender, address(this), swapEthAmountInDAI));
            }

            //then deposit in Compound:

            //(for local tests - just a simple quotation based on a fixed ether price and only ETH -> DAI)

            //event emitted on successful swap
            emit StablecoinswapSuccess();

            //pooled capital state updated to reflect the "frozen value"/stablecoin value

            //return this value and the address of the instantiated cToken for this pool
        }
    
    //function using Uniswapv3 to swap Eth payment (by investors and CPs) to DAI:
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


    //3. Call to compound contract to deposit stablecoin and earn on it - which returns cTokens, kept under escrow by this contract 
    //  Take a closer look at the Compound.js wrappers to see if you can do it in the most simple way.
    //      => https://github.com/compound-finance/compound-js
    //          => See in particular: https://compound.finance/docs/compound-js#cToken
    // OR use the Compound (lower-level) API: https://compound.finance/docs/api
    // Also see the Consensys demo github repo: https://github.com/ajb413/consensys-academy-compound-js
    // cf. also FEI Compound call/PCVdeposit contract code

    //4. Call to/from RfC contract to makes those pooled cTokens part of the RfC token (maybe using the ownable token interface in proposition state)
         

    //user-investors bonds data
    function manageInvestorsFunds(address _sender, uint256 _amount) external payable isInvestor returns() {
        //metadata recording to facilitate the management of the funds of the user-investors,
        // and the tracking of the investors position through an NFT minted
        timeOfDeposit = time.?;
        ...


    };

    //CPs bonds-like data to mint one from the RfC contract
    function manageCPsFunds(address _sender, uint256 _amount) external payable isContentProvider returns() {
        //specific metadata reagrding the deposit so the fund management automation can be done properly, 
        // and the tracking of the CP position through an NFT minted



    };

    //5. mint content NFT or access to content NFT for the investors + shares on content earned by the investors (tracked through same mechanism as 
    //  Uniswap LPs share NFT mechanism) granted because of their contribution

    //  (a second function - might also encoded in the same function - regards
    //  providing acces to any users => likely separately so you implement the flow for a user to access content (simple payment, access token (NFT)
    //  and distribution of the payment between investors shares on this content, CP(s) involved in the content production, and fees for the actual
    //  platform(s) hosting the content (filecoin/IPFS, LivePeer, etc.))) 

    //5.1  if content delivered successfully:

    // 5.1 PooledFunds under cToken contract are swapped for Eth: cDAI -> DAI -> ETH swap before withdraw
    
    // Once contract gets Eth back, withdraw and payments functions
    function withdrawInvestors() external {

    }

     

    //5.1.2. CPs payment once content minted and accessed by investors + get some of the yield gained through cTokens with which they can 
    //  tune up a bit their business model (perks for investors, perks for future users accessing the content, etc. => a limited /contrained and 
    //  trustless amount of options proposed through their web UI/dashboard)
    function payCPs(uint256 _amountFundsXyield, address CPaddr) internal returns(bool successPayment) {

        //Calculate CP payment (cf. what you already defined to foactor in that calculation)

        //One CP payment once content is delivered

        //Case of a part or all content delivery **delegated** by the CP who first commited for RfC mint  
        // TO DO for next iteration

    };

    // 5.2 If the RfC is not delivered or accepted:

    

    // 5.2.2 Slash a part of the CPs capital commited to this contract

    /*
        >>>>>
            LAST IMPORTANT PIECE OF YOUR 1ST ITERATION -- NOW thought to be implemented after 1st iteration 
            (cf. FEI Protocol implementation, particularly relative complexity brought with
            the execution control/contracts calls management necessary for the PCV to act through a 
            authorization for a main contract acting as the PCV through modifiers):
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