// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {

    event Transfer(address indexed from,address indexed to,uint amount);

    event Approval(address indexed owner,address indexed spender,uint amount);

    function transfer(address recipient,uint amount) external returns (bool);

    function approve(address spender,uint amount) external returns(bool);

    function transferFrom(address sender,address recipient,uint amount) external returns(bool);

    function totalSupply() external view returns (uint256);

    function name() external view returns(string memory);

    function symbol() external view returns(string memory);

    function decimals() external view returns (uint8);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

}

contract ERC20 is IERC20 {

    uint256 public i_totalSupply;
    mapping(address => uint256) public i_balanceOf;
    mapping(address => mapping(address=>uint256)) public i_allowance;
    string public i_name;
    string public i_symbol;
    uint8 public i_decimals = 18;

    constructor(string memory _name,string memory _symbol,uint _totalSupply){
        i_name=_name;
        i_symbol=_symbol;
        i_totalSupply=_totalSupply*i_decimals;
    }

    function transfer(address recipient,uint amount) external override returns(bool){
        require(i_balanceOf[msg.sender]>amount,"You do not have enough balance left.");
        i_balanceOf[msg.sender]-=amount;
        i_balanceOf[recipient]+=amount;
        emit Transfer(msg.sender,recipient,amount);
        return true;
    }

    function approve(address spender,uint amount) external override returns(bool){
        require(i_balanceOf[msg.sender]>amount,"You do not have enough funds left");
        i_allowance[msg.sender][spender]=amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function transferFrom(address _from,address _to,uint _amount) external override returns(bool){
        require(i_balanceOf[_from]>_amount,"Sender has insufficient balance");
        require(i_allowance[_from][msg.sender]>_amount,"You are not approved to by owner of the account you are trying to use.");
        i_balanceOf[_from]-=_amount;
        i_allowance[_from][msg.sender]-=_amount;
        i_balanceOf[_to]+=_amount;
        emit Transfer(_from,_to,_amount);
        return true;
    }

    // Here amount is in WEI
    function mintTokens(uint amount) external returns(bool){
        i_totalSupply-=amount;
        i_balanceOf[msg.sender]+=amount;
        emit Transfer(address(this),msg.sender,amount);
        return true;
    }

    function name() public view override returns(string memory){
        return i_name;
    }

    function symbol() public view override returns(string memory){
        return i_symbol;
    }

    function decimals() public view override returns(uint8){
        return i_decimals;
    }

    function allowance(address _owner, address _spender) public view override returns(uint){
        return i_allowance[_owner][_spender];
    }

    function balanceOf(address _owner) public view override returns (uint256 balance){
        return i_balanceOf[_owner];
    }

    function totalSupply() public view override returns (uint256){
        return i_totalSupply;
    }

}