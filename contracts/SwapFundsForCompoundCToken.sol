// SPDX-License-Identifier: GPL-3.0-only

/*

Likely to be integrated in the FundsManagement contract (maybe kept spearate for better modularity, upgradability and readability)?

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

*/

// Tests to be done with the Rinkeby Testnet contracts addresses of Comppound and Pendle (check for compatibility of testnets of both Pendle and Compound - 
// should be fine as Pendle is built on top of money markets as Compound and Aave)


//This contract could be an interface designed for our FundsManager contract to interact with Compound (interesting pattern thinking here
// it might indeed be easier to maintain as Compound and our Dapp core contract evolves (upgrades management)?).

//It also could handle the swap of a crypto-currency such as Ether for a stablecoin such as DAI or FEI.
contract SwapFundsForCTokens {
    //TO DO


}