// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
	constructor() ERC20("MockUSDC", "MUSDC") {}

	function mint(address to, uint256 amount) external {
		_mint(to, amount);
	}

}
