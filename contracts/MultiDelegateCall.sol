// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiDelegateCallExample {

    function multiDelegateCall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results)
    {

        results= new bytes[](data.length);

        for(uint i=0;i<data.length;i++){
            (bool ok,bytes memory res)=address(this).delegatecall(data[i]);
            require(ok,"Delegate call failed");
            results[i]=res;
        }

    }

}

// Why use multi delegatecall? why not use multi call?
// Alice -->test --- call ---> test (msg.sender = multi call)
// Alice -->test --delegatecall --->test (msg.sender = alice)

contract TestMultiDelegateCall is MultiDelegateCallExample {

    event Log(address caller, string funcName, uint256 i);

    function func1(uint256 x, uint256 y) external {
        emit Log(msg.sender, "Func1", x + y);
    }

    function func2() external returns (uint256) {
        emit Log(msg.sender, "Func2", 2);
        return 111;
    }

    mapping(address => uint) public balanceOf;

    // Warning: Unsafe code when used in combination with multi-delegatecall
    // when called 'n' number of times in same transection then with same eth it can increase balance 'n' times.
    function mint() external payable{
        balanceOf[msg.sender]+=msg.value;
    }
}


contract Helper{

    function getFunc1Data(uint x,uint y) external pure returns (bytes memory){
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector,x,y);
        // same as return abi.encodeWithSignature("func1(uint256,uint256)");
    }

    function getFunc2Data() external pure returns(bytes memory){
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    }

    function getMintData() external pure returns(bytes memory){
        return abi.encodeWithSelector(TestMultiDelegateCall.mint.selector);
    }

}