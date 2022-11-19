// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



contract EtherWallet {

    event Log(address sender,uint256 amount);

    address payable public owner;

    modifier onlyOwner{
        require(msg.sender==owner,"You are not authorised to use this function");
        _;
    }

    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log(msg.sender,msg.value);
    }

    function transferTo(address _to,uint256 amtInWEI) external onlyOwner {
        (bool success,)=_to.call{value:amtInWEI}(" ");
        require(success,"Transfer failed");
    }

    function withdraw(uint256 amtInWEI) external onlyOwner {
        (bool success,)=owner.call{value:amtInWEI}(" ");
        require(success,"Transfer failed");
    }

}