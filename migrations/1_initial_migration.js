const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Token = artifacts.require('Token');

module.exports = async function (deployer) {
  const instance = await deployProxy(Token, { deployer });
  console.log('Deployed', instance.address);
};