// SPDX-License-Identifier: MIT

pragma solidity ^0.7.5;


contract rsvp {
    
    address owner;
    bool public currentEvent;
    uint rsvpCost;
    
    address[] RSVPs;
    mapping(address => bool) RSVPstatus;
    
    address[] checkedInAddresses;
    mapping(address => bool) checkedIn;
    
    
    constructor() {
        owner = msg.sender;
        currentEvent = false;
    }
    
    
    modifier onlyOwner() {
        require(owner == msg.sender, "Only the event organiser has permission.");
        _;
    }
    
    
    function createEvent(uint _rsvpCost) external { // event creation
        require(currentEvent == false, "There is already an ongoing event.");
        rsvpCost = _rsvpCost;
        currentEvent = true;
    }
    
    
    function cancelEvent() external onlyOwner { // returns all RSVP stakes to guests
        
        for (uint i=0; i<RSVPs.length; i++) {
            payable(RSVPs[i]).transfer(rsvpCost); // refunds RSVPers the RSVP cost
        }
        
        reset();
    }
    
    
    function guestRSVPing() external payable {
        // TO DO -- add rsvp cut off date / time
        require(currentEvent == true, "No event to RSVP."); // checks there is an event on
        require(RSVPstatus[msg.sender] == false, "You have already RSVP'd."); // checks they havent already RSVP'd
        require(rsvpCost >= msg.value, "Wrong amount sent."); // checks guest send enough
        RSVPstatus[msg.sender] = true;
        RSVPs.push(msg.sender); // adds address to list of RSVPs
    }
    
    
    function guestCheckIn(address _guestAddress) external onlyOwner {
        require(currentEvent == true, "No event to check in at."); // checks there is an event on
        require(RSVPstatus[_guestAddress], "Guest did not RSVP."); // checks they RSVP'd
        require(checkedIn[msg.sender] == false, "Already checked in."); // checks they havent already checked in
        checkedIn[_guestAddress] = true;
        checkedInAddresses.push(_guestAddress);
    }
    
    
    function payout() external onlyOwner {
        if (RSVPs.length != checkedInAddresses.length) { // checks the difference isn't zero
            uint potShare = getBalance() / (checkedInAddresses.length);
            for (uint i=0; i<checkedInAddresses.length; i++) {
                payable(checkedInAddresses[i]).transfer(potShare); // transfers potShare to each checked in address
            }
        }
        
        reset();
    }
    
    function reset() internal { // re-initializes contract
        currentEvent = false;
        delete RSVPs; // clears list
        delete checkedInAddresses; // clears list
    }
    
    function getBalance() public view returns(uint) { // returns balance of smart contract
        return address(this).balance;
    }
    
}
