import { ethers } from 'ethers';

const _hashRole = (role: string) =>
    ethers.keccak256(ethers.toUtf8Bytes(role));

export const licenseCostInUsd = BigInt("1000000000000000000");

export const DEFAULT_ADMIN_ROLE = "0x0000000000000000000000000000000000000000000000000000000000000000";
export const LICENSE_ADMIN_ROLE = _hashRole("LICENSE_ADMIN_ROLE");
export const REVOKER_ROLE = _hashRole("REVOKER_ROLE");
export const PROVIDER_ADMIN_ROLE = _hashRole("PROVIDER_ADMIN_ROLE");
export const ORACLE_ADMIN_ROLE = _hashRole("ORACLE_ADMIN_ROLE");

export const addressDimoToken = {
    polygon: '0xe261d618a959afffd53168cd07d12e37b26761db',
    amoy: '0x21cFE003997fB7c2B3cfe5cf71e7833B7B2eCe10',
}

export const addressReceiver = {
    polygon: '0xA2f0fD6A9411f4911b992C2389A53FfAb1E2BE88',
    amoy: '0x07B584f6a7125491C991ca2a45ab9e641B1CeE1b'
}