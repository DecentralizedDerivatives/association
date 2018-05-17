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
    assert(await membership.getMembershipType(accounts[0]) > 0, "MembershipType should not be zero");
    console.log("ensure member type is greater than zero");
    });

    it("Should assign membership details to new address", async function () {
    await membership.updateMemberAddress(accounts[0], accounts[1], {from: accounts[3]});
    console.log("tranferFrom");
    assert(await membership.getMembershipType(accounts[0]) == 0, "MembershipType should be zero");
    assert(await membership.getMembershipType(accounts[1]) > 0, "MembershipType should not be zero");
    console.log("ensure member type is greater than zero");
    });


        	
})