# Upgrading the Developer License contracts

This repo has four upgradeable on-chain pieces:

| Contract | Pattern | How it's upgraded |
|---|---|---|
| `DevLicenseDimo` | UUPS proxy | `upgradeToAndCall` on the proxy |
| `DimoCredit` | UUPS proxy | `upgradeToAndCall` on the proxy |
| `LicenseAccountFactory` | UUPS proxy | `upgradeToAndCall` on the proxy |
| `DimoDeveloperLicenseAccount` | **Beacon implementation** | `upgradeTo` on the `UpgradeableBeacon` |

The license accounts are the interesting case. Every license account is a
`BeaconProxy` clone pointing at a single `UpgradeableBeacon`. The beacon holds
the address of the `DimoDeveloperLicenseAccount` implementation. **Upgrading the
beacon's implementation instantly upgrades every existing license account** — no
per-account migration, no new clones. So a change like adding `execute()` is a
single `beacon.upgradeTo(newImpl)` call.

> Storage safety: `DimoDeveloperLicenseAccount` uses ERC-7201 namespaced
> storage. When you change it, only **append** functions/state — don't reorder or
> change the existing `DimoDeveloperLicenseAccountStorage` struct, or you'll
> corrupt every live account.

## The upgrade script

`script/upgrade.ts` drives upgrades via Hardhat. Two building blocks:

- `upgradeContract(name, …)` — UUPS proxies (DevLicenseDimo, DimoCredit, factory).
- `upgradeLicenseAccount(…)` — deploys a new `DimoDeveloperLicenseAccount` impl
  and calls `upgradeTo` on the beacon.

`main()` is what actually runs, and **you edit `main()` to scope each upgrade to
only what changed.** Don't leave it upgrading all four contracts if only one
changed — that needlessly redeploys and re-`upgradeToAndCall`s untouched proxies
(wasted gas + risk).

Example: a change that only touches the license account implementation (e.g.
adding `execute()`/`receive()`):

```ts
async function main() {
    let [deployer, user1] = await ethers.getSigners();
    let { name } = await ethers.provider.getNetwork();

    // ... (localhost fork branch) ...

    await upgradeLicenseAccount(deployer, name, true); // true = verify on Polygonscan
}
```

For a change that also touched, say, `DevLicenseDimo`, add
`await upgradeContract("DevLicenseDimo", deployer, name, true)` and so on.

The script reads ABIs/bytecode from `out/` and rewrites
`script/data/addresses.json` with the newly deployed address(es).

### Prerequisites

1. Env (`.env` or exported in your shell):
   - `AMOY_URL` / `POLYGON_URL` — RPC endpoints
   - `PRIVATE_KEY` — the deployer key (see the per-network ownership notes below)
   - `POLYGONSCAN_API_KEY` — for verification
2. Build artifacts:
   ```bash
   forge build
   ```
   **Use `forge build`, not `npm run build`.** `npm run build` runs
   `forge build --skip test`, and `UpgradeableBeacon` is only referenced from
   test files — so `--skip test` won't emit `out/UpgradeableBeacon.sol/…`, and
   `upgradeLicenseAccount` (which needs the beacon ABI) will fail.

## Testnet (Amoy) — beacon owned by an EOA

On Amoy the beacon and proxies are owned by the shared dev EOA
(`0xC008EF40B0b42AAD7e34879EB024385024f753ea`). As long as `PRIVATE_KEY` is that
key, the script can do everything end to end:

```bash
forge build
npx hardhat run script/upgrade.ts --network amoy
```

This deploys the new impl, calls `beacon.upgradeTo(newImpl)`, updates
`addresses.json`, and verifies on Amoy Polygonscan.

> Optional dry run: start a fork (`npx hardhat node --fork $AMOY_URL`) and run
> with `--network localhost`. `main()`'s `localhost` branch impersonates the
> owner so `upgradeTo` passes. Make sure the impersonated address is the actual
> beacon owner.

## Mainnet (Polygon) — beacon owned by a Gnosis Safe

On prod the beacon (and the `Admin` role) is owned by a **Gnosis Safe**
(`0x62b98e019e0d3e4A1Ad8C786202e09017Bd995e1`), not an EOA. So the flow splits in
two:

