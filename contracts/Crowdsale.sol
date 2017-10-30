pragma solidity ^0.4.15;

import './Queue.sol';
import './Token.sol';
import './utils/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Contract that deploys `Token.sol`
 * Is timelocked, manages buyer queue, updates balances on `Token.sol`
 */

contract Crowdsale {
	// YOUR CODE HERE
  /*
  Join the Crowdsale
  Buy

  */
  using SafeMath for uint;
 	using SafeMath for uint256;

  // initialize contracts
  Token public token;
  Queue public queue;

  address public owner;

  uint public tokenSaleStart;
  uint public tokenSaleEnds;

  uint public tokenSold;
 	uint public weiRaised;
  uint public weiToToken; //conversion rate

  // dictionary to keep track of balances
  mapping(address => uint) balances;

  // Events
  event Refund(address buyer, uint amount);
  event Purchase(address buyer, uint amount);

  // Modifiers
  modifier isOwner() {
     require(msg.sender == owner);
     _;
   }
   modifier tokenSaleActive() {
     require(now >= tokenSaleStart && now <= tokenSaleEnds);
     _;
   }

  function Cowdsale(uint _totalTokens, uint _queueTimeout, uint saleDuration, uint conversionRate) {
    tokenSold = 0;
    weiRaised = 0;
    owner = msg.sender;
    token = new Token(_totalTokens);
    queue = new Queue(_queueTimeout);

    tokenSaleStart = now;
    tokenSaleEnds = tokenSaleStart + saleDuration;
  }

  function () {
    revert();
  }



}
