// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "@openzeppelin/contracts/token/ERC1155/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155Burnable.sol";

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

contract RequestForContent is ERC1155, Initializable, ERC1155Upgradeable, /*OwnableUpgradeable,*/ ERC1155SupplyUpgradeable, UUPSUpgradeable {          

    //Each type of content is linked to one or several protocols (Filecoin, Audius, LivePeer, etc.), each linked 
    //to a certain collateral that will allow the payment of the fees to become the medium of the content 
        //  => can be implemented by a "simple" call to a swap contract, calling on Uniswap contract

    // Make sure choosing it to be a data structure enum is still dynamic - otherwise choose a different way to build this so it can be dynamic, maybe by using an index that can take in 
    // input some data from th UI frontend - through web3.js or so, in a way that can't be tampered with (if it is even possible without using a central server, and is using the security
    // model of ethereum smart contract).

    
    //        >>>>>>>>>>>>>>Following the openzeppelin wizard:<<<<<<<<<<<<<<<<<

    //I will have to redefine some of the roles

    // I prefer a role pattern with multi-sig accounts (that would evolve in theory towards some DAO councils-like owned roles)over the ownable pattern,
    // where too much power is given to an account or even a simple role. Also, as I mentioned, if I were to see this dapp to evolve, I'd like a fully-fledged
    // DAO-like governance (where needed), and so I see this role-based model as closer, hence easier to upgrade in the (hypotheticla) future of the dapp: 
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("FUNDSMANAGER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() initializer public {
        __ERC1155_init("");
        __Ownable_init();
        __ERC1155Supply_init();
        __UUPSUpgradeable_init();


    }

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

    //events
    /// @dev Emitted upon the successful preparation (its definition and acceptation by investors through their financial commitment, 
    ///         CP(s) comitting to delivery) of a Request for Content.
    /// @param RfCId The condition's ID. This ID may be derived from the other three parameters via ``keccak256(abi.encodePacked(oracle, questionId, outcomeSlotCount))``.
    //MIGHT BE REPLACED BY A VOTE RESULT OR AUTOMATED CONTROLS VALIDATED make that useless. Anyway an oracle won't be used as such in my use case. 
    //    [/// @param oracle The account assigned to report the result for the prepared condition.]
    //CHECK THAT LATER (what would it be in our case: rn, just wnat to define a bit better the actual mechanics of the RfC/ERC1155)    
    //    [/// @param questionId An identifier for the question to be answered by the oracle.]
    /// @param RfCComponentsCount The number of outcome slots which should be used for this condition. Must not exceed 256.
    event RfCValidation(
        bytes32 indexed RfCId,      // maybe no need of this extra-complexity there: just use a simple uint id to refer to a RfC token, and then use your enums
                                    // to build an array of enums (or a struct using the enums defined) that represents the RfC in its simple structured info,
                                    // than can be then used to define a set of simple requirements (eg. must be a content streamed on Livepeer, etc.) 
        //address indexed oracle,
        bytes32 indexed RfCDefinitionId,
        uint RfCComponentsCount
    );

    event RfCDeliveryEvaluationOutcome(
        bytes32 indexed RfCId,
        //address indexed oracle,
        bytes32 indexed RfCDefinitionId,
        uint RfCComponentsCount,
        uint[] payoutNumerators
    );

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
        contentAccessForEveryone
    }


    //>>>>>>Request for Content tokenization definition - check the way Gnosis tokenizes its "rich-logic/data tokens":<<<<<<<<\\


    //mandatory
    enum ContentTypeDelivered {
        NFT,
        LiveStream,
        Video,
        Audio,
        Article,
        Software,
        undefined               // => just used to disqualified a proposal before it reaches the proposal round (there will be also a grey/uncliclable 
                                // are as long as the proposal don't include this mandatory field)
    }
        // => result which could be passed in a tx from the frontend would be a value that triggers a certain call among the ERC1155 functions:
        //  _mint() / etc.

    //optional
    enum subContentTypeFileFormats {
        EthBlockTx,
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
        css
        html
        javascript,
        typescript,
        rust,
        WindowsExe,
        LinuxApp,
        dockerizedImage,
        undefined
    }
        // => result: add a component (that can be split later if necessary) to the RfC tokenized set of requirements

    //optional
    enum PlatformIntegrationAtDelivery {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        undefined
    }

    //mandatory
    enum StoragePlatformUsedToDeliverContent {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        AWS,
        Azure,
        ...,
        undefined
    }

    // optional
    enum dataRetrievedAPIToBeUsed {
        Google,
        GoogleMap,
        TheGraph,
        ...,
        undefined
    }

    //mandatory => define further and more clearly the use of this choice of collateral => and maybe it will require more fields if it 
    // has to be decided for several uses in the protocol
    enum Collateral {
        ETH,
        FIL,
        BTC,
        LVP,
        ...,
        USDT,
        UST,
        DAI
    } 

    // For the CPs time constraints AND maybe for instanting a time structure used in the FundsManagement contract (but that might just be defined in it) => both will be presented 
    // in the web fronted so the users can agree on it (when user's choice is required - for Pendle and Compound, it might be irrelevant)
    struct timeForDelivery {
        // Like for a bond expiration date, those data are then used in both RfC delivery date constraint, and likely the data structure
        // will be instantiated separately for the use in Pendle mechanics
        hours nbHoursToDelivery,
        days nbDaysToDelivery,
        years nbYearsToDelivery,
    }


    //then read (sequentially in memory) the struct so you can add (or not) those elements to the final RfC token: 
    struct Proofs {
        //in case users want to define a specific 
        string ProofOfSpace,
        string ProofOfExistence,
        //in case users want a content originating from a specific geo-location:
        string ProofOfLocation,
        string ProofOfAuthenticity,
        string ProofOfUniqueness,
        //in case users want some specific entity/organization/individual to be part of the content production:
        string ProofOfParticipation
    }


    //in memory, at execution time in EVM instantiation of the RfC as a struct of array (?)

    //The RfC struct, leading to the set of components and properties to be eventually tokenized as representing the request for content
    struct RequestForContent {
        //Define 1st the "mandatory" fields (for the RfC to even be considered to be proposed )
        ContentType[] contentTypes;
        Platform[] platforms;
        dataRetrivedAPIToBeUSed[] APIs;
        Collateral[] RfCCollateral;
        ...;
        Properties[] RfCProperties
    }

    //read function of te struct to extract offsets for properties, and metadata to be used, like length, etc.
    function readRfCStruct(RequestForContent RfC) internal returns(int256 length, uint256[] proertiesOffsets, ..?) {
        //TO DO
    }

    

    //Define some mandatory fields for a RfC to be minted

    //Set a RfC structure (built with inputs from the Proposer) to enter the proposal to CPs cycle will require from investors to commit funds/send funds to the escrow 
    // contract

    //RfC struct has to pass some basic conditions: 
    // length != null
    // length > 0 
    // components <= 256 (check if data type like struct can have more elements??)
    // controls on the mandatory fields (to be defined in your contract - eg. at least one contentType, etc.) 

    function setRfC(RequestForContent RfC, bool isFinalized, int256 fundsPooledInvestorsAmount, uint256 fundsPooledCPsAmount) external returns() {};
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
    function collaterlizedRfCAtMinting() internal returns() {
        //TO DO
    };

    function reportRfCPayouts() external {
        //TO DO
    }

    /// @dev This function splits RfC in the case a subset of the required components are to be delegated among several CPs. (I will limit for now the use case to that)
    //    REWORK for your RfC instead [/// @dev This function splits a position. If splitting from the collateral, this contract will attempt to transfer `amount` collateral from the message sender to itself. Otherwise, this contract will burn `amount` stake held by the message sender in the position being split worth of EIP 1155 tokens. Regardless, if successful, `amount` stake will be minted in the split target positions. If any of the transfers, mints, or burns fail, the transaction will revert. The transaction will also revert if the given partition is trivial, invalid, or refers to more slots than the condition is prepared with.]

    /// @param RfCcollateralToken The address of the positions' backing collateral token.
    /// @param partition An array of disjoint index sets representing a nontrivial partition of the outcome slots of the given condition. E.g. A|B and C but not A|B and B|C (is not disjoint). Each element's a number which, together with the condition, represents the outcome collection. E.g. 0b110 is A|B, 0b010 is B, etc. 
    ///         => adapt it to your
    /// @param amount The amount of collateral or stake to split.
    function splitRfC(
        IERC721 setOfTasksDelegated,
        uint calldata RfCId,
        IERC20 RfCcollateralizedToken,
        uint[] calldata partition,
        uint amount
    ) internal returns() {
        //TO DO
        
        /*split pattern: mandatory fields (1st token) / offset -> property X = 2nd token / etc.
        // 
        // Minting those NFT-associated-to-"yes/no"-tokens where: 
        // 1/ we want to know in the end if it is included in the delivery
        // 2/ can be used (function can be called for this use case too) to coordinate/delegate several CPs on 1 RfC - in the case
        //      where several ContentType, PlatformIntegrationAtDelivery, ..., (any field having several members for the same element)
        //      that might require by ) are expected (tokenized in the RfC).
        // 3/ must correspond to a calculation on CPs slashing on rewards if not delivered (how do we come to an agreement on that?) )
        //      ==> let's agree that in the delivery content, the medium, the content format, accessibility, exactitude (ex: geolocation)
        //      will be valued more than the richness in properties. It does not mean "a lot" more, so a ratio that 
        //      >>>***captures some intuitive "successful in delivery AND having a quality that we might expect 
        //      given the RfC **and its future cunsumption**"***<<< [[[THIS WOULD BECOME A WHOLE TOPIC IN ITSELF TO RESEARCH TO MAKE THIS PROTOCOL ACTUALLY
                WORK IN THE WILD... a bit like the work Gnosis team made to come up with Conditional Tokens for predictive markets I'm guessing]]]
                    => I think that is it: if I manage to define in a satisfactory way the intended future consumption of the content,
                    I will have some better pre-agreement on the content "quality".

                    BUT, that being said, I have to add a round of possible complaints by users for a delivery that does not fulfill the
                    intended content in a significant way - although if I manage to define in a satisfactory way a Request for Content pattern,
                    I will not need this (overhead and un/de-coordinated behavior - very difficult it seems to get afterwards except by 
                    very costly outcomes like "redo or cancel"...).
        */

        // with the parameters, mint() subsets of tokens as other ERC1155 that represents CPs RfC new positions and ERC20 staked/commited new positions.
    }

    function mergeEl() internal returns() {  // might be called in 2 instances:
        //TO DO
                                                    // 2/ contentQuality not passed (investors vote - simple mechanism, same
                                                    // as below) and investors still want to commit w/o the cost incurred by a
                                                    // new RfC whole cycle (including gaining on the Yield compounded that  
                                                    // would be lost if reset to the very beginning)
                                                    // 1/ contentEnrichment (means adding an investors **voting phase** 
                                                    //      between contentDelivered and contentAccepted 
                                                    //      => think of an easy way to implement it )
                                                    // 
    }

    //for readability and clarity (in function call for instance), separate the function below from the one adding new elements:
    function addNewElToRfC() internal returns () {
        //TO DO
    }

}
