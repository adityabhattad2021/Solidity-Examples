// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "./ERC20.sol";

contract CPAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "Invalid Token"
        );

        require(_amountIn > 0, "Amount In = 0");

        bool isToken0 = _tokenIn == address(token0);
        (
            IERC20 tokenIn,
            IERC20 tokenOut,
            uint reserveIn,
            uint reserveOut
        ) = isToken0
                ? (token0, token1, reserve0, reserve1)
                : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        uint amountInWithFee = (_amountIn * 997) / 1000;
        amountOut =
            (reserveOut * amountInWithFee) /
            (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function addLiquidity(uint _amount0,uint _amount1) external returns(uint shares) {
        token0.transferFrom(msg.sender,address(this),_amount0);
        token1.transferFrom(msg.sender,address(this),_amount1);

        if(reserve0>0 || reserve1>0){
            require(reserve0 * _amount1 == reserve1 *_amount1, "dy/dx!=y/x");
        }

        if(totalSupply==0){
            shares = _sqrt(_amount0*_amount1);
        }else{
            shares = _min(
                (_amount0*totalSupply)/reserve0,
                (_amount1*totalSupply)/reserve1
            );
        }

        require(shares>0,"Shares = 0");

        _mint(msg.sender,shares);

        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function removeLiquidity(uint _shares) external returns(uint amount0,uint amount1){
        require(_shares>0,"Shares = 0");
        // Calculate amount0 and amount1 to withdraw
        /**
         * dx = S / T * x
         * dy = S / T * y
         * 'Burn the shares
         * Update the reserves 
         * Transfer the tokens to the msg.sender
         */
        uint balence0 = token0.balanceOf(address(this));
        uint balence1 = token1.balanceOf(address(this));

        amount0 = (_shares * balence0)/totalSupply;
        amount1 = (_shares * balence1)/totalSupply;

        require(
            amount0 > 0 && amount1 > 0,
            "Either of amount 0 or amount 1 = 0"
        );

        _burn(msg.sender,_shares);

        _update(
            balence0-amount0,
            balence1-amount1
        );

        token0.transfer(msg.sender,amount0);
        token1.transfer(msg.sender,amount1);

    }

    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint x,uint y) private pure returns(uint){
        return x <= y ? x : y;
    }
}
