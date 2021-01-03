// SPDX-License-Identifier: MIT
pragma solidity 0.7.4;


contract Ownable {
  address payable public owner;

  event OwnershipTransferred(address newOwner);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner!");
    _;
  }

  function transferOwnership(address payable newOwner) onlyOwner public {
    owner = newOwner;
    emit OwnershipTransferred(owner);
  }
  
}
