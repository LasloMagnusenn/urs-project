// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract RaffleToken is ERC20 {

  uint  public i = 2;
    constructor() ERC20("RaffleToken Test", "RRR") {}

    function mint(address to, uint256 amount) public  {
        _mint(to, amount);
    }

    
}