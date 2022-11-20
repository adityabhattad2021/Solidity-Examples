// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PiggyBank{

    event Withdraw(uint256 indexed value);
    event Deposit(uint indexed amount,address indexed sender);


    address payable public owner;

    constructor(){
        owner=payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"You are not authorised");
        _;
    }

    receive() external payable {
        emit Deposit(msg.value,msg.sender);
    }

    function withdrawAndDelete() onlyOwner external {
        emit Withdraw(address(this).balance);
        selfdestruct(owner);
    }

}