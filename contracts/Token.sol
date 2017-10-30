pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE

  mapping (address => uint256) balances;
  mapping (address => bool) lockedAccounts;
  mapping (address => mapping (address => uint256)) allowed;
  address owner;

  modifier notLocked(address account) {
      require(!lockedAccounts[account]);
      _;
  }

  modifier isOwner() {
      require(msg.sender == owner);
      _;
  }

  modifier isDebug() {
    require(true);
    _;
  }

  function Token(address _owner) {
    owner = _owner;
  }

  function transfer(address _to, uint256 _value) notLocked(msg.sender) public returns (bool success) {
      //Default assumes totalSupply can't be over max (2^256 - 1).
      //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
      //Replace the if with this one instead.
      //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      if (balances[msg.sender] >= _value && _value > 0) {
          balances[msg.sender] -= _value;
          balances[_to] += _value;
          Transfer(msg.sender, _to, _value);
          return true;
      } else { return false; }
  }

  function transferFrom(address _from, address _to, uint256 _value) notLocked(_from) public returns (bool success) {
      //same as above. Replace this line with the following if you want to protect against wrapping uints.
      //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
          balances[_to] += _value;
          balances[_from] -= _value;
          allowed[_from][msg.sender] -= _value;
          Transfer(_from, _to, _value);
          return true;
      } else { return false; }
  }

  function balanceOf(address _owner) constant public returns (uint256 balance) {
      return balances[_owner];
  }

  function approve(address _spender, uint256 _value) public returns (bool success) {
      allowed[msg.sender][_spender] = _value;
      Approval(msg.sender, _spender, _value);
      return true;
  }

  function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
      return allowed[_owner][_spender];
  }

  /* locks account for address */
  function lockAccount(address account) public {
      lockedAccounts[account] = true;
  }
  /* unlocks account for address, call after everyone has revealed ans has been charged */
  function unlockAccount(address account, uint256 newBalance) public {
      forceUpdate(account, newBalance);
    lockedAccounts[account] = false;
  }
  /* unlocks account for address, call after everyone has revealed ans has been charged */
  function forceUpdate(address account, uint256 newBalance) public {
      /* update total supply after force update */
      totalSupply = totalSupply + newBalance - balances[account];
      balances[account] = newBalance;
  }

  function debugAddTokens(address account, uint amount) isDebug() {
    balances[account] = amount;
  }

  function lockedStatus(address account) public returns(bool) {
      return lockedAccounts[account];
  }

}