**Step 1 — deploy the implementation (any deployer key).** Deploying a contract
needs no special permission, so this is the same as Amoy *except* you must skip
the `upgradeTo` call (your key can't call it — the Safe owns the beacon). Edit
`upgradeLicenseAccount` in `script/upgrade.ts` to deploy-only by commenting out
the beacon call:

```ts
    // const addressProxy = instances[networkName].UpgradeableBeacon;
    // const proxy = getContractInstance(signer, 'UpgradeableBeacon', addressProxy)
    // await (await proxy.upgradeTo(addressDdla)).wait()
    // console.log(`${nameDdla} template contract was upgraded to ${addressDdla}`);
```

Then:

```bash
forge build
npx hardhat run script/upgrade.ts --network polygon
```

Record the deployed implementation address it prints (it also writes it to
`addresses.json`). Verify it:

```bash
forge verify-contract <NEW_IMPL> DimoDeveloperLicenseAccount \
    --chain-id 137 --etherscan-api-key $POLYGONSCAN_API_KEY
```

**Step 2 — point the beacon at it, via the Safe.** Submit an `upgradeTo` call to
the beacon `0x734bc70E7A600D0c1fdc6D7a74120e397058051D` through the Safe
(app.safe.global → New transaction → Transaction Builder, or a custom tx). The
calldata is:

```bash
cast calldata "upgradeTo(address)" <NEW_IMPL>
```

Target: the beacon. Value: 0. Once the required Safe signers confirm and it
executes, every license account is upgraded.

> The same Safe-mediated pattern applies to the UUPS proxies on prod
> (`upgradeToAndCall` is `onlyRole(UPGRADER_ROLE)`, held by the Safe): deploy the
> new implementation with a normal key, then submit the `upgradeToAndCall` call
> through the Safe.

## Verifying an upgrade on-chain

After upgrading, confirm the beacon points at the new impl and that behavior is
correct. (Examples below use Amoy values from the `execute()` rollout; swap in
the relevant addresses/RPC.)

```bash
RPC=https://polygon-amoy.drpc.org
BEACON=0x938Dae8B8B99950b9e75f6dFdA59F2007211c697

# Beacon now points at the new implementation
cast call $BEACON "implementation()(address)" --rpc-url $RPC
```

For the `execute()` rollout specifically, the following were checked on Amoy and
all passed — a useful template for future account upgrades:

**New `execute()` / `receive()`**
- `implementation()` returns the new impl; `execute(address,uint256,bytes)`
  selector (`0xb61d27f6`) present in the deployed bytecode.
- Owner calling `execute(account, 0, <tokenId() selector>)` returns the tokenId;
  a non-owner gets `Unauthorized()` (`0x82b42900`).
- Account can receive native POL (`receive()`) and forward it back out via
  `execute(target, value, 0x)`.
- Account can receive an ERC-20 and send it back out via
  `execute(token, 0, <transfer calldata>)`.

**Pre-existing behavior still intact (storage preserved)**
- `tokenId()` and `license()` read back correctly.
- ERC-1271 `isValidSignature`: a genuinely enabled signer's signature returns the
  magic value `0x1626ba7e`; everything else is rejected —
  - valid sig from a non-enabled signer → `0xffffffff`
  - valid sig over a different hash → `0xffffffff`
  - tampered sig → `0xffffffff`
  - malformed-length sig → reverts `ECDSAInvalidSignatureLength`

## Key addresses

| | Amoy | Polygon |
|---|---|---|
| UpgradeableBeacon | `0x938Dae8B8B99950b9e75f6dFdA59F2007211c697` | `0x734bc70E7A600D0c1fdc6D7a74120e397058051D` |
| DevLicenseDimo (proxy) | `0xdb6c0dBbaf48b9D9Bcf5ca3C45cFF3811D70eD96` | `0x9A9D2E717bB005B240094ba761Ff074d392C7C85` |
| Beacon/Admin owner | `0xC008…f753ea` (EOA dev key) | `0x62b98e…995e1` (Gnosis Safe) |

See `script/data/addresses.json` for the full, current set.
