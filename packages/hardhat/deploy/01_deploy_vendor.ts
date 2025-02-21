import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

/**
 * Deploys a contract named "Vendor" using the deployer account and
 * constructor arguments set to the deployer address
 *
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployVendor: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // Get deployer account from the named accounts
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Get an instance of YourToken which already minted tokens to the deployer
  const yourToken = await hre.ethers.getContract<Contract>("YourToken", deployer);
  const yourTokenAddress = await yourToken.getAddress();

  // Deploy the Vendor contract, passing in the address of YourToken
  await deploy("Vendor", {
    from: deployer,
    // Contract constructor arguments: pass the YourToken address
    args: [yourTokenAddress],
    log: true,
    autoMine: true,
  });

  // Get the deployed Vendor contract instance
  const vendor = await hre.ethers.getContract<Contract>("Vendor", deployer);
  const vendorAddress = await vendor.getAddress();

  // Transfer 1000 tokens from the deployer's YourToken balance to the Vendor contract
  await yourToken.transfer(vendorAddress, hre.ethers.parseEther("1000"));

  // (Optional) Transfer contract ownership to your frontend address
  // Replace **YOUR FRONTEND ADDRESS** with your actual frontend address if needed.
  await vendor.transferOwnership("**YOUR FRONTEND ADDRESS**");
};

export default deployVendor;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags Vendor
deployVendor.tags = ["Vendor"];
