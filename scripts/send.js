
const { ethers } = require('ethers');

const providerPrivateKey = '';
const rpcUrl = 'https://polygon-mumbai.g.alchemy.com/v2/WRYcJ3AqrRfEiw5P_vrnN2bsACAoLpDt';






async function main() {
  // Set up ethers provider (e.g., for localhost development)

  const provider = new ethers.providers.JsonRpcProvider(rpcUrl);

  const wallet = new ethers.Wallet(providerPrivateKey, provider);
  
  
  // Recipient address

  // Amount to send (in wei)
  const amountToSend = ethers.utils.parseEther("0.1"); // Sending 0.1 Ether

  // Send Ether transaction
  const transaction = await wallet.sendTransaction({
    to: "0x1149733f503c5d1317188a2056c6aE48a0d48995",
    value: ethers.utils.parseEther("0.1"),
    gasLimit: "100000",
    gasPrice: "5011111111"
  });

  console.log("Transaction hash:", transaction.hash);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  
  