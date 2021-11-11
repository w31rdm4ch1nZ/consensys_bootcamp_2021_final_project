/*

- To mint yield tokens, in case I don't use Pendle and decide to implement it in a simple way for 1/ demonstrating my idea of its interest,
2/ understanding through first principles the mechanisms at play.

- To split and mint NFTs tokens keeping track of those states at any given time, as long as their funds are not redeemed/withdrawned:
    - a fixed rate given by the protocol to its users
    - a variable rate, meant to 1/ manage risks of the fixed rate not to be reached, and 2/ top up the fixed-rate with an excess capital
        that can then be reused for rewarding users (all of them) of the protocol.

    => Great case for Pendle is the AMM, as it should allow to redeem funds for funds + yield at any time (much greater flexibility).

*/