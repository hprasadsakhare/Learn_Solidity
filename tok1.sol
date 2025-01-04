// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GreenSRewardSystem is ERC20 {
    address public owner;
    uint256 public rewardRatePerKm; // Reward tokens per km

    // Tracks the total kilometers traveled by each user
    mapping(address => uint256) public kilometersTraveled;

    // Tracks the rewards earned but not yet claimed by each user
    mapping(address => uint256) public unclaimedRewards;

    event TravelRecorded(address indexed user, uint256 kilometers, uint256 reward);
    event RewardsClaimed(address indexed user, uint256 rewardAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(uint256 _rewardRatePerKm) ERC20("GreenS", "GRS") {
        require(_rewardRatePerKm > 0, "Reward rate must be greater than 0");
        _mint(msg.sender, 100_000_000 * 10**18); // Mint 100M tokens to the owner
        rewardRatePerKm = _rewardRatePerKm;
        owner = msg.sender;
    }

    // Record kilometers traveled by a user and calculate rewards
    function recordTravel(address user, uint256 kilometers) external onlyOwner {
        require(user != address(0), "Invalid user address");
        require(kilometers > 0, "Kilometers must be greater than 0");

        // Update the total kilometers traveled by the user
        kilometersTraveled[user] += kilometers;

        // Calculate rewards
        uint256 reward = kilometers * rewardRatePerKm;

        // Ensure sufficient tokens are available in the owner's balance
        require(balanceOf(owner) >= reward, "Insufficient reward tokens available");

        // Update unclaimed rewards
        unclaimedRewards[user] += reward;

        emit TravelRecorded(user, kilometers, reward);
    }

    // Allow users to claim their rewards
    function claimRewards() external {
        uint256 reward = unclaimedRewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        // Reset unclaimed rewards for the user
        unclaimedRewards[msg.sender] = 0;

        // Transfer reward tokens to the user
        _transfer(owner, msg.sender, reward);

        emit RewardsClaimed(msg.sender, reward);
    }

    // Update the reward rate per km (only owner)
    function updateRewardRate(uint256 newRate) external onlyOwner {
        require(newRate > 0, "Reward rate must be greater than 0");
        rewardRatePerKm = newRate;
    }
}
