const { catchRevert } = require("./exceptionsHelpers.js");
//var FundsManager = artifacts.require("./FundsManager");
var InvestorEscrow = artifacts.require(".DeFiMarketMakerLogic/InvestorEscrow");

contract('InvestorEscrow', function(accounts) {

    const [contractOwner, alice] = accounts;
    //toBN => to big numer; 2 is for 2 accounts (?)
    const deposit = web3.utils.toBN(2);
  
    beforeEach(async () => {
      instance = await InvestorEscrow.new();
    });

    it("The contract should receive ether correctly", function() {
        // Get initial balances of first and second account.
        var account_one = accounts[0];
        var account_two = accounts[1];
        var contract_account = InvestorEscrow.options.address;

        web3.eth.sendTransaction({
            from: account_one,
            to: contract_account,
            value: '1000000000000000'
        })
        .then(function(instance){
            return instance.getBalance.call(contract_account);
        }).then(function(balance) {
            account_one_ending_balance = balance.toNumber();
            //make sure the sender is taken the ether sent to the contract
            assert.equal(account_one_ending_balance, account_one - 1000000000000000, "Amount wasn't correctly taken from the sender");
            // make sure the contract receives the amount sent (maybe -gas => could lead to an error, it it happens check that)
            assert.equal(balance.valueOf(), 1000000000000000, "1000000000000000 is not in the contract. The accounts[1] transaction didn't work as expected");
        });
    });


});