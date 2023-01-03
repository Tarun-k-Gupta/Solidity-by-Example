// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address, uint) external;
}

contract Token {
    event Log(string);
    function transfer(address, uint) external {
      emit Log("yoyo");
    }
}

contract AbiEncode {
    function test(address _contract, bytes calldata data) external {
        (bool ok, ) = _contract.call(data); // here data is the signature of transfer function, so transfer function of Token contract will be called.
        require(ok, "call failed");
    }

    function encodeWithSignature(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Typo is not checked - "transfer(address, uint)" (typo because space is not allowed bw arguments and uint256 should be written. But still with these typos, code compiles)
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount); // This returns the data that you will pass to test function which will in turn call transfer function of Token contract.
    }

    function encodeWithSelector(
        address to,
        uint amount
    ) external pure returns (bytes memory) {
        // Type is not checked - (IERC20.transfer.selector, true, amount) (Here if you write transfers then compile error but if u will pass wrong argument eg bool instead of address then no error)
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount); // Or if you don't want to use IERC20, then Token(to).transfer.selector in 1st argument.
    }

    function encodeCall(address to, uint amount) external pure returns (bytes memory) {
        // Typo and type errors will not compile (compile errors if wrong argument is passed or function name wrong. So this is best among above two).
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}
