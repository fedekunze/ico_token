pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './utils/SafeMath.sol' ;

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {
	// YOUR CODE HERE
  uint public totalTokens;
  mapping (address => uint256) balances;
  mapping (address => mapping (address => uint256)) allowed;
  address owner;

  using SafeMath for uint;
 	using SafeMath for uint256;

  modifier isOwner() {
      require(msg.sender == owner);
      _;
  }

  function Token(uint _totalTokens) {
    owner = msg.sender;
    balances[owner] = _totalTokens;
    totalTokens = _totalTokens;

  }


  function balanceOf(address _owner) constant public returns (uint256 balance) {
      return balances[_owner];
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
      //Default assumes totalSupply can't be over max (2^256 - 1).
      //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
      //Replace the if with this one instead.
      //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      if (balances[msg.sender] >= _value && _value > 0) {
          balances[msg.sender].sub(_value);
          balances[_to].add(_value);
          Transfer(msg.sender, _to, _value);
          return true;
      } else { return false; }
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      //same as above. Replace this line with the following if you want to protect against wrapping uints.
      //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
      uint256 approved = allowed[_from][msg.sender];
      if (balances[_from] >= _value && approved >= _value && _value > 0) {
          balances[_to] = balances[_to].add(_value);
          balances[_from] = balances[_from].sub(_value);
          approved = approved.sub(_value);
          Transfer(_from, _to, _value);
          return true;
      } else { return false; }
  }


  function approve(address _spender, uint256 _value) public returns (bool success) {
      allowed[msg.sender][_spender] = _value;
      Approval(msg.sender, _spender, _value);
      return true;
  }

  function approveRefund(address _addr, uint256 _value) isOwner() public returns (bool success) {
    allowed[_addr][msg.sender] = _value;
    Approval(_addr, msg.sender, _value);
    return true;
 }

 function burnTokens(uint _amount) isOwner() public {
   if (balances[owner] >= _amount) {
     totalTokens = totalTokens.sub(_amount);
     balances[owner] = balances[owner].sub(_amount);
   }
 }

 function addTokens(uint256 _amount) isOwner() public {
   totalTokens = totalTokens.add(_amount);
   balances[owner] = balances[owner].add(_amount);
 }


  function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
      return allowed[_owner][_spender];
  }

}
