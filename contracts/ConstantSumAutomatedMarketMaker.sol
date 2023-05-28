// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "./ERC20.sol";

contract CSAMM {
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

    function _update(uint _res0, uint _res1) private {
        reserve0 = _res0;
        reserve1 = _res1;
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function swap(
        address _tokenIn,
        uint _amountIn
    ) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "Token not supported by the exchange"
        );

        bool isToken0 = _tokenIn == address(token0);
        (
            IERC20 tokenIn,
            IERC20 tokenOut,
            uint reserveIn,
            uint reserveOut
        ) = isToken0
                ? (token0, token1, reserve0, reserve1)
                : (token1, token0, reserve1, reserve0);

        // Transfering the token from the sender to the exchange.
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenIn.balanceOf(address(this)) - reserveIn;

        // Calculate amount out (including fees)
        amountOut = (amountIn * 997) / 1000;

        (uint newReserve0,uint newReserve1) = isToken0 ? (reserveIn + _amountIn,reserveOut - amountOut) : (reserveIn - amountOut,reserveOut - _amountIn);

        // Updating the reserves
        _update(newReserve0,newReserve1);

        // Transfer the tokens out
        tokenOut.transfer(msg.sender, amountOut);
    }

    function addLiquidity(uint _amount0,uint _amount1) external returns(uint shares){
        token0.transferFrom(msg.sender,address(this),_amount0);
        token1.transferFrom(msg.sender,address(this),_amount1);

        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;

        if(totalSupply == 0) {
            shares = d0 + d1;
        } else {
            shares = ((d0 + d1) * totalSupply) / (reserve0 + reserve1);
        }

        require(shares > 0,"Shares = 0");
        _mint(msg.sender,shares);
        _update(bal0,bal1);
    }

    function removeLiquidity(uint _shares) external returns(uint d0,uint d1){
        d0 = (reserve0 * _shares) / totalSupply;
        d1 = (reserve1 * _shares) / totalSupply;

        _burn(msg.sender,_shares);
        _update(reserve0-d0,reserve1-d1);

        if(d0 > 0){
            token0.transfer(msg.sender,d0);
        }
        if(d1 > 0){
            token1.transfer(msg.sender,d1);
        }
    }
}
