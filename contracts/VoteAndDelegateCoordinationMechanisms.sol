// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8;
/*

    >>>>Waiting for a full DAO tooling, the most simplistic vote implementation you can think of so it can
    work for the few rounds it is required.<<<<

    For staking inspiration, see: https://solidity-by-example.org/defi/staking-rewards/

*/

/*
contract Vote {
    //TO DO

    //

    //register voters addr
    function getAddr() public returns(address user) {
        //TO DO
    }

    //get/verify that account is among the addr that commits for a given RfC, either as an investor
    // or a CP:
    function verifiedAddrCommit() public returns(address userCommitted, UserType userType) {
        //TO DO
    }



}
*/

//Actual cimple vote implementation:
// https://www.toshblocks.com/solidity/complete-example-voting-ballot-smart-contract/


//(you now have to link it in some vote cases -adding a function- 
// to a staking position that will modify almost all parameters and variables, like weight, a read() 
// function in this contract on the FundsManager contract, etc. )

//check this contract for outdated coding patterns (like will you use "throw here"?)
pragma solidity ^0.8.0;

/// @title Voting with delegation and with weight possibly modified under certain conditions (through parameters taken from other contracts like FundsManager for the staked/commited/under escrow funds).
contract VoteAndDelegateCoordinationMechanisms {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // "This is a type for a single proposal" => That is actually normally where your RfC comes in...
    // It could be there that an *input is taken from the web UI frontend* and, after a transaction by the user submitting the input 
    // (avoiding massive spamming through this frontend), passed to a function that allows it to be listed on the frontend
    // and first proposed (before minting) to all user-investors on a defined period of 3 to 10 days (depending on the complexity 
    // of the proposal - meaning, **complexity* = number of medium used to produce and display the content, 
    // nb of platforms used under the hood (bc of costs usually associated with those), number of properties of the end product required (like the 
    // nb of members the last dynamic array, the additional properties being the last member of our RfC struct*, for instance, a specific 
    // file format, a specific definition of a video or picture (4K, 1080/740, ...), etc.)
        // ==> more on a RfC design note: for each platform and medium, there will be a frontend set of possible propertied all presented as
        // a constrained drop-down list between which the proposer can choose, and the investors, can agree to modify.
        //  => important side-note, we want our frontend to be stored on a distributed p2p network so it cannot be tampered with, especially those
        //      future inputs to our smart contracts and ERC-1155 contract to be minted eventually with those elements being then key to the
        //      inner working of the content creation market.  
    struct Proposal
    {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    function Ballot(bytes32[] proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) {
        if (msg.sender != chairperson || voters[voter].voted) {
            // `throw` terminates and reverts all changes to
            // the state and to Ether balances. It is often
            // a good idea to use this if functions are
            // called incorrectly. But watch out, this
            // will also consume all provided gas.
            throw;
        }
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) {
        // assigns reference
        Voter sender = voters[msg.sender];
        if (sender.voted)
            throw;

        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (
            voters[to].delegate != address(0) &&
            voters[to].delegate != msg.sender
        ) {
            to = voters[to].delegate;
        }

        // We found a loop in the delegation, not allowed.
        if (to == msg.sender) {
            throw;
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter delegate = voters[to];
        if (delegate.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) {
        Voter sender = voters[msg.sender];
        if (sender.voted)
            throw;
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() constant
            returns (uint winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() constant
            returns (bytes32 winnerName)
    {
        winnerName = proposals[winningProposal()].name;
    }

    //vote functions to add for staking-backed votes cases, in you use case there are some.
    // But the first check through giveRightToVote() is doing
    // most of the work already. What's left is how the stake of an account is going to affect a vote weight calculation, how the output of the vote
    // is going to be usable as an input for rewards and/or slashing of staked funds. 

    //>>>>>DON'T FORGET: think of that directly related to the "yes/no" 2 ERC-20 tokens minted at the mint of your ERC-1155 RfC token!!!!<<<<<

    //So, now, the scaffold of those few functions and tweaks to add to this contract:

    //1. call a getStakedFunds() (or commitedFunds, whatever the name) of the FundsManager contract and keep in memory for the time of the vote
    // the output
    function getStakedFundsOnVoteTime() public view returns(uint256 stakedAmount) {
        //TO DO: write this or invoke it on a public state variable in FundsManager contract
        _getFromFundsManager();
    }
    
    //2.1. Then overwrite/rewrite function giveRightToVote(address voter)(or any safe pattern - so it can't be called when you dont want it to be called - likely, you'll rewrite this function so
    // it encodes both voters[voter].weight = 1, and the version where weight is indexed on the voters' staked funds in FundsManager contract):
    function giveRightToVote(address voter) internal onlyStakers returns(uint256 ) {
        //TO DO
    }

    //2.2. Same case added to the function delegate(address _addr) [likely I am going to pass on delegation on the 1st iteration]

    //3. Make those functions callable on a wide set (all concerned) of voters(-stakers)

    //4. returns the outputs needed as inputs for the mint functions that need it in both ERC-1155_RfC and FundsManager contracts, and that's about it... 


    //!!!!!DOABLE!!!!! So be it!!
    //to delegate, a CP can put to auction rthe subset of RfC components/requirements (reverse Dutch-auction where the bidders are bidding the amount they require to take the delegated subset
    // of tasks = RfC split + attached ERC-20 amount + sent to the winning bidder => the one *to accept a price*. Start price is determined by the CP
    // delegating, and end/rest price also.). The important is to give a maximum amount of capital, and some time for the different potential delegatee
    // to take the subset, and compete for the price (so it is not overpriced, neither without ...) 
    function auctionDelegationRfCSubset
        (
        uint _RfCsplitId, 
        uint _startPrice, 
        uint _restPrice, 
        uint _amountAllocatedByDelegator
        ) internal
        returns (bool auctionSuccess, uint priceTaken) {
        //TO DO

        //Decide of how to present information in the frontend
        //see what's best to use on an auction to display (in the UI eventually) the time passing and the corresponding price  

        //CP delegator sends amount
    }
}

