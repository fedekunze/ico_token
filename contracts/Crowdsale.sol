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

  function Cowdsale(uint _totalTokens, uint saleDuration, uint conversionRate) {
    tokenSold = 0;
    weiRaised = 0;
    owner = msg.sender;
    token = new Token(_totalTokens);
    queue = new Queue();

    tokenSaleStart = now;
    tokenSaleEnds = tokenSaleStart + saleDuration;

    weiToToken = conversionRate;
  }

  function () {
    revert();
  }

  function buy()
    tokenSaleActive()
    payable
    public
    returns(bool)
   {
     if (queue.getFirst() == msg.sender) {
       queue.dequeue();

       uint tokensGranted = msg.value.div(weiToToken);
       uint refund = msg.value.sub(tokensGranted.mul(weiToToken));
       balances[msg.sender] = refund;

       token.transfer(msg.sender, tokensGranted);
       tokenSold += tokensGranted;
			 return true;
     }
     return false;
   }

   function withdrawRefund()
    tokenSaleActive()
    external
    returns(bool)
   {
    if (balances[msg.sender] > 0) {
 		uint transferAmount = balances[msg.sender];
 	  balances[msg.sender] = 0;
 	  msg.sender.transfer(transferAmount);
 		return true;
    } else {
      return false;
    }
 	}

  function refund()
    tokenSaleActive()
    public
  {
    uint tokensBalance = token.balanceOf(msg.sender);
    token.approveRefund(msg.sender, tokensBalance);
    token.transferFrom(msg.sender, address(this), tokensBalance);

    uint refundedAmount = tokensBalance.mul(weiToToken);
    balances[msg.sender] = refundedAmount;
    tokenSold -= tokensBalance;
  }

  function mint(uint256 _amount) isOwner() public {
    token.addTokens(_amount);
  }

  function burn(uint256 _amount) isOwner() public {
    token.burnTokens(_amount);
  }

}
