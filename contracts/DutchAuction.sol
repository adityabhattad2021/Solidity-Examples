// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This will be an example code for a dutch auction for an NFT sale.
// In Ductch auction price of the entity is by default set to high by the seller, It goes down gradually 
// someone decides to buy the entity and end the auction.

// You have to deploy an sample ERC721 contract in order to test this auction :)
interface IERC721 {

    function transferFrom (
        address _from,
        address _to,
        uint _tokenId
    ) external;

}

contract DutchAuction {

    uint private constant DURATION = 7 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startingTime;
    uint public immutable endingTime;
    uint public immutable discountRate;


    constructor(
        uint _startingPriceInWEI,
        uint _discountRate,
        address _nft,
        uint _nftId
    ) {
        seller=payable(msg.sender);
        startingPrice=_startingPriceInWEI;
        discountRate=_discountRate;
        require(
            _startingPriceInWEI>=_discountRate*DURATION,
            "Starting price cannot be less than final discount to be given."
        );
        nft=IERC721(_nft);
        nftId=_nftId;
        startingTime=block.timestamp;
        endingTime=block.timestamp+DURATION;
    }

    function getCurrentPrice() public view returns(uint){
        // Price in WEI
        uint timeElapsed=(block.timestamp-startingTime);
        uint discount=discountRate*timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable  {
        uint currentPrice=getCurrentPrice();
        require(msg.value>=currentPrice,"Insufficient amount paid");
        nft.transferFrom(seller,msg.sender,nftId);
        uint refundAmount=msg.value-currentPrice;
        if(refundAmount>0){
          (bool success,) = payable(msg.sender).call{value:refundAmount}("");
           require(success,"Refund transfer failed");
        }
        selfdestruct(seller);
    }



}