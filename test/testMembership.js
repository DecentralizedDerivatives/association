var Membership = artifacts.require("Membership");

contract('Contracts', function(accounts) {
  let membership;

    it('Setup contract for testing', async function () {
        membership = await Membership.new();
        await membership.setFee(10, 15, 20);
//        await membership.requestMembership() public payable returns (uint); 
  //      await transferFrom(address _from, address _to, uint256 _tokenId);
    //    await setMembershipType(address _member,  uint _membershipType);
      //  await getMembers() view public returns;
        //await getMember(address _member) view public returns(uint, uint, bool) ;
        //await countMembers() view public returns(uint);
    });

    it("should send coin correctly", async function () {
    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var amount = 1;

    let meta = await Membership.deployed();
    let balance = await meta.requestMembership.call();
    let balance1 = await meta.getBalance.call(account_one);
    let balance2 = await meta.getBalance.call(account_two);

    let account_one_starting_balance = balance1.toNumber();
    let account_two_starting_balance = balance2.toNumber();

    await meta.transferFrom(account_one,account_two, amount);

    let balance3 = await meta.getBalance.call(account_one);
    let balance4 = await meta.getBalance.call(account_two);

    let account_one_ending_balance = balance3.toNumber();
    let account_two_ending_balance = balance4.toNumber();

    assert.equal(account_one_ending_balance, account_one_starting_balance - 1, "Amount wasn't correctly taken from the sender");
    assert.equal(account_two_ending_balance, account_two_starting_balance + 1, "Amount wasn't correctly sent to the receiver");
  });



        	
    })