// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC721{

    function transferFrom(
        address _from,
        address _to,
        uint nftId
    ) external;

}

// English auction is the type of auction in which seller sets the starting price and the ending time
// and untill some one buys the entity at the highest price and ends the auction.

contract EngishAuction {

    event Start();
    event Bid(address indexed sender,uint amount);
    event Withdraw(address indexed bidder,uint amount);
    event Ended(address highestBidder,uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;
    
    address payable public immutable seller;
    uint public endingTime;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address=>uint) public bids;


    constructor(
        uint _startingPriceInWEI,
        address _nft,
        uint _nftId
    ) {
        nft=IERC721(_nft);
        nftId=_nftId;
        seller=payable(msg.sender);
        highestBid=_startingPriceInWEI;
    }

    function start() external {
        require(msg.sender==seller,"Not seller");
        require(!started,"Already started");

        started=true;
        endingTime = block.timestamp+ 7 days;
        nft.transferFrom(seller,address(this),nftId);

        emit Start();
    }

    function bid() external payable {
        require(started,"Not Started yet.");
        require(block.timestamp<endingTime,"Auction already ended.");
        require(!ended,"Auction already ended.");
        require(msg.sender!=highestBidder,"You are already the highest bidder.");

        if(highestBidder!=address(0)){
            bids[highestBidder]+=highestBid;
        }

        highestBid=msg.value;
        highestBidder=msg.sender;

        emit Bid(msg.sender,msg.value);
    }

    function withDraw() external {
        require(bids[msg.sender]>0,"You have no proceedings to withdraw.");
        uint bal = bids[msg.sender];
        bids[msg.sender]=0;
        (bool success,)=payable(msg.sender).call{value:bal}("");
        require(success,"Withdraw failed.");

        emit Withdraw(msg.sender,bal);
    }

    function endAuction() external {
        require(started,"Auction not yet started");
        require(!ended,"Auction already ended");
        require(block.timestamp>endingTime,"Auction time has not yet passed");
        ended=true;
        if(highestBidder!=address(0)){
            nft.transferFrom(address(this),highestBidder,nftId);
        }else{
            nft.transferFrom(address(this),seller,nftId);
        }
        (bool success,)=seller.call{value:address(this).balance}("");
        require(success,"Transfer to the owner failed");

        emit Ended(highestBidder,highestBid);
    }



}