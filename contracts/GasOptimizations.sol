// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    - use calldata for inputs
    - load state variables in memory
    - short circuits
    - loop increments
    - cache array length
    - load array elements to memory 
*/

contract Unoptimized{

    uint public total;
    //49899 gas
    function sumIfEvenAndLessThan99(uint[] memory nums) external {

        for(uint i = 0;i<nums.length;i+=1){
            bool isEven = nums[i]%2==0;
            bool isLessThan99 = nums[i]<99;
            if(isEven && isLessThan99){
                total+=nums[i];
            }
        }

    }
}

contract Optimized{

    uint public total;
    // 	30318 gas
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {

        uint _total=total;
        uint arrayLength=nums.length;
        for(uint i = 0;i<arrayLength;++i){
            // This is called short circuiting, if first statement is false it won't check second statement.
            uint num=nums[i];
            if(num%2==0 && num<99){
                _total+=num;
            }
        }
        total=_total;
    }
}