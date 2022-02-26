const IssuersContract = artifacts.require("IssuersContract");

module.exports = function (deployer) {
  deployer.deploy(IssuersContract);
};
