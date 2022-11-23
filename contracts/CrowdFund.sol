// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "./ERC20.sol";

contract CrowdFund{

    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startsAt,
        uint32 endsAt
    );

    event Cancel(uint id);

    event Pledge(uint indexed id,address indexed caller,uint amount);

    event Unpledge(uint indexed id,address indexed caller,uint amount);

    event Claimed(uint id,uint amount);

    event Refunded(uint indexed id,address indexed,uint caller);

    struct Campaign{
        address creator;
        uint goal;
        uint pledged;
        uint32 startsAt;
        uint32 endsAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint public count;
    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public campaignIdToPlegedAmount;

    constructor(
        address _token
    ) {
        token=IERC20(_token);
        // It is 0 by default but, being explicit (good practice).
        count=0;
    }

    
    function launch (
        uint _goal,
        uint32 _startsAt,
        uint32 _endsAt
    ) external {

        require(_startsAt >= block.timestamp,"Starts at cannot be less than now.");
        require(_endsAt >= _startsAt,"Campaign cannot end before starting it.");
        require(_endsAt <= _startsAt + 90 days,"Ends at exeeds the max duration allowed for the a campaign");
        count+=1;
        Campaign storage campaign=campaigns[count];
        campaign.creator=msg.sender;
        campaign.goal=_goal;
        campaign.startsAt=_startsAt;
        campaign.endsAt=_endsAt;
        campaign.claimed=false;

        emit Launch(count,msg.sender,_goal,_startsAt,_endsAt);

    }

    function cancel(uint _id) external {

        Campaign memory campaign=campaigns[_id];
        require(msg.sender==campaign.creator,"Caller not the creater of this campaign.");
        require(campaign.startsAt>block.timestamp);
        delete campaigns[_id];

        emit Cancel(_id);

    }

    function pledge(uint _id,uint _amount) external {
        Campaign storage campaign=campaigns[_id];
        require(block.timestamp >= campaign.startsAt,"Campaign has not started yet.");
        require(block.timestamp <= campaign.endsAt ,"Campaign has alreay ended.");
        campaign.pledged+=_amount;
        campaignIdToPlegedAmount[_id][msg.sender]+=_amount;
        token.transferFrom(msg.sender,address(this),_amount);

        emit Pledge(_id,msg.sender,_amount);

    }

    function unpledge(uint _id,uint _amount) external {

        Campaign storage campaign=campaigns[_id];
        require(block.timestamp>=campaign.startsAt,"Campaign has not started yet.");
        require(block.timestamp<=campaign.endsAt,"Campaign has already ended.");
        uint amountPledgedBySender = campaignIdToPlegedAmount[_id][msg.sender];
        require(amountPledgedBySender>_amount,"Amount pledge should be more that amount to be withdrawn");
        campaign.pledged-=_amount;
        campaignIdToPlegedAmount[_id][msg.sender]-=_amount;
        token.transfer(msg.sender,_amount);

        emit Unpledge(_id,msg.sender,_amount);

    }

    function claim(uint _id) external {

        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator,"Caller not the creater of this campaign.");
        require(block.timestamp > campaign.endsAt,"Campaign not ended yet.");
        require(campaign.pledged >= campaign.goal,"Campaign's total pledged amount > campaign's predefined goal");
        require(!campaign.claimed,"Tokens already claimed");

        campaign.claimed=true;
        token.transfer(msg.sender,campaign.pledged);

        emit Claimed(_id,campaign.pledged);

    }       

    function refund(uint _id) external {

        Campaign storage campaign = campaigns[_id];
        require(block.timestamp>campaign.endsAt,"Campaign not ended yet.");
        require(campaign.pledged<campaign.goal,"Cannot refund as campaign was successful");

        uint amountToBeRefunded=campaignIdToPlegedAmount[_id][msg.sender];
        campaignIdToPlegedAmount[_id][msg.sender]=0;
        campaign.pledged-=amountToBeRefunded;
        token.transfer(msg.sender,amountToBeRefunded);

        emit Refunded(_id,msg.sender,amountToBeRefunded);

    }

}