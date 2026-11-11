
 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.18;

 contract ProposalContract {

     struct Proposal {
         string title; // Title of the proposal
         string description; // Description of the proposal
         uint256 approve; // Number of approve votes
         uint256 reject; // Number of reject votes
         uint256 pass; // Number of pass votes
         uint256 total_vote_to_end; // Vote limit
         bool current_state; // Whether the proposal passes
         bool is_active; // Whether voting is active
     }

     mapping(uint256 => Proposal) proposal_history;

 }
