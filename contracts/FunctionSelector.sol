// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract FunctionSelectorExample{

    function getFunctionSelector(string memory _functionSignature) external pure returns(bytes4){
        return bytes4(keccak256(bytes(_functionSignature)));
        // If we pass function signature of transfer function in below contract
        // i.e. transfer(address,uint)
        // We will get 0xa9059cbb   This is called function selector.
    }
    
}

contract Recivier {

    // To log all the data when a function is called.
    event Log(bytes data);

    function transfer(address _to,uint _amount) external {
        emit Log(msg.data);
        // This was the data that was emitted when we call the function transfer.
        // 0xa9059cbb  This is the encoded function selector.
        // 0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4  This is the value of parameter we passed.
        // 00000000000000000000000000000000000000000000000000000000000000fb  This is the value of parameter we passed.
        // This is the way data is encoded when we call the fuction from a contract, the first four bytes 
        // encodes the function to call, the rest of the data encodes the paramaters to pass to the function.
    }

}