/* 
1. Receive funds
 
2. Pools funds once a RfC has gone through the validation process, keeping track separately (2 mapping state variable probably)
    for user-investors and CPs.

3. Call Pendle functions to handle the pooled funds and use the mechanism for FutureYield tokens and their AMM. 
    => Swap it according to a logic linked to the inputs (check Pendle's ABI and the function's inputs accordingly):
      - "starting time of the deposit for yield of tokens", 
      - "time to maturity/redeem"
      - "amount"
      - "..."
 
4. Receive what Pendle returns under a tokenized form yet to be defined - by going through their doc and testing what you
    can do with their ABI.

5. - Tokens distribution Logic for User-investore in case of failing to deliver on teh CPs side
   - Symmetric Logic applying to the CPs commited = slashing a ratio of what they have commited.

6. - Token distribution Logic for the CPs when the outcome is "yes/true", that is the content was delivered.
   - Corresponding Logic with the funds escrowed by user-investors.

7. *[maybe for another iteration as it introduces new pbs/challenges linked to voting mechanisms and threat vectors for CPs against competing CPs, etc.]*
    In case of completion ("yes/true"), once the last round of distribution happened, the remaining CPs funds are to be 
    subject to a last round of satisfaction (vote signaling) by the user-investors 


*/

pragma solidity ^0.5.9;
//the abicoder-v2, to allow for arbitrary nested arrays and structs to be encoded and decoded in calldata. => to research.
pragma abicoder v2;


//import required by Pendle:
import './IPendleRouter.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';


contract ManageFunds {

    //variables


    //events


    //constructor


    //fallback and ..? functions


    //user-investors functions related to funds management
    function receiveInvestorsFunds(address _sender, uint256 _amount) external payable returns() {
        //metadata recording to facilitate the management of the funds of the user-investors,
        // and the tracking of the investors position through an NFT minted
        timeOfDeposit = time.?;
        ...


    };

    function receiveCPsFunds(address _sender, uint256 _amount) external payable returns() {
        //specific metadata reagrding the deposit so the fund management automation can be done properly, 
        // and the tracking of the CP position through an NFT minted



    };

    function poolingFunds() internal returns() {};

    //Pendle functions contract ABI calls - see docs (if the AMM is not worth it, maybe better to do it by yourself directly working with Compound or 
    // Aave tokens and tokenized future yields)
    /*
        SUPER IMPORTANT TO CONTINUE THAT ROAD, their contracts address on the Kovan testnet: 
        https://docs.pendle.finance/docs/addresses/kovan

        SDK reference to build on Pendle:
        https://docs.pendle.finance/docs/reference/intro

        ANOTHER IMPORTANT ASPECT for testing to work:
        As Pendle is reliant on other other DeFi protocols like Aave and Compound for their yield tokens, it is important 
        to have these protocols set up in your test environment during development. Hence, to avoid having to deploy 
        these protocols from scratch, and to best simulate mainnet conditions, we recommend using Hardhat's mainnet forking feature."

    */
    function callPendle

}