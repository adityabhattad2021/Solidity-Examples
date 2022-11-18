// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Uses: Signature, come up with a unique ID and also used to prevent front running(Commit reveal scheme).
contract HashFunc{

    // Returns a unique hash for different inputs.
    function hash(string memory name,int num,address addr) external pure returns(bytes32){
        return keccak256(abi.encodePacked(name,num,addr));
    }



    // Difference between abi.encode and abi.encodePacked

    // abi.encode encodes the data into bytes
    // abi.encodePacked also encodes the data into bytes but also compresses it, the output will
    // be smaller and some of the information will be lost



    /*
        Output for "AA","ABBB":0x000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000002414100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044142424200000000000000000000000000000000000000000000000000000000
        Output for "AAA","BBB":0x000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000003414141000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000034242420000000000000000000000000000000000000000000000000000000000
    */
    function encodeExample(string memory text1,string memory text2) external pure returns(bytes memory){
        return abi.encode(text1,text2);
    }



    /*
        Output for "AA","ABBB" and "AAA","BBB" will be the same 0x414141424242, which can result to hash
        collision.
    */
    function encodePackedExample(string memory text1,string memory text2) external pure returns(bytes memory){
        return abi.encodePacked(text1,text2);
    }


    // Example of hash collision (To be avoided in any case)
    /*
        here hash for AA,ABBB and AAA,BBB is same i.e. 0xf6568e65381c5fc6a447ddf0dcb848248282b798b2121d9944a87599b7921358
    */
    function collision(string memory text1,string memory text2) external pure returns(bytes32){
        return keccak256(abi.encodePacked(text1,text2));
    }



}