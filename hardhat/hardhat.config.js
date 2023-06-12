require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(".env");

const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: QUICKNODE_HTTP_URL,
      accounts: [PRIVATE_KEY],
      // gasPrice: 1000000000, // Set the gas price in Wei
      // gas: 8000000, // Set the gas limit
      chainId: 11155111,
    },
  },
};
