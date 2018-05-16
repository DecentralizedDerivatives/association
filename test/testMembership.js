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
    var account_three = accounts[3];
    console.log("set up accts");

    let fee =  await membership.setFee(10, {from: accounts[3]});
    console.log("contract deployed");
    let member = await membership.requestMembership({from: accounts[0], value:web3.toWei(20, "ether")});
        console.log("requestMembership");


    let member1 = await membership.getMemberType(account_one);
    let member2 = await membership.getMemberType(account_two);
        console.log("get balances");

    let account_one_starting_member = member1.toNumber();
    let account_two_starting_member = member2.toNumber();
            console.log("set balances");


        console.log("set balances after from");
    assert.equal(account_one_starting_member, 0, "From");
            console.log("assert1");
    assert.equal(account_two_starting_member, 1, "to");
            console.log("assert2");
    });



        	
})