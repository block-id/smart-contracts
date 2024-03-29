// SPDX-License-Identifier: Apache License Version 2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract IssuersContract {
    // Mapping UIDs to issuer public keys
    mapping(bytes16 => address) idTypes;

    event AddIdType(
      bytes16 idType,
      address signer
    );

    // Creates a new signer for ID type
    function addIdType(bytes16 idType) public returns (bool) {
        // Check if id type already exists
        if (idTypes[idType] == msg.sender) return true;
        require(address(0) == idTypes[idType], "idType already exists");
        // Add id type
        idTypes[idType] = msg.sender;
        emit AddIdType(idType, msg.sender);
        return true;
    }

    // For logging
    // event VerifyHash(
    //   bytes32 message,
    //   bytes signature,
    //   bytes16 idType,
    //   bytes32 ethMessageHash,
    //   address recoveredSigner
    // );

    // Verify a signature for an idType.
    function verifySignature(
        bytes32 message,
        bytes memory signature,
        bytes16 idType
    ) public view returns (bool) {
        if (address(0) == idTypes[idType]) return false;
        bytes32 hash = ECDSA.toEthSignedMessageHash(message);
        address signer = ECDSA.recover(hash, signature);
        // emit VerifyHash(message, signature, idType, hash, signer);
        return signer == getSigner(idType);
    }

    // Get the public key for an ID type
    function getSigner(bytes16 idType) internal view returns (address) {
        return idTypes[idType];
    }
}
