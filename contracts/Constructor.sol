// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// There are two ways to call parent constructor.
// Order of Initialization.

contract S{
    string public name;

    constructor(string memory _name){
        name = _name;
    }
}

contract T{
    string public text;

    constructor(string memory _text){
        text = _text;
    }
}

contract WayOne is S("Some name 1"), T("Some text 1") {

}


contract WayTwo is S, T{
    constructor(string memory _name,string memory _text) S(_name) T(_text) {

    }
}

contract MixedOfWayOneAndWayTwo is S("Some name 1"), T{
    constructor(string memory _text) T(_text) {

    }
}


// Order of execution (Order in which the folowing contract will be called)
// 1. S
// 2. T
// 3. V0
contract V0 is S,T{
    constructor(string memory _name,string memory _text) S(_name) T(_text) {}
}


// Order of execution (Order in which the folowing contract will be called)
// 1. S
// 2. T
// 3. V1
contract V1 is S,T{
    constructor(string memory _name,string memory _text) T(_text) S(_name) {}
}

// Order of execution (Order in which the folowing contract will be called)
// 1. T
// 2. S
// 3. V2
contract V2 is T,S{
    constructor(string memory _name,string memory _text) T(_text) S(_name) {}
}


// Order of execution (Order in which the folowing contract will be called)
// 1. T
// 2. S
// 3. V3
contract V3 is T,S {
    constructor(string memory _name,string memory _text) S(_name) T(_text) {}
}


