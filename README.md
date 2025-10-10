# DIMO Developer License

This is an NFT collection minted for developers building on the DIMO Network.

## How to run

You can execute the following commands to build the project and run additional scripts:

```sh
# Installs dependencies
npm i

# Compiles contracts
npm run build

# Run tests
npm run test
```

## Documentation

```
forge doc --serve --port 40000
```

## Deployment Script

Using `$DIMO`.

```
npx hardhat run script/deploy.ts
```

```
npx hardhat run script/upgrade.ts
```

## Normalized Price Provider

## Resources

- [PRD](https://docs.google.com/document/d/1V7qlsMj8GgujmnHYlQ1ZiW_DDkxHWkvkDQ70itPtRsg/edit)
- [Spec #0](https://docs.google.com/document/d/1fFXOi_lmVBGG-vYmwSCZVd9nRRf3d0jP1hZjJq-G8MA/edit)

### Go ABI

To regenerate the Go bindings for, e.g., [the devices API](https://github.com/DIMO-Network/devices-api/blob/main/internal/contracts/registry.go), you would run

```sh
npm run abigen
```

and copy over the generated files from [bindings](/bindings) folder.
