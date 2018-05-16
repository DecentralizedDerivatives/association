var Membership = artifacts.require("Membership");

contract('Contracts', function(accounts) {
  let membership;

    it('Setup contract for testing', async function () {
        membership = await Membership.new({from: accounts[3]});
    });

    it("should send coin correctly", async function () {
    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];
    console.log("set up accts");

    var amount = 1;
    console.log("set up amount");


    let fee =  await membership.setFee(10, {from: accounts[3]});
    console.log("contract deployed");
    let balance = await membership.requestMembership({from: accounts[0], value:web3.toWei(20, "ether")});
        console.log("requestMembership");
    let balance1 = await membership.getBalance(account_one);
    let balance2 = await membership.getBalance(account_two);
        console.log("get balances");

    let account_one_starting_balance = balance1.toNumber();
    let account_two_starting_balance = balance2.toNumber();
            console.log("set balances");

    await membership.transferFrom(account_one,account_two, amount);
            console.log("tranferFrom");

    let balance3 = await membership.getBalance(account_one);
    let balance4 = await membership.getBalance(account_two);
        console.log("get balances after tranferFrom");
    let account_one_ending_balance = balance3.toNumber();
    let account_two_ending_balance = balance4.toNumber();
        console.log("set balances after from");
    assert.equal(account_one_ending_balance, account_one_starting_balance - 1, "Amount wasn't correctly taken from the sender");
            console.log("assert1");
    assert.equal(account_two_ending_balance, account_two_starting_balance + 1, "Amount wasn't correctly sent to the receiver");
            console.log("assert2");
  });



        	
    })