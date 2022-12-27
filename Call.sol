// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Receiver {
    event Received(address caller, uint amount, string message);

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract Caller {
    event Response(bool success, bytes data);

    // Let's imagine that contract Caller does not have the source code for the
    // contract Receiver, but we do know the address of contract Receiver and the function to call.
    // This is the other functionality that call provides. We already saw how to transfer ether using Call in payable.sol. In this example, we call the function from 
    // another contract using it.
    // _addr is the address of the contract of whose the function you want to call
    function testCallFoo(address payable _addr) public payable {
        // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123) //The first argument is the function name with argument type in the brackets(don't leave 
            // space in the string and uint256) Rest arguments are the values of the arguments that you want to pass. 
            // If the first arg contains the name of function which doesn't exist in the contract, then the fallback function will be called(If it exists, else error)
            // as shown in next function.
            // Also, bytes memory data is the return value from the function call in bytes.
        );

        emit Response(success, data);
    }

    // Calling a function that does not exist triggers the fallback function if it exists else error. In our case, it exists.
    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );

        emit Response(success, data);
    }
}
