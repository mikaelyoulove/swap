pragma solidity 0.7.1;

import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/IPancakeRouter02.sol";
import "https://github.com/pancakeswap/pancake-swap-core/blob/master/contracts/interfaces/IERC20.sol";


contract SwapContract {
  address public owner;

//   mainnet
  address pancakeSwapRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
  address constant internal pancakeWBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
// 

// // testnet
//   address pancakeSwapRouter = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
//   address constant internal pancakeWBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd;
// // 

  modifier onlyOwner () {
    require(msg.sender == owner, "This can only be called by the contract owner!");
    _;
  }


  constructor () public {
      owner = msg.sender;
  }
 

  function balanceBNB() onlyOwner public view returns(uint256 balanceEth) {
      balanceEth = address(this).balance;
  }
 

  function balanceToken(address tokenAddress) onlyOwner public view returns(uint256) {
      IERC20 token = IERC20(tokenAddress);
      uint tokenBalance = token.balanceOf(address(this));
      return tokenBalance;
  }
 

  function withdrawBNB() onlyOwner public {
      msg.sender.transfer(address(this).balance);
  }
  
  
  function withdrawToken(address tokenAddress) onlyOwner public {
      IERC20 token = IERC20(tokenAddress);
      uint tokens_amount = balanceToken(tokenAddress);
      token.transfer(msg.sender, tokens_amount);
  }


  function buyTokens(uint BNBAmountToSwap, address tokenAddress, uint32 deadlineTimestamp, uint amountOutMin) onlyOwner external {
      IPancakeRouter02 router = IPancakeRouter02(pancakeSwapRouter);
      address[] memory path = new address[](2);
      path[0] = pancakeWBNB;
      path[1] = tokenAddress;

      router.swapExactETHForTokens{ value: BNBAmountToSwap }(amountOutMin, path,  address(this), deadlineTimestamp);
      
  }
  

  receive() payable external {}
 
}
