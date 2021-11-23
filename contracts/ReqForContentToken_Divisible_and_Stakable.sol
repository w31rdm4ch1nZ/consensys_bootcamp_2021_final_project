/*

>>>>[[[[[11/23: IS NOW A MERGE OF BOTH ReqForContentToken_Divisible_and_Stakable.sol 
AND RequestForContent_CoreLogic_ERC1155.sol]]]]]<<<<<

For now, a placeholder for the logic intervening when the Content Delivery event outcome is evaluated:
    - yes/true tokens;
    - OR no/false tokens;
        => in the second case, user-investors can choose:
            - to claim back their funds + share on the slashed ratio from the CPs commited tokens in the Escrow contract + yield
            - compound for a new round of Request for Content, waiting for another CP(s) to answer and commit + mint token positions
                including funds + yield made on the previous round + their share on the slashed tokens from the prev CP(s) + **another
                incentive to think of so the request does not die because of a (bad) CP(s), unable to deliver**.
    - logic that allows to strip the RfC token 
    (based on its composition/structure RfC token minted composition: 
    RfC[0] = content medium, RfC[1] = bool statusFinalDelivery, RfC[2] (and >2) = Property2)
    and used to define the supply in ERC20 tokens for which the value accrues and consequently the supply (?) ( curve shape) with the first few elements
    (medium, deliveredStatus, properties 1-to-3)
        => Value added by the degree of completion of the RfC drops smoothely after the max spike at sucess (without this one it's like 0)
        + medium (potentially several more adding content richness which can significantly increase the value at this point and define a 
        "plateau" to which value starts) + at least the first 2 properties minted in the RfC (if numberProperties <= 2 , of course 
        it doesn't affect the value) contributes also to define the "plateau"/maintain the accruance in value by the highest multiplier, 
        then there is a smooth reduction of added value for each new property (with a ratio higher once numberProperties <= 4 
        and lower with the more properties there are in the RfC).


My RfC demands a ConditionalToken dedicated for the outcome being the successfull
 delivery of the content, or something very close.

I see in Gnosis vision exactly the framework in which the RfC can be tought of.

    "The conditional tokens framework sets a new standard for event-based digital assets with a wide variety of use cases, 
    from prediction markets to conditional bounty payments."

    "Through enabling conditional logic (“if this, then that”) for digital assets, the conditional tokens framework 
    can mint digital assets with value contingent on arbitrarily complex logic."

    "The Conditional Tokens Framework allows you to:

    - Make simple markets on the likelihood of a given event.
    - Make complex markets about how the likelihood of an event is affected by any other event.
    - Trade any asset under the condition that a specific event occurs."

    ==> It is the 3rd aspects tat we are leveraging in our use case. 


Here is a nice template from https://docs.gnosis.io/conditionaltokens/docs/ctftutorial03/ to have an idea
of how to build the RfC token:

 A condition can be thought of as a question that an oracle is expected to give an answer to in the future.

On the conditional tokens contract conditions are represented by three parameters.

1. An oracle: an Ethereum address that is expected to make a transaction to the conditional tokens in the future, reporting the result of a condition.
    => in my context, it would be likely the majority of user-investors reporting satisfaction, or not (or should it be left to a third participant, whose
    incentives are purposefully decorrelated from the content production and investment interaction - like a trader betting on the outcome(s), 
    one participant of a market that has nothing to do directly with the relation user-investors and CPs engage in, but would "bring truth" (play the role
    of an oracle, but on-chain, through the final settlement on the winners and losers on this trading activity?). Is it even possible to think of this de-correlation,
    are the collusions evitable??? - my 1st thought is no, so it should be settle by an automated, on-chain, smart contract encoded logic... [TBD])

2. A question ID: 32 bytes of data used to uniquely identify a question. Note that the contract has no knowledge of how to interpret the question ID, 
it is just used as an input for distinguishing different conditions. However, many front ends choose to interpret the question ID in very specific ways. 
For example, when they have a database where entries of the database may be identified by this question ID.
    => That would be the elements which will define the request (for content), its expected properties.

3. Outcome slots: A 256 bit unsigned integer that determines the different potential outcomes of this condition. 
Conditions can have between 2 and 256 outcome slots.
    => the complexity of a request taking so many slots is already looking as more than necessary.



Something that will be useful further for Conditional Tokens / RfC Tokens: 

    Bit arrays are exactly how they sound, they are just an array of bits. They are useful for indicating whether something is included in a set or not.
    We use bit arrays to indicate whether or not an outcome is part of a specific set of outcomes.

    One very efficient way to represent bit arrays is with unsigned integers, like so.

    0b001 == 1
    0b010 == 2
    0b011 == 3
    0b100 == 4
    0b101 == 5
    0b111 == 6

"Having discussed outcome collections and how to derive their IDs, we can now finally get to the concept called positions and their respective IDs.
Positions can simply be defined as an outcome collection together with a collateral token."

We can generate ERC20 tokens to be used as collateral. (in our case the collateral is made of the funds of the user-investors and the CPs committing to deliver).

"Use the getPositionID() function with the T1 token address and collection ID for (B|C) as parameters.
This position ID is also the ERC1155 ID that identifies the conditional token, or outcome token, that represents a stake in this position."

"Once we have these position IDs, we can finally start querying accounts for their respective stakes in positions or the amount of conditional tokens 
they may be holding. In order to do so, we may use ERC1155 method of balanceOf() or, if we are querying for multiple positions, balanceOfBatch().
Now that we can derive position IDs, let's use them to split some collateral into sets of conditional tokens."

"So let's learn how to create some conditional tokens!

Before we create any conditional tokens, we'll need some collateral.

Call the mint() function in each of your ToyToken contracts to mint some amount of tokens (say 1000) to your address.

Then we need to set approval for the conditional tokens contract to send your ToyTokens. Call the approve() function on each of your ToyToken contracts with the address of your conditional tokens contract and the amount of tokens that you minted.

Conditional tokens are created using the splitPosition() function, which takes the following parameters:

colleteralToken: the address of the collateral token.
parantCollectionId: the bytes32 ID of the parent collection. Since we're splitting from collateral, we set this to zero with 0x0000000000000000000000000000000000000000000000000000000000000000.
conditionId: the bytes32 ID of the condition that we'll be creating conditional tokens for.
partition: an array of outcome index sets that define how the outcome slots will be partitioned.
amount: the amount of collateral that will be split into conditional tokens."


>>>>>YOU MIGHT END UP USING MORE WHAT THEY MADE AS GENERALIZED AMM, because you can then have a Content Market that makes everyone "happy",
     as it allows U-Is and CPs to win a share on the content accessed by any user, and so we manage to de-correllate the subjective satisfaction
     of user-investors on a content leaving it to the market to create an acceptable value for them, or if there is not enough activity, then
     the outcome is considered to be "undelivered content" and the CPs punished.
     => vs. idea of *a vote* by the user-investors (U-Is) = TBD.

     In both case, a threshold must be defined that allows to encode it in the smart contracts so it is not up to someone (any third-party) to manage it. 
<<<<<<

"For the first condition you created (the one with three outcomes, A, B, and C), let's use the splitPosition() create two positions (A) and (B|C) using your 
first ToyToken as collateral.

The partion parameter in splitPosition() is the only one we haven't encountered yet. For this, we'll input an array of the index sets that we derived earlier. 
To split the collateral into positions (A) and (B|C), the array should be [1,6]. Remember the index set for (A) is 0x001 --> 1 and the index set for (B|C) is 0x110 --> 6.

You can check the balance of your positions using the balanceOf() or balanceOfBatch() functions, with your address and the positionIds of your positions as parameters.

Repeat these steps to create the same set of positions with your other ToyToken, and then repeat the steps to create the positions (lo) and (hi) in your second 
condition with each of your ToyTokens as collateral.

When you're done, you should have eight positions.

T1(A)
T1(B|C)
T2(A)
T2(B|C)
T1(lo)
T1(hi)
T2(lo)
T2(hi)
Call balanceOfBatch() on your conditional tokens contract to check the balances of each in one function call."


    ==> One thing to think hard about: you should redefine the logic of your Request for Content from the Logic of Conditional Tokens, not mimic it.
    It means that the propertire of the RfC token itself (not the ones describing the content and the requirements associated to the delivery of this content)
    should be taken into account and decide wha is the needed/required and likely the best way to implement it.
        => at this stage, "the needed" is enough. "The best" way to implement is not yet the current goal. (just to make simpler the design of this part and not
        spend too much time rn on this).

Another great element of the Contitional Token to learn from isgoing from their splitPosition() to the mergePosition() and understand the mechanics to distribute the stakes
according to the outcome market/predictive market. Doing so, think about your needs.

    "The splitPosition() function has a corresponding inverse called mergePosition() which does exactly what it sounds like, 
    merge equal amounts positions into their underlying collateral or positions."

*/

