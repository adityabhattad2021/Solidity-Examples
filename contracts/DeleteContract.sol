// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*  
    Self destruct
    - Delete Contract
    - Force send ether to any address
*/

contract Kill {

    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns(uint256){
        return 123;
    }

}

// To demonstrate that we can force send ETH to a contract ky killing the sender contract.
// notice this contract has no where 'payable' marked on function but we will still send it ETH.
contract Helper{

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }

    function kill(Kill _kill) external {
        _kill.kill();
    }

}