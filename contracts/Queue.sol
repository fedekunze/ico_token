pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 size = 5;
	uint timeLimit = 30 minutes;
	uint private startTime;

	// YOUR CODE HERE
	mapping (address => uint8) positions;
	address[] public line;

	/* Add events */
	// YOUR CODE HERE
	event Timeout();
	event FirstInLine(address _addr);
	event Enqueue(address _addr);
	event Dequeue();

	/* Add constructor */
	// YOUR CODE HERE
	function Queue() {
		// Set the size of the queue
		line.length = size;
	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		// YOUR CODE HERE
		return uint8(line.length);
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		// YOUR CODE HERE
		if (line.length == 0) return true;
		else return false;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		// YOUR CODE HERE
		return line[0];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
		// YOUR CODE HERE
		return positions[msg.sender];
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		// YOUR CODE HERE
		if ((startTime + timeLimit) >= now) {
			dequeue();
			Timeout();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		// YOUR CODE HERE
		/*
			- Get the first person in line
			- Trigger event to notify the first in line
			- Copy the existing line[1:]
			- Delete the first in line from the positions mapping
			- Trigger event Dequeue
		*/
		address firstInLine = getFirst();
		address[] memory arrayNew = new address[](line.length-1);
    for (uint i = 0; i<arrayNew.length; i++){
			address addr = line[i+1];
      arrayNew[i] = addr;
			positions[addr] -= 1;
    }
		line.length -= 1;
    line = arrayNew;
		delete positions[firstInLine];
		Dequeue();
		firstInLine = getFirst();
		FirstInLine(firstInLine);
		startTime = now;
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		// YOUR CODE HERE
		/*
			- Register address in the mapping
			- Extend list one position
			- Append address to list
		*/
		positions[addr] = uint8(line.length);
		line.length = line.length + 1;
		line.push(addr);
		Enqueue(addr);
	}
}
