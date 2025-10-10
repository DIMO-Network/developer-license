// Code generated via abigen V2 - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package devLicenseDimo

import (
	"bytes"
	"errors"
	"math/big"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind/v2"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = bytes.Equal
	_ = errors.New
	_ = big.NewInt
	_ = common.Big1
	_ = types.BloomLookup
	_ = abi.ConvertType
)

// DevLicenseDimoMetaData contains all meta data concerning the DevLicenseDimo contract.
var DevLicenseDimoMetaData = bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"DEFAULT_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"LICENSE_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"REVOKER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"UPGRADER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"UPGRADE_INTERFACE_VERSION\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"adminBurnLockedFunds\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"adminFreeze\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"frozen_\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"adminReallocate\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"adminWithdraw\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"approve\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"clientIdToTokenId\",\"inputs\":[{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"contractDescription\",\"inputs\":[],\"outputs\":[{\"name\":\"contractDescription_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"contractImage\",\"inputs\":[],\"outputs\":[{\"name\":\"contractImage_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"contractURI\",\"inputs\":[],\"outputs\":[{\"name\":\"contractURI_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"dimoCredit\",\"inputs\":[],\"outputs\":[{\"name\":\"dimoCredit_\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"dimoToken\",\"inputs\":[],\"outputs\":[{\"name\":\"dimoToken_\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"disableSigner\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"enableSigner\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"frozen\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"frozen_\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getLicenseAliasByTokenId\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getRoleAdmin\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getSignerExpiration\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"timestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getTokenIdByLicenseAlias\",\"inputs\":[{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getTokenIdByLicenseAlias\",\"inputs\":[{\"name\":\"licenseAlias\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"grantRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"hasRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"initialize\",\"inputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"licenseAccountFactory_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"provider_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"dimoTokenAddress_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"dimoCreditAddress_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"licenseCostInUsd_\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"image_\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"description_\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"isSigner\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"isSigner_\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"issueInDc\",\"inputs\":[{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"issueInDc\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"issueInDimo\",\"inputs\":[{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"issueInDimo\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"licenseAccountFactory\",\"inputs\":[],\"outputs\":[{\"name\":\"licenseAccountFactory_\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"licenseCostInUsd1e18\",\"inputs\":[],\"outputs\":[{\"name\":\"licenseCostInUsd1e18_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"lock\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"locked\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"locked_\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"name\",\"inputs\":[],\"outputs\":[{\"name\":\"name_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"ownerOf\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"owner\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"periodValidity\",\"inputs\":[],\"outputs\":[{\"name\":\"periodValidity_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"provider\",\"inputs\":[],\"outputs\":[{\"name\":\"provider_\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"proxiableUUID\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"receiver\",\"inputs\":[],\"outputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"redirectUriStatus\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"uri\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[{\"name\":\"enabled\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"renounceRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"callerConfirmation\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revoke\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revokeRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"safeTransferFrom\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"safeTransferFrom\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setApprovalForAll\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setContractDescription\",\"inputs\":[{\"name\":\"description_\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setContractImage\",\"inputs\":[{\"name\":\"image_\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setDimoCreditAddress\",\"inputs\":[{\"name\":\"dimoCreditAddress_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setDimoTokenAddress\",\"inputs\":[{\"name\":\"dimoTokenAddress_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setLicenseAlias\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setLicenseCost\",\"inputs\":[{\"name\":\"licenseCostInUsd1e18_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setLicenseFactoryAddress\",\"inputs\":[{\"name\":\"licenseAccountFactory_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setPeriodValidity\",\"inputs\":[{\"name\":\"periodValidity_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setPriceProviderAddress\",\"inputs\":[{\"name\":\"providerAddress_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setReceiverAddress\",\"inputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setRedirectUri\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"enabled\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"uri\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setTokenDescription\",\"inputs\":[{\"name\":\"description_\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setTokenImage\",\"inputs\":[{\"name\":\"image_\",\"type\":\"string\",\"internalType\":\"string\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"signers\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"timestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"stakeTotal\",\"inputs\":[],\"outputs\":[{\"name\":\"stakeTotal_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"stakedBalance\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"stakedBalance_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"supportsInterface\",\"inputs\":[{\"name\":\"interfaceId\",\"type\":\"bytes4\",\"internalType\":\"bytes4\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"symbol\",\"inputs\":[],\"outputs\":[{\"name\":\"symbol_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"tokenDescription\",\"inputs\":[],\"outputs\":[{\"name\":\"tokenDescription_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"tokenIdToClientId\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"clientId\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"tokenImage\",\"inputs\":[],\"outputs\":[{\"name\":\"tokenImage_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"tokenURI\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"tokenURI_\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"totalStaked\",\"inputs\":[],\"outputs\":[{\"name\":\"totalStaked_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"transferFrom\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"upgradeToAndCall\",\"inputs\":[{\"name\":\"newImplementation\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"payable\"},{\"type\":\"function\",\"name\":\"withdraw\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"AssetForfeit\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"AssetFreezeUpdate\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"frozen\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Initialized\",\"inputs\":[{\"name\":\"version\",\"type\":\"uint64\",\"indexed\":false,\"internalType\":\"uint64\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Issued\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"owner\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"clientId\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"LicenseAliasSet\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"licenseAlias\",\"type\":\"string\",\"indexed\":false,\"internalType\":\"string\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Locked\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RedirectUriDisabled\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"uri\",\"type\":\"string\",\"indexed\":false,\"internalType\":\"string\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RedirectUriEnabled\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"uri\",\"type\":\"string\",\"indexed\":false,\"internalType\":\"string\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleAdminChanged\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"previousAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"newAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleGranted\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleRevoked\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SignerDisabled\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SignerEnabled\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"signer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"StakeDeposit\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"user\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"StakeWithdraw\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"},{\"name\":\"user\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Transfer\",\"inputs\":[{\"name\":\"from\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"to\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"tokenId\",\"type\":\"uint256\",\"indexed\":true,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateDimoCreditAddress\",\"inputs\":[{\"name\":\"dimoCredit_\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateDimoTokenAddress\",\"inputs\":[{\"name\":\"dimoToken_\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateLicenseAccountFactoryAddress\",\"inputs\":[{\"name\":\"licenseAccountFactory_\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateLicenseCost\",\"inputs\":[{\"name\":\"licenseCost\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdatePeriodValidity\",\"inputs\":[{\"name\":\"periodValidity\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdatePriceProviderAddress\",\"inputs\":[{\"name\":\"provider\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateReceiverAddress\",\"inputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Upgraded\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AccessControlBadConfirmation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AccessControlUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"neededRole\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AddressEmptyCode\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"AliasAlreadyInUse\",\"inputs\":[{\"name\":\"licenseAlias\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"AliasExceedsMaxLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ERC1967InvalidImplementation\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"ERC1967NonPayable\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FailedCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FrozenToken\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"InsufficientStakedFunds\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"InvalidAmount\",\"inputs\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"InvalidInitialization\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidOperation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSender\",\"inputs\":[{\"name\":\"sender\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"NonexistentToken\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"NotInitializing\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ReentrancyGuardReentrantCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"StakedFunds\",\"inputs\":[{\"name\":\"tokenId\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"UUPSUnauthorizedCallContext\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UUPSUnsupportedProxiableUUID\",\"inputs\":[{\"name\":\"slot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]}]",
	ID:  "DevLicenseDimo",
}

// DevLicenseDimo is an auto generated Go binding around an Ethereum contract.
type DevLicenseDimo struct {
	abi abi.ABI
}

// NewDevLicenseDimo creates a new instance of DevLicenseDimo.
func NewDevLicenseDimo() *DevLicenseDimo {
	parsed, err := DevLicenseDimoMetaData.ParseABI()
	if err != nil {
		panic(errors.New("invalid ABI: " + err.Error()))
	}
	return &DevLicenseDimo{abi: *parsed}
}

// Instance creates a wrapper for a deployed contract instance at the given address.
// Use this to create the instance object passed to abigen v2 library functions Call, Transact, etc.
func (c *DevLicenseDimo) Instance(backend bind.ContractBackend, addr common.Address) *bind.BoundContract {
	return bind.NewBoundContract(addr, c.abi, backend, backend, backend)
}

// PackDEFAULTADMINROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackDEFAULTADMINROLE() []byte {
	enc, err := devLicenseDimo.abi.Pack("DEFAULT_ADMIN_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDEFAULTADMINROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackDEFAULTADMINROLE(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("DEFAULT_ADMIN_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackLICENSEADMINROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x6d1de63d.
//
// Solidity: function LICENSE_ADMIN_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackLICENSEADMINROLE() []byte {
	enc, err := devLicenseDimo.abi.Pack("LICENSE_ADMIN_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackLICENSEADMINROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x6d1de63d.
//
// Solidity: function LICENSE_ADMIN_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackLICENSEADMINROLE(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("LICENSE_ADMIN_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackREVOKERROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x7c4acabf.
//
// Solidity: function REVOKER_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackREVOKERROLE() []byte {
	enc, err := devLicenseDimo.abi.Pack("REVOKER_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackREVOKERROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x7c4acabf.
//
// Solidity: function REVOKER_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackREVOKERROLE(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("REVOKER_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackUPGRADERROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf72c0d8b.
//
// Solidity: function UPGRADER_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackUPGRADERROLE() []byte {
	enc, err := devLicenseDimo.abi.Pack("UPGRADER_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackUPGRADERROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf72c0d8b.
//
// Solidity: function UPGRADER_ROLE() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackUPGRADERROLE(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("UPGRADER_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackUPGRADEINTERFACEVERSION is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (devLicenseDimo *DevLicenseDimo) PackUPGRADEINTERFACEVERSION() []byte {
	enc, err := devLicenseDimo.abi.Pack("UPGRADE_INTERFACE_VERSION")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackUPGRADEINTERFACEVERSION is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (devLicenseDimo *DevLicenseDimo) UnpackUPGRADEINTERFACEVERSION(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("UPGRADE_INTERFACE_VERSION", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackAdminBurnLockedFunds is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xde06ce84.
//
// Solidity: function adminBurnLockedFunds(uint256 tokenId, uint256 amount) returns()
func (devLicenseDimo *DevLicenseDimo) PackAdminBurnLockedFunds(tokenId *big.Int, amount *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("adminBurnLockedFunds", tokenId, amount)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackAdminFreeze is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x0a98e154.
//
// Solidity: function adminFreeze(uint256 tokenId, bool frozen_) returns()
func (devLicenseDimo *DevLicenseDimo) PackAdminFreeze(tokenId *big.Int, frozen bool) []byte {
	enc, err := devLicenseDimo.abi.Pack("adminFreeze", tokenId, frozen)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackAdminReallocate is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x92d937c7.
//
// Solidity: function adminReallocate(uint256 tokenId, uint256 amount, address to) returns()
func (devLicenseDimo *DevLicenseDimo) PackAdminReallocate(tokenId *big.Int, amount *big.Int, to common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("adminReallocate", tokenId, amount, to)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackAdminWithdraw is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xa28835b6.
//
// Solidity: function adminWithdraw(address to) returns()
func (devLicenseDimo *DevLicenseDimo) PackAdminWithdraw(to common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("adminWithdraw", to)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackApprove is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x095ea7b3.
//
// Solidity: function approve(address , uint256 ) returns()
func (devLicenseDimo *DevLicenseDimo) PackApprove(arg0 common.Address, arg1 *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("approve", arg0, arg1)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackClientIdToTokenId is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xce052244.
//
// Solidity: function clientIdToTokenId(address clientId) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) PackClientIdToTokenId(clientId common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("clientIdToTokenId", clientId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackClientIdToTokenId is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xce052244.
//
// Solidity: function clientIdToTokenId(address clientId) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackClientIdToTokenId(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("clientIdToTokenId", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackContractDescription is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x872db889.
//
// Solidity: function contractDescription() view returns(string contractDescription_)
func (devLicenseDimo *DevLicenseDimo) PackContractDescription() []byte {
	enc, err := devLicenseDimo.abi.Pack("contractDescription")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackContractDescription is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x872db889.
//
// Solidity: function contractDescription() view returns(string contractDescription_)
func (devLicenseDimo *DevLicenseDimo) UnpackContractDescription(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("contractDescription", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackContractImage is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x8eab84ee.
//
// Solidity: function contractImage() view returns(string contractImage_)
func (devLicenseDimo *DevLicenseDimo) PackContractImage() []byte {
	enc, err := devLicenseDimo.abi.Pack("contractImage")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackContractImage is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x8eab84ee.
//
// Solidity: function contractImage() view returns(string contractImage_)
func (devLicenseDimo *DevLicenseDimo) UnpackContractImage(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("contractImage", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackContractURI is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xe8a3d485.
//
// Solidity: function contractURI() view returns(string contractURI_)
func (devLicenseDimo *DevLicenseDimo) PackContractURI() []byte {
	enc, err := devLicenseDimo.abi.Pack("contractURI")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackContractURI is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xe8a3d485.
//
// Solidity: function contractURI() view returns(string contractURI_)
func (devLicenseDimo *DevLicenseDimo) UnpackContractURI(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("contractURI", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackDimoCredit is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xdb60ded9.
//
// Solidity: function dimoCredit() view returns(address dimoCredit_)
func (devLicenseDimo *DevLicenseDimo) PackDimoCredit() []byte {
	enc, err := devLicenseDimo.abi.Pack("dimoCredit")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDimoCredit is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xdb60ded9.
//
// Solidity: function dimoCredit() view returns(address dimoCredit_)
func (devLicenseDimo *DevLicenseDimo) UnpackDimoCredit(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("dimoCredit", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackDimoToken is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x0524f28c.
//
// Solidity: function dimoToken() view returns(address dimoToken_)
func (devLicenseDimo *DevLicenseDimo) PackDimoToken() []byte {
	enc, err := devLicenseDimo.abi.Pack("dimoToken")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDimoToken is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x0524f28c.
//
// Solidity: function dimoToken() view returns(address dimoToken_)
func (devLicenseDimo *DevLicenseDimo) UnpackDimoToken(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("dimoToken", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackDisableSigner is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xde9cc84d.
//
// Solidity: function disableSigner(uint256 tokenId, address signer) returns()
func (devLicenseDimo *DevLicenseDimo) PackDisableSigner(tokenId *big.Int, signer common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("disableSigner", tokenId, signer)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackEnableSigner is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x3b1c393b.
//
// Solidity: function enableSigner(uint256 tokenId, address signer) returns()
func (devLicenseDimo *DevLicenseDimo) PackEnableSigner(tokenId *big.Int, signer common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("enableSigner", tokenId, signer)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackFrozen is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xe9ac0440.
//
// Solidity: function frozen(uint256 tokenId) view returns(bool frozen_)
func (devLicenseDimo *DevLicenseDimo) PackFrozen(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("frozen", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackFrozen is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xe9ac0440.
//
// Solidity: function frozen(uint256 tokenId) view returns(bool frozen_)
func (devLicenseDimo *DevLicenseDimo) UnpackFrozen(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("frozen", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackGetLicenseAliasByTokenId is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x3aea1a10.
//
// Solidity: function getLicenseAliasByTokenId(uint256 tokenId) view returns(string licenseAlias)
func (devLicenseDimo *DevLicenseDimo) PackGetLicenseAliasByTokenId(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("getLicenseAliasByTokenId", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetLicenseAliasByTokenId is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x3aea1a10.
//
// Solidity: function getLicenseAliasByTokenId(uint256 tokenId) view returns(string licenseAlias)
func (devLicenseDimo *DevLicenseDimo) UnpackGetLicenseAliasByTokenId(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("getLicenseAliasByTokenId", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackGetRoleAdmin is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackGetRoleAdmin(role [32]byte) []byte {
	enc, err := devLicenseDimo.abi.Pack("getRoleAdmin", role)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetRoleAdmin is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackGetRoleAdmin(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("getRoleAdmin", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackGetSignerExpiration is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x0efbfa42.
//
// Solidity: function getSignerExpiration(uint256 tokenId, address signer) view returns(uint256 timestamp)
func (devLicenseDimo *DevLicenseDimo) PackGetSignerExpiration(tokenId *big.Int, signer common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("getSignerExpiration", tokenId, signer)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetSignerExpiration is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x0efbfa42.
//
// Solidity: function getSignerExpiration(uint256 tokenId, address signer) view returns(uint256 timestamp)
func (devLicenseDimo *DevLicenseDimo) UnpackGetSignerExpiration(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("getSignerExpiration", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetTokenIdByLicenseAlias is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x6eac1c40.
//
// Solidity: function getTokenIdByLicenseAlias(string licenseAlias) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) PackGetTokenIdByLicenseAlias(licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("getTokenIdByLicenseAlias", licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetTokenIdByLicenseAlias is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x6eac1c40.
//
// Solidity: function getTokenIdByLicenseAlias(string licenseAlias) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackGetTokenIdByLicenseAlias(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("getTokenIdByLicenseAlias", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetTokenIdByLicenseAlias0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf5c7223d.
//
// Solidity: function getTokenIdByLicenseAlias(bytes32 licenseAlias) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) PackGetTokenIdByLicenseAlias0(licenseAlias [32]byte) []byte {
	enc, err := devLicenseDimo.abi.Pack("getTokenIdByLicenseAlias0", licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetTokenIdByLicenseAlias0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf5c7223d.
//
// Solidity: function getTokenIdByLicenseAlias(bytes32 licenseAlias) view returns(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackGetTokenIdByLicenseAlias0(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("getTokenIdByLicenseAlias0", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGrantRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (devLicenseDimo *DevLicenseDimo) PackGrantRole(role [32]byte, account common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("grantRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackHasRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (devLicenseDimo *DevLicenseDimo) PackHasRole(role [32]byte, account common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("hasRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackHasRole is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (devLicenseDimo *DevLicenseDimo) UnpackHasRole(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("hasRole", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackInitialize is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x1dccc525.
//
// Solidity: function initialize(address receiver_, address licenseAccountFactory_, address provider_, address dimoTokenAddress_, address dimoCreditAddress_, uint256 licenseCostInUsd_, string image_, string description_) returns()
func (devLicenseDimo *DevLicenseDimo) PackInitialize(receiver common.Address, licenseAccountFactory common.Address, provider common.Address, dimoTokenAddress common.Address, dimoCreditAddress common.Address, licenseCostInUsd *big.Int, image string, description string) []byte {
	enc, err := devLicenseDimo.abi.Pack("initialize", receiver, licenseAccountFactory, provider, dimoTokenAddress, dimoCreditAddress, licenseCostInUsd, image, description)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackIsSigner is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x48bcbd2d.
//
// Solidity: function isSigner(uint256 tokenId, address signer) view returns(bool isSigner_)
func (devLicenseDimo *DevLicenseDimo) PackIsSigner(tokenId *big.Int, signer common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("isSigner", tokenId, signer)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackIsSigner is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x48bcbd2d.
//
// Solidity: function isSigner(uint256 tokenId, address signer) view returns(bool isSigner_)
func (devLicenseDimo *DevLicenseDimo) UnpackIsSigner(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("isSigner", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackIssueInDc is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x69054339.
//
// Solidity: function issueInDc(string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) PackIssueInDc(licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("issueInDc", licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// IssueInDcOutput serves as a container for the return parameters of contract
// method IssueInDc.
type IssueInDcOutput struct {
	TokenId  *big.Int
	ClientId common.Address
}

// UnpackIssueInDc is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x69054339.
//
// Solidity: function issueInDc(string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackIssueInDc(data []byte) (IssueInDcOutput, error) {
	out, err := devLicenseDimo.abi.Unpack("issueInDc", data)
	outstruct := new(IssueInDcOutput)
	if err != nil {
		return *outstruct, err
	}
	outstruct.TokenId = abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	outstruct.ClientId = *abi.ConvertType(out[1], new(common.Address)).(*common.Address)
	return *outstruct, err

}

// PackIssueInDc0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x6cca0c45.
//
// Solidity: function issueInDc(address to, string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) PackIssueInDc0(to common.Address, licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("issueInDc0", to, licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// IssueInDc0Output serves as a container for the return parameters of contract
// method IssueInDc0.
type IssueInDc0Output struct {
	TokenId  *big.Int
	ClientId common.Address
}

// UnpackIssueInDc0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x6cca0c45.
//
// Solidity: function issueInDc(address to, string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackIssueInDc0(data []byte) (IssueInDc0Output, error) {
	out, err := devLicenseDimo.abi.Unpack("issueInDc0", data)
	outstruct := new(IssueInDc0Output)
	if err != nil {
		return *outstruct, err
	}
	outstruct.TokenId = abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	outstruct.ClientId = *abi.ConvertType(out[1], new(common.Address)).(*common.Address)
	return *outstruct, err

}

// PackIssueInDimo is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x5d9cbfb6.
//
// Solidity: function issueInDimo(string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) PackIssueInDimo(licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("issueInDimo", licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// IssueInDimoOutput serves as a container for the return parameters of contract
// method IssueInDimo.
type IssueInDimoOutput struct {
	TokenId  *big.Int
	ClientId common.Address
}

// UnpackIssueInDimo is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x5d9cbfb6.
//
// Solidity: function issueInDimo(string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackIssueInDimo(data []byte) (IssueInDimoOutput, error) {
	out, err := devLicenseDimo.abi.Unpack("issueInDimo", data)
	outstruct := new(IssueInDimoOutput)
	if err != nil {
		return *outstruct, err
	}
	outstruct.TokenId = abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	outstruct.ClientId = *abi.ConvertType(out[1], new(common.Address)).(*common.Address)
	return *outstruct, err

}

// PackIssueInDimo0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x8efdce0a.
//
// Solidity: function issueInDimo(address to, string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) PackIssueInDimo0(to common.Address, licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("issueInDimo0", to, licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// IssueInDimo0Output serves as a container for the return parameters of contract
// method IssueInDimo0.
type IssueInDimo0Output struct {
	TokenId  *big.Int
	ClientId common.Address
}

// UnpackIssueInDimo0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x8efdce0a.
//
// Solidity: function issueInDimo(address to, string licenseAlias) returns(uint256 tokenId, address clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackIssueInDimo0(data []byte) (IssueInDimo0Output, error) {
	out, err := devLicenseDimo.abi.Unpack("issueInDimo0", data)
	outstruct := new(IssueInDimo0Output)
	if err != nil {
		return *outstruct, err
	}
	outstruct.TokenId = abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	outstruct.ClientId = *abi.ConvertType(out[1], new(common.Address)).(*common.Address)
	return *outstruct, err

}

// PackLicenseAccountFactory is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xddfaf5c2.
//
// Solidity: function licenseAccountFactory() view returns(address licenseAccountFactory_)
func (devLicenseDimo *DevLicenseDimo) PackLicenseAccountFactory() []byte {
	enc, err := devLicenseDimo.abi.Pack("licenseAccountFactory")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackLicenseAccountFactory is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xddfaf5c2.
//
// Solidity: function licenseAccountFactory() view returns(address licenseAccountFactory_)
func (devLicenseDimo *DevLicenseDimo) UnpackLicenseAccountFactory(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("licenseAccountFactory", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackLicenseCostInUsd1e18 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x5d79373d.
//
// Solidity: function licenseCostInUsd1e18() view returns(uint256 licenseCostInUsd1e18_)
func (devLicenseDimo *DevLicenseDimo) PackLicenseCostInUsd1e18() []byte {
	enc, err := devLicenseDimo.abi.Pack("licenseCostInUsd1e18")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackLicenseCostInUsd1e18 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x5d79373d.
//
// Solidity: function licenseCostInUsd1e18() view returns(uint256 licenseCostInUsd1e18_)
func (devLicenseDimo *DevLicenseDimo) UnpackLicenseCostInUsd1e18(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("licenseCostInUsd1e18", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackLock is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x1338736f.
//
// Solidity: function lock(uint256 tokenId, uint256 amount) returns()
func (devLicenseDimo *DevLicenseDimo) PackLock(tokenId *big.Int, amount *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("lock", tokenId, amount)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackLocked is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xb45a3c0e.
//
// Solidity: function locked(uint256 tokenId) view returns(bool locked_)
func (devLicenseDimo *DevLicenseDimo) PackLocked(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("locked", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackLocked is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xb45a3c0e.
//
// Solidity: function locked(uint256 tokenId) view returns(bool locked_)
func (devLicenseDimo *DevLicenseDimo) UnpackLocked(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("locked", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackName is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x06fdde03.
//
// Solidity: function name() view returns(string name_)
func (devLicenseDimo *DevLicenseDimo) PackName() []byte {
	enc, err := devLicenseDimo.abi.Pack("name")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackName is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x06fdde03.
//
// Solidity: function name() view returns(string name_)
func (devLicenseDimo *DevLicenseDimo) UnpackName(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("name", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackOwnerOf is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address owner)
func (devLicenseDimo *DevLicenseDimo) PackOwnerOf(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("ownerOf", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackOwnerOf is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x6352211e.
//
// Solidity: function ownerOf(uint256 tokenId) view returns(address owner)
func (devLicenseDimo *DevLicenseDimo) UnpackOwnerOf(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("ownerOf", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackPeriodValidity is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xb30afb81.
//
// Solidity: function periodValidity() view returns(uint256 periodValidity_)
func (devLicenseDimo *DevLicenseDimo) PackPeriodValidity() []byte {
	enc, err := devLicenseDimo.abi.Pack("periodValidity")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackPeriodValidity is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xb30afb81.
//
// Solidity: function periodValidity() view returns(uint256 periodValidity_)
func (devLicenseDimo *DevLicenseDimo) UnpackPeriodValidity(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("periodValidity", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackProvider is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x085d4883.
//
// Solidity: function provider() view returns(address provider_)
func (devLicenseDimo *DevLicenseDimo) PackProvider() []byte {
	enc, err := devLicenseDimo.abi.Pack("provider")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackProvider is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x085d4883.
//
// Solidity: function provider() view returns(address provider_)
func (devLicenseDimo *DevLicenseDimo) UnpackProvider(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("provider", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackProxiableUUID is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) PackProxiableUUID() []byte {
	enc, err := devLicenseDimo.abi.Pack("proxiableUUID")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackProxiableUUID is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (devLicenseDimo *DevLicenseDimo) UnpackProxiableUUID(data []byte) ([32]byte, error) {
	out, err := devLicenseDimo.abi.Unpack("proxiableUUID", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackReceiver is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf7260d3e.
//
// Solidity: function receiver() view returns(address receiver_)
func (devLicenseDimo *DevLicenseDimo) PackReceiver() []byte {
	enc, err := devLicenseDimo.abi.Pack("receiver")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackReceiver is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf7260d3e.
//
// Solidity: function receiver() view returns(address receiver_)
func (devLicenseDimo *DevLicenseDimo) UnpackReceiver(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("receiver", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackRedirectUriStatus is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x2877fed1.
//
// Solidity: function redirectUriStatus(uint256 tokenId, string uri) view returns(bool enabled)
func (devLicenseDimo *DevLicenseDimo) PackRedirectUriStatus(tokenId *big.Int, uri string) []byte {
	enc, err := devLicenseDimo.abi.Pack("redirectUriStatus", tokenId, uri)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackRedirectUriStatus is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x2877fed1.
//
// Solidity: function redirectUriStatus(uint256 tokenId, string uri) view returns(bool enabled)
func (devLicenseDimo *DevLicenseDimo) UnpackRedirectUriStatus(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("redirectUriStatus", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackRenounceRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (devLicenseDimo *DevLicenseDimo) PackRenounceRole(role [32]byte, callerConfirmation common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("renounceRole", role, callerConfirmation)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackRevoke is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x20c5429b.
//
// Solidity: function revoke(uint256 tokenId) returns()
func (devLicenseDimo *DevLicenseDimo) PackRevoke(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("revoke", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackRevokeRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (devLicenseDimo *DevLicenseDimo) PackRevokeRole(role [32]byte, account common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("revokeRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSafeTransferFrom is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x42842e0e.
//
// Solidity: function safeTransferFrom(address , address , uint256 ) returns()
func (devLicenseDimo *DevLicenseDimo) PackSafeTransferFrom(arg0 common.Address, arg1 common.Address, arg2 *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("safeTransferFrom", arg0, arg1, arg2)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSafeTransferFrom0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xb88d4fde.
//
// Solidity: function safeTransferFrom(address , address , uint256 , bytes ) returns()
func (devLicenseDimo *DevLicenseDimo) PackSafeTransferFrom0(arg0 common.Address, arg1 common.Address, arg2 *big.Int, arg3 []byte) []byte {
	enc, err := devLicenseDimo.abi.Pack("safeTransferFrom0", arg0, arg1, arg2, arg3)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetApprovalForAll is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xa22cb465.
//
// Solidity: function setApprovalForAll(address , bool ) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetApprovalForAll(arg0 common.Address, arg1 bool) []byte {
	enc, err := devLicenseDimo.abi.Pack("setApprovalForAll", arg0, arg1)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetContractDescription is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf754dd9b.
//
// Solidity: function setContractDescription(string description_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetContractDescription(description string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setContractDescription", description)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetContractImage is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xdc42c255.
//
// Solidity: function setContractImage(string image_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetContractImage(image string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setContractImage", image)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetDimoCreditAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xd866e391.
//
// Solidity: function setDimoCreditAddress(address dimoCreditAddress_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetDimoCreditAddress(dimoCreditAddress common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("setDimoCreditAddress", dimoCreditAddress)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetDimoTokenAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x81c9bb13.
//
// Solidity: function setDimoTokenAddress(address dimoTokenAddress_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetDimoTokenAddress(dimoTokenAddress common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("setDimoTokenAddress", dimoTokenAddress)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetLicenseAlias is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x507c5a89.
//
// Solidity: function setLicenseAlias(uint256 tokenId, string licenseAlias) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetLicenseAlias(tokenId *big.Int, licenseAlias string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setLicenseAlias", tokenId, licenseAlias)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetLicenseCost is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x1d6f8ef3.
//
// Solidity: function setLicenseCost(uint256 licenseCostInUsd1e18_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetLicenseCost(licenseCostInUsd1e18 *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("setLicenseCost", licenseCostInUsd1e18)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetLicenseFactoryAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x5b10dd30.
//
// Solidity: function setLicenseFactoryAddress(address licenseAccountFactory_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetLicenseFactoryAddress(licenseAccountFactory common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("setLicenseFactoryAddress", licenseAccountFactory)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetPeriodValidity is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xd0dde29b.
//
// Solidity: function setPeriodValidity(uint256 periodValidity_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetPeriodValidity(periodValidity *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("setPeriodValidity", periodValidity)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetPriceProviderAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x920e7190.
//
// Solidity: function setPriceProviderAddress(address providerAddress_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetPriceProviderAddress(providerAddress common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("setPriceProviderAddress", providerAddress)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetReceiverAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x8279c7db.
//
// Solidity: function setReceiverAddress(address receiver_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetReceiverAddress(receiver common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("setReceiverAddress", receiver)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetRedirectUri is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xba1bedfc.
//
// Solidity: function setRedirectUri(uint256 tokenId, bool enabled, string uri) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetRedirectUri(tokenId *big.Int, enabled bool, uri string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setRedirectUri", tokenId, enabled, uri)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetTokenDescription is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x00d5da02.
//
// Solidity: function setTokenDescription(string description_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetTokenDescription(description string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setTokenDescription", description)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetTokenImage is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf806147d.
//
// Solidity: function setTokenImage(string image_) returns()
func (devLicenseDimo *DevLicenseDimo) PackSetTokenImage(image string) []byte {
	enc, err := devLicenseDimo.abi.Pack("setTokenImage", image)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSigners is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xc920ba60.
//
// Solidity: function signers(uint256 tokenId, address signer) view returns(uint256 timestamp)
func (devLicenseDimo *DevLicenseDimo) PackSigners(tokenId *big.Int, signer common.Address) []byte {
	enc, err := devLicenseDimo.abi.Pack("signers", tokenId, signer)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackSigners is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xc920ba60.
//
// Solidity: function signers(uint256 tokenId, address signer) view returns(uint256 timestamp)
func (devLicenseDimo *DevLicenseDimo) UnpackSigners(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("signers", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackStakeTotal is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x4b5c8bdf.
//
// Solidity: function stakeTotal() view returns(uint256 stakeTotal_)
func (devLicenseDimo *DevLicenseDimo) PackStakeTotal() []byte {
	enc, err := devLicenseDimo.abi.Pack("stakeTotal")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackStakeTotal is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x4b5c8bdf.
//
// Solidity: function stakeTotal() view returns(uint256 stakeTotal_)
func (devLicenseDimo *DevLicenseDimo) UnpackStakeTotal(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("stakeTotal", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackStakedBalance is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf256cad5.
//
// Solidity: function stakedBalance(uint256 tokenId) view returns(uint256 stakedBalance_)
func (devLicenseDimo *DevLicenseDimo) PackStakedBalance(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("stakedBalance", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackStakedBalance is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf256cad5.
//
// Solidity: function stakedBalance(uint256 tokenId) view returns(uint256 stakedBalance_)
func (devLicenseDimo *DevLicenseDimo) UnpackStakedBalance(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("stakedBalance", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackSupportsInterface is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (devLicenseDimo *DevLicenseDimo) PackSupportsInterface(interfaceId [4]byte) []byte {
	enc, err := devLicenseDimo.abi.Pack("supportsInterface", interfaceId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackSupportsInterface is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (devLicenseDimo *DevLicenseDimo) UnpackSupportsInterface(data []byte) (bool, error) {
	out, err := devLicenseDimo.abi.Unpack("supportsInterface", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackSymbol is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x95d89b41.
//
// Solidity: function symbol() view returns(string symbol_)
func (devLicenseDimo *DevLicenseDimo) PackSymbol() []byte {
	enc, err := devLicenseDimo.abi.Pack("symbol")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackSymbol is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x95d89b41.
//
// Solidity: function symbol() view returns(string symbol_)
func (devLicenseDimo *DevLicenseDimo) UnpackSymbol(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("symbol", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackTokenDescription is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x25e6f516.
//
// Solidity: function tokenDescription() view returns(string tokenDescription_)
func (devLicenseDimo *DevLicenseDimo) PackTokenDescription() []byte {
	enc, err := devLicenseDimo.abi.Pack("tokenDescription")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTokenDescription is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x25e6f516.
//
// Solidity: function tokenDescription() view returns(string tokenDescription_)
func (devLicenseDimo *DevLicenseDimo) UnpackTokenDescription(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("tokenDescription", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackTokenIdToClientId is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x5df1453e.
//
// Solidity: function tokenIdToClientId(uint256 tokenId) view returns(address clientId)
func (devLicenseDimo *DevLicenseDimo) PackTokenIdToClientId(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("tokenIdToClientId", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTokenIdToClientId is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x5df1453e.
//
// Solidity: function tokenIdToClientId(uint256 tokenId) view returns(address clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackTokenIdToClientId(data []byte) (common.Address, error) {
	out, err := devLicenseDimo.abi.Unpack("tokenIdToClientId", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackTokenImage is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xc1aef4f2.
//
// Solidity: function tokenImage() view returns(string tokenImage_)
func (devLicenseDimo *DevLicenseDimo) PackTokenImage() []byte {
	enc, err := devLicenseDimo.abi.Pack("tokenImage")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTokenImage is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xc1aef4f2.
//
// Solidity: function tokenImage() view returns(string tokenImage_)
func (devLicenseDimo *DevLicenseDimo) UnpackTokenImage(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("tokenImage", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackTokenURI is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string tokenURI_)
func (devLicenseDimo *DevLicenseDimo) PackTokenURI(tokenId *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("tokenURI", tokenId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTokenURI is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xc87b56dd.
//
// Solidity: function tokenURI(uint256 tokenId) view returns(string tokenURI_)
func (devLicenseDimo *DevLicenseDimo) UnpackTokenURI(data []byte) (string, error) {
	out, err := devLicenseDimo.abi.Unpack("tokenURI", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackTotalStaked is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x817b1cd2.
//
// Solidity: function totalStaked() view returns(uint256 totalStaked_)
func (devLicenseDimo *DevLicenseDimo) PackTotalStaked() []byte {
	enc, err := devLicenseDimo.abi.Pack("totalStaked")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTotalStaked is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x817b1cd2.
//
// Solidity: function totalStaked() view returns(uint256 totalStaked_)
func (devLicenseDimo *DevLicenseDimo) UnpackTotalStaked(data []byte) (*big.Int, error) {
	out, err := devLicenseDimo.abi.Unpack("totalStaked", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackTransferFrom is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x23b872dd.
//
// Solidity: function transferFrom(address , address , uint256 ) returns()
func (devLicenseDimo *DevLicenseDimo) PackTransferFrom(arg0 common.Address, arg1 common.Address, arg2 *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("transferFrom", arg0, arg1, arg2)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackUpgradeToAndCall is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x4f1ef286.
//
// Solidity: function upgradeToAndCall(address newImplementation, bytes data) payable returns()
func (devLicenseDimo *DevLicenseDimo) PackUpgradeToAndCall(newImplementation common.Address, data []byte) []byte {
	enc, err := devLicenseDimo.abi.Pack("upgradeToAndCall", newImplementation, data)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackWithdraw is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x441a3e70.
//
// Solidity: function withdraw(uint256 tokenId, uint256 amount) returns()
func (devLicenseDimo *DevLicenseDimo) PackWithdraw(tokenId *big.Int, amount *big.Int) []byte {
	enc, err := devLicenseDimo.abi.Pack("withdraw", tokenId, amount)
	if err != nil {
		panic(err)
	}
	return enc
}

// DevLicenseDimoAssetForfeit represents a AssetForfeit event raised by the DevLicenseDimo contract.
type DevLicenseDimoAssetForfeit struct {
	TokenId *big.Int
	Amount  *big.Int
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoAssetForfeitEventName = "AssetForfeit"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoAssetForfeit) ContractEventName() string {
	return DevLicenseDimoAssetForfeitEventName
}

// UnpackAssetForfeitEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event AssetForfeit(uint256 indexed tokenId, uint256 amount)
func (devLicenseDimo *DevLicenseDimo) UnpackAssetForfeitEvent(log *types.Log) (*DevLicenseDimoAssetForfeit, error) {
	event := "AssetForfeit"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoAssetForfeit)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoAssetFreezeUpdate represents a AssetFreezeUpdate event raised by the DevLicenseDimo contract.
type DevLicenseDimoAssetFreezeUpdate struct {
	TokenId *big.Int
	Amount  *big.Int
	Frozen  bool
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoAssetFreezeUpdateEventName = "AssetFreezeUpdate"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoAssetFreezeUpdate) ContractEventName() string {
	return DevLicenseDimoAssetFreezeUpdateEventName
}

// UnpackAssetFreezeUpdateEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event AssetFreezeUpdate(uint256 indexed tokenId, uint256 amount, bool frozen)
func (devLicenseDimo *DevLicenseDimo) UnpackAssetFreezeUpdateEvent(log *types.Log) (*DevLicenseDimoAssetFreezeUpdate, error) {
	event := "AssetFreezeUpdate"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoAssetFreezeUpdate)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoInitialized represents a Initialized event raised by the DevLicenseDimo contract.
type DevLicenseDimoInitialized struct {
	Version uint64
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoInitializedEventName = "Initialized"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoInitialized) ContractEventName() string {
	return DevLicenseDimoInitializedEventName
}

// UnpackInitializedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Initialized(uint64 version)
func (devLicenseDimo *DevLicenseDimo) UnpackInitializedEvent(log *types.Log) (*DevLicenseDimoInitialized, error) {
	event := "Initialized"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoInitialized)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoIssued represents a Issued event raised by the DevLicenseDimo contract.
type DevLicenseDimoIssued struct {
	TokenId  *big.Int
	Owner    common.Address
	ClientId common.Address
	Raw      *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoIssuedEventName = "Issued"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoIssued) ContractEventName() string {
	return DevLicenseDimoIssuedEventName
}

// UnpackIssuedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Issued(uint256 indexed tokenId, address indexed owner, address indexed clientId)
func (devLicenseDimo *DevLicenseDimo) UnpackIssuedEvent(log *types.Log) (*DevLicenseDimoIssued, error) {
	event := "Issued"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoIssued)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoLicenseAliasSet represents a LicenseAliasSet event raised by the DevLicenseDimo contract.
type DevLicenseDimoLicenseAliasSet struct {
	TokenId      *big.Int
	LicenseAlias string
	Raw          *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoLicenseAliasSetEventName = "LicenseAliasSet"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoLicenseAliasSet) ContractEventName() string {
	return DevLicenseDimoLicenseAliasSetEventName
}

// UnpackLicenseAliasSetEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event LicenseAliasSet(uint256 indexed tokenId, string licenseAlias)
func (devLicenseDimo *DevLicenseDimo) UnpackLicenseAliasSetEvent(log *types.Log) (*DevLicenseDimoLicenseAliasSet, error) {
	event := "LicenseAliasSet"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoLicenseAliasSet)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoLocked represents a Locked event raised by the DevLicenseDimo contract.
type DevLicenseDimoLocked struct {
	TokenId *big.Int
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoLockedEventName = "Locked"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoLocked) ContractEventName() string {
	return DevLicenseDimoLockedEventName
}

// UnpackLockedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Locked(uint256 indexed tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackLockedEvent(log *types.Log) (*DevLicenseDimoLocked, error) {
	event := "Locked"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoLocked)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoRedirectUriDisabled represents a RedirectUriDisabled event raised by the DevLicenseDimo contract.
type DevLicenseDimoRedirectUriDisabled struct {
	TokenId *big.Int
	Uri     string
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoRedirectUriDisabledEventName = "RedirectUriDisabled"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoRedirectUriDisabled) ContractEventName() string {
	return DevLicenseDimoRedirectUriDisabledEventName
}

// UnpackRedirectUriDisabledEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RedirectUriDisabled(uint256 indexed tokenId, string uri)
func (devLicenseDimo *DevLicenseDimo) UnpackRedirectUriDisabledEvent(log *types.Log) (*DevLicenseDimoRedirectUriDisabled, error) {
	event := "RedirectUriDisabled"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoRedirectUriDisabled)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoRedirectUriEnabled represents a RedirectUriEnabled event raised by the DevLicenseDimo contract.
type DevLicenseDimoRedirectUriEnabled struct {
	TokenId *big.Int
	Uri     string
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoRedirectUriEnabledEventName = "RedirectUriEnabled"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoRedirectUriEnabled) ContractEventName() string {
	return DevLicenseDimoRedirectUriEnabledEventName
}

// UnpackRedirectUriEnabledEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RedirectUriEnabled(uint256 indexed tokenId, string uri)
func (devLicenseDimo *DevLicenseDimo) UnpackRedirectUriEnabledEvent(log *types.Log) (*DevLicenseDimoRedirectUriEnabled, error) {
	event := "RedirectUriEnabled"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoRedirectUriEnabled)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoRoleAdminChanged represents a RoleAdminChanged event raised by the DevLicenseDimo contract.
type DevLicenseDimoRoleAdminChanged struct {
	Role              [32]byte
	PreviousAdminRole [32]byte
	NewAdminRole      [32]byte
	Raw               *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoRoleAdminChangedEventName = "RoleAdminChanged"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoRoleAdminChanged) ContractEventName() string {
	return DevLicenseDimoRoleAdminChangedEventName
}

// UnpackRoleAdminChangedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (devLicenseDimo *DevLicenseDimo) UnpackRoleAdminChangedEvent(log *types.Log) (*DevLicenseDimoRoleAdminChanged, error) {
	event := "RoleAdminChanged"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoRoleAdminChanged)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoRoleGranted represents a RoleGranted event raised by the DevLicenseDimo contract.
type DevLicenseDimoRoleGranted struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoRoleGrantedEventName = "RoleGranted"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoRoleGranted) ContractEventName() string {
	return DevLicenseDimoRoleGrantedEventName
}

// UnpackRoleGrantedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (devLicenseDimo *DevLicenseDimo) UnpackRoleGrantedEvent(log *types.Log) (*DevLicenseDimoRoleGranted, error) {
	event := "RoleGranted"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoRoleGranted)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoRoleRevoked represents a RoleRevoked event raised by the DevLicenseDimo contract.
type DevLicenseDimoRoleRevoked struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoRoleRevokedEventName = "RoleRevoked"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoRoleRevoked) ContractEventName() string {
	return DevLicenseDimoRoleRevokedEventName
}

// UnpackRoleRevokedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (devLicenseDimo *DevLicenseDimo) UnpackRoleRevokedEvent(log *types.Log) (*DevLicenseDimoRoleRevoked, error) {
	event := "RoleRevoked"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoRoleRevoked)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoSignerDisabled represents a SignerDisabled event raised by the DevLicenseDimo contract.
type DevLicenseDimoSignerDisabled struct {
	TokenId *big.Int
	Signer  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoSignerDisabledEventName = "SignerDisabled"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoSignerDisabled) ContractEventName() string {
	return DevLicenseDimoSignerDisabledEventName
}

// UnpackSignerDisabledEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event SignerDisabled(uint256 indexed tokenId, address indexed signer)
func (devLicenseDimo *DevLicenseDimo) UnpackSignerDisabledEvent(log *types.Log) (*DevLicenseDimoSignerDisabled, error) {
	event := "SignerDisabled"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoSignerDisabled)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoSignerEnabled represents a SignerEnabled event raised by the DevLicenseDimo contract.
type DevLicenseDimoSignerEnabled struct {
	TokenId *big.Int
	Signer  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoSignerEnabledEventName = "SignerEnabled"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoSignerEnabled) ContractEventName() string {
	return DevLicenseDimoSignerEnabledEventName
}

// UnpackSignerEnabledEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event SignerEnabled(uint256 indexed tokenId, address indexed signer)
func (devLicenseDimo *DevLicenseDimo) UnpackSignerEnabledEvent(log *types.Log) (*DevLicenseDimoSignerEnabled, error) {
	event := "SignerEnabled"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoSignerEnabled)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoStakeDeposit represents a StakeDeposit event raised by the DevLicenseDimo contract.
type DevLicenseDimoStakeDeposit struct {
	TokenId *big.Int
	User    common.Address
	Amount  *big.Int
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoStakeDepositEventName = "StakeDeposit"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoStakeDeposit) ContractEventName() string {
	return DevLicenseDimoStakeDepositEventName
}

// UnpackStakeDepositEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event StakeDeposit(uint256 indexed tokenId, address indexed user, uint256 amount)
func (devLicenseDimo *DevLicenseDimo) UnpackStakeDepositEvent(log *types.Log) (*DevLicenseDimoStakeDeposit, error) {
	event := "StakeDeposit"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoStakeDeposit)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoStakeWithdraw represents a StakeWithdraw event raised by the DevLicenseDimo contract.
type DevLicenseDimoStakeWithdraw struct {
	TokenId *big.Int
	User    common.Address
	Amount  *big.Int
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoStakeWithdrawEventName = "StakeWithdraw"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoStakeWithdraw) ContractEventName() string {
	return DevLicenseDimoStakeWithdrawEventName
}

// UnpackStakeWithdrawEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event StakeWithdraw(uint256 indexed tokenId, address indexed user, uint256 amount)
func (devLicenseDimo *DevLicenseDimo) UnpackStakeWithdrawEvent(log *types.Log) (*DevLicenseDimoStakeWithdraw, error) {
	event := "StakeWithdraw"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoStakeWithdraw)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoTransfer represents a Transfer event raised by the DevLicenseDimo contract.
type DevLicenseDimoTransfer struct {
	From    common.Address
	To      common.Address
	TokenId *big.Int
	Raw     *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoTransferEventName = "Transfer"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoTransfer) ContractEventName() string {
	return DevLicenseDimoTransferEventName
}

// UnpackTransferEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 indexed tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackTransferEvent(log *types.Log) (*DevLicenseDimoTransfer, error) {
	event := "Transfer"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoTransfer)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdateDimoCreditAddress represents a UpdateDimoCreditAddress event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdateDimoCreditAddress struct {
	DimoCredit common.Address
	Raw        *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdateDimoCreditAddressEventName = "UpdateDimoCreditAddress"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdateDimoCreditAddress) ContractEventName() string {
	return DevLicenseDimoUpdateDimoCreditAddressEventName
}

// UnpackUpdateDimoCreditAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateDimoCreditAddress(address dimoCredit_)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdateDimoCreditAddressEvent(log *types.Log) (*DevLicenseDimoUpdateDimoCreditAddress, error) {
	event := "UpdateDimoCreditAddress"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdateDimoCreditAddress)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdateDimoTokenAddress represents a UpdateDimoTokenAddress event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdateDimoTokenAddress struct {
	DimoToken common.Address
	Raw       *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdateDimoTokenAddressEventName = "UpdateDimoTokenAddress"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdateDimoTokenAddress) ContractEventName() string {
	return DevLicenseDimoUpdateDimoTokenAddressEventName
}

// UnpackUpdateDimoTokenAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateDimoTokenAddress(address dimoToken_)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdateDimoTokenAddressEvent(log *types.Log) (*DevLicenseDimoUpdateDimoTokenAddress, error) {
	event := "UpdateDimoTokenAddress"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdateDimoTokenAddress)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdateLicenseAccountFactoryAddress represents a UpdateLicenseAccountFactoryAddress event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdateLicenseAccountFactoryAddress struct {
	LicenseAccountFactory common.Address
	Raw                   *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdateLicenseAccountFactoryAddressEventName = "UpdateLicenseAccountFactoryAddress"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdateLicenseAccountFactoryAddress) ContractEventName() string {
	return DevLicenseDimoUpdateLicenseAccountFactoryAddressEventName
}

// UnpackUpdateLicenseAccountFactoryAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateLicenseAccountFactoryAddress(address licenseAccountFactory_)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdateLicenseAccountFactoryAddressEvent(log *types.Log) (*DevLicenseDimoUpdateLicenseAccountFactoryAddress, error) {
	event := "UpdateLicenseAccountFactoryAddress"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdateLicenseAccountFactoryAddress)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdateLicenseCost represents a UpdateLicenseCost event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdateLicenseCost struct {
	LicenseCost *big.Int
	Raw         *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdateLicenseCostEventName = "UpdateLicenseCost"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdateLicenseCost) ContractEventName() string {
	return DevLicenseDimoUpdateLicenseCostEventName
}

// UnpackUpdateLicenseCostEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateLicenseCost(uint256 licenseCost)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdateLicenseCostEvent(log *types.Log) (*DevLicenseDimoUpdateLicenseCost, error) {
	event := "UpdateLicenseCost"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdateLicenseCost)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdatePeriodValidity represents a UpdatePeriodValidity event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdatePeriodValidity struct {
	PeriodValidity *big.Int
	Raw            *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdatePeriodValidityEventName = "UpdatePeriodValidity"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdatePeriodValidity) ContractEventName() string {
	return DevLicenseDimoUpdatePeriodValidityEventName
}

// UnpackUpdatePeriodValidityEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdatePeriodValidity(uint256 periodValidity)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdatePeriodValidityEvent(log *types.Log) (*DevLicenseDimoUpdatePeriodValidity, error) {
	event := "UpdatePeriodValidity"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdatePeriodValidity)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdatePriceProviderAddress represents a UpdatePriceProviderAddress event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdatePriceProviderAddress struct {
	Provider common.Address
	Raw      *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdatePriceProviderAddressEventName = "UpdatePriceProviderAddress"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdatePriceProviderAddress) ContractEventName() string {
	return DevLicenseDimoUpdatePriceProviderAddressEventName
}

// UnpackUpdatePriceProviderAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdatePriceProviderAddress(address provider)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdatePriceProviderAddressEvent(log *types.Log) (*DevLicenseDimoUpdatePriceProviderAddress, error) {
	event := "UpdatePriceProviderAddress"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdatePriceProviderAddress)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpdateReceiverAddress represents a UpdateReceiverAddress event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpdateReceiverAddress struct {
	Receiver common.Address
	Raw      *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpdateReceiverAddressEventName = "UpdateReceiverAddress"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpdateReceiverAddress) ContractEventName() string {
	return DevLicenseDimoUpdateReceiverAddressEventName
}

// UnpackUpdateReceiverAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateReceiverAddress(address receiver_)
func (devLicenseDimo *DevLicenseDimo) UnpackUpdateReceiverAddressEvent(log *types.Log) (*DevLicenseDimoUpdateReceiverAddress, error) {
	event := "UpdateReceiverAddress"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpdateReceiverAddress)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// DevLicenseDimoUpgraded represents a Upgraded event raised by the DevLicenseDimo contract.
type DevLicenseDimoUpgraded struct {
	Implementation common.Address
	Raw            *types.Log // Blockchain specific contextual infos
}

const DevLicenseDimoUpgradedEventName = "Upgraded"

// ContractEventName returns the user-defined event name.
func (DevLicenseDimoUpgraded) ContractEventName() string {
	return DevLicenseDimoUpgradedEventName
}

// UnpackUpgradedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Upgraded(address indexed implementation)
func (devLicenseDimo *DevLicenseDimo) UnpackUpgradedEvent(log *types.Log) (*DevLicenseDimoUpgraded, error) {
	event := "Upgraded"
	if log.Topics[0] != devLicenseDimo.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DevLicenseDimoUpgraded)
	if len(log.Data) > 0 {
		if err := devLicenseDimo.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range devLicenseDimo.abi.Events[event].Inputs {
		if arg.Indexed {
			indexed = append(indexed, arg)
		}
	}
	if err := abi.ParseTopics(out, indexed, log.Topics[1:]); err != nil {
		return nil, err
	}
	out.Raw = log
	return out, nil
}

// UnpackError attempts to decode the provided error data using user-defined
// error definitions.
func (devLicenseDimo *DevLicenseDimo) UnpackError(raw []byte) (any, error) {
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["AccessControlBadConfirmation"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackAccessControlBadConfirmationError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["AccessControlUnauthorizedAccount"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackAccessControlUnauthorizedAccountError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["AddressEmptyCode"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackAddressEmptyCodeError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["AliasAlreadyInUse"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackAliasAlreadyInUseError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["AliasExceedsMaxLength"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackAliasExceedsMaxLengthError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["ERC1967InvalidImplementation"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackERC1967InvalidImplementationError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["ERC1967NonPayable"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackERC1967NonPayableError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["FailedCall"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackFailedCallError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["FrozenToken"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackFrozenTokenError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["InsufficientStakedFunds"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackInsufficientStakedFundsError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["InvalidAmount"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackInvalidAmountError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["InvalidInitialization"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackInvalidInitializationError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["InvalidOperation"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackInvalidOperationError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["InvalidSender"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackInvalidSenderError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["NonexistentToken"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackNonexistentTokenError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["NotInitializing"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackNotInitializingError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["ReentrancyGuardReentrantCall"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackReentrancyGuardReentrantCallError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["StakedFunds"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackStakedFundsError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["UUPSUnauthorizedCallContext"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackUUPSUnauthorizedCallContextError(raw[4:])
	}
	if bytes.Equal(raw[:4], devLicenseDimo.abi.Errors["UUPSUnsupportedProxiableUUID"].ID.Bytes()[:4]) {
		return devLicenseDimo.UnpackUUPSUnsupportedProxiableUUIDError(raw[4:])
	}
	return nil, errors.New("Unknown error")
}

// DevLicenseDimoAccessControlBadConfirmation represents a AccessControlBadConfirmation error raised by the DevLicenseDimo contract.
type DevLicenseDimoAccessControlBadConfirmation struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AccessControlBadConfirmation()
func DevLicenseDimoAccessControlBadConfirmationErrorID() common.Hash {
	return common.HexToHash("0x6697b23232a647058342c0724fe7c415cab25915b54e5dbc03f233173d37b41c")
}

// UnpackAccessControlBadConfirmationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AccessControlBadConfirmation()
func (devLicenseDimo *DevLicenseDimo) UnpackAccessControlBadConfirmationError(raw []byte) (*DevLicenseDimoAccessControlBadConfirmation, error) {
	out := new(DevLicenseDimoAccessControlBadConfirmation)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "AccessControlBadConfirmation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoAccessControlUnauthorizedAccount represents a AccessControlUnauthorizedAccount error raised by the DevLicenseDimo contract.
type DevLicenseDimoAccessControlUnauthorizedAccount struct {
	Account    common.Address
	NeededRole [32]byte
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AccessControlUnauthorizedAccount(address account, bytes32 neededRole)
func DevLicenseDimoAccessControlUnauthorizedAccountErrorID() common.Hash {
	return common.HexToHash("0xe2517d3fbfae6f8515ef5ff1ccedc3933ab0cbbda0b492c06eb54ad10ef03b3e")
}

// UnpackAccessControlUnauthorizedAccountError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AccessControlUnauthorizedAccount(address account, bytes32 neededRole)
func (devLicenseDimo *DevLicenseDimo) UnpackAccessControlUnauthorizedAccountError(raw []byte) (*DevLicenseDimoAccessControlUnauthorizedAccount, error) {
	out := new(DevLicenseDimoAccessControlUnauthorizedAccount)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "AccessControlUnauthorizedAccount", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoAddressEmptyCode represents a AddressEmptyCode error raised by the DevLicenseDimo contract.
type DevLicenseDimoAddressEmptyCode struct {
	Target common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AddressEmptyCode(address target)
func DevLicenseDimoAddressEmptyCodeErrorID() common.Hash {
	return common.HexToHash("0x9996b315c842ff135b8fc4a08ad5df1c344efbc03d2687aecc0678050d2aac89")
}

// UnpackAddressEmptyCodeError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AddressEmptyCode(address target)
func (devLicenseDimo *DevLicenseDimo) UnpackAddressEmptyCodeError(raw []byte) (*DevLicenseDimoAddressEmptyCode, error) {
	out := new(DevLicenseDimoAddressEmptyCode)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "AddressEmptyCode", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoAliasAlreadyInUse represents a AliasAlreadyInUse error raised by the DevLicenseDimo contract.
type DevLicenseDimoAliasAlreadyInUse struct {
	LicenseAlias string
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AliasAlreadyInUse(string licenseAlias)
func DevLicenseDimoAliasAlreadyInUseErrorID() common.Hash {
	return common.HexToHash("0xe2cd3255acdd9dc6d2364c5034ba7cf7e50d54d89f5cec2e9d65b5ac0729ba83")
}

// UnpackAliasAlreadyInUseError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AliasAlreadyInUse(string licenseAlias)
func (devLicenseDimo *DevLicenseDimo) UnpackAliasAlreadyInUseError(raw []byte) (*DevLicenseDimoAliasAlreadyInUse, error) {
	out := new(DevLicenseDimoAliasAlreadyInUse)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "AliasAlreadyInUse", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoAliasExceedsMaxLength represents a AliasExceedsMaxLength error raised by the DevLicenseDimo contract.
type DevLicenseDimoAliasExceedsMaxLength struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AliasExceedsMaxLength()
func DevLicenseDimoAliasExceedsMaxLengthErrorID() common.Hash {
	return common.HexToHash("0xe7414602374a89f16738970a3f846797855bcc073eaa522847971bc9d8ef1d64")
}

// UnpackAliasExceedsMaxLengthError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AliasExceedsMaxLength()
func (devLicenseDimo *DevLicenseDimo) UnpackAliasExceedsMaxLengthError(raw []byte) (*DevLicenseDimoAliasExceedsMaxLength, error) {
	out := new(DevLicenseDimoAliasExceedsMaxLength)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "AliasExceedsMaxLength", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoERC1967InvalidImplementation represents a ERC1967InvalidImplementation error raised by the DevLicenseDimo contract.
type DevLicenseDimoERC1967InvalidImplementation struct {
	Implementation common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ERC1967InvalidImplementation(address implementation)
func DevLicenseDimoERC1967InvalidImplementationErrorID() common.Hash {
	return common.HexToHash("0x4c9c8ce3ceb3130f17f7cdba48d89b5b0129f266a8bac114e6e315a41879b617")
}

// UnpackERC1967InvalidImplementationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ERC1967InvalidImplementation(address implementation)
func (devLicenseDimo *DevLicenseDimo) UnpackERC1967InvalidImplementationError(raw []byte) (*DevLicenseDimoERC1967InvalidImplementation, error) {
	out := new(DevLicenseDimoERC1967InvalidImplementation)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "ERC1967InvalidImplementation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoERC1967NonPayable represents a ERC1967NonPayable error raised by the DevLicenseDimo contract.
type DevLicenseDimoERC1967NonPayable struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ERC1967NonPayable()
func DevLicenseDimoERC1967NonPayableErrorID() common.Hash {
	return common.HexToHash("0xb398979fa84f543c8e222f17890372c487baf85e062276c127fef521eea7224b")
}

// UnpackERC1967NonPayableError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ERC1967NonPayable()
func (devLicenseDimo *DevLicenseDimo) UnpackERC1967NonPayableError(raw []byte) (*DevLicenseDimoERC1967NonPayable, error) {
	out := new(DevLicenseDimoERC1967NonPayable)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "ERC1967NonPayable", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoFailedCall represents a FailedCall error raised by the DevLicenseDimo contract.
type DevLicenseDimoFailedCall struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error FailedCall()
func DevLicenseDimoFailedCallErrorID() common.Hash {
	return common.HexToHash("0xd6bda27508c0fb6d8a39b4b122878dab26f731a7d4e4abe711dd3731899052a4")
}

// UnpackFailedCallError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error FailedCall()
func (devLicenseDimo *DevLicenseDimo) UnpackFailedCallError(raw []byte) (*DevLicenseDimoFailedCall, error) {
	out := new(DevLicenseDimoFailedCall)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "FailedCall", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoFrozenToken represents a FrozenToken error raised by the DevLicenseDimo contract.
type DevLicenseDimoFrozenToken struct {
	TokenId *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error FrozenToken(uint256 tokenId)
func DevLicenseDimoFrozenTokenErrorID() common.Hash {
	return common.HexToHash("0x32072f3050b98b488e0cc71163b9f5bba43de8ee3ce0063120697f0306132e1a")
}

// UnpackFrozenTokenError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error FrozenToken(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackFrozenTokenError(raw []byte) (*DevLicenseDimoFrozenToken, error) {
	out := new(DevLicenseDimoFrozenToken)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "FrozenToken", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoInsufficientStakedFunds represents a InsufficientStakedFunds error raised by the DevLicenseDimo contract.
type DevLicenseDimoInsufficientStakedFunds struct {
	TokenId *big.Int
	Amount  *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InsufficientStakedFunds(uint256 tokenId, uint256 amount)
func DevLicenseDimoInsufficientStakedFundsErrorID() common.Hash {
	return common.HexToHash("0xe3f8e56c33b39f7db1f9fdf43cdb5437746cfb1b7a20c69ff03b08dc1acfd4b2")
}

// UnpackInsufficientStakedFundsError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InsufficientStakedFunds(uint256 tokenId, uint256 amount)
func (devLicenseDimo *DevLicenseDimo) UnpackInsufficientStakedFundsError(raw []byte) (*DevLicenseDimoInsufficientStakedFunds, error) {
	out := new(DevLicenseDimoInsufficientStakedFunds)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "InsufficientStakedFunds", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoInvalidAmount represents a InvalidAmount error raised by the DevLicenseDimo contract.
type DevLicenseDimoInvalidAmount struct {
	Amount *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidAmount(uint256 amount)
func DevLicenseDimoInvalidAmountErrorID() common.Hash {
	return common.HexToHash("0x3728b83da61d63401ac13ad617e59d729e6cb5ed67c24fa9dc4e9b626307fd6e")
}

// UnpackInvalidAmountError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidAmount(uint256 amount)
func (devLicenseDimo *DevLicenseDimo) UnpackInvalidAmountError(raw []byte) (*DevLicenseDimoInvalidAmount, error) {
	out := new(DevLicenseDimoInvalidAmount)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "InvalidAmount", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoInvalidInitialization represents a InvalidInitialization error raised by the DevLicenseDimo contract.
type DevLicenseDimoInvalidInitialization struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidInitialization()
func DevLicenseDimoInvalidInitializationErrorID() common.Hash {
	return common.HexToHash("0xf92ee8a957075833165f68c320933b1a1294aafc84ee6e0dd3fb178008f9aaf5")
}

// UnpackInvalidInitializationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidInitialization()
func (devLicenseDimo *DevLicenseDimo) UnpackInvalidInitializationError(raw []byte) (*DevLicenseDimoInvalidInitialization, error) {
	out := new(DevLicenseDimoInvalidInitialization)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "InvalidInitialization", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoInvalidOperation represents a InvalidOperation error raised by the DevLicenseDimo contract.
type DevLicenseDimoInvalidOperation struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidOperation()
func DevLicenseDimoInvalidOperationErrorID() common.Hash {
	return common.HexToHash("0x398d4d32963991cf02978f96f1a4d81787345d957c0995bedfe70af66ce594fd")
}

// UnpackInvalidOperationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidOperation()
func (devLicenseDimo *DevLicenseDimo) UnpackInvalidOperationError(raw []byte) (*DevLicenseDimoInvalidOperation, error) {
	out := new(DevLicenseDimoInvalidOperation)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "InvalidOperation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoInvalidSender represents a InvalidSender error raised by the DevLicenseDimo contract.
type DevLicenseDimoInvalidSender struct {
	Sender common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidSender(address sender)
func DevLicenseDimoInvalidSenderErrorID() common.Hash {
	return common.HexToHash("0x4c14f64c7080dbf09cd2f31c3a9d338f2d0e8c9c45404d9eef6c1762cbca067a")
}

// UnpackInvalidSenderError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidSender(address sender)
func (devLicenseDimo *DevLicenseDimo) UnpackInvalidSenderError(raw []byte) (*DevLicenseDimoInvalidSender, error) {
	out := new(DevLicenseDimoInvalidSender)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "InvalidSender", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoNonexistentToken represents a NonexistentToken error raised by the DevLicenseDimo contract.
type DevLicenseDimoNonexistentToken struct {
	TokenId *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error NonexistentToken(uint256 tokenId)
func DevLicenseDimoNonexistentTokenErrorID() common.Hash {
	return common.HexToHash("0x2f4163e7f60ab96e507171d63a4c80001ac344c577a560a1f11f148de9592ccb")
}

// UnpackNonexistentTokenError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error NonexistentToken(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackNonexistentTokenError(raw []byte) (*DevLicenseDimoNonexistentToken, error) {
	out := new(DevLicenseDimoNonexistentToken)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "NonexistentToken", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoNotInitializing represents a NotInitializing error raised by the DevLicenseDimo contract.
type DevLicenseDimoNotInitializing struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error NotInitializing()
func DevLicenseDimoNotInitializingErrorID() common.Hash {
	return common.HexToHash("0xd7e6bcf8597daa127dc9f0048d2f08d5ef140a2cb659feabd700beff1f7a8302")
}

// UnpackNotInitializingError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error NotInitializing()
func (devLicenseDimo *DevLicenseDimo) UnpackNotInitializingError(raw []byte) (*DevLicenseDimoNotInitializing, error) {
	out := new(DevLicenseDimoNotInitializing)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "NotInitializing", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoReentrancyGuardReentrantCall represents a ReentrancyGuardReentrantCall error raised by the DevLicenseDimo contract.
type DevLicenseDimoReentrancyGuardReentrantCall struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ReentrancyGuardReentrantCall()
func DevLicenseDimoReentrancyGuardReentrantCallErrorID() common.Hash {
	return common.HexToHash("0x3ee5aeb571de7fc460830b4d0017439a1ca56fb0bc39062227ade4fe4a24c1ca")
}

// UnpackReentrancyGuardReentrantCallError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ReentrancyGuardReentrantCall()
func (devLicenseDimo *DevLicenseDimo) UnpackReentrancyGuardReentrantCallError(raw []byte) (*DevLicenseDimoReentrancyGuardReentrantCall, error) {
	out := new(DevLicenseDimoReentrancyGuardReentrantCall)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "ReentrancyGuardReentrantCall", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoStakedFunds represents a StakedFunds error raised by the DevLicenseDimo contract.
type DevLicenseDimoStakedFunds struct {
	TokenId *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error StakedFunds(uint256 tokenId)
func DevLicenseDimoStakedFundsErrorID() common.Hash {
	return common.HexToHash("0xa8e20eacf355b71b4c660b123fffb241972e85ada925a12be8f85310dcebfcb9")
}

// UnpackStakedFundsError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error StakedFunds(uint256 tokenId)
func (devLicenseDimo *DevLicenseDimo) UnpackStakedFundsError(raw []byte) (*DevLicenseDimoStakedFunds, error) {
	out := new(DevLicenseDimoStakedFunds)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "StakedFunds", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoUUPSUnauthorizedCallContext represents a UUPSUnauthorizedCallContext error raised by the DevLicenseDimo contract.
type DevLicenseDimoUUPSUnauthorizedCallContext struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error UUPSUnauthorizedCallContext()
func DevLicenseDimoUUPSUnauthorizedCallContextErrorID() common.Hash {
	return common.HexToHash("0xe07c8dba242a06571ac65fe4bbe20522c9fb111cb33599b799ff8039c1ed18f4")
}

// UnpackUUPSUnauthorizedCallContextError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error UUPSUnauthorizedCallContext()
func (devLicenseDimo *DevLicenseDimo) UnpackUUPSUnauthorizedCallContextError(raw []byte) (*DevLicenseDimoUUPSUnauthorizedCallContext, error) {
	out := new(DevLicenseDimoUUPSUnauthorizedCallContext)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "UUPSUnauthorizedCallContext", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DevLicenseDimoUUPSUnsupportedProxiableUUID represents a UUPSUnsupportedProxiableUUID error raised by the DevLicenseDimo contract.
type DevLicenseDimoUUPSUnsupportedProxiableUUID struct {
	Slot [32]byte
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error UUPSUnsupportedProxiableUUID(bytes32 slot)
func DevLicenseDimoUUPSUnsupportedProxiableUUIDErrorID() common.Hash {
	return common.HexToHash("0xaa1d49a4c084bfa9aeeee2a0be65267a7f19ba7e1476b114dac513d2c14cb563")
}

// UnpackUUPSUnsupportedProxiableUUIDError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error UUPSUnsupportedProxiableUUID(bytes32 slot)
func (devLicenseDimo *DevLicenseDimo) UnpackUUPSUnsupportedProxiableUUIDError(raw []byte) (*DevLicenseDimoUUPSUnsupportedProxiableUUID, error) {
	out := new(DevLicenseDimoUUPSUnsupportedProxiableUUID)
	if err := devLicenseDimo.abi.UnpackIntoInterface(out, "UUPSUnsupportedProxiableUUID", raw); err != nil {
		return nil, err
	}
	return out, nil
}
