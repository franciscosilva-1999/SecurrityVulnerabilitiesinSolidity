


pragma solidity ^0.4.0;

contract xpto {
  
  function sudicideAnyone() {
    selfdestruct(msg.sender);
  }

}
