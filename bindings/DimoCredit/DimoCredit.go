// Code generated via abigen V2 - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package dimoCredit

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

// DimoCreditMetaData contains all meta data concerning the DimoCredit contract.
var DimoCreditMetaData = bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"BURNER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"DC_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"DEFAULT_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"TRANSFERER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"UPGRADER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"UPGRADE_INTERFACE_VERSION\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"allowance\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"approve\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"balanceOf\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"burn\",\"inputs\":[{\"name\":\"from\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"decimals\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint8\",\"internalType\":\"uint8\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"dimoCreditRate\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"dimoToken\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getQuote\",\"inputs\":[],\"outputs\":[{\"name\":\"quote\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getQuote\",\"inputs\":[{\"name\":\"amountDimoTokens\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"quote\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getQuoteDc\",\"inputs\":[{\"name\":\"amountDcxTokens\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"quote\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getQuoteDc\",\"inputs\":[],\"outputs\":[{\"name\":\"quote\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getRoleAdmin\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"grantRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"hasRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"initialize\",\"inputs\":[{\"name\":\"name_\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"symbol_\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"dimoToken_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"receiver_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"provider_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"periodValidity_\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"dimoCreditRateInWei_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"mint\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amountDimoCredits\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"mint\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amountDimoCredits\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"mintInDimo\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amountDimoTokens\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[{\"name\":\"dimoCredits\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"mintInDimo\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amountDimoTokens\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"dimoCredits\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"name\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"periodValidity\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"provider\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"proxiableUUID\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"receiver\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"renounceRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"callerConfirmation\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revokeRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setDimoCreditRate\",\"inputs\":[{\"name\":\"dimoCreditRateInWei_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setDimoTokenAddress\",\"inputs\":[{\"name\":\"dimoTokenAddress_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setPeriodValidity\",\"inputs\":[{\"name\":\"periodValidity_\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setPriceProviderAddress\",\"inputs\":[{\"name\":\"providerAddress_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"setReceiverAddress\",\"inputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"supportsInterface\",\"inputs\":[{\"name\":\"interfaceId\",\"type\":\"bytes4\",\"internalType\":\"bytes4\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"symbol\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"totalSupply\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"transfer\",\"inputs\":[{\"name\":\"to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"transferFrom\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"updatePrice\",\"inputs\":[{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"upgradeToAndCall\",\"inputs\":[{\"name\":\"newImplementation\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"payable\"},{\"type\":\"event\",\"name\":\"Initialized\",\"inputs\":[{\"name\":\"version\",\"type\":\"uint64\",\"indexed\":false,\"internalType\":\"uint64\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleAdminChanged\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"previousAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"newAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleGranted\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleRevoked\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Transfer\",\"inputs\":[{\"name\":\"from\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"to\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateDimoCreditRate\",\"inputs\":[{\"name\":\"rate\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateDimoTokenAddress\",\"inputs\":[{\"name\":\"dimo_\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdatePeriodValidity\",\"inputs\":[{\"name\":\"periodValidity\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdatePriceProviderAddress\",\"inputs\":[{\"name\":\"provider\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UpdateReceiverAddress\",\"inputs\":[{\"name\":\"receiver_\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Upgraded\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AccessControlBadConfirmation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AccessControlUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"neededRole\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AddressEmptyCode\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"ERC1967InvalidImplementation\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"ERC1967NonPayable\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FailedCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InsufficientBalance\",\"inputs\":[{\"name\":\"from\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"fromBalance\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"InvalidInitialization\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidOperation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotInitializing\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UUPSUnauthorizedCallContext\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UUPSUnsupportedProxiableUUID\",\"inputs\":[{\"name\":\"slot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"Unauthorized\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"ZeroAddress\",\"inputs\":[]}]",
	ID:  "DimoCredit",
}

// DimoCredit is an auto generated Go binding around an Ethereum contract.
type DimoCredit struct {
	abi abi.ABI
}

// NewDimoCredit creates a new instance of DimoCredit.
func NewDimoCredit() *DimoCredit {
	parsed, err := DimoCreditMetaData.ParseABI()
	if err != nil {
		panic(errors.New("invalid ABI: " + err.Error()))
	}
	return &DimoCredit{abi: *parsed}
}

// Instance creates a wrapper for a deployed contract instance at the given address.
// Use this to create the instance object passed to abigen v2 library functions Call, Transact, etc.
func (c *DimoCredit) Instance(backend bind.ContractBackend, addr common.Address) *bind.BoundContract {
	return bind.NewBoundContract(addr, c.abi, backend, backend, backend)
}

// PackBURNERROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x282c51f3.
//
// Solidity: function BURNER_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) PackBURNERROLE() []byte {
	enc, err := dimoCredit.abi.Pack("BURNER_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackBURNERROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x282c51f3.
//
// Solidity: function BURNER_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackBURNERROLE(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("BURNER_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackDCADMINROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x43b80b81.
//
// Solidity: function DC_ADMIN_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) PackDCADMINROLE() []byte {
	enc, err := dimoCredit.abi.Pack("DC_ADMIN_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDCADMINROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x43b80b81.
//
// Solidity: function DC_ADMIN_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackDCADMINROLE(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("DC_ADMIN_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackDEFAULTADMINROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) PackDEFAULTADMINROLE() []byte {
	enc, err := dimoCredit.abi.Pack("DEFAULT_ADMIN_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDEFAULTADMINROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackDEFAULTADMINROLE(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("DEFAULT_ADMIN_ROLE", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackTRANSFERERROLE is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x0ade7dc1.
//
// Solidity: function TRANSFERER_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) PackTRANSFERERROLE() []byte {
	enc, err := dimoCredit.abi.Pack("TRANSFERER_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTRANSFERERROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x0ade7dc1.
//
// Solidity: function TRANSFERER_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackTRANSFERERROLE(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("TRANSFERER_ROLE", data)
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
func (dimoCredit *DimoCredit) PackUPGRADERROLE() []byte {
	enc, err := dimoCredit.abi.Pack("UPGRADER_ROLE")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackUPGRADERROLE is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf72c0d8b.
//
// Solidity: function UPGRADER_ROLE() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackUPGRADERROLE(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("UPGRADER_ROLE", data)
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
func (dimoCredit *DimoCredit) PackUPGRADEINTERFACEVERSION() []byte {
	enc, err := dimoCredit.abi.Pack("UPGRADE_INTERFACE_VERSION")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackUPGRADEINTERFACEVERSION is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (dimoCredit *DimoCredit) UnpackUPGRADEINTERFACEVERSION(data []byte) (string, error) {
	out, err := dimoCredit.abi.Unpack("UPGRADE_INTERFACE_VERSION", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackAllowance is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xdd62ed3e.
//
// Solidity: function allowance(address , address ) pure returns(uint256)
func (dimoCredit *DimoCredit) PackAllowance(arg0 common.Address, arg1 common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("allowance", arg0, arg1)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackAllowance is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xdd62ed3e.
//
// Solidity: function allowance(address , address ) pure returns(uint256)
func (dimoCredit *DimoCredit) UnpackAllowance(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("allowance", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackApprove is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x095ea7b3.
//
// Solidity: function approve(address , uint256 ) pure returns(bool)
func (dimoCredit *DimoCredit) PackApprove(arg0 common.Address, arg1 *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("approve", arg0, arg1)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackApprove is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x095ea7b3.
//
// Solidity: function approve(address , uint256 ) pure returns(bool)
func (dimoCredit *DimoCredit) UnpackApprove(data []byte) (bool, error) {
	out, err := dimoCredit.abi.Unpack("approve", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackBalanceOf is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (dimoCredit *DimoCredit) PackBalanceOf(account common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("balanceOf", account)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackBalanceOf is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x70a08231.
//
// Solidity: function balanceOf(address account) view returns(uint256)
func (dimoCredit *DimoCredit) UnpackBalanceOf(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("balanceOf", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackBurn is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x9dc29fac.
//
// Solidity: function burn(address from, uint256 amount) returns()
func (dimoCredit *DimoCredit) PackBurn(from common.Address, amount *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("burn", from, amount)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackDecimals is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x313ce567.
//
// Solidity: function decimals() pure returns(uint8)
func (dimoCredit *DimoCredit) PackDecimals() []byte {
	enc, err := dimoCredit.abi.Pack("decimals")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDecimals is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x313ce567.
//
// Solidity: function decimals() pure returns(uint8)
func (dimoCredit *DimoCredit) UnpackDecimals(data []byte) (uint8, error) {
	out, err := dimoCredit.abi.Unpack("decimals", data)
	if err != nil {
		return *new(uint8), err
	}
	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)
	return out0, err
}

// PackDimoCreditRate is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xb06965b6.
//
// Solidity: function dimoCreditRate() view returns(uint256)
func (dimoCredit *DimoCredit) PackDimoCreditRate() []byte {
	enc, err := dimoCredit.abi.Pack("dimoCreditRate")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDimoCreditRate is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xb06965b6.
//
// Solidity: function dimoCreditRate() view returns(uint256)
func (dimoCredit *DimoCredit) UnpackDimoCreditRate(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("dimoCreditRate", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackDimoToken is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x0524f28c.
//
// Solidity: function dimoToken() view returns(address)
func (dimoCredit *DimoCredit) PackDimoToken() []byte {
	enc, err := dimoCredit.abi.Pack("dimoToken")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackDimoToken is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x0524f28c.
//
// Solidity: function dimoToken() view returns(address)
func (dimoCredit *DimoCredit) UnpackDimoToken(data []byte) (common.Address, error) {
	out, err := dimoCredit.abi.Unpack("dimoToken", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackGetQuote is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x171755b1.
//
// Solidity: function getQuote() view returns(uint256 quote)
func (dimoCredit *DimoCredit) PackGetQuote() []byte {
	enc, err := dimoCredit.abi.Pack("getQuote")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetQuote is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x171755b1.
//
// Solidity: function getQuote() view returns(uint256 quote)
func (dimoCredit *DimoCredit) UnpackGetQuote(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("getQuote", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetQuote0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xcf39918e.
//
// Solidity: function getQuote(uint256 amountDimoTokens) view returns(uint256 quote)
func (dimoCredit *DimoCredit) PackGetQuote0(amountDimoTokens *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("getQuote0", amountDimoTokens)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetQuote0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xcf39918e.
//
// Solidity: function getQuote(uint256 amountDimoTokens) view returns(uint256 quote)
func (dimoCredit *DimoCredit) UnpackGetQuote0(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("getQuote0", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetQuoteDc is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x63746fd3.
//
// Solidity: function getQuoteDc(uint256 amountDcxTokens) view returns(uint256 quote)
func (dimoCredit *DimoCredit) PackGetQuoteDc(amountDcxTokens *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("getQuoteDc", amountDcxTokens)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetQuoteDc is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x63746fd3.
//
// Solidity: function getQuoteDc(uint256 amountDcxTokens) view returns(uint256 quote)
func (dimoCredit *DimoCredit) UnpackGetQuoteDc(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("getQuoteDc", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetQuoteDc0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xffb37c10.
//
// Solidity: function getQuoteDc() view returns(uint256 quote)
func (dimoCredit *DimoCredit) PackGetQuoteDc0() []byte {
	enc, err := dimoCredit.abi.Pack("getQuoteDc0")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetQuoteDc0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xffb37c10.
//
// Solidity: function getQuoteDc() view returns(uint256 quote)
func (dimoCredit *DimoCredit) UnpackGetQuoteDc0(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("getQuoteDc0", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackGetRoleAdmin is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (dimoCredit *DimoCredit) PackGetRoleAdmin(role [32]byte) []byte {
	enc, err := dimoCredit.abi.Pack("getRoleAdmin", role)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackGetRoleAdmin is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackGetRoleAdmin(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("getRoleAdmin", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackGrantRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (dimoCredit *DimoCredit) PackGrantRole(role [32]byte, account common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("grantRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackHasRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (dimoCredit *DimoCredit) PackHasRole(role [32]byte, account common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("hasRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackHasRole is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (dimoCredit *DimoCredit) UnpackHasRole(data []byte) (bool, error) {
	out, err := dimoCredit.abi.Unpack("hasRole", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackInitialize is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xcd3fa04b.
//
// Solidity: function initialize(string name_, string symbol_, address dimoToken_, address receiver_, address provider_, uint256 periodValidity_, uint256 dimoCreditRateInWei_) returns()
func (dimoCredit *DimoCredit) PackInitialize(name string, symbol string, dimoToken common.Address, receiver common.Address, provider common.Address, periodValidity *big.Int, dimoCreditRateInWei *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("initialize", name, symbol, dimoToken, receiver, provider, periodValidity, dimoCreditRateInWei)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackMint is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x40c10f19.
//
// Solidity: function mint(address to, uint256 amountDimoCredits) returns()
func (dimoCredit *DimoCredit) PackMint(to common.Address, amountDimoCredits *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("mint", to, amountDimoCredits)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackMint0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x94d008ef.
//
// Solidity: function mint(address to, uint256 amountDimoCredits, bytes data) returns()
func (dimoCredit *DimoCredit) PackMint0(to common.Address, amountDimoCredits *big.Int, data []byte) []byte {
	enc, err := dimoCredit.abi.Pack("mint0", to, amountDimoCredits, data)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackMintInDimo is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x7f2c81a0.
//
// Solidity: function mintInDimo(address to, uint256 amountDimoTokens, bytes data) returns(uint256 dimoCredits)
func (dimoCredit *DimoCredit) PackMintInDimo(to common.Address, amountDimoTokens *big.Int, data []byte) []byte {
	enc, err := dimoCredit.abi.Pack("mintInDimo", to, amountDimoTokens, data)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackMintInDimo is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x7f2c81a0.
//
// Solidity: function mintInDimo(address to, uint256 amountDimoTokens, bytes data) returns(uint256 dimoCredits)
func (dimoCredit *DimoCredit) UnpackMintInDimo(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("mintInDimo", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackMintInDimo0 is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xec88fc37.
//
// Solidity: function mintInDimo(address to, uint256 amountDimoTokens) returns(uint256 dimoCredits)
func (dimoCredit *DimoCredit) PackMintInDimo0(to common.Address, amountDimoTokens *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("mintInDimo0", to, amountDimoTokens)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackMintInDimo0 is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xec88fc37.
//
// Solidity: function mintInDimo(address to, uint256 amountDimoTokens) returns(uint256 dimoCredits)
func (dimoCredit *DimoCredit) UnpackMintInDimo0(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("mintInDimo0", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackName is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (dimoCredit *DimoCredit) PackName() []byte {
	enc, err := dimoCredit.abi.Pack("name")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackName is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (dimoCredit *DimoCredit) UnpackName(data []byte) (string, error) {
	out, err := dimoCredit.abi.Unpack("name", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackPeriodValidity is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xb30afb81.
//
// Solidity: function periodValidity() view returns(uint256)
func (dimoCredit *DimoCredit) PackPeriodValidity() []byte {
	enc, err := dimoCredit.abi.Pack("periodValidity")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackPeriodValidity is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xb30afb81.
//
// Solidity: function periodValidity() view returns(uint256)
func (dimoCredit *DimoCredit) UnpackPeriodValidity(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("periodValidity", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackProvider is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x085d4883.
//
// Solidity: function provider() view returns(address)
func (dimoCredit *DimoCredit) PackProvider() []byte {
	enc, err := dimoCredit.abi.Pack("provider")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackProvider is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x085d4883.
//
// Solidity: function provider() view returns(address)
func (dimoCredit *DimoCredit) UnpackProvider(data []byte) (common.Address, error) {
	out, err := dimoCredit.abi.Unpack("provider", data)
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
func (dimoCredit *DimoCredit) PackProxiableUUID() []byte {
	enc, err := dimoCredit.abi.Pack("proxiableUUID")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackProxiableUUID is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (dimoCredit *DimoCredit) UnpackProxiableUUID(data []byte) ([32]byte, error) {
	out, err := dimoCredit.abi.Unpack("proxiableUUID", data)
	if err != nil {
		return *new([32]byte), err
	}
	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	return out0, err
}

// PackReceiver is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xf7260d3e.
//
// Solidity: function receiver() view returns(address)
func (dimoCredit *DimoCredit) PackReceiver() []byte {
	enc, err := dimoCredit.abi.Pack("receiver")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackReceiver is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xf7260d3e.
//
// Solidity: function receiver() view returns(address)
func (dimoCredit *DimoCredit) UnpackReceiver(data []byte) (common.Address, error) {
	out, err := dimoCredit.abi.Unpack("receiver", data)
	if err != nil {
		return *new(common.Address), err
	}
	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)
	return out0, err
}

// PackRenounceRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (dimoCredit *DimoCredit) PackRenounceRole(role [32]byte, callerConfirmation common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("renounceRole", role, callerConfirmation)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackRevokeRole is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (dimoCredit *DimoCredit) PackRevokeRole(role [32]byte, account common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("revokeRole", role, account)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetDimoCreditRate is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xe3a2d827.
//
// Solidity: function setDimoCreditRate(uint256 dimoCreditRateInWei_) returns()
func (dimoCredit *DimoCredit) PackSetDimoCreditRate(dimoCreditRateInWei *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("setDimoCreditRate", dimoCreditRateInWei)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetDimoTokenAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x81c9bb13.
//
// Solidity: function setDimoTokenAddress(address dimoTokenAddress_) returns()
func (dimoCredit *DimoCredit) PackSetDimoTokenAddress(dimoTokenAddress common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("setDimoTokenAddress", dimoTokenAddress)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetPeriodValidity is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xd0dde29b.
//
// Solidity: function setPeriodValidity(uint256 periodValidity_) returns()
func (dimoCredit *DimoCredit) PackSetPeriodValidity(periodValidity *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("setPeriodValidity", periodValidity)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetPriceProviderAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x920e7190.
//
// Solidity: function setPriceProviderAddress(address providerAddress_) returns()
func (dimoCredit *DimoCredit) PackSetPriceProviderAddress(providerAddress common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("setPriceProviderAddress", providerAddress)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSetReceiverAddress is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x8279c7db.
//
// Solidity: function setReceiverAddress(address receiver_) returns()
func (dimoCredit *DimoCredit) PackSetReceiverAddress(receiver common.Address) []byte {
	enc, err := dimoCredit.abi.Pack("setReceiverAddress", receiver)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackSupportsInterface is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (dimoCredit *DimoCredit) PackSupportsInterface(interfaceId [4]byte) []byte {
	enc, err := dimoCredit.abi.Pack("supportsInterface", interfaceId)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackSupportsInterface is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (dimoCredit *DimoCredit) UnpackSupportsInterface(data []byte) (bool, error) {
	out, err := dimoCredit.abi.Unpack("supportsInterface", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackSymbol is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (dimoCredit *DimoCredit) PackSymbol() []byte {
	enc, err := dimoCredit.abi.Pack("symbol")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackSymbol is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (dimoCredit *DimoCredit) UnpackSymbol(data []byte) (string, error) {
	out, err := dimoCredit.abi.Unpack("symbol", data)
	if err != nil {
		return *new(string), err
	}
	out0 := *abi.ConvertType(out[0], new(string)).(*string)
	return out0, err
}

// PackTotalSupply is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (dimoCredit *DimoCredit) PackTotalSupply() []byte {
	enc, err := dimoCredit.abi.Pack("totalSupply")
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTotalSupply is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (dimoCredit *DimoCredit) UnpackTotalSupply(data []byte) (*big.Int, error) {
	out, err := dimoCredit.abi.Unpack("totalSupply", data)
	if err != nil {
		return new(big.Int), err
	}
	out0 := abi.ConvertType(out[0], new(big.Int)).(*big.Int)
	return out0, err
}

// PackTransfer is the Go binding used to pack the parameters required for calling
// the contract method with ID 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (dimoCredit *DimoCredit) PackTransfer(to common.Address, amount *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("transfer", to, amount)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTransfer is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (dimoCredit *DimoCredit) UnpackTransfer(data []byte) (bool, error) {
	out, err := dimoCredit.abi.Unpack("transfer", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackTransferFrom is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x23b872dd.
//
// Solidity: function transferFrom(address , address , uint256 ) pure returns(bool)
func (dimoCredit *DimoCredit) PackTransferFrom(arg0 common.Address, arg1 common.Address, arg2 *big.Int) []byte {
	enc, err := dimoCredit.abi.Pack("transferFrom", arg0, arg1, arg2)
	if err != nil {
		panic(err)
	}
	return enc
}

// UnpackTransferFrom is the Go binding that unpacks the parameters returned
// from invoking the contract method with ID 0x23b872dd.
//
// Solidity: function transferFrom(address , address , uint256 ) pure returns(bool)
func (dimoCredit *DimoCredit) UnpackTransferFrom(data []byte) (bool, error) {
	out, err := dimoCredit.abi.Unpack("transferFrom", data)
	if err != nil {
		return *new(bool), err
	}
	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)
	return out0, err
}

// PackUpdatePrice is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x8736ec47.
//
// Solidity: function updatePrice(bytes data) returns()
func (dimoCredit *DimoCredit) PackUpdatePrice(data []byte) []byte {
	enc, err := dimoCredit.abi.Pack("updatePrice", data)
	if err != nil {
		panic(err)
	}
	return enc
}

// PackUpgradeToAndCall is the Go binding used to pack the parameters required for calling
// the contract method with ID 0x4f1ef286.
//
// Solidity: function upgradeToAndCall(address newImplementation, bytes data) payable returns()
func (dimoCredit *DimoCredit) PackUpgradeToAndCall(newImplementation common.Address, data []byte) []byte {
	enc, err := dimoCredit.abi.Pack("upgradeToAndCall", newImplementation, data)
	if err != nil {
		panic(err)
	}
	return enc
}

// DimoCreditInitialized represents a Initialized event raised by the DimoCredit contract.
type DimoCreditInitialized struct {
	Version uint64
	Raw     *types.Log // Blockchain specific contextual infos
}

const DimoCreditInitializedEventName = "Initialized"

// ContractEventName returns the user-defined event name.
func (DimoCreditInitialized) ContractEventName() string {
	return DimoCreditInitializedEventName
}

// UnpackInitializedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Initialized(uint64 version)
func (dimoCredit *DimoCredit) UnpackInitializedEvent(log *types.Log) (*DimoCreditInitialized, error) {
	event := "Initialized"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditInitialized)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditRoleAdminChanged represents a RoleAdminChanged event raised by the DimoCredit contract.
type DimoCreditRoleAdminChanged struct {
	Role              [32]byte
	PreviousAdminRole [32]byte
	NewAdminRole      [32]byte
	Raw               *types.Log // Blockchain specific contextual infos
}

const DimoCreditRoleAdminChangedEventName = "RoleAdminChanged"

// ContractEventName returns the user-defined event name.
func (DimoCreditRoleAdminChanged) ContractEventName() string {
	return DimoCreditRoleAdminChangedEventName
}

// UnpackRoleAdminChangedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (dimoCredit *DimoCredit) UnpackRoleAdminChangedEvent(log *types.Log) (*DimoCreditRoleAdminChanged, error) {
	event := "RoleAdminChanged"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditRoleAdminChanged)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditRoleGranted represents a RoleGranted event raised by the DimoCredit contract.
type DimoCreditRoleGranted struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DimoCreditRoleGrantedEventName = "RoleGranted"

// ContractEventName returns the user-defined event name.
func (DimoCreditRoleGranted) ContractEventName() string {
	return DimoCreditRoleGrantedEventName
}

// UnpackRoleGrantedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (dimoCredit *DimoCredit) UnpackRoleGrantedEvent(log *types.Log) (*DimoCreditRoleGranted, error) {
	event := "RoleGranted"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditRoleGranted)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditRoleRevoked represents a RoleRevoked event raised by the DimoCredit contract.
type DimoCreditRoleRevoked struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     *types.Log // Blockchain specific contextual infos
}

const DimoCreditRoleRevokedEventName = "RoleRevoked"

// ContractEventName returns the user-defined event name.
func (DimoCreditRoleRevoked) ContractEventName() string {
	return DimoCreditRoleRevokedEventName
}

// UnpackRoleRevokedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (dimoCredit *DimoCredit) UnpackRoleRevokedEvent(log *types.Log) (*DimoCreditRoleRevoked, error) {
	event := "RoleRevoked"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditRoleRevoked)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditTransfer represents a Transfer event raised by the DimoCredit contract.
type DimoCreditTransfer struct {
	From   common.Address
	To     common.Address
	Amount *big.Int
	Raw    *types.Log // Blockchain specific contextual infos
}

const DimoCreditTransferEventName = "Transfer"

// ContractEventName returns the user-defined event name.
func (DimoCreditTransfer) ContractEventName() string {
	return DimoCreditTransferEventName
}

// UnpackTransferEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 amount)
func (dimoCredit *DimoCredit) UnpackTransferEvent(log *types.Log) (*DimoCreditTransfer, error) {
	event := "Transfer"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditTransfer)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpdateDimoCreditRate represents a UpdateDimoCreditRate event raised by the DimoCredit contract.
type DimoCreditUpdateDimoCreditRate struct {
	Rate *big.Int
	Raw  *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpdateDimoCreditRateEventName = "UpdateDimoCreditRate"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpdateDimoCreditRate) ContractEventName() string {
	return DimoCreditUpdateDimoCreditRateEventName
}

// UnpackUpdateDimoCreditRateEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateDimoCreditRate(uint256 rate)
func (dimoCredit *DimoCredit) UnpackUpdateDimoCreditRateEvent(log *types.Log) (*DimoCreditUpdateDimoCreditRate, error) {
	event := "UpdateDimoCreditRate"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpdateDimoCreditRate)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpdateDimoTokenAddress represents a UpdateDimoTokenAddress event raised by the DimoCredit contract.
type DimoCreditUpdateDimoTokenAddress struct {
	Dimo common.Address
	Raw  *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpdateDimoTokenAddressEventName = "UpdateDimoTokenAddress"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpdateDimoTokenAddress) ContractEventName() string {
	return DimoCreditUpdateDimoTokenAddressEventName
}

// UnpackUpdateDimoTokenAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateDimoTokenAddress(address indexed dimo_)
func (dimoCredit *DimoCredit) UnpackUpdateDimoTokenAddressEvent(log *types.Log) (*DimoCreditUpdateDimoTokenAddress, error) {
	event := "UpdateDimoTokenAddress"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpdateDimoTokenAddress)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpdatePeriodValidity represents a UpdatePeriodValidity event raised by the DimoCredit contract.
type DimoCreditUpdatePeriodValidity struct {
	PeriodValidity *big.Int
	Raw            *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpdatePeriodValidityEventName = "UpdatePeriodValidity"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpdatePeriodValidity) ContractEventName() string {
	return DimoCreditUpdatePeriodValidityEventName
}

// UnpackUpdatePeriodValidityEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdatePeriodValidity(uint256 periodValidity)
func (dimoCredit *DimoCredit) UnpackUpdatePeriodValidityEvent(log *types.Log) (*DimoCreditUpdatePeriodValidity, error) {
	event := "UpdatePeriodValidity"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpdatePeriodValidity)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpdatePriceProviderAddress represents a UpdatePriceProviderAddress event raised by the DimoCredit contract.
type DimoCreditUpdatePriceProviderAddress struct {
	Provider common.Address
	Raw      *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpdatePriceProviderAddressEventName = "UpdatePriceProviderAddress"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpdatePriceProviderAddress) ContractEventName() string {
	return DimoCreditUpdatePriceProviderAddressEventName
}

// UnpackUpdatePriceProviderAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdatePriceProviderAddress(address indexed provider)
func (dimoCredit *DimoCredit) UnpackUpdatePriceProviderAddressEvent(log *types.Log) (*DimoCreditUpdatePriceProviderAddress, error) {
	event := "UpdatePriceProviderAddress"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpdatePriceProviderAddress)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpdateReceiverAddress represents a UpdateReceiverAddress event raised by the DimoCredit contract.
type DimoCreditUpdateReceiverAddress struct {
	Receiver common.Address
	Raw      *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpdateReceiverAddressEventName = "UpdateReceiverAddress"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpdateReceiverAddress) ContractEventName() string {
	return DimoCreditUpdateReceiverAddressEventName
}

// UnpackUpdateReceiverAddressEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event UpdateReceiverAddress(address indexed receiver_)
func (dimoCredit *DimoCredit) UnpackUpdateReceiverAddressEvent(log *types.Log) (*DimoCreditUpdateReceiverAddress, error) {
	event := "UpdateReceiverAddress"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpdateReceiverAddress)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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

// DimoCreditUpgraded represents a Upgraded event raised by the DimoCredit contract.
type DimoCreditUpgraded struct {
	Implementation common.Address
	Raw            *types.Log // Blockchain specific contextual infos
}

const DimoCreditUpgradedEventName = "Upgraded"

// ContractEventName returns the user-defined event name.
func (DimoCreditUpgraded) ContractEventName() string {
	return DimoCreditUpgradedEventName
}

// UnpackUpgradedEvent is the Go binding that unpacks the event data emitted
// by contract.
//
// Solidity: event Upgraded(address indexed implementation)
func (dimoCredit *DimoCredit) UnpackUpgradedEvent(log *types.Log) (*DimoCreditUpgraded, error) {
	event := "Upgraded"
	if log.Topics[0] != dimoCredit.abi.Events[event].ID {
		return nil, errors.New("event signature mismatch")
	}
	out := new(DimoCreditUpgraded)
	if len(log.Data) > 0 {
		if err := dimoCredit.abi.UnpackIntoInterface(out, event, log.Data); err != nil {
			return nil, err
		}
	}
	var indexed abi.Arguments
	for _, arg := range dimoCredit.abi.Events[event].Inputs {
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
func (dimoCredit *DimoCredit) UnpackError(raw []byte) (any, error) {
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["AccessControlBadConfirmation"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackAccessControlBadConfirmationError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["AccessControlUnauthorizedAccount"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackAccessControlUnauthorizedAccountError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["AddressEmptyCode"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackAddressEmptyCodeError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["ERC1967InvalidImplementation"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackERC1967InvalidImplementationError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["ERC1967NonPayable"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackERC1967NonPayableError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["FailedCall"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackFailedCallError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["InsufficientBalance"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackInsufficientBalanceError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["InvalidInitialization"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackInvalidInitializationError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["InvalidOperation"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackInvalidOperationError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["NotInitializing"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackNotInitializingError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["UUPSUnauthorizedCallContext"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackUUPSUnauthorizedCallContextError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["UUPSUnsupportedProxiableUUID"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackUUPSUnsupportedProxiableUUIDError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["Unauthorized"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackUnauthorizedError(raw[4:])
	}
	if bytes.Equal(raw[:4], dimoCredit.abi.Errors["ZeroAddress"].ID.Bytes()[:4]) {
		return dimoCredit.UnpackZeroAddressError(raw[4:])
	}
	return nil, errors.New("Unknown error")
}

// DimoCreditAccessControlBadConfirmation represents a AccessControlBadConfirmation error raised by the DimoCredit contract.
type DimoCreditAccessControlBadConfirmation struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AccessControlBadConfirmation()
func DimoCreditAccessControlBadConfirmationErrorID() common.Hash {
	return common.HexToHash("0x6697b23232a647058342c0724fe7c415cab25915b54e5dbc03f233173d37b41c")
}

// UnpackAccessControlBadConfirmationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AccessControlBadConfirmation()
func (dimoCredit *DimoCredit) UnpackAccessControlBadConfirmationError(raw []byte) (*DimoCreditAccessControlBadConfirmation, error) {
	out := new(DimoCreditAccessControlBadConfirmation)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "AccessControlBadConfirmation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditAccessControlUnauthorizedAccount represents a AccessControlUnauthorizedAccount error raised by the DimoCredit contract.
type DimoCreditAccessControlUnauthorizedAccount struct {
	Account    common.Address
	NeededRole [32]byte
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AccessControlUnauthorizedAccount(address account, bytes32 neededRole)
func DimoCreditAccessControlUnauthorizedAccountErrorID() common.Hash {
	return common.HexToHash("0xe2517d3fbfae6f8515ef5ff1ccedc3933ab0cbbda0b492c06eb54ad10ef03b3e")
}

// UnpackAccessControlUnauthorizedAccountError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AccessControlUnauthorizedAccount(address account, bytes32 neededRole)
func (dimoCredit *DimoCredit) UnpackAccessControlUnauthorizedAccountError(raw []byte) (*DimoCreditAccessControlUnauthorizedAccount, error) {
	out := new(DimoCreditAccessControlUnauthorizedAccount)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "AccessControlUnauthorizedAccount", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditAddressEmptyCode represents a AddressEmptyCode error raised by the DimoCredit contract.
type DimoCreditAddressEmptyCode struct {
	Target common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error AddressEmptyCode(address target)
func DimoCreditAddressEmptyCodeErrorID() common.Hash {
	return common.HexToHash("0x9996b315c842ff135b8fc4a08ad5df1c344efbc03d2687aecc0678050d2aac89")
}

// UnpackAddressEmptyCodeError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error AddressEmptyCode(address target)
func (dimoCredit *DimoCredit) UnpackAddressEmptyCodeError(raw []byte) (*DimoCreditAddressEmptyCode, error) {
	out := new(DimoCreditAddressEmptyCode)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "AddressEmptyCode", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditERC1967InvalidImplementation represents a ERC1967InvalidImplementation error raised by the DimoCredit contract.
type DimoCreditERC1967InvalidImplementation struct {
	Implementation common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ERC1967InvalidImplementation(address implementation)
func DimoCreditERC1967InvalidImplementationErrorID() common.Hash {
	return common.HexToHash("0x4c9c8ce3ceb3130f17f7cdba48d89b5b0129f266a8bac114e6e315a41879b617")
}

// UnpackERC1967InvalidImplementationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ERC1967InvalidImplementation(address implementation)
func (dimoCredit *DimoCredit) UnpackERC1967InvalidImplementationError(raw []byte) (*DimoCreditERC1967InvalidImplementation, error) {
	out := new(DimoCreditERC1967InvalidImplementation)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "ERC1967InvalidImplementation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditERC1967NonPayable represents a ERC1967NonPayable error raised by the DimoCredit contract.
type DimoCreditERC1967NonPayable struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ERC1967NonPayable()
func DimoCreditERC1967NonPayableErrorID() common.Hash {
	return common.HexToHash("0xb398979fa84f543c8e222f17890372c487baf85e062276c127fef521eea7224b")
}

// UnpackERC1967NonPayableError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ERC1967NonPayable()
func (dimoCredit *DimoCredit) UnpackERC1967NonPayableError(raw []byte) (*DimoCreditERC1967NonPayable, error) {
	out := new(DimoCreditERC1967NonPayable)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "ERC1967NonPayable", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditFailedCall represents a FailedCall error raised by the DimoCredit contract.
type DimoCreditFailedCall struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error FailedCall()
func DimoCreditFailedCallErrorID() common.Hash {
	return common.HexToHash("0xd6bda27508c0fb6d8a39b4b122878dab26f731a7d4e4abe711dd3731899052a4")
}

// UnpackFailedCallError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error FailedCall()
func (dimoCredit *DimoCredit) UnpackFailedCallError(raw []byte) (*DimoCreditFailedCall, error) {
	out := new(DimoCreditFailedCall)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "FailedCall", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditInsufficientBalance represents a InsufficientBalance error raised by the DimoCredit contract.
type DimoCreditInsufficientBalance struct {
	From        common.Address
	FromBalance *big.Int
	Amount      *big.Int
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InsufficientBalance(address from, uint256 fromBalance, uint256 amount)
func DimoCreditInsufficientBalanceErrorID() common.Hash {
	return common.HexToHash("0xdb42144d928cd19733b9dfeead8bc02ed403845c274e06a6eee0944fb25ca5c4")
}

// UnpackInsufficientBalanceError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InsufficientBalance(address from, uint256 fromBalance, uint256 amount)
func (dimoCredit *DimoCredit) UnpackInsufficientBalanceError(raw []byte) (*DimoCreditInsufficientBalance, error) {
	out := new(DimoCreditInsufficientBalance)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "InsufficientBalance", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditInvalidInitialization represents a InvalidInitialization error raised by the DimoCredit contract.
type DimoCreditInvalidInitialization struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidInitialization()
func DimoCreditInvalidInitializationErrorID() common.Hash {
	return common.HexToHash("0xf92ee8a957075833165f68c320933b1a1294aafc84ee6e0dd3fb178008f9aaf5")
}

// UnpackInvalidInitializationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidInitialization()
func (dimoCredit *DimoCredit) UnpackInvalidInitializationError(raw []byte) (*DimoCreditInvalidInitialization, error) {
	out := new(DimoCreditInvalidInitialization)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "InvalidInitialization", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditInvalidOperation represents a InvalidOperation error raised by the DimoCredit contract.
type DimoCreditInvalidOperation struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error InvalidOperation()
func DimoCreditInvalidOperationErrorID() common.Hash {
	return common.HexToHash("0x398d4d32963991cf02978f96f1a4d81787345d957c0995bedfe70af66ce594fd")
}

// UnpackInvalidOperationError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error InvalidOperation()
func (dimoCredit *DimoCredit) UnpackInvalidOperationError(raw []byte) (*DimoCreditInvalidOperation, error) {
	out := new(DimoCreditInvalidOperation)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "InvalidOperation", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditNotInitializing represents a NotInitializing error raised by the DimoCredit contract.
type DimoCreditNotInitializing struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error NotInitializing()
func DimoCreditNotInitializingErrorID() common.Hash {
	return common.HexToHash("0xd7e6bcf8597daa127dc9f0048d2f08d5ef140a2cb659feabd700beff1f7a8302")
}

// UnpackNotInitializingError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error NotInitializing()
func (dimoCredit *DimoCredit) UnpackNotInitializingError(raw []byte) (*DimoCreditNotInitializing, error) {
	out := new(DimoCreditNotInitializing)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "NotInitializing", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditUUPSUnauthorizedCallContext represents a UUPSUnauthorizedCallContext error raised by the DimoCredit contract.
type DimoCreditUUPSUnauthorizedCallContext struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error UUPSUnauthorizedCallContext()
func DimoCreditUUPSUnauthorizedCallContextErrorID() common.Hash {
	return common.HexToHash("0xe07c8dba242a06571ac65fe4bbe20522c9fb111cb33599b799ff8039c1ed18f4")
}

// UnpackUUPSUnauthorizedCallContextError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error UUPSUnauthorizedCallContext()
func (dimoCredit *DimoCredit) UnpackUUPSUnauthorizedCallContextError(raw []byte) (*DimoCreditUUPSUnauthorizedCallContext, error) {
	out := new(DimoCreditUUPSUnauthorizedCallContext)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "UUPSUnauthorizedCallContext", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditUUPSUnsupportedProxiableUUID represents a UUPSUnsupportedProxiableUUID error raised by the DimoCredit contract.
type DimoCreditUUPSUnsupportedProxiableUUID struct {
	Slot [32]byte
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error UUPSUnsupportedProxiableUUID(bytes32 slot)
func DimoCreditUUPSUnsupportedProxiableUUIDErrorID() common.Hash {
	return common.HexToHash("0xaa1d49a4c084bfa9aeeee2a0be65267a7f19ba7e1476b114dac513d2c14cb563")
}

// UnpackUUPSUnsupportedProxiableUUIDError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error UUPSUnsupportedProxiableUUID(bytes32 slot)
func (dimoCredit *DimoCredit) UnpackUUPSUnsupportedProxiableUUIDError(raw []byte) (*DimoCreditUUPSUnsupportedProxiableUUID, error) {
	out := new(DimoCreditUUPSUnsupportedProxiableUUID)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "UUPSUnsupportedProxiableUUID", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditUnauthorized represents a Unauthorized error raised by the DimoCredit contract.
type DimoCreditUnauthorized struct {
	Account common.Address
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error Unauthorized(address account)
func DimoCreditUnauthorizedErrorID() common.Hash {
	return common.HexToHash("0x8e4a23d6a5d81f013eca4bc92aeb9214ccafcaebd1f097c350c922d6e19122d5")
}

// UnpackUnauthorizedError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error Unauthorized(address account)
func (dimoCredit *DimoCredit) UnpackUnauthorizedError(raw []byte) (*DimoCreditUnauthorized, error) {
	out := new(DimoCreditUnauthorized)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "Unauthorized", raw); err != nil {
		return nil, err
	}
	return out, nil
}

// DimoCreditZeroAddress represents a ZeroAddress error raised by the DimoCredit contract.
type DimoCreditZeroAddress struct {
}

// ErrorID returns the hash of canonical representation of the error's signature.
//
// Solidity: error ZeroAddress()
func DimoCreditZeroAddressErrorID() common.Hash {
	return common.HexToHash("0xd92e233df2717d4a40030e20904abd27b68fcbeede117eaaccbbdac9618c8c73")
}

// UnpackZeroAddressError is the Go binding used to decode the provided
// error data into the corresponding Go error struct.
//
// Solidity: error ZeroAddress()
func (dimoCredit *DimoCredit) UnpackZeroAddressError(raw []byte) (*DimoCreditZeroAddress, error) {
	out := new(DimoCreditZeroAddress)
	if err := dimoCredit.abi.UnpackIntoInterface(out, "ZeroAddress", raw); err != nil {
		return nil, err
	}
	return out, nil
}