contract ProductProvider is IERC1155, ReentrencyGuard {          // The contract can call standard functions from the ERC-1155 (as I understand it so far)
    //Each type of content is linked to one or several protocols (Filecoin, Audius, LivePeer, etc.), each linked 
    //to a certain collateral that will allow the payment of the fees to become the medium of the content 
    // Make sure choosing it to be a data structure enum is still dynamic - otherwise choose a different way to build this so it can be dynamic, maybe by using an index that can take in 
    // input some data from th UI frontend - through web3.js or so, in a way that can't be tampered with (if it is even possible without using a central server, and is using the security
    // model of ethereum smart contract).



    //Phases/Cycles/Steps of the Content delivery:
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


    //Request for Content tokenization definition - check the way Gnosis tokenizes its "rich-logic/data tokens":



    enum ContentType {
        NFT,
        LiveStream,
        Video,
        Audio,
        Article,
        Software
    }

    enum PlatformIntegrationAtDelivery {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        ...,
        undefined
    }
    enum PlatformUsedToMintDeliverContent {
        OpenSea,
        LivePeer,
        Audius,
        Filecoin,
        Arweave,
        Siacoin,
        ...,
        undefined
    }

    enum dataRetrievedAPIToBeUsed {
        Google,
        GoogleMap,
        TheGraph,
        ...,
        undefined
    }

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
    struct RequestForContent(
        ContentType[] contentTypes,
        Platform[] platforms,
        dataRetrivedAPIToBeUSed[] APIs,
        Collateral[] RfCCollateral, 
        ...,
    )

    //read function of te struct to extract offsets for properties, and metadata to be used, like length, etc.
    function readRfCStruct(RequestForContent RfC) internal returns(int256 length, uint256[] proertiesOffsets, ..?) {
        //TO DO
    }

    //minting the RfC

    //Define some mandatory fields for a RfC to be minted

    //Mint of a RfC to enter the proposal to CPs cycle will require from investors to commit funds/send funds to the escrow 
    // contract

    //RfC struct has to pass some basic conditions: 
    // length != null
    // length > 0 
    // components <= 256 (check if data type like struct can have more elements??)
    // controls on the mandatory fields (to be defined in your contract - eg. at least one contentType, etc.) 

    function mintRfc(RequestForContent RfC, bool isFinalized, int256 fundsPooledInvestorsAmount, uint256 fundsPooledCPsAmount) external returns() {};
        //TO DO

        //NFT minted, incorporating the possibilities to be then splitted (as for Gnosis Conditional Tokens)
    }

    //called in mint function (probably?)
    function collaterlizedRfCAtMinting() internal returns() {
        //TO DO
    };

    //function splitRfC (to be called by mint function?)
    function splitRfC() internal returns() {
        //TO DO
        
        //split pattern: mandatory fields (1st token) / offset -> property X = 2nd token / etc.
        // 
        // Minting those NFT-associated-to-"yes/no"-tokens where: 
        // 1/ we want to know in the end if it is included in the delivery
        // 2/ can be used (function can be called for this use case too) to coordinate/delegate several CPs on 1 RfC
        // 3/ must correspond to a calculation on CPs slashing on rewards if not delivered (how do we come to an agreement on that?) )
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

    /*
        Coordination mechanism for Content Providers when several answer the RfC proposition:
          
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


    */
}
