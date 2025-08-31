

pragma solidity ^0.4.24;

contract xpto {

  address owner;

  constructor() public {
    owner = msg.sender;
  }

  function forward(address callee, bytes _data) public {
    
    require(callee.delegatecall(_data)); 
  }

}
