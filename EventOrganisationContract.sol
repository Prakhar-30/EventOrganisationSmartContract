// SPDX-License-Identifier: Unlicense
pragma solidity >0.5.0 <=0.9.9;
struct Event{
    address organiser;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
}
contract EventContract{
    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextID;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external
     {
             require(date>block.timestamp,"You can organize event for future date");
             require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
             events[nextID] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
             nextID++;
     }     
    function buyTicket(uint id,uint quantity) external payable
    {
             require(events[id].date!=0,"Event does not exist");
             require(events[id].date>block.timestamp,"Event has already occured");
             Event storage _event = events[id];
             require(msg.value==(_event.price*quantity),"Ethere is not enough");
             require(_event.ticketRemain>=quantity,"Not enough tickets");
             _event.ticketRemain-=quantity;
             tickets[msg.sender][id]+=quantity;
     }
    function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
 }
}
