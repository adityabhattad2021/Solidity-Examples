// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// There are two ways to create a contract from another contract, create and create2.

contract Account {

    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }

}

// Good practice to suffix the contract with factory as it refers to the contract that has created another
// contract.
contract AccountFactory {

    Account[] public accounts;

    function createAccount(address _owner) external payable {

        // Value amount in WEI.
        Account account = new Account{value:111}(_owner);
        accounts.push(account);

    }

}


