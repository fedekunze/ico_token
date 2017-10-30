const expectThrow = require('./helpers/expectThrow.js');

var Queue = artifacts.require('./Queue.sol');
const web3 = require('web3');
var web3 = new Web3(new Web3.providers.HtppProvider("http://localhost:8545"));
contract("Queue", function(accounts) {
	it("must have basic functionality", async function() {
		let queue = await Queue.new();
		let queuesize = await queue.qsize();
		assert.equal(queuesize, 0);
		assert.equal(await queue.empty(), true);
		await queue.enqueue(accounts[9]);
		assert.equal(await queue.empty(), false);
		assert.equal(await queue.qsize(), 1);
		let first = await queue.getFirst();
		assert.equal(first, accounts[9]);
		let place = await queue.checkPlace({from: accounts[9]});
		assert.equal(place, 1);
		await queue.enqueue(accounts[8]);
		assert.equal(await queue.checkPlace({from: accounts[8]}), 2);
		await queue.dequeue();
		assert.equal(await queue.getFirst(), accounts[10]);
	})

	it("should not allow more than 5 people to be on queue", async function() {
		let queue = await Queue.new();
		await queue.enqueue(accounts[9]);
		await queue.enqueue(accounts[8]);
		await queue.enqueue(accounts[7]);
		await queue.enqueue(accounts[6]);
		await queue.enqueue(accounts[5]);
		assert(await queue.qsize(), 5);
		await expectThrow(queue.enqueue(accounts[4]));
	}
})
