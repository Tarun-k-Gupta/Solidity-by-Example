// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Example: A calls B sends 100 wei, B calls C sends 50 wei 
// A --> B --> C
//            For Contract C, msg.sender = B, msg.value = 50, execute code on C's state variables, uses ether of C if rqd.

// A calls B sends 100 wei, B delegates call to C 
// A --> B --> C
//            For Contract C, msg.sender = A, msg.value = 100, execute code on B's state variables, uses ether of B if rqd.


// NOTE: Deploy this contract first
contract B {
    // NOTE: storage layout must be the same as contract A else weird results
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint public num;
    address public sender;
    uint public value;

    // When contract A executes delegatecall to contract B, B's code is executed
    // with contract A's storage, msg.sender and msg.value.
    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
