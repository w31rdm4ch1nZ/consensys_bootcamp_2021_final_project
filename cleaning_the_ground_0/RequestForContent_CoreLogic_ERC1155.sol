// check https://exploringethereum.substack.com/p/gnosiss-conditional-tokens 
// for an intro to Conditional Tokens as the primitive for predictive markets

/*

    Another commonly cited use case is futarchy. The idea here is to use prediction markets as a decision mechanism in some organization. 
    In the context of Ethereum, this could be a DAO that makes some decisions only if some prediction market gives, say, an 80% chance 
    or more of that decision producing a certain benefit for the DAO.

    You could also use conditional tokens as a mechanism for paying someone. For example, Alice could create a prediction market 
    on “Will Bob complete the project Alice assigned him before the end of the year?”, split some amount of DAI in 
    the “Yes” and “No” outcomes, and pay him with the “Yes” tokens. (As always, we are assuming that the oracle reporting 
    the result is to be trusted.) This is not very different to depositing the payment in an smart contract 
    and using the oracle as an escrow. The difference is that Bob can do whatever he wants with those tokens. 
    For example, he can use them before the market is resolved, assuming the person receiving them thinks Bob 
    will complete his project and therefore considers they are worth 1 DAI. Or, if he wants, he could use them 
    at a discounted value with someone that is not so sure about the result.

    The core idea here is that you can tokenize a potential future outcome: anything that can be built on that idea can be done with conditional tokens.

        =>> in my case, both the fulfillment of the request for content and the payment for that future content production and delivery can be 
        trustlessly implemented through this mechanism (imo).


    https://gnosis.io/conditional-tokens/

        The conditional tokens framework sets a new standard for event-based digital assets with a wide variety of use cases, 
        from prediction markets to **conditional bounty payments**.
            ==>> "conditional bounty paynanents is actually close to what I am trying to achieve with the Content Providers and Tokenized Users Requests.

        Through enabling conditional logic (“if this, then that”) for digital assets, the conditional tokens framework 
        can mint digital assets with value contingent on arbitrarily complex logic. 

        The conditional tokens framework is oracle agonistic, meaning users can choose what information sources to rely 
        on for reporting the outcome of an event.


    https://docs.gnosis.io/conditionaltokens/docs/introduction1/

        Gnosis anticipates a tokenized future in which no single currency is dominant, and tradable asset classes 
        take on increasing informational complexity. Conditional tokens that enable prediction markets are one of these new asset classes.

        Example:
        Consider a simple future event. Suppose Yang and Trump are engaged in a political election. How do we construct a market with 
        economic incentives for correctly predicting the outcome?

        First, we lock some collateral (e.g. DAI) into a contract as collateral to mint conditional tokens. To then create the market 
        question Who will win the election?, we must define a collection of outcomes for the condition. In this case, there are two possible outcomes:

            a) Yang is elected
            b) Trump is elected.

        For each DAI committed to the market, market participants receive conditional tokens representing all potential outcomes. 
        The market contract holds the DAI tokens received as collateral until the outcome of the election is known.

        Each participant begins in a neutral position, with a set of all outcome token for each DAI locked as collateral. 
        That is, fungible “Yang is elected” and “Trump is elected” tokens are issued to each participant who puts collateral into the contract. 
        All “Yang is elected” tokens are fungible with other “Yang is elected” tokens. The “Trump is elected” tokens are materially different 
        from “Yang is elected” tokens. They are fungible with other “Trump is elected” tokens. After the outcome is known, the contract will 
        redeem each “correct” conditional token for the DAI held as collateral. The “incorrect” tokens are irredeemable.

        Key Takeaway
        This brings us to the central point of this section: trading conditional tokens is the same as predicting which outcome is more likely. 
        Suppose a participant believes Yang will be elected. They may sell their “Trump is elected” tokens at whatever price the market will bear, 
        and later redeem their “Yang is elected” tokens at “par” value when (and if) Yang is elected. Trading conditional tokens helps discover 
        the price of different opinions in a neutral way, as highly probable outcomes trade close to their redeemable par value, and highly 
        improbable outcomes naturally find their market price near zero.

        Other possible use cases
        Conditional tokens are >>>>***built on the ERC-1155 token standard***<<<<, which affords numerous advantages for their multiple use cases. 
        For instance, ERC-1155 batch sends substantially decrease gas costs for users, making them ideal within gaming environments 
        that encompass different tokens and high-velocity economies.

        The use case section explores how the conditional token standard can be used to improve existing decentralized applications (dapps). 
        In the tutorials section, you’ll find the tools and know-how needed to set up, inspect, and apply the conditional tokens framework 
        to your own projects—as well as some inspiration regarding other use cases for this new standard beyond prediction markets.

    https://docs.gnosis.io/conditionaltokens/docs/introduction3/#basic-amm-mechanics

        Basic AMM mechanics

        Essentially, an automated market maker (AMM) is just a market participant that's a bot that makes sure there are always 
        some outcome tokens for every outcome in its inventory and that there is always a price that can be offered for an outcome token. 
        As long as the AMM is active, traders can buy and sell outcome tokens for a prediction market, and the AMM will aggregate the trade 
        data to produce estimates for the odds of outcomes.

        Gnosis offers smart contract implementations of two automated market makers for prediction markets: the logarithmic market scoring 
        rule (LMSR) market maker, and the constant product market maker (CPMM). Both these market makers require funding to obtain the initial 
        outcome tokens required to start providing liquidity.

        The LMSR market maker, originally described by Robin Hanson, has a rich academic history. It is a market maker designed specifically 
        for the prediction market use case, and its properties have been well researched.

        The CPMM is a newer market maker using the same mechanism as Uniswap and Balancer pools. It is also known as the fixed product 
        market maker (FPMM) in Gnosis' codebase. It was originally designed for the more general use case of swapping tokens, 
        but has been tailored for the prediction market use case in the FixedProductMarketMaker contract.

        Both market makers can be described in terms of an invariant value kept between trades:

        For LMSR, the formula for the invariant is

        invariant = sum(numOutcomes^(-numOutcomeTokensInInventoryForOutcome / funding) for every outcome)
        For CPMM, the formula for the invariant is

        invariant = product(numOutcomeTokensInInventoryForOutcome for every outcome)
        This invariant value can be considered in the context of a constant function market maker.

        When traders buy an amount of an outcome token from an AMM, essentially the following steps occur:

        The trader sends the cost amount to the AMM.
        The AMM converts the cost amount received to a set of outcome tokens and adds the outcome tokens to its inventory. 
        The AMM's invariant expression is now broken.
        The AMM now sends enough of the demanded outcome token back to the trader so that the invariant is restored. 
        This is the amount of the demanded outcome token bought.
        Similarly, selling works as follows:

        The trader sends the sold amount of an outcome token to the AMM.
        The AMM adds the sold outcome token to its inventory. The AMM's invariant expression is now broken.
        The AMM converts an amount of the full set of outcome tokens back to collateral and sends this collateral back the trader 
        so that the invariant is restored. This amount is the sale price.
        Both AMMs can also estimate the odds of outcomes as well.

        The odds for an outcome with LMSR can be found with the formula:

        oddsForOutcome = numOutcomes^(-numOutcomeTokensInInventoryForOutcome / funding)
        The odds for an outcome with the CPMM can be found with the formula:

        oddsWeightForOutcome = product(numOutcomeTokensInInventoryForOtherOutcome for every otherOutcome)
        oddsForOutcome = oddsWeightForOutcome / sum(oddsWeightForOutcome for every outcome)
        An example with LMSR
        Let's return to Alice and Bob in Gotham. We will create and fund an LMSR market maker named CPU with $10. 
        CPU takes the funding and converts it into 10 Yes and 10 No for its own inventory. The initial odds estimate for the market is 50:50.

        Now let's say Alice buys $10 worth of Yes tokens from CPU:

        Alice sends $10 to CPU.
        CPU turns $10 into 10 Yes and 10 No tokens. CPU now has 20 Yes and 20 No tokens, and CPU's invariant is broken 
        (invariant should be 1, but now it is 1/2).
        CPU returns 15.84963 Yes tokens to Alice, restoring the invariant.
        At the end of this trade, CPU has 4.15037 Yes and 20 No tokens, and it estimates the odds of Yes are 75% and the odds of No are 25%.

        An example with CPMM
        Let's fund a CPMM named Digi with $10. Like CPU, Digi takes $10, converts it to 10 Yes and 10 No tokens, and adds them to its inventory.

        Now let's say Alice buys $10 worth of Yes tokens from Digi:

        Alice sends $10 to Digi.
        Digi turns $10 into 10 Yes and 10 No tokens. Digi has now 20 Yes and 20 No tokens, breaking its invariant (invariant should be 100, but now it's 400).
        Digi returns 15 Yes tokens to Alice, restoring the invariant.
        At the end of this trade, Digi has 5 Yes and 20 No tokens, and it estimates the odds of Yes are 80% and the odds of No are 20%.

        Differences between LMSR and CPMM

        LMSR and CPMM have a few differences, beyond the numerical differences from a different curve shape. 
        These differences manifest in pros and cons for each in application.

        LMSR Advantages:
        For one, LMSR has more recognition in academic work, and its properties are much more studied than CPMM. 
        It is easier to find papers on the properties of LMSR, or to leverage existing research on this market maker.

        LMSR breaks down into self-similar components when applied to combinatorial prediction markets. 
        Its analysis in those scenarios has been quite explored in the literature.

        Finally, the closed form expressions for buying and selling with the LMSR allow calculating a net cost for 
        a batch of buys and sells done simultaneously. The CPMM does not admit such an expression for the prediction 
        market use case, so buying and selling is limited on the contract to one outcome token at a time.

        CPMM Advantages:
        The arithmetic involved in the CPMM tends to be more elementary than the LMSR. There is no need to program 
        approximations of logarithms and exponentials with the CPMM.

        The CPMM can also be easily dynamically crowdfunded similar to Uniswap and Balancer pools. LMSR market
        makers cannot be easily crowdfunded dynamically though. The funding parameter of the LMSR (derived from a 'liquidity parameter' in the literature), has no elementary closed form depending on the outcome token amounts in an LMSR instance's inventory, even though this parameter is completely determined by the instance's inventory.
*/