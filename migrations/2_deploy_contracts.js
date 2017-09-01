var token = artifacts.require("./TokenKey.sol");

module.exports = function(deployer) {
  deployer.deploy(token);
};
