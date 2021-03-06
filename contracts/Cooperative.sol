pragma solidity ^0.4.18;

import "./PetBase.sol";

/**
*@title PetCore
* Front contract for CryptoPets. Holds create pet funtionality and token name and symbol
*/
contract PetCore is PetBase{
    // @notice Name and symbol of the non fungible token, as defined in ERC721.
    string public name = "CryptoPets";
    string public symbol = "CP";

    /**
    *@dev Creates the main CryptoPets smart contract instance.
    * sets the owenr and issues the first pet
    */
    function PetCore() public {
        owner = msg.sender;
        createPet("Waxfang",9000,owner);
    }

    /**
    *@notice No tipping!
    *@dev fallback function to reject all Ether from being sent to contract
    */
    function() external payable {
        require(msg.value == 0);
    }

    /**
    *@dev this is the function to create a pet and update the mappings with a new pet
    *@param _kind a string variable repreenting the kind of cryptopet
    *@param _genes a string variable representing the unique genes of the cryptopet
    *@param _owner an address to which the pet will be given, defaults to the owner
    */
    function createPet(string _kind, uint _genes, address _owner) public onlyOwner() {
        if(_owner == address(0)) {
            _owner = owner;
        }
        uint256 newPetId = totalTokens;
        pets[newPetId] = Pet({
            kind: _kind,
            genes: _genes,
            birthTime: uint64(now)
            });
        transferFrom(address(0),_owner,newPetId);
        Birth(_owner,newPetId, _kind, _genes);
    }


}