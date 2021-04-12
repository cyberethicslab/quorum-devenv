var SimpleStorage = artifacts.require("SimpleStorage");

module.exports = function(deployer) {
  // Pass 0 to the contract as the first constructor parameter
  deployer.deploy(SimpleStorage, 0)
};