// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "@openzeppelin/contracts/token/ERC1155/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Burnable.sol";

/** 
    TO DO
    Out of the RfCProposalNFT (called by the content orchestrator) is minted the final RfC,
    which is the same as the RfCProposalNFT, but with enriched content (all data pertaining
    to the CP (address, amount, ...), the actual total funds once all investors send it during
    the funding/approval round).
**/


//**the upgradable pattern** is chosen in the event of a real dapp evolution, as I would like a beta to be available to the public, 
// but also that they keep their access to the contents and the shares on those contents produced in the beta phase, w/o a cumbersome 
// upgrade and migration at their gas cost, and implying operations from those users that might be challenging for some. 

// Once validated (cf. conditions for an RfC to be validated - already defind in your notes):
// Mint an ERC155 allowing to keep track of those multiple tokens multiple positions:
//  - Mint an NFT of the RfC
//  - At the same time, mint the ERC20s / pooled funds associated to the RfC (and redeemable by the different participants in
//      different ways)
//  - Splitted RfC if it happens
//  - ...

contract RequestForContent is ERC1155/*, Initializable, ERC1155Upgradeable, OwnableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable*/ {          

    //Each type of content is linked to one or several protocols (Filecoin, Audius, LivePeer, etc.), each linked 
    //to a certain collateral that will allow the payment of the fees to become the medium of the content 
        //  => can be implemented by a "simple" call to a swap contract, calling on Uniswap contract

    // Make sure choosing it to be a data structure enum is still dynamic - otherwise choose a different way to build this so it can be dynamic, maybe by using an index that can take in 
    // input some data from th UI frontend - through web3.js or so, in a way that can't be tampered with (if it is even possible without using a central server, and is using the security
    // model of ethereum smart contract).

    uint256 public RfCid;

    uint256 private fundsPooledForRfC;  // should be set after mint...? (because unknown at proposal)

    uint256 public allocatedBudgetForPC; // see if you tokenize this (probably)

    mapping (address => mapping(address => uint256)) public trackFundsUseByCP; // see if doable in a simple way for now

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /*
            >>>>
                ALL THE FOLLOWING POSSIBLE COMPONENTS ARE DISPLAYED TO USERS 
                THROUGH A WEB LIST THAT THEY CAN SELECT - FOR THE ONES MAKING A RfC
                PROPOSALS
            <<<<< 
    */

    //  >>>>> What follows is for a more complex implementation inspired from Gnosis Conditional Token Framework: reevaluate nxt iteration <<<<<<
    //events
    /// @dev Emitted upon the successful preparation (its definition and acceptation by investors through their financial commitment, 
    ///         CP(s) comitting to delivery) of a Request for Content.
    /// @param RfCId The condition's ID. This ID may be derived from the other three parameters via ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``.
    //MIGHT BE REPLACED BY A VOTE RESULT OR AUTOMATED CONTROLS VALIDATED make that useless. Anyway an oracle won't be used as such in my use case. 
    //    [/// @param oracle The account assigned to report the result for the prepared condition.]
    //CHECK THAT LATER (what would it be in our case: rn, just wnat to define a bit better the actual mechanics of the RfC/ERC1155)    
    //    [/// @param questionId An identifier for the question to be answered by the oracle.]
    /// @param RfCComponentsCount The number of outcome slots which should be used for this condition. Must not exceed 256.
    // event RfCValidation(
    //     bytes32 indexed RfCId,      // maybe no need of this extra-complexity there: just use a simple uint id to refer to a RfC token, and then use your enums
    //                                 // to build an array of enums (or a struct using the enums defined) that represents the RfC in its simple structured info,
    //                                 // than can be then used to define a set of simple requirements (eg. must be a content streamed on Livepeer, etc.) 
    //     //address indexed oracle,
    //     bytes32 indexed RfCDefinitionId,
    //     uint RfCComponentsCount
    // );

    // event RfCDeliveryEvaluationOutcome(
    //     bytes32 indexed RfCId,
    //     //address indexed oracle,
    //     bytes32 indexed RfCDefinitionId,
    //     uint RfCComponentsCount,
    //     uint[] payoutNumerators
    // );

    /**
    *
    *   
    *   REQUEST FOR CONTENT ELEMENTS OF DEFINITION => just a sketch at this step 
    *   (will include on-chain Proofs, etc. to increase trustless aspect, and decrease ways for CPs to cheat, 
    *   or anticipate on most possible disagreements)
    *
    * 
    **/

    //(Phases/Cycles/Steps/)**Components that can translated *unambiguously* in a requirement** for the Content delivery:

    enum DeliveryStatus {
        investorsVote,
        cancelled,  //can happen at several stage on a mechanism of coordination between investors (that you might not implement
                    // for this iteration)
        mintedRfC,
        CPsProposition,
        contentInProduction, // pendingDelivery (?)
        contentDelivered,
        qualityEvaluation,  // not sure I will implement any mechanism fo that at this point   
        contentAccepted,    //triggers the CP(s) payment
        contentRefusedAsIs, // starts a new proposition for CP(s) (either calling the function "contentEnrichment()", or resets
                            // to CPsProposition step (it avoids cost of new minting and the cost of the compounded Yield assotiated 
                            // operations))
        contentAccessibleByInvestors,
        contentAccessForEveryone,
        //...,
        unknown
    }

    DeliveryStatus RfCRoundStatus;

    //>>>>>>Request for Content tokenization definition - check the way Gnosis tokenizes its "rich-logic/data tokens":<<<<<<<<\\


    //mandatory
    enum When {
        Live,
        Stored,
        Archived
    }

    When when;

    enum ContentMediumDelivered {
        NFT,
        Stream,
        Video,
        Audio,
        Article,
        Software,
        //...,
        undefined               // => just used to disqualified a proposal before it reaches the proposal round (there will be also a grey/uncliclable 
                                // are as long as the proposal don't include this mandatory field)
    }

    ContentTypeDelivered contentMedium;

        // => result which could be passed in a tx from the frontend would be a value that triggers a certain call among the ERC1155 functions:
        //  _mint(), and with more time (TO DO), more complex integrations like call to mint an NFT of a LivePeer video feed, etc.

    //optional for definition from the user and the minting of an RfC(not for the CP)
    enum ContentDigitalFileFormats {
        EthBlock,
        EthTx,
        jpg,
        gif,
        raw,
        svg,
        mp4,
        mp3,
        ogg,
        txt,
        pdf,
        latex,
        css,
        html,
        javascript,
        typescript,
        rust,
        WindowsExe,
        LinuxApp,
        dockerizedImage,
        //...,
        undefined
    }
        // => result: add a component (that can be split later if necessary) to the RfC tokenized set of requirements
    ContentDigitalFileFormats fileFormat;

    //optional
    enum PlatformCompatibilityAtDelivery {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        //...,
        undefined
    }

    PlatformCompatibilityAtDelivery integratedTo;    

    //mandatory
    enum StoragePlatformUsedToDeliverContent {
        EthBlocks,
        IPFS,
        Arweave,
        Siacoin,
        OpenSea,
        LivePeer,
        Audius,
        AWS,
        Azure,
        //...,
        undefined
    }

    StoragePlatformUsedToDeliverContent storageSolution;

    // optional => can be forgotten for the purpose of this final project (just an exemple of how multiple use cases could be integrated in the protocol)
    enum dataAPIToBeUsed {
        Google,
        GoogleMap,
        TheGraph,
        //...,
        undefined
    }

    dataAPIToBeUsed apiUsed;

    //mandatory => define further and more clearly the use of this choice of collateral => and maybe it will require more fields if it 
    // has to be decided for several uses in the protocol
    enum ContentIsRedeemableFor {
        ETH,
        WETH,
        wFIL,
        WBTC,
        LVP,
        //...,
        USDT,
        wUST,
        DAI,
        DecentralandIsland,
        SandboxSpace
    } 

    ContentIsRedeemableFor contentRedeemableFor; 

    // For the CPs time constraints AND maybe for instanting a time structure used in the FundsManagement contract (but that might just be defined in it) => both will be presented 
    // in the web fronted so the users can agree on it (when user's choice is required - for Pendle and Compound, it might be irrelevant)
    uint256 public timeForDelivery;
    // Like for a bond expiration date, those data are then used in both RfC delivery date constraint, and likely the data structure
    // will be instantiated separately for the use in Pendle mechanics


    /*
    >>>>>>Likely part of the next iteration
    
    //then read (sequentially in memory) the struct so you can add (or not) those elements to the final RfC token: 
    struct Proofs {
        //in case users want to define a specific 
        bytes ProofOfSpace,
        bytes ProofOfExistence, //cf. your shell contract to have a better idea of how to implement those controls 
        //in case users want a content originating from a specific geo-location:
        bytes ProofOfLocation,
        bytes ProofOfAuthenticity,
        bytes ProofOfUniqueness,
        //in case users want some specific entity/organization/individual to be part of the content production:
        bytes ProofOfParticipation
    }
    <<<<<<<<
    */

    //in memory, at execution time in EVM instantiation of the RfC as a struct of array (?)

    // Set arrays with values from enums passed (and checked for validity) from web3/MM tx 
    //The RfC struct, leading to the set of components and properties to be eventually tokenized as representing the request for content
    
    struct RequestForContent {
        //Define 1st the "mandatory" fields (for the RfC to even be considered to be proposed )
        // set arrays with possibly several values of one enum
        string[] contentTimeRequirements;
        string[] media;
        string[] storageSolutions;
        string[] fileFormats;
        string[] contentIntegrations;
        string[] redeemableFor;
        //...;
        //Properties[] RfCProperties;
    }

    //read function of te struct to extract offsets for properties, and metadata to be used, like length, etc.
    // function readRfCStruct(RequestForContent RfC) internal returns(int256 length, uint256[] proertiesOffsets, ..?) {
    //     //TO DO
    // }

    

    //Define some mandatory fields for a RfC to be minted

    //Set a RfC structure (built with inputs from the Proposer) to enter the proposal to CPs cycle will require from investors to commit funds/send funds to the escrow 
    // contract

    //RfC struct has to pass some basic conditions: 
    // length != null
    // length > 0 
    // components <= 256 (check if data type like struct can have more elements??)
    // controls on the mandatory fields (to be defined in your contract - eg. at least one contentType, etc.) 

    function setEnums(uint256 _data) internal {
        // Find a way (simpler) than with offsets in bytes, but if necessary... do it
        //contentTimeRequirements = ...; 
    }

    function setRfCForMint() internal returns (RequestForContent RfC) {
        // set struct with the values set in setEnums:
        RequestForContent.When = _when;
        RequestForContent.ContentTypeDelivered = _contentType;
        //...
    } 

        // =>>>>> USE THIS struct states to avoid 2 mints and keep this track state during the CP silent auction

    // Then, once CP selected, mint it (wit the info like fundsAllocated, etc. that allow to leverage ERC1155 possibilities):
    function setRfCReadyForMint(RequestForContent RfC, bool isFunded, int256 fundsPooledInvestorsAmount, uint256 fundsPooledCPsAmount) external returns() {};
        //TO DO

        //NFT minted, incorporating the possibilities to be then splitted (as for Gnosis Conditional Tokens)
    }

    //Following ERC1155 standard:
    //minting the RfC => calls to ERC1155 contracts/interfaces (import them)
    function mintRfC() external {
        //To do in order to check that the data from the transaction coming are in the set of RfC valid inputs => loop through the enum (or
        //  anything more efficient/involving less computation ops...)

        _mint(address toRfCEscrow, uint256 RfCId, int256 )

    }

    //called in mint function (probably?)
    function collaterlizedRfCMint() internal returns() {
        //TO DO
    };

    function reportRfCPayouts() external {
        //TO DO
    }

    // QUESTION: in FundsManager contract or here??
    //comparable to the split function in the Gnosis Conditional Token contract:
    function burnSharesNFTforERC20(address _contentCreationOG, uint256 _contentPrice, ) external returns(bool success) {
        //TO DO: allow investors to sell their shares for some ERC20 stablecoin(DAI)/Eth

    }

    // Lkely not to be implemented in this iteration
    //for readability and clarity (in function call for instance), separate the function below from the one adding new elements:
    function addNewElToRfC() internal returns () {
        //TO DO: enrich an existing RfC by adding richer content/properties (eg. might be interesting if it is a software or an investigative article)
    }

    /// @dev This function splits RfC in the case a subset of the required components are to be delegated among several CPs. (I will limit for now the use case to that)
    //    REWORK for your RfC instead [/// @dev This function splits a position. If splitting from the collateral, this contract will attempt to transfer `amount` collateral from the message sender to itself. Otherwise, this contract will burn `amount` stake held by the message sender in the position being split worth of EIP 1155 tokens. Regardless, if successful, `amount` stake will be minted in the split target positions. If any of the transfers, mints, or burns fail, the transaction will revert. The transaction will also revert if the given partition is trivial, invalid, or refers to more slots than the condition is prepared with.]

    /// @param RfCcollateralToken The address of the positions' backing collateral token.
    /// @param partition An array of disjoint index sets representing a nontrivial partition of the outcome slots of the given condition. E.g. A|B and C but not A|B and B|C (is not disjoint). Each element's a number which, together with the condition, represents the outcome collection. E.g. 0b110 is A|B, 0b010 is B, etc. 
    ///         => adapt it to your
    /// @param amount The amount of collateral or stake to split.
    
    /*>>>>>>>ALSO, it is used for a content's share AMM<<<<<<<<,
            starting with burning the NFT, representing shares on content, for ERC20 tokens
            that are withdrawn from the protocol treasury to get stablecoin, proportional to
            the amount a content is currently priced + fees received by investors
            (weighted on a future fees/expected revenue that accrue a bit more the
            content price but not linearly, as passed a certain point it is entirely dependent 
            on exogenous market dynamics, eg. valuation of the content platform (like Livepeer)
            instead of minting it from thin air as a native token - although in-between could be 
            explored later on, depending on an analysis of the value creation by the protocol 
            and the content brought to life through the use of this protocol).
    <<<<<<<*/
    

    /** 
    *
    *
    *   >>>>Too complex rn, for nxt iterations<<< 
    *
    *
    **/

    // function splitRfC(
    //     IERC721 setOfTasksDelegated,
    //     uint calldata RfCId,
    //     IERC20 RfCcollateralizedToken,
    //     uint[] calldata partition,
    //     uint amount
    // ) internal returns() {
    //     //TO DO
        
    //     /*split pattern: mandatory fields (1st token) / offset -> property X = 2nd token / etc.
    //     // 
    //     // Minting those NFT-associated-to-"yes/no"-tokens where: 
    //     // 1/ we want to know in the end if it is included in the delivery
    //     // 2/ can be used (function can be called for this use case too) to coordinate/delegate several CPs on 1 RfC - in the case
    //     //      where several ContentType, PlatformIntegrationAtDelivery, ..., (any field having several members for the same element)
    //     //      that might require by ) are expected (tokenized in the RfC).
    //     // 3/ must correspond to a calculation on CPs slashing on rewards if not delivered (how do we come to an agreement on that?) )
    //     //      ==> let's agree that in the delivery content, the medium, the content format, accessibility, exactitude (ex: geolocation)
    //     //      will be valued more than the richness in properties. It does not mean "a lot" more, so a ratio that 
    //     //      >>>***captures some intuitive "successful in delivery AND having a quality that we might expect 
    //     //      given the RfC **and its future cunsumption**"***<<< [[[THIS WOULD BECOME A WHOLE TOPIC IN ITSELF TO RESEARCH TO MAKE THIS PROTOCOL ACTUALLY
    //             WORK IN THE WILD... a bit like the work Gnosis team made to come up with Conditional Tokens for predictive markets I'm guessing]]]
    //                 => I think that is it: if I manage to define in a satisfactory way the intended future consumption of the content,
    //                 I will have some better pre-agreement on the content "quality".

    //                 BUT, that being said, I have to add a round of possible complaints by users for a delivery that does not fulfill the
    //                 intended content in a significant way - although if I manage to define in a satisfactory way a Request for Content pattern,
    //                 I will not need this (overhead and un/de-coordinated behavior - very difficult it seems to get afterwards except by 
    //                 very costly outcomes like "redo or cancel"...).
    //     */

    //     // with the parameters, mint() subsets of tokens as other ERC1155 that represents CPs RfC new positions and ERC20 staked/commited new positions.
    // }

    // function mergeEl() internal returns() {  // might be called in 2 instances:
    //     //TO DO
    //                                                 // 2/ contentQuality not passed (investors vote - simple mechanism, same
    //                                                 // as below) and investors still want to commit w/o the cost incurred by a
    //                                                 // new RfC whole cycle (including gaining on the Yield compounded that  
    //                                                 // would be lost if reset to the very beginning)
    //                                                 // 1/ contentEnrichment (means adding an investors **voting phase** 
    //                                                 //      between contentDelivered and contentAccepted 
    //                                                 //      => think of an easy way to implement it )
    //                                                 // 
    // }



}
