'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Crowdsale.sol");
const Token = artifacts.require('./Token.sol');
const Queue = artifacts.require('./Queue.sol');
// YOUR CODE HERE

contract('testTemplate', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */

	var crowdsale;
	var token;
	var queue;


	const args = {};
	let x, y, z;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		// YOUR CODE HERE
		return Crowdsale.new(7, 2, 100, 1, 2, 1, [accounts[4]], [accounts[3]], {from: accounts[0]}).then(crowdInstance => {
      crowdsale = crowdInstance;
			return crowdsale.token.call().then(tokenAddr => {
				token = Token.at(tokenAddr);
				return crowdsale.queue.call().then(queueAddr => {
					queue = Queue.at(queueAddr);
				})
			})
		})
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Your string here', function() {
		it("your string here", async function() {
			// YOUR CODE HERE
		});
		// YOUR CODE HERE
	});

	describe('Your string here', function() {
		// YOUR CODE HERE
	});
});
