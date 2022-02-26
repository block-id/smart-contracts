// SPDX-License-Identifier: Apache License Version 2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract IssuersContract {
    // Mapping UIDs to issuer public keys
    mapping(bytes16 => address) idTypes;

    // Creates a new signer for ID type
    function addIdType(bytes16 idType) public returns (bool) {
        // Check if id type already exists
        require(address(0) == idTypes[idType], "idType already exists");
        idTypes[idType] = msg.sender;
        return true;
    }

    // Verify an idHash (sha256 hash of a verifiable id) was issued by the owner of idType.
    function verifyIdType(
        bytes32 idHash,
        bytes memory signature,
        bytes16 idType
    ) public view returns (bool) {
        if (address(0) == idTypes[idType]) return false;

        bytes32 hash = ECDSA.toEthSignedMessageHash(idHash);
        address signer = ECDSA.recover(hash, signature);
        return signer == getSigner(idType);
    }

    // Get the public key for an ID type
    function getSigner(bytes16 idType) internal view returns (address) {
        return idTypes[idType];
    }
}
