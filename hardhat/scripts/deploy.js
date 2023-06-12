const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  const metadataUrl = METADATA_URL;

  // Contract factory
  const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs");

  // Contract Deploy
  const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
    metadataUrl,
    whitelistContract
  );

  await deployedCryptoDevsContract.deployed();

  console.log("CryptoDevs Address:", deployedCryptoDevsContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
