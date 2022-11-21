// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet{

    event Deposit(address indexed sender,uint indexed amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner,uint indexed txId);
    event Revoke(address indexed owner,uint indexed txId);
    event Execute(uint indexed txId);

    struct Transection {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address=>bool) public isOwner;
    uint public requiredNumberOfApprovals;
    uint public transectionIdCounter;

    Transection[] public transections;
    mapping(uint=>mapping(address=>bool)) public approved;

    constructor(address[] memory _owners,uint _requiredNumberOfApprovals){
        require(_owners.length>0,"Owner's not added");
        require(_requiredNumberOfApprovals>0 && _requiredNumberOfApprovals<=_owners.length,"Invalid required numbers of owners.");
        for(uint x = 0;x<_owners.length;x++){
            address owner =_owners[x]; 
            require(owner!=address(0),"Owner cannot be zero address");
            require(!isOwner[owner],"Duplicate address in _owners present");
            isOwner[owner]=true;
            owners.push(owner);
        }
         requiredNumberOfApprovals=_requiredNumberOfApprovals;
         transectionIdCounter=0;
    }

    modifier onlyOwner(){
        require(isOwner[msg.sender],"You are not the owner of this wallet");
        _;
    }

    modifier txExists(uint _txId){
        require(_txId<transectionIdCounter,"Transection Id does not exists");
        _;
    }

    modifier notAlreadyApproved(uint _txId){
        require(!approved[_txId][msg.sender],"Transection already approved");
        _;
    }

    modifier notExecuted(uint _txId){
        require(!transections[_txId].executed,"Transection already executed");
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender,msg.value);
    }

    function proposeATransection(address _to,uint _value,bytes calldata _data) external onlyOwner {
        transections.push(Transection({
            to:_to,
            value:_value,
            data:_data,
            executed:false
        }));
        emit Submit(transectionIdCounter);
        transectionIdCounter+=1;
    }

    function approveTransection(uint _txId) 
        external
        onlyOwner
        txExists(_txId) 
        notAlreadyApproved(_txId)
        notExecuted(_txId)
    {
        approved[_txId][msg.sender]=true;
        emit Approve(msg.sender,_txId);
    }

    function revokeApproval(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(approved[_txId][msg.sender],"Transection already unapproved");
        approved[_txId][msg.sender]=false;
        emit Revoke(msg.sender,_txId);
    }

    function getApprovalCount(uint _txId) public view returns(uint){
        uint counter=0;
        for(uint x = 0;x<owners.length;x++){
            if(approved[_txId][owners[x]]){
                counter+=1;
            }
        }
        return counter;
    }

    function execute(uint _txId) 
        external 
        txExists(_txId) 
        notExecuted(_txId)
    {
        uint noOfApprovals=getApprovalCount(_txId);
        require(noOfApprovals>=requiredNumberOfApprovals,"Not enough approvals");
        Transection storage transection=transections[_txId];
        transection.executed=true;
        address to=transection.to;
        uint value=transection.value;
        bytes memory data=transection.data;
        (bool success,)=to.call{value:value}(data);
        require(success,"Transection failed");
        emit Execute(_txId);
    }

}