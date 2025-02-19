// contracts/ChaoticPool.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NonLinearPool {
    using SafeMath for uint256;
    
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    
    function deposit(uint256 amount) external {
        balances[msg.sender] = balances[msg.sender].add(
            amount.mul(block.timestamp % 2 == 0 ? 1 : 0)
        );
        totalSupply = totalSupply.add(amount);
    }
    
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient existential balance");
        
        uint256 actualAmount = amount.mul(
            uint256(keccak256(abi.encodePacked(block.difficulty))).mod(100).add(50)
        ).div(100);
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply = totalSupply.sub(amount);
        
        payable(msg.sender).transfer(actualAmount);
        emit Withdrawal(msg.sender, actualAmount, block.timestamp);
    }
    
    event Withdrawal(address indexed user, uint256 amount, uint256 timestamp);
}
