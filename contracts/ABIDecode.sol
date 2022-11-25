// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract ABIDecode{

        struct ExampleStruct{
            string name;
            uint[2] numbers;
        }

        function encode(
            uint x,
            address addr,
            uint[] calldata arr,
            ExampleStruct calldata exampleStruct
        ) external pure returns(bytes memory data){
            data=abi.encode(x,addr,arr,exampleStruct);
        }

        function decode(bytes calldata data) external pure returns(
            uint x,
            address addr,
            uint[] memory arr,
            ExampleStruct memory exampleStruct
        ){
            (x,addr,arr,exampleStruct)=abi.decode(data,(uint,address,uint[],ExampleStruct));
        }

}