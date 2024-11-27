## DevLicenseDimo
#### Functions
| Selector | Signature |
|-|-|
| 0xa217fddf | DEFAULT_ADMIN_ROLE() |
| 0x6d1de63d | LICENSE_ADMIN_ROLE() |
| 0x7c4acabf | REVOKER_ROLE() |
| 0xf72c0d8b | UPGRADER_ROLE() |
| 0xad3cb1cc | UPGRADE_INTERFACE_VERSION() |
| 0xde06ce84 | adminBurnLockedFunds(uint256,uint256) |
| 0x0a98e154 | adminFreeze(uint256,bool) |
| 0x92d937c7 | adminReallocate(uint256,uint256,address) |
| 0xa28835b6 | adminWithdraw(address) |
| 0x095ea7b3 | approve(address,uint256) |
| 0xce052244 | clientIdToTokenId(address) |
| 0x872db889 | contractDescription() |
| 0x8eab84ee | contractImage() |
| 0xe8a3d485 | contractURI() |
| 0xdb60ded9 | dimoCredit() |
| 0x0524f28c | dimoToken() |
| 0xde9cc84d | disableSigner(uint256,address) |
| 0x3b1c393b | enableSigner(uint256,address) |
| 0xe9ac0440 | frozen(uint256) |
| 0x3aea1a10 | getLicenseAliasByTokenId(uint256) |
| 0x248a9ca3 | getRoleAdmin(bytes32) |
| 0x6eac1c40 | getTokenIdByLicenseAlias(string) |
| 0xf5c7223d | getTokenIdByLicenseAlias(bytes32) |
| 0x2f2ff15d | grantRole(bytes32,address) |
| 0x91d14854 | hasRole(bytes32,address) |
| 0x1dccc525 | initialize(address,address,address,address,address,uint256,string,string) |
| 0x48bcbd2d | isSigner(uint256,address) |
| 0x69054339 | issueInDc(string) |
| 0x6cca0c45 | issueInDc(address,string) |
| 0x5d9cbfb6 | issueInDimo(string) |
| 0x8efdce0a | issueInDimo(address,string) |
| 0xddfaf5c2 | licenseAccountFactory() |
| 0x5d79373d | licenseCostInUsd1e18() |
| 0x1338736f | lock(uint256,uint256) |
| 0xb45a3c0e | locked(uint256) |
| 0x06fdde03 | name() |
| 0x6352211e | ownerOf(uint256) |
| 0xb30afb81 | periodValidity() |
| 0x085d4883 | provider() |
| 0x52d1902d | proxiableUUID() |
| 0xf7260d3e | receiver() |
| 0x2877fed1 | redirectUriStatus(uint256,string) |
| 0x36568abe | renounceRole(bytes32,address) |
| 0x20c5429b | revoke(uint256) |
| 0xd547741f | revokeRole(bytes32,address) |
| 0x42842e0e | safeTransferFrom(address,address,uint256) |
| 0xb88d4fde | safeTransferFrom(address,address,uint256,bytes) |
| 0xa22cb465 | setApprovalForAll(address,bool) |
| 0xf754dd9b | setContractDescription(string) |
| 0xdc42c255 | setContractImage(string) |
| 0xd866e391 | setDimoCreditAddress(address) |
| 0x81c9bb13 | setDimoTokenAddress(address) |
| 0x507c5a89 | setLicenseAlias(uint256,string) |
| 0x1d6f8ef3 | setLicenseCost(uint256) |
| 0x5b10dd30 | setLicenseFactoryAddress(address) |
| 0xd0dde29b | setPeriodValidity(uint256) |
| 0x920e7190 | setPriceProviderAddress(address) |
| 0x8279c7db | setReceiverAddress(address) |
| 0xba1bedfc | setRedirectUri(uint256,bool,string) |
| 0x00d5da02 | setTokenDescription(string) |
| 0xf806147d | setTokenImage(string) |
| 0xc920ba60 | signers(uint256,address) |
| 0x4b5c8bdf | stakeTotal() |
| 0xf256cad5 | stakedBalance(uint256) |
| 0x01ffc9a7 | supportsInterface(bytes4) |
| 0x95d89b41 | symbol() |
| 0x25e6f516 | tokenDescription() |
| 0x5df1453e | tokenIdToClientId(uint256) |
| 0xc1aef4f2 | tokenImage() |
| 0xc87b56dd | tokenURI(uint256) |
| 0x817b1cd2 | totalStaked() |
| 0x23b872dd | transferFrom(address,address,uint256) |
| 0x4f1ef286 | upgradeToAndCall(address,bytes) |
| 0x441a3e70 | withdraw(uint256,uint256) |

