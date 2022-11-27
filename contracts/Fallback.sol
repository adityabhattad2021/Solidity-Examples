// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/*
    "Fallback" are a special type of function which execute when some function called does't exist or
    someone directly sends ETH.
    It is mostly used to enable a smart contract to recieve ether.
*/

// There is another varient of "fallback" function that is "receive".
// So what is difference between fallback and receive ?
/*
    Ether is sent to the contract.
                |
        is msg.data empty?
                /\
              yes no
              /    \
             /      \
            /        \
receive() exists   fallback()
        /             \
        yes            no
        /               \
      receive()       fallback()
*/

contract FallbackExamples {
    event Log(string message);

    fallback() external payable {
        emit Log("Fallback is called");
    }

    receive() external payable {
        emit Log("Recieve is called");
    }
}