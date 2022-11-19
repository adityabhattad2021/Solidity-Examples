// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Call is a low level function.

contract TestCall {

    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable {
        emit Log("Fallback function was triggered");
    }

    function foo(string memory _message,uint _x) payable external returns(bool,uint){
        message=_message;
        x=_x;
        return (true,281);
    }

}

contract CallExample{
     
    bytes public data;

    // Value in WEI and specify gas or it sends all the gas.
    function callFoo(address _test) external payable {
        (bool success,bytes memory _data)=_test.call{value:111}(
            abi.encodeWithSignature(
                "foo(string,uint256)","Some message",254
            )
        );
        require(success,"call to the contract fail");
        data=_data;
    }

    function callAUnexistantFunction(address _test) external {
        (bool success, )=_test.call(abi.encodeWithSignature("functionThatDoesNotExists()"));
        require(success,"Call to an unexistant function failed");
    }

}