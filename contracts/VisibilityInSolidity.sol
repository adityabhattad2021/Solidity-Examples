// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


/*
    Visibility
    - Private - only inside contract.
    - Internal - only inside the contract and the child contract.
    - Public - Inside and Outside the contract (everywhere).
    - External - Only from outside the contract.
*/

contract VisibilityBase {
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;
    uint public outputForPrivateFunction;
    uint public outputForPublicFunction;
    uint public outputForExternalFunction;
    uint public outputForInternalFunction;

    function privateFunction() private pure returns(uint){
        return 0;
    }

    function internalFunction() internal pure returns(uint){
        return 100;
    }

    function publicFunction() internal pure returns(uint){
        return 200;
    }

    function externalFunction() external pure returns(uint){
        return 300;
    }

    function examples() external  {
        // Accessible.
        x+y+z;

        // These will work as expected.
        outputForPrivateFunction=privateFunction();
        outputForInternalFunction=internalFunction();
        outputForPublicFunction=publicFunction();

        // This will give error.
        // externalFunction();

        // But there is a hack to call the external contract form inside the contract.
        // What this line do is call the external function by refering to this  contract.
        // like we do contractABC.someFunction() , "this" keyword refers to this contract.
        outputForExternalFunction=this.externalFunction();

    }

}

contract VisibilityChild is VisibilityBase {

    function example2() external view {
        y + z;

        // This are the functions which can be called from child contract.
        internalFunction();
        publicFunction();
    }

}