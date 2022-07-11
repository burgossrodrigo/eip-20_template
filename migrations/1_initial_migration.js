const Token = artifacts.require("Token");

module.exports = async function (deployer) {
  deployer.deploy(Token, "Blocos", "BRLB", 100000000);
};
