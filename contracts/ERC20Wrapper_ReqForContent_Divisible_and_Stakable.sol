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

*/