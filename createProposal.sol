// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProposalContract {
    enum ProposalStatus { Active, Passed, Failed, Canceled }
    
    struct Proposal {
        string title;
        string description;
        address proposer;
        uint256 startTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalStatus status;
        mapping(address => bool) hasVoted;
    }

    uint256 public minimumVotingPeriod = 1 days;
    uint256 public maximumVotingPeriod = 7 days;
    uint256 public proposalCount;
    
    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public isEligibleVoter;
    
    address public owner;
    
    event ProposalCreated(uint256 indexed proposalId, string title, address proposer, uint256 startTime, uint256 endTime);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalFinalized(uint256 indexed proposalId, ProposalStatus status);
    event VoterStatusChanged(address indexed voter, bool isEligible);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyEligibleVoter() {
        require(isEligibleVoter[msg.sender], "Not eligible to vote");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        isEligibleVoter[msg.sender] = true;
    }

    function createProposal(
        string memory _title,
        string memory _description,
        uint256 _votingPeriod
    ) public onlyEligibleVoter returns (uint256) {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(_votingPeriod >= minimumVotingPeriod && _votingPeriod <= maximumVotingPeriod, 
                "Voting period out of bounds");

        uint256 proposalId = proposalCount++;
        Proposal storage newProposal = proposals[proposalId];
        
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.proposer = msg.sender;
        newProposal.startTime = block.timestamp;
        newProposal.endTime = block.timestamp + _votingPeriod;
        newProposal.status = ProposalStatus.Active;
        
        emit ProposalCreated(proposalId, _title, msg.sender, newProposal.startTime, newProposal.endTime);
        
        return proposalId;
    }
    
    function vote(uint256 _proposalId, bool _support) public onlyEligibleVoter {
        Proposal storage proposal = proposals[_proposalId];
        
        require(proposal.status == ProposalStatus.Active, "Proposal is not active");
        require(block.timestamp >= proposal.startTime, "Voting has not started");
        require(block.timestamp <= proposal.endTime, "Voting has ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");
        
        if (_support) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
        
        proposal.hasVoted[msg.sender] = true;
        
        emit Voted(_proposalId, msg.sender, _support);
    }
    
    function finalizeProposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        
        require(proposal.status == ProposalStatus.Active, "Proposal is not active");
        require(block.timestamp > proposal.endTime, "Voting period not ended");
        
        if (proposal.yesVotes > proposal.noVotes) {
            proposal.status = ProposalStatus.Passed;
        } else {
            proposal.status = ProposalStatus.Failed;
        }
        
        emit ProposalFinalized(_proposalId, proposal.status);
    }
    
    function cancelProposal(uint256 _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        
        require(msg.sender == proposal.proposer || msg.sender == owner, "Not authorized");
        require(proposal.status == ProposalStatus.Active, "Proposal is not active");
        
        proposal.status = ProposalStatus.Canceled;
        emit ProposalFinalized(_proposalId, ProposalStatus.Canceled);
    }
    
    function setVoterEligibility(address _voter, bool _isEligible) public onlyOwner {
        isEligibleVoter[_voter] = _isEligible;
        emit VoterStatusChanged(_voter, _isEligible);
    }
    
    // View functions
    function getProposal(uint256 _proposalId) public view returns (
        string memory title,
        string memory description,
        address proposer,
        uint256 startTime,
        uint256 endTime,
        uint256 yesVotes,
        uint256 noVotes,
        ProposalStatus status
    ) {
        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.title,
            proposal.description,
            proposal.proposer,
            proposal.startTime,
            proposal.endTime,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.status
        );
    }
    
    function hasVoted(uint256 _proposalId, address _voter) public view returns (bool) {
        return proposals[_proposalId].hasVoted[_voter];
    }
    
    function setVotingPeriodLimits(uint256 _minimumVotingPeriod, uint256 _maximumVotingPeriod) public onlyOwner {
        require(_minimumVotingPeriod < _maximumVotingPeriod, "Invalid voting period limits");
        minimumVotingPeriod = _minimumVotingPeriod;
        maximumVotingPeriod = _maximumVotingPeriod;
    }
}
