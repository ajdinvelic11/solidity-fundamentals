
 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.18;

 contract ProposalContract {

     address public owner;
     uint256 private counter;

     struct Proposal {
         string title;
         string description;
         uint256 approve;
         uint256 reject;
         uint256 pass;
         uint256 total_vote_to_end;
         bool current_state;
         bool is_active;
     }

     mapping(uint256 => Proposal) private proposal_history;
     address[] private voted_addresses;

     constructor() {
         owner = msg.sender;
         voted_addresses.push(msg.sender);
     }

     modifier onlyOwner() {
         require(msg.sender == owner, "Only owner allowed");
         _;
     }

     modifier active() {
         require(
             proposal_history[counter].is_active,
             "The proposal is not active"
         );
         _;
     }

     modifier newVoter(address voter) {
         require(voter != owner, "Owner cannot vote");
         require(!isVoted(voter), "Address has already voted");
         _;
     }

     function setOwner(address new_owner) external onlyOwner {
         require(new_owner != address(0), "Invalid owner");
         owner = new_owner;
     }

     function create(
         string calldata _title,
         string calldata _description,
         uint256 _total_vote_to_end
     ) external onlyOwner {
         require(_total_vote_to_end > 0, "Invalid vote limit");

         counter += 1;

         proposal_history[counter] = Proposal(
             _title,
             _description,
             0,
             0,
             0,
             _total_vote_to_end,
             false,
             true
         );

         delete voted_addresses;
         voted_addresses.push(owner);
     }

     function vote(uint8 choice) external active newVoter(msg.sender) {
         require(choice <= 2, "Invalid vote choice");

         Proposal storage proposal = proposal_history[counter];

         voted_addresses.push(msg.sender);

         if (choice == 1) {
             proposal.approve += 1;
         } else if (choice == 2) {
             proposal.reject += 1;
         } else {
             proposal.pass += 1;
         }

         proposal.current_state = calculateCurrentState();

         uint256 total_vote =
             proposal.approve + proposal.reject + proposal.pass;

         if (total_vote >= proposal.total_vote_to_end) {
             proposal.is_active = false;
             delete voted_addresses;
             voted_addresses.push(owner);
         }
     }

     // Assignment 4: Custom absolute-majority voting logic
     function calculateCurrentState() private view returns (bool) {
         Proposal storage proposal = proposal_history[counter];

         return proposal.approve >
             (proposal.reject + proposal.pass);
     }

     function isVoted(address voter) public view returns (bool) {
         for (uint256 i = 0; i < voted_addresses.length; i++) {
             if (voted_addresses[i] == voter) {
                 return true;
             }
         }
         return false;
     }

     function getCurrentProposal()
         external
         view
         returns (Proposal memory)
     {
         return proposal_history[counter];
     }
 }
