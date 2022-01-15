// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
contract ContentProviderEscrow {

    using SafeERC20 for IERC20;
    mapping (address => uint256) public balance;

    mapping (address => bool) isContentProvider;
    mapping (address => bool) isContentProviderDelegatee;   // allows less users to access possibly sensitive functions 
                                                            // (a subset of the CPs functions and actions)
    
    modifier onlyCP{
        require(isContentProvider[msg.sender] == true, "must be a Content Provider");
        _;
    }

    event Commit(address indexed cp, bool success);

    //make sure contract can receive ether
    function commit(uint256 _timeMaturity) external payable {
         
        require(msg.value > 0, "the deposit must be greater than 0");

        balance[address(this)] += msg.value;
        
        lockFunds(msg.sender, _timeMaturity);

        emit Commit(msg.sender, true);

    }

    function lockFunds(address CP, uint256 _timeMaturity) internal {
        //Check pattern usually used for this purpose (as a resting time before actual unstaking happeing for instance)
    }

}
