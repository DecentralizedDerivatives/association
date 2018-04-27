pragma solidity ^0.4.18;

import "./ERC721.sol";

/**
*@title PetBase
* Base contract for CryptoPets. Holds all common structs, events and base variables.
*/
contract PetBase is ERC721{
    /***VARIABLES***/
    address public owner; //The owner of the contract
    address public marketContract; //The addresss of the official marketplace contract

    /*** DATA TYPES ***/
    /// @dev The main Pet struct.
    struct Pet {
        string kind;// kind of Pets creating
        uint genes;// The Pet's genetic code is packed into these 256-bits
        uint64 birthTime;// The timestamp from the block when this cat came into existence
    }
    /*** STORAGE ***/
    mapping(uint256 => Pet) pets;//A mapping from pet IDs to the details of the pet.
    mapping(uint256 => uint256) experience; //A mapping from pets ID to the experience it has;

    /***MODIFIERS***/
    /// @dev Access modifier for Owner functionality
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /*** EVENTS ***/
    /// @dev The Birth event is fired whenever a new pet comes into existence
    event Birth(address indexed owner, uint256 petId, string kind, uint genes);


    /***FUNCTIONS***/
    /**
    *@dev allows the owner to set the owner of the contract
    *@param _owner is the address of the new owner
    */
    function setOwner(address _owner) public onlyOwner() {
        owner = _owner;
    }

    /**
    *@dev allows the owner to set the official marketplace of the token
    *@param _market is the address of the PetMarket contract
    */
    function setMarket(address _market) public onlyOwner() {
        marketContract = _market;
    }

    /**
    *@dev allows for the details of the pet to be viewed
    *@param _tokenId is the address of the new owner
    *@return string kind
    *@return bytes32 genes
    *@return uint64 birthTime
    *@return uint256 experience
    */
    function getPet(uint _tokenId) public view returns(string,uint, uint64,uint256){
        Pet memory _pet = pets[_tokenId];
        return (_pet.kind,_pet.genes,_pet.birthTime,experience[_tokenId]);
    }

    /**
    *@dev allows the owner to add experience points to the pet
    *@param _tokenId [] is the array of tokenIds
    *@param _xp[] is the array of xp to add
    */
    function addExperience(uint[] _tokenId, uint[] _xp) public onlyOwner() {
        for (uint i = 0; i < _tokenId.length;i++){
            experience[_tokenId[i]] = experience[_tokenId[i]].add(_xp[i]);
        }
    }
    

  /**
   * @dev This overwrites the transferFrom function to allow the market contract to interact
   * @param _from is the address that the token will be sent from
   * @param _to is the address we are sending the token to
   * @param _tokenId the numeric identifier of a token
  */
  function transferFrom(address _from, address _to, uint256 _tokenId) public{
    require(msg.sender == owner || isApproved(msg.sender,_from) || isApproved(msg.sender,_from,_tokenId) || ownerOf(_tokenId)==msg.sender || msg.sender==marketContract);
    clearApprovalAndTransfer(_from,_to,_tokenId);
  }
}
