import { ethers } from 'ethers';

const _hashRole = (role: string) =>
    ethers.keccak256(ethers.toUtf8Bytes(role));

export const licenseCostInUsd = BigInt("1000000000000000000");

export const DEFAULT_ADMIN_ROLE = "0x0000000000000000000000000000000000000000000000000000000000000000";
export const LICENSE_ADMIN_ROLE = _hashRole("LICENSE_ADMIN_ROLE");
export const REVOKER_ROLE = _hashRole("REVOKER_ROLE");
export const PROVIDER_ADMIN_ROLE = _hashRole("PROVIDER_ADMIN_ROLE");
export const ORACLE_ADMIN_ROLE = _hashRole("ORACLE_ADMIN_ROLE");

export const METADATA_DESCRIPTION = "This is an NFT collection minted for developers building on the DIMO Network";