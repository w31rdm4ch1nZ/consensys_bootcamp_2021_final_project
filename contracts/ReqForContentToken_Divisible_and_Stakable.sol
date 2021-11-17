/*

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