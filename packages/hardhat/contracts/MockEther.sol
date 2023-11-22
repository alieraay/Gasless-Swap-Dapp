// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockEther is ERC20 {
	constructor() ERC20("MockETH", "METH") {}

	function mint(address to, uint256 amount) external {
		_mint(to, amount);
	}
}
