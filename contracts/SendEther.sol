// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 3 Ways to send ETH
// Transfer - 2300 gas, reverts.
// Send - 2300 gas, returns bool.
// Call - All gas, returns bool and data.

contract SendEther {

   constructor() payable {}

    // If we only have recieve function in our contract then it mean that we are only going to send ether
    // and if any one calls fucntion that does not exists in the contract then the call will fail.

    receive() external payable {}

    // In all the three functions amount is in WEI i.e. (123). 123 WEI = 123*(10**-18).

    function sendEtherViaTransfer(address payable _to) external payable {
        _to.transfer(123);
    }

    // Not used commonly.
    function sendEtherViaSend(address payable _to) external payable {
        bool sent = _to.send(123);
        require(sent,"Sent Failed");
    }

    function sendEtherViaCall(address payable _to) external payable {
        (bool success, ) = _to.call{value:123}(" ");
        require(success,"Transfer Failed");
    }

}

contract EtherReciever {

    event Log(uint amount,uint gas);

    receive() external payable {
        emit Log(msg.value,gasleft());
    }
    
}