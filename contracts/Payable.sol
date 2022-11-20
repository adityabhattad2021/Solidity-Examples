// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The "payable" keyword adds functionality to send and recieve ether.
contract PayableExample{
    
    // By declaring an address payable, we allow it to send ether.
    // This
    address payable public pOwner;
    // The payable keyword has to come right after the address.

    // And this are different data types 
    address public owner;

    // E.g
    constructor() {
        // This will work.
        owner = msg.sender;

        // This will throw error.
        owner = pOwner;
        
        // To make it work we have to: 
        owner = payable(pOwner);
    }

    function deposit() payable external {/*This function does nothing, wrote is as an example for payable.*/}

    function getbalance() public view returns(uint){
        return address(this).balance;
    }

}