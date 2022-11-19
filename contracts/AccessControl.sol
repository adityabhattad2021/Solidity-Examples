// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Tried to implement Clash of Clans's, Clan access control structure.
contract AccessControl {
    event GrantRole(bytes32 indexed role,address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address=>bool)) public roles;

    bytes32 public constant LEADER=keccak256(abi.encodePacked("LEADER"));
    bytes32 public constant COLEADER=keccak256(abi.encodePacked("COLEADER"));
    bytes32 public constant MEMBER=keccak256(abi.encodePacked("MEMBER"));

    modifier onlyRole(bytes32 role){
        require(roles[role][msg.sender] || roles[LEADER][msg.sender],"You are unauthorized");
        _;
    }

    modifier onlyLeader(){
        require(roles[LEADER][msg.sender],"You are unauthorized to access this function.");
        _;
    }

    constructor(){
        _grantRole(LEADER,msg.sender);
    }

    function _grantRole(bytes32 _role,address _account) internal {
        roles[_role][_account]=true;
        emit GrantRole(_role,_account);
    }

    function grantRole(bytes32 _role,address account) external onlyRole(COLEADER) {
        _grantRole(_role,account);
    }

    function _revokeRole(bytes32 _role,address _account) internal  {
        roles[_role][_account]=false;
        emit RevokeRole(_role,_account);
    }

    function revokeRole(bytes32 _role,address _account) external onlyLeader {
        _revokeRole(_role,_account);
    }
}
