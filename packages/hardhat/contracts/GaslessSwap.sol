// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/// @title GaslessSwap
/// @author alieraay
/// @notice Gasless Swap dapp that allows swapping between mock Ether (METH) and mock USDC (MUSDC)

interface IMockEther {
	function mint(address to, uint256 amount) external;

	function balanceOf(address account) external view returns (uint256);

	function transfer(address to, uint256 value) external returns (bool);

	function transferFrom(
		address from,
		address to,
		uint256 value
	) external returns (bool);
}

interface IMockUSDC {
	function mint(address to, uint256 amount) external;

	function balanceOf(address account) external view returns (uint256);

	function transfer(address to, uint256 value) external returns (bool);

	function transferFrom(
		address from,
		address to,
		uint256 value
	) external returns (bool);
}

contract GaslessSwap {
	event LiquidityAdded(uint256 indexed _liquidityAmount);

	IMockEther private mockEther;
	IMockUSDC private mockUSDC;

	address public methAddress;
	address public musdcAddress;

	uint256 public exchangeRate = 2000;

	constructor(address _methAddress, address _musdcAddress) {
		methAddress = _methAddress;
		musdcAddress = _musdcAddress;

		mockEther = IMockEther(_methAddress);
		mockUSDC = IMockUSDC(_musdcAddress);
	}

	/// @notice Adds liquidity to the contract for swapping
	/// @param amount The amount of liquidity to be added for meth pair
	function addLiquidity(uint256 amount) public {
		mockEther.mint(address(this), amount);
		mockUSDC.mint(address(this), amount * exchangeRate);

		emit LiquidityAdded(amount);
	}

	/// @notice Swaps mock Ether to mock USDC
	/// @param amount The amount of mock Ether to be swapped
	function swapMethToUSDC(uint256 amount) public {
		require(amount > 0, "Amount must be greater than 0");
		require(
			mockEther.balanceOf(msg.sender) >= amount,
			"Insufficient METH balance"
		);
		require(
			mockUSDC.balanceOf(address(this)) >= amount * exchangeRate,
			"Insufficient liquidity"
		);

		require(
			mockEther.transferFrom(msg.sender, address(this), amount),
			"METH transfer failed"
		);

		mockUSDC.transfer(msg.sender, amount * exchangeRate);
	}

	function swapUSDCToMeth(uint256 amount) public {
		require(amount > 0, "Amount must be greater than 0");
		require(
			mockUSDC.balanceOf(msg.sender) >= amount,
			"Insufficient MUSDC balance"
		);
		require(
			mockEther.balanceOf(address(this)) >= (amount * 1) / exchangeRate,
			"Insufficient liquidity"
		);

		require(
			mockUSDC.transferFrom(
				msg.sender,
				address(this),
				(amount * 1) / exchangeRate
			),
			"MUSDC transfer failed"
		);

		mockEther.transfer(msg.sender, (amount * 1) / exchangeRate);
	}

	/// @notice Sets a new exchange rate for METH to USDC
	/// @param newExchangeRate The new exchange rate to be set
	function setExchangeRate(uint256 newExchangeRate) public {
		exchangeRate = newExchangeRate;
	}

	/// @notice Returns the current balance of the liquidty pool
	function liquidityAmount() public view returns (uint256, uint256) {
		uint256 methBalance = mockEther.balanceOf(address(this));
		uint256 musdcBalance = mockUSDC.balanceOf(address(this));
		return (methBalance, musdcBalance);
	}

	/// @notice Returns the current exchange rate
	/// @return The current exchange rate
	function getExchangeRate() public view returns (uint256) {
		return exchangeRate;
	}
}
