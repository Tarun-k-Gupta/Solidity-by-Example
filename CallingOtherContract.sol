// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        value = msg.value;

        return (x, value);
    }
}

contract Caller {
    // _callee is the address of contract(so technically it should be declared as address) but if you declare it as Callee, you can directly call functions. Else, do as done in setXFromAddress function.
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }

    function setXFromAddress(address _addr, uint _x) public {
        // _addr.setX(_x) is wrong because you can't call functions using address. 
        Callee callee = Callee(_addr);
        callee.setX(_x); // Or Callee(_addr).setX(_x); if you want to do in 1 line.
    }

    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}
