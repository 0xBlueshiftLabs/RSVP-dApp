# RSVP

-- work in progress --

Simple smart contract that allows guests to RSVP for an event by paying a small fee in to the smart contract. Said fee is returned to any guests who attend the event. Any remaining Ether left in the smart contract, a result of guests not attending, is divided up and sent to the guests that did.

Future work will entail incorporating Open Zeppelin’s Safe Math library to prevent the possibility of overflows, and writing tests in Javascript before developing a simple front end using React.
