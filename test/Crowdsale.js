const expectThrow = require('./helpers/expectThrow.js');

var Token = artifacts.require('./Token.sol');
var Crowdsale = artifacts.require('./Crowdsale.sol');
// const Web3 = require('web3');
// var web3 = new Web3(new Web3.providers.HtppProvider("http://localhost:8545"));

contract("Crowdsale", function(accounts) {
	it("keeps track of how many tokens have been sold", async function() {
		let crowdsale = await Crowdsale.new();
		await crowdsale.buy(7, {from: accounts[6]});
		assert.equal(await crowdsale.tokenSold, 7);
	})

	it("must be able to mint new tokens and burn tokens that have not been sold yet", async function() {
		let crowdsale = await Crowdsale.new(10, 10, 1);
		await crowdsale.mint(5);
		let sale_token = await crowdsale.token.call();
		assert.equal(await sale_token.totalTokens.call(), 15);
		await crowdsale.buy(4, {from: accounts[6]});
		await crowdsale.burn(5);
		assert.equal(sale_token.totalTokens.call(), 10);
		await expectThrow(crowdsale.burn(7));
	})

	it("", async function() {
		let token = await Token.new(10);
		await token.burnTokens(5, {from: accounts[0]});
		assert.equal(await token.totalTokens.call(), 5, "Total supply is not correct after burn");
		await expectThrow(token.burnTokens(10));
		await token.addTokens(10);
		assert.equal(await token.totalTokens.call(), 15, "Tokens were not added correctly");
	})
})
