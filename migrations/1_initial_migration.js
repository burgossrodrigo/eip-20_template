const Token = artifacts.require("Token");

module.exports = function (deployer) {
  deployer.deploy(Token, "Blocos", "BRLB", 100000000);
};
