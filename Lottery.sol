//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 < 0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor(){
        manager=msg.sender; //manager is the administrator of lottery process
    }

    receive() external payable {
        require(msg.value==1 ether); //check if 1 ether is transferred from the account(fee of buying lottery) to the contract
        participants.push(payable(msg.sender)); //push the lottery buyer's address in participants array
    }

    function getBalance() public view returns (uint){
        require(msg.sender==manager); //only manager can check the balance
        return address(this).balance; //contracts balance
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));//generate a random number
    }

    function selectWinner() public {
        require(msg.sender==manager); //only manager can select the winner
        require(participants.length>=3); //minimum persons buying the lottery should be 3
        uint r=random(); //random number
        
        uint index=r%participants.length; //index of array
        address payable winner=participants[index]; //selecting the winner
        winner.transfer(getBalance()); //transfer lottery winning price(here all price in the contract)  to the winner
        participants=new address payable[](0);//to make participants array empty(reset)

    }
}