#### Events
| Selector | Signature |
|-|-|
| 0x52d30ff0 | AssetForfeit(uint256,uint256) |
| 0x16ba6956 | AssetFreezeUpdate(uint256,uint256,bool) |
| 0xc7f505b2 | Initialized(uint64) |
| 0x7533f62e | Issued(uint256,address,address) |
| 0xcd1647e8 | LicenseAliasSet(uint256,string) |
| 0x032bc66b | Locked(uint256) |
| 0xa5ad928e | RedirectUriDisabled(uint256,string) |
| 0x100a5934 | RedirectUriEnabled(uint256,string) |
| 0xbd79b86f | RoleAdminChanged(bytes32,bytes32,bytes32) |
| 0x2f878811 | RoleGranted(bytes32,address,address) |
| 0xf6391f5c | RoleRevoked(bytes32,address,address) |
| 0xdbd8d9c5 | SignerDisabled(uint256,address) |
| 0x0ea45d41 | SignerEnabled(uint256,address) |
| 0x1cd3a07c | StakeDeposit(uint256,address,uint256) |
| 0xb632f81a | StakeWithdraw(uint256,address,uint256) |
| 0xddf252ad | Transfer(address,address,uint256) |
| 0x695a889a | UpdateDimoCreditAddress(address) |
| 0xbf31bafe | UpdateDimoTokenAddress(address) |
| 0xa5898a6a | UpdateLicenseAccountFactoryAddress(address) |
| 0x0aca62d3 | UpdateLicenseCost(uint256) |
| 0x9a360497 | UpdatePeriodValidity(uint256) |
| 0x47641d98 | UpdatePriceProviderAddress(address) |
| 0x61dcb70b | UpdateReceiverAddress(address) |
| 0xbc7cd75a | Upgraded(address) |

#### Errors
| Selector | Signature |
|-|-|
| 0x6697b232 | AccessControlBadConfirmation() |
| 0xe2517d3f | AccessControlUnauthorizedAccount(address,bytes32) |
| 0x9996b315 | AddressEmptyCode(address) |
| 0xe2cd3255 | AliasAlreadyInUse(string) |
| 0xe7414602 | AliasExceedsMaxLength() |
| 0x4c9c8ce3 | ERC1967InvalidImplementation(address) |
| 0xb398979f | ERC1967NonPayable() |
| 0x1425ea42 | FailedInnerCall() |
| 0x32072f30 | FrozenToken(uint256) |
| 0xe3f8e56c | InsufficientStakedFunds(uint256,uint256) |
| 0x3728b83d | InvalidAmount(uint256) |
| 0xf92ee8a9 | InvalidInitialization() |
| 0x398d4d32 | InvalidOperation() |
| 0x4c14f64c | InvalidSender(address) |
| 0x2f4163e7 | NonexistentToken(uint256) |
| 0xd7e6bcf8 | NotInitializing() |
| 0x3ee5aeb5 | ReentrancyGuardReentrantCall() |
| 0xa8e20eac | StakedFunds(uint256) |
| 0xe07c8dba | UUPSUnauthorizedCallContext() |
| 0xaa1d49a4 | UUPSUnsupportedProxiableUUID(bytes32) |

## DimoCredit
#### Functions
| Selector | Signature |
|-|-|
| 0x282c51f3 | BURNER_ROLE() |
| 0x43b80b81 | DC_ADMIN_ROLE() |
| 0xa217fddf | DEFAULT_ADMIN_ROLE() |
| 0xf72c0d8b | UPGRADER_ROLE() |
| 0xad3cb1cc | UPGRADE_INTERFACE_VERSION() |
| 0xdd62ed3e | allowance(address,address) |
| 0x095ea7b3 | approve(address,uint256) |
| 0x70a08231 | balanceOf(address) |
| 0x9dc29fac | burn(address,uint256) |
| 0x313ce567 | decimals() |
| 0xb06965b6 | dimoCreditRate() |
| 0x0524f28c | dimoToken() |
| 0x171755b1 | getQuote() |
| 0xcf39918e | getQuote(uint256) |
| 0x63746fd3 | getQuoteDc(uint256) |
| 0xffb37c10 | getQuoteDc() |
| 0x248a9ca3 | getRoleAdmin(bytes32) |
| 0x2f2ff15d | grantRole(bytes32,address) |
| 0x91d14854 | hasRole(bytes32,address) |
| 0xcd3fa04b | initialize(string,string,address,address,address,uint256,uint256) |
| 0x40c10f19 | mint(address,uint256) |
| 0x94d008ef | mint(address,uint256,bytes) |
| 0x7f2c81a0 | mintInDimo(address,uint256,bytes) |
| 0xec88fc37 | mintInDimo(address,uint256) |
| 0x06fdde03 | name() |
| 0xb30afb81 | periodValidity() |
| 0x085d4883 | provider() |
| 0x52d1902d | proxiableUUID() |
| 0xf7260d3e | receiver() |
| 0x36568abe | renounceRole(bytes32,address) |
| 0xd547741f | revokeRole(bytes32,address) |
| 0xe3a2d827 | setDimoCreditRate(uint256) |
| 0x81c9bb13 | setDimoTokenAddress(address) |
| 0xd0dde29b | setPeriodValidity(uint256) |
| 0x920e7190 | setPriceProviderAddress(address) |
| 0x8279c7db | setReceiverAddress(address) |
| 0x01ffc9a7 | supportsInterface(bytes4) |
| 0x95d89b41 | symbol() |
| 0x18160ddd | totalSupply() |
| 0xa9059cbb | transfer(address,uint256) |
| 0x23b872dd | transferFrom(address,address,uint256) |
| 0x8736ec47 | updatePrice(bytes) |
| 0x4f1ef286 | upgradeToAndCall(address,bytes) |

#### Events
| Selector | Signature |
|-|-|
| 0xc7f505b2 | Initialized(uint64) |
| 0xbd79b86f | RoleAdminChanged(bytes32,bytes32,bytes32) |
| 0x2f878811 | RoleGranted(bytes32,address,address) |
| 0xf6391f5c | RoleRevoked(bytes32,address,address) |
| 0xddf252ad | Transfer(address,address,uint256) |
| 0x5eb62e2c | UpdateDimoCreditRate(uint256) |
| 0xbf31bafe | UpdateDimoTokenAddress(address) |
| 0x9a360497 | UpdatePeriodValidity(uint256) |
| 0x47641d98 | UpdatePriceProviderAddress(address) |
| 0x61dcb70b | UpdateReceiverAddress(address) |
| 0xbc7cd75a | Upgraded(address) |

#### Errors
| Selector | Signature |
|-|-|
| 0x6697b232 | AccessControlBadConfirmation() |
| 0xe2517d3f | AccessControlUnauthorizedAccount(address,bytes32) |
| 0x9996b315 | AddressEmptyCode(address) |
| 0x4c9c8ce3 | ERC1967InvalidImplementation(address) |
| 0xb398979f | ERC1967NonPayable() |
| 0x1425ea42 | FailedInnerCall() |
| 0xf92ee8a9 | InvalidInitialization() |
| 0x398d4d32 | InvalidOperation() |
| 0xd7e6bcf8 | NotInitializing() |
| 0xe07c8dba | UUPSUnauthorizedCallContext() |
| 0xaa1d49a4 | UUPSUnsupportedProxiableUUID(bytes32) |

## LicenseAccountFactory
#### Functions
| Selector | Signature |
|-|-|
| 0x75b238fc | ADMIN_ROLE() |
| 0xa217fddf | DEFAULT_ADMIN_ROLE() |
| 0xf72c0d8b | UPGRADER_ROLE() |
| 0xad3cb1cc | UPGRADE_INTERFACE_VERSION() |
| 0x48462c66 | beaconProxyTemplate() |
| 0x780900dc | create(uint256) |
| 0xc25917af | devLicenseDimo() |
| 0x248a9ca3 | getRoleAdmin(bytes32) |
| 0x2f2ff15d | grantRole(bytes32,address) |
| 0x91d14854 | hasRole(bytes32,address) |
| 0xc4d66de8 | initialize(address) |
| 0x52d1902d | proxiableUUID() |
| 0x36568abe | renounceRole(bytes32,address) |
| 0xd547741f | revokeRole(bytes32,address) |
| 0x8b848f06 | setDevLicenseDimo(address) |
| 0x01ffc9a7 | supportsInterface(bytes4) |
| 0x4f1ef286 | upgradeToAndCall(address,bytes) |

#### Events
| Selector | Signature |
|-|-|
| 0xc7f505b2 | Initialized(uint64) |
| 0xbd79b86f | RoleAdminChanged(bytes32,bytes32,bytes32) |
| 0x2f878811 | RoleGranted(bytes32,address,address) |
| 0xf6391f5c | RoleRevoked(bytes32,address,address) |
| 0xbc7cd75a | Upgraded(address) |

#### Errors
| Selector | Signature |
|-|-|
| 0x6697b232 | AccessControlBadConfirmation() |
| 0xe2517d3f | AccessControlUnauthorizedAccount(address,bytes32) |
| 0x9996b315 | AddressEmptyCode(address) |
| 0xc2f868f4 | ERC1167FailedCreateClone() |
| 0x4c9c8ce3 | ERC1967InvalidImplementation(address) |
| 0xb398979f | ERC1967NonPayable() |
| 0x1425ea42 | FailedInnerCall() |
| 0xf92ee8a9 | InvalidInitialization() |
| 0xd7e6bcf8 | NotInitializing() |
| 0xe07c8dba | UUPSUnauthorizedCallContext() |
| 0xaa1d49a4 | UUPSUnsupportedProxiableUUID(bytes32) |
| 0x8e4a23d6 | Unauthorized(address) |
| 0xd92e233d | ZeroAddress() |

## DimoDeveloperLicenseAccount
#### Functions
| Selector | Signature |
|-|-|
| 0xda35a26f | initialize(uint256,address) |
| 0x7df73e27 | isSigner(address) |
| 0x1626ba7e | isValidSignature(bytes32,bytes) |
| 0x6b87d24c | license() |
| 0x17d70f7c | tokenId() |

#### Errors
| Selector | Signature |
|-|-|
| 0xf645eedf | ECDSAInvalidSignature() |
| 0xfce698f7 | ECDSAInvalidSignatureLength(uint256) |
| 0xd78bce0c | ECDSAInvalidSignatureS(bytes32) |
| 0xed15e6cf | InvalidTokenId(uint256) |
| 0x6d32f59e | LicenseAccountAlreadyInitialized() |
| 0xd92e233d | ZeroAddress() |

## NormalizedPriceProvider
#### Functions
| Selector | Signature |
|-|-|
| 0xa217fddf | DEFAULT_ADMIN_ROLE() |
| 0x1837fc64 | PROVIDER_ADMIN_ROLE() |
| 0x47e63380 | UPDATER_ROLE() |
| 0x6dcac986 | _oracleSources(uint256) |
| 0xcead6206 | _primaryIndex() |
| 0xdf8293f8 | addOracleSource(address) |
| 0x672d20f7 | getAllOracleSources() |
| 0xa3ec8a70 | getAmountUsdPerToken() |
| 0xe14c13cb | getAmountUsdPerToken(bytes) |
| 0xd7e64ad6 | getLastAmountUsdPerToken() |
| 0x16a4453f | getPrimaryOracleSource() |
| 0x248a9ca3 | getRoleAdmin(bytes32) |
| 0x2f2ff15d | grantRole(bytes32,address) |
| 0x91d14854 | hasRole(bytes32,address) |
| 0x0e1d2ec8 | isUpdatable() |
| 0x5cdd8707 | removeOracleSource(uint256) |
| 0x36568abe | renounceRole(bytes32,address) |
| 0xd547741f | revokeRole(bytes32,address) |
| 0x2ac89407 | setPrimaryOracleSource(uint256) |
| 0x01ffc9a7 | supportsInterface(bytes4) |
| 0x673a7e28 | updatePrice() |

#### Events
| Selector | Signature |
|-|-|
| 0xf32b2917 | OracleSourceAdded(address) |
| 0xa695bd4e | OracleSourceRemoved(address) |
| 0xac891244 | PrimaryOracleSourceSet(uint256) |
| 0xbd79b86f | RoleAdminChanged(bytes32,bytes32,bytes32) |
| 0x2f878811 | RoleGranted(bytes32,address,address) |
| 0xf6391f5c | RoleRevoked(bytes32,address,address) |

#### Errors
| Selector | Signature |
|-|-|
| 0x6697b232 | AccessControlBadConfirmation() |
| 0xe2517d3f | AccessControlUnauthorizedAccount(address,bytes32) |
| 0x63df8171 | InvalidIndex() |
| 0x716eb205 | MaxOraclesReached() |
| 0xd92e233d | ZeroAddress() |

## TwapV3
#### Functions
| Selector | Signature |
|-|-|
| 0xa217fddf | DEFAULT_ADMIN_ROLE() |
| 0x8003a94f | ORACLE_ADMIN_ROLE() |
| 0x1ed6e374 | _amountUsdPerToken() |
| 0xcf6d2d99 | _getPriceInWei(uint256) |
| 0x91d3593e | _updateTimestamp() |
| 0x794ed7bc | getAmountNativePerToken(bytes) |
| 0xad95ce54 | getAmountNativePerToken() |
| 0xa3ec8a70 | getAmountUsdPerToken() |
| 0xe14c13cb | getAmountUsdPerToken(bytes) |
| 0x081ab0df | getIntervalDimo() |
| 0x37700059 | getIntervalUsdc() |
| 0x4e09a610 | getPriceX96FromSqrtPriceX96(uint160) |
| 0x248a9ca3 | getRoleAdmin(bytes32) |
| 0x47628f60 | getSqrtTwapX96(address,uint32) |
| 0x2f2ff15d | grantRole(bytes32,address) |
| 0x91d14854 | hasRole(bytes32,address) |
| 0x3ecc0f5e | initialize(uint32,uint32) |
| 0x0e1d2ec8 | isUpdatable() |
| 0x13aa067c | poolWmaticDimo() |
| 0x25e0f6c0 | poolWmaticUsdc() |
| 0x36568abe | renounceRole(bytes32,address) |
| 0xd547741f | revokeRole(bytes32,address) |
| 0x4b75508f | setTwapIntervalDimo(uint32) |
| 0xaaafba87 | setTwapIntervalUsdc(uint32) |
| 0x01ffc9a7 | supportsInterface(bytes4) |
| 0x673a7e28 | updatePrice() |

#### Events
| Selector | Signature |
|-|-|
| 0x19f3e90e | NewPrice(address,uint256,uint256) |
| 0xbd79b86f | RoleAdminChanged(bytes32,bytes32,bytes32) |
| 0x2f878811 | RoleGranted(bytes32,address,address) |
| 0xf6391f5c | RoleRevoked(bytes32,address,address) |

#### Errors
| Selector | Signature |
|-|-|
| 0x6697b232 | AccessControlBadConfirmation() |
| 0xe2517d3f | AccessControlUnauthorizedAccount(address,bytes32) |
| 0xce8ef7fc | InvalidTick() |

