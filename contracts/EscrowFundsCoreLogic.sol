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