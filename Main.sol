pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    address public winner;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum payment is 0.01 ether");
        
        players.push(payable(msg.sender));
    }

    function pickWinner() public restricted {
        uint index = random() % players.length;
        
        players[index].transfer(address(this).balance);
        winner = players[index];
        
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
    
    modifier restricted() {
        require(msg.sender == manager, "Only manager can pick the winner");
        _;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
}
