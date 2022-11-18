// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Verifying Signature on chain.
/*
    The process of verifying signature in solidity is in four steps:
    - Message to sign
    - hash (message)
    - sign(hash(message),private key) | this will happen offchain
    - ecrecover(hash(message)), signature) == signer
*/
contract VerifySigatureExample{

    function verify(address _signer,string memory _message,bytes memory _signature)
    external
    pure
    returns(bool){
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthereumSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash,_signature) == _signer;
    }

    // We get the message hash.
    function getMessageHash(string memory _message) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function getEthereumSignedMessageHash(bytes32 _messageHash) public pure returns(bytes32){
        // It is prefixed with a string my metamask.
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
        ));
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns(address){
        (bytes32 r,bytes32 s,uint8 v)=_split(_signature);
        return ecrecover(_ethSignedMessageHash,v,r,s);
    }

    function _split(bytes memory _signature) internal pure returns(bytes32 r,bytes32 s,uint8 v){
        require(_signature.length==65,"Invalid Signature");

        assembly{
            r := mload(add(_signature,32))
            s := mload(add(_signature,64))
            v := byte(0,mload(add(_signature,96)))
        }
    }



}