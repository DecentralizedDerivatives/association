pragma solidity ^0.4.21;
import "./safemath.sol";

contract Membership {
    using SafeMath for uint256;
    
    /*Variables*/
    address public owner;
    
    //Memebership fees
    uint public memberFee;
    uint public investorFee;
    uint public partnerFee;
    
    //Total membership tokens
    uint public total_supply;
    
    /*Structs*/
    /**
    *@dev Keeps member information 
    */
    struct Member {
        uint memberId;
        uint membershipType;
        bool membership;
    }
    
    //Members information
    mapping(address => Member) public members;
    address[] public membersAccts;
    mapping(address => uint) ownerMembershipCount;

    
    /*Events*/
    event Transfer(address _from, address _to, uint _tokenId);

    /*Modifiers*/
    modifier onlyOwner() {
        require(msg.sender == owner);
    _;
    }
    
    /*Functions*/
    /**
    *@dev Constructor - Sets owner
    */
    constructor(Membership) public {
        owner = msg.sender;
    }

    /*
    *@dev Updates the fee amount
    *@param _memberFee fee amount for member
    *@param _investorFee fee amount for investor member
    *@param _partnerFee fee amount for member
    */
    function setFee(uint _memberFee, uint _investorFee, uint _partnerFee) public onlyOwner() {
        //define fee structure for the three membership types
        memberFee = _memberFee;
        investorFee = _investorFee;
        partnerFee = _partnerFee;
    }
    
    /**
    *@notice Allows a user to become DDA members if they pay the fee. However, they still have to complete
    complete KYC/AML verification off line
    *@dev this creates the token 
    *@return returns the newly created token
    */
    function requestMembership() public payable returns (uint) {
        Member storage sender = members[msg.sender];
        require(msg.value >= memberFee && sender.membership == false);
        //Update total supply of membership Tokens
        total_supply = total_supply.add(1);
        uint membershipToken = uint(keccak256(now, msg.sender, total_supply));
        sender.memberId = membershipToken;
        sender.membershipType = 1;
        sender.membership = true;
        membersAccts.push(msg.sender)-1;
        return membershipToken;
        transferFrom(owner, msg.sender,membershipToken);
    }
    
  /**
  * @dev This overload transferFrom function is required on ERC721.org
  * @param _from is the address that the token will be sent from
  * @param _to is the address we are sending the token to
  * @param _tokenId the uint256 numeric identifier of a token or the memberId
  */
  function transferFrom(address _from, address _to, uint256 _tokenId) public onlyOwner{
    require (_to != address(0));
    ownerMembershipCount[_from] = ownerMembershipCount[_from].sub(1);
    ownerMembershipCount[_to] = ownerMembershipCount[_to].add(1);
    //how do I send the actual tokenid/memberhipToken
    emit Transfer(_from, _to, _tokenId);
  }

    /**
    *@dev Use this function to set membershipType for the member
    @param _member address of member that we need to update membershipType
    @param _membershipType type of membership to assign to member
    **/
    function setMembershipType(address _member,  uint _membershipType) public onlyOwner{
        Member storage member = members[_member];
        member.membershipType = _membershipType;
    }

    /**
    *@dev getter function to get all membersAccts
    **/
    function getMembers() view public returns (address[]){
        return membersAccts;
    }
    
    /**
    @dev Get member information. could be the ownerOf funciton
    @param _member address to pull the memberId, membershipType and membership
    **/
    function getMember(address _member) view public returns(uint, uint, bool) {
        return(members[_member].memberId, members[_member].membershipType, members[_member].membership);
    }

    /**
    @dev gets length of array containing all member accounts or total suply
    **/
    function countMembers() view public returns(uint) {
        return membersAccts.length;
    }
    
}
    
