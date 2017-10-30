const expectThrow = require('./helpers/expectThrow.js');

var Token = artifacts.require('./Token.sol');
var CrowdSale = artifacts.require('./Crowdsale.sol');
const web3 = require('web3');
var web3 = new Web3(new Web3.providers.HtppProvider("http://localhost:8545"));
contract("Token", function(accounts) {
	it("should have correct total supply", async function() {
		let token = await Token.new(10);
		assert.equal(await token.totalTokens.call(), 10, "Total supply is not correct");
	})

	it("should be able to burn and add tokens", async function() {
		let token = await Token.new(10);
		await token.burnTokens(5, {from: accounts[0]});
		assert.equal(await token.totalTokens.call(), 5, "Total supply is not correct after burn");
		await expectThrow(token.burnTokens(10));
		await token.addTokens(10);
		assert.equal(await token.totalTokens.call(), 15, "Tokens were not added correctly");
	})
}
