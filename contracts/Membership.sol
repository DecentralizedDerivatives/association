pragma solidity ^0.4.21;
import "./library/SafeMath.sol";

contract Membership {
    using SafeMath for uint256;
    
    /*Variables*/
    address public owner;
    
    //Memebership fees
    uint public memberFee;

    /*Structs*/
    /**
    *@dev Keeps member information 
    */
    struct Member {
        uint memberId;
        uint membershipType;
    }
    
    //Members information
    mapping(address => Member) public members;
    address[] public membersAccts;
    mapping(address => uint) ownerMembershipCount;

    
    /*Events*/
    event TransferFrom(address _from, address _to);

    /*Modifiers*/
    modifier onlyOwner() {
        require(msg.sender == owner);
    _;
    }
    
    /*Functions*/
    /**
    *@dev Constructor - Sets owner
    */
    constructor () public {
        owner = msg.sender;
    }

    /*
    *@dev Updates the fee amount
    *@param _memberFee fee amount for member
    *@param _investorFee fee amount for investor member
    *@param _partnerFee fee amount for member
    */
    function setFee(uint _memberFee) public onlyOwner() {
        //define fee structure for the three membership types
        memberFee = _memberFee;
    }
    
    /**
    *@notice Allows a user to become DDA members if they pay the fee. However, they still have to complete
    complete KYC/AML verification off line
    *@dev this creates and transfers the token 
    *@return returns the newly created token
    */
    function requestMembership() public payable returns (uint) {
        Member storage sender = members[msg.sender];
        require(msg.value >= memberFee && sender.membershipType > 0);
        uint membershipToken = membersAccts.length.add(1);
        sender.memberId = membershipToken;
        sender.membershipType = 1;
        membersAccts.push(msg.sender)-1;
        return membershipToken;
    }
    
    /**
    *@dev This overload transferFrom function is required on ERC721.org
    *@param _from is the address that the token will be sent from
    *@param _to is the address we are sending the token to
    *@param _tokenId the uint256 numeric identifier of a token or the memberId
    */
    function transferFrom(address _from, address _to) public onlyOwner {
        require (_to != address(0));
        Member storage sender = members[_from];
        Member storage receiver = members[_to];
        receiver.memberId = sender.memberId;
        receiver.membershipType = sender.membershipType;
        sender.memberId = 0;
        sender.membershipType = 0;
        emit TransferFrom(_from, _to);
    }

    /**
    *@dev Use this function to set membershipType for the member
    *@param _member address of member that we need to update membershipType
    *@param _membershipType type of membership to assign to member
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
    *@dev Get member information. could be the ownerOf funciton
    *@param _member address to pull the memberId, membershipType and membership
    **/
    function getMember(address _member) view public returns(uint, uint) {
        return(members[_member].memberId, members[_member].membershipType);
    }

    /**
    @dev gets length of array containing all member accounts or total supply
    **/
    function countMembers() view public returns(uint) {
        return membersAccts.length;
    }

    /**
    *@dev gets membership count per owner but it should always be 1
    **/
    function getMemberType(address _member) public constant returns(uint){
        return members[_member].membershipType;
    }
    
    /**
    *@dev Allows the owner to set a new owner address
    *@param _new_owner the new owner address
    */
    function setOwner(address _new_owner) public onlyOwner() { 
        owner = _new_owner; 
    }

}
