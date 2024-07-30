// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

interface IDimoCredit is IAccessControl {
    function dimoCreditRate() external view returns (uint256);
    function periodValidity() external view returns (uint256);
    function receiver() external view returns (address);
    function dimoToken() external view returns (address);
    function provider() external view returns (address);
    function decimals() external pure returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function burn(address from, uint256 amount) external;
    function mintInDimo(address to, uint256 amountDimo) external returns (uint256 dimoCredits);
    function mintInDimo(address to, uint256 amountDimo, bytes calldata data) external returns (uint256 dimoCredits);
    function mint(address to, uint256 amountDimoCredits) external;
    function mint(address to, uint256 amountDimoCredits, bytes calldata data) external;
    function updatePrice(bytes calldata data) external;
    function setDimoCreditRate(uint256 dimoCreditRateInWei_) external;
    function setDimoTokenAddress(address dimoTokenAddress_) external;
    function setPriceProviderAddress(address providerAddress_) external;
    function setReceiverAddress(address receiver_) external;
    function setPeriodValidity(uint256 periodValidity_) external;
}
