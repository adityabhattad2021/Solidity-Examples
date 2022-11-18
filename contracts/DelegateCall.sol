// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Delegate call executes code in another contract in the context of the contract that called it.
/*
    Normal Call
    A calls B, sends 100 WEI
    B calls C, sends 50 WEI
    A --> B --> C
                msg.sender = B
                msg.value = 50
                executes code on C's state variables
                use ETH in C
*/
/*
    Delegate call
    A calls B, sends 100 WEI
    B delegatecalls C
    A --> B --> C
                msg.sender = A
                msg.value = 100
                executes code on B's state variables
                use ETH in B
*/
// Here order of state variables in both the contract should be same
// If some variable is still needed to be add in the testdelegatecall it should be added to
// the end of the contract.
contract TestDelegateCall {

    // Order matters here ⚠️.
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

}


contract TestDelegateCaller {

    // Order matters here ⚠️.
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test,uint _num) external payable {
        // Way 1.
        // (bool success, /* bytes memory data */ ) = _test.delegatecall(
        //     abi.encodeWithSignature("setVars(uint)",_num)
        // );

        // Way 2.
        (bool success, /* bytes memory data */) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector,_num)
        );
        require(success,"Delegate call failed");
    }

}

// Thoughts,
// Delegate call can be use to update the logic of the contract without redeploying it 
// e.g the function in test delegate caller can remain same, but we can call new test delegate call with
// new logic and it will still work