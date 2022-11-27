// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Order of Inheritance: Most base like to derived
/*
    X
  /  |
  Y  |
   \ |
     Z
*/
// Order of more base like to derived contract will be X, Y, Z.

/*
     X
    / \
   /   \
  Y     A
  |     |
  |     |
  |     B
  \    /
   \  /
     Z
*/
// Order of more base like to derived contract will be X,Y,A,B,Z

contract X {
    function foo() public pure virtual returns(string memory){
        return "X";
    }

    function bar() public pure virtual returns(string memory){
        return "X";
    }

    function x() public pure returns(string memory){
        return "X";
    }
}

contract Y is X {
    function foo() public pure virtual override returns(string memory){
        return "Y";
    }

    function bar() public pure virtual override returns(string memory){
        return "Y";
    }

    function y() public pure returns(string memory){
        return "Y";
    }
}

contract Z is X, Y{
    function foo() public pure override(X,Y) returns(string memory){
        return "Z";
    }

    function bar() public pure override(X,Y) returns(string memory){
        return "Z";
    }
}