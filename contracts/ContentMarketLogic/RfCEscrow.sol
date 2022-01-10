// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/** 

    This contract will receive all RfC tokens, holding them with 3 possible status (proposalOnly/sucessful/unsucessful).
    
    In the event of the will to inspect, resubmit to check factual content (crowdjournalism use case), add to an RfC some richer feature 
    that could build upon the previous RfC.

    Would only be accessible by a specific role, defined in AccessControl contract (using the open zeppelin AccessControlEnumerable.sol contract 
    pattern)


**/

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract RfCEscrow {

    //TO DO => next iteration, focusing on "crowdjournalism" use case (?)

}