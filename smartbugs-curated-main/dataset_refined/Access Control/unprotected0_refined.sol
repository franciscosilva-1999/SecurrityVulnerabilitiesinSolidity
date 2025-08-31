

 pragma solidity ^0.4.15;

 contract xpto{
     address private owner;

     modifier onlyowner {
         require(msg.sender==owner);
         _;
     }

     function Unprotected()
         public
     {
         owner = msg.sender;
     }

     
     
     function changeOwner(address _newOwner)
         public
     {
        owner = _newOwner;
     }

    
 }
