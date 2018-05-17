var Membership = artifacts.require("Membership");

contract('Contracts', function(accounts) {
  let membership;

    it('Setup contract for testing', async function () {
        membership = await Membership.new({from: accounts[3]});
        console.log("contract Membership.sol deployed");
    });

    it("Should assign memberhipType and memberId", async function () {
    await membership.setFee(10, {from: accounts[3]});
    console.log("membership.setFee set to 10");
    await membership.requestMembership({value: web3.toWei(20,'ether'), from: accounts[0]});
    console.log("requestMembership");
    assert(await membership.getMemberType(accounts[0]) > 0, "MembershipType should not be zero");
    console.log("ensure member type is greater than zero");
    });

        	
})