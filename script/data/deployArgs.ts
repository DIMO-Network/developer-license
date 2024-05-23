import { ethers } from 'ethers';

const _hashRole = (role: string) =>
    ethers.keccak256(ethers.toUtf8Bytes(role));

export const licenseCostInUsd = BigInt("1000000000000000000");

export const DEFAULT_ADMIN_ROLE = "0x0000000000000000000000000000000000000000000000000000000000000000";

// License roles
export const LICENSE_ADMIN_ROLE = _hashRole("LICENSE_ADMIN_ROLE");
export const REVOKER_ROLE = _hashRole("REVOKER_ROLE");

// Oracle Source role
export const ORACLE_ADMIN_ROLE = _hashRole("ORACLE_ADMIN_ROLE");

// DIMO Credit roles
export const DC_ADMIN_ROLE = _hashRole("DC_ADMIN_ROLE");
export const UPGRADER_ROLE = _hashRole("UPGRADER_ROLE");
export const BURNER_ROLE = _hashRole("BURNER_ROLE");

// Normalized Price Provider roles
export const PROVIDER_ADMIN_ROLE = _hashRole("PROVIDER_ADMIN_ROLE");
export const UPDATER_ROLE = _hashRole("UPDATER_ROLE");

export const METADATA_DESCRIPTION = "This is an NFT collection minted for developers building on the DIMO Network";

export const DIMO_CREDIT_SYMBOL = "DCX";
export const DIMO_CREDIT_NAME = "DIMO Credit";
export const DIMO_CREDIT_PERIOD_VALIDITY = "86400"; // 1 day
export const DIMO_CREDIT_RATE_IN_WEI = "1000000000000000" // 0.001 ether