const { ethers } = require('ethers');
const fs = require("fs");

const providerPrivateKey = '';
const rpcUrl = 'https://polygon-mumbai.g.alchemy.com/v2/WRYcJ3AqrRfEiw5P_vrnN2bsACAoLpDt';



const raffleTOken = require("../artifacts/contracts/RaffleToken.sol/RaffleToken.json");
const raffleNFT = require("../artifacts/contracts/RaffleNFT.sol/RaffleNFT.json");
const MintContract = require("../artifacts/contracts/MintContract.sol/MintContract.json");
const game = require("../artifacts/contracts/GameContract.sol/GameContract.json");
const reduct = require("../artifacts/contracts/Reduct.sol/Reduct.json");
const helper = require("../artifacts/contracts/Helper.sol/Helper.json");
const helper1 = require("../artifacts/contracts/Helper1.sol/Helper1.json");




const provider = new ethers.providers.JsonRpcProvider(rpcUrl);

const wallet = new ethers.Wallet(providerPrivateKey, provider);


// деплой raffleTOken, MintContract, GameContract

async function deployContract() {

  const raffleNFTFactory = new ethers.ContractFactory([], raffleNFT.bytecode, wallet);

  const raffleNFTContract = await raffleNFTFactory.deploy();

  await raffleNFTContract.deployed();
//   console.log('raffleToken has been deployed to: ', raffletokenContract.address);
    console.log('raffleNFT +');


  
  const raffleTOkenFactory = new ethers.ContractFactory([], raffleTOken.bytecode, wallet);

  const raffletokenContract = await raffleTOkenFactory.deploy();

  await raffletokenContract.deployed();
//   console.log('raffleToken has been deployed to: ', raffletokenContract.address);
    console.log('raffleToken +');




  const MintContractFactory = new ethers.ContractFactory([], MintContract.bytecode, wallet);

  const mintContract = await MintContractFactory.deploy();

  await mintContract.deployed();


//   console.log('MintContract has been deployed to: ', MintContractContract.address);
    console.log('MintContract +');


    
  const HelperFactory = new ethers.ContractFactory(helper.abi, helper.bytecode, wallet);

  const helperContract = await HelperFactory.deploy(mintContract.address);

  await helperContract.deployed();

  
  
    console.log('helperContract +');

    
    
  const HelperFactory1 = new ethers.ContractFactory(helper1.abi, helper1.bytecode, wallet);

  const helperContract1 = await HelperFactory1.deploy(mintContract.address);

  await helperContract1.deployed();

  
  
    console.log('helperContract1 +');



    
  const ReductFactory = new ethers.ContractFactory([], reduct.bytecode, wallet);

  const reductContract = await ReductFactory.deploy();

  await reductContract.deployed();

  
  

//   console.log('MintContract has been deployed to: ', MintContractContract.address);
    console.log('reductContract +');


const GameContractFactory = new ethers.ContractFactory(game.abi, game.bytecode, wallet)

const GameContract = await GameContractFactory.deploy(mintContract.address, raffletokenContract.address, raffleNFTContract.address, helperContract.address, helperContract1.address);

await GameContract.deployed();

 

//   console.log('GameContract has been deployed to: ', GameContract.address);
console.log('GameContract +');



//after deploy settings

const helperDeployed = new ethers.Contract(helperContract.address, helper.abi, wallet);
const helperDeployed1 = new ethers.Contract(helperContract1.address, helper1.abi, wallet);
const raffleNFTDeployed = new ethers.Contract(raffleNFTContract.address, raffleNFT.abi, wallet);
const raffleTokenDeployed = new ethers.Contract(raffletokenContract.address, raffleTOken.abi, wallet);
const mintContractDeployed = new ethers.Contract(mintContract.address, MintContract.abi, wallet);

const reductDeployed = new ethers.Contract(reductContract.address, reduct.abi, wallet);

console.log("starting after deploy settings")


await helperDeployed.setGameContract(GameContract.address)

await helperDeployed.setReduct(reductContract.address)

await reductDeployed.setGameContract(GameContract.address);



await helperDeployed1.setGameContract(GameContract.address)

await helperDeployed1.setGameContract(helperContract.address)



await mintContractDeployed.setGameContract(GameContract.address)

console.log("finishing after deploy settings")


await raffleTokenDeployed.mint(GameContract.address, 100000000);
await raffleNFTDeployed.safeMint(GameContract.address);
await raffleNFTDeployed.safeMint(GameContract.address);


const transaction = await wallet.sendTransaction({
  to: GameContract.address,
  value: ethers.utils.parseEther("0.3"),
  gasLimit: "100000",
  gasPrice: "5011111111"
});

const transaction1 = await wallet.sendTransaction({
  to: mintContract.address,
  value: ethers.utils.parseEther("0.3"),
  gasLimit: "100000",
  gasPrice: "5011111111"
});




var dt = new Date();


const path = './deploy-abis/';
const datePrefix = `${dt.getDate()}0${(dt.getMonth() + 1)}`; // Ваш префикс даты

// клин папки
try {
  // Получаем список файлов в папке
  const files = fs.readdirSync(path);

  // Проходимся по каждому файлу и удаляем его
  files.forEach((file) => {
    const filePath = path + file;
    fs.unlinkSync(filePath);
    console.log(`Файл ${filePath} удален.`);
  });

  console.log('Все файлы в папке успешно удалены.');
} catch (err) {
  console.error('Ошибка при удалении файлов:', err);
}
////


// Функция для создания файла, если он не существует, и записи в него данных
function createAndWriteFile(filePath, data) {
  if (!fs.existsSync(filePath)) {
    // Файл не существует, создаем его
    fs.writeFileSync(filePath, data);
    console.log('Файл успешно создан:', filePath);
  } else {
    // Файл уже существует, перезаписываем данные
    fs.writeFileSync(filePath, data);
    console.log('Данные успешно записаны в файл:', filePath);
  }
}


// Данные для записи в файлы
const raffleTokenData = JSON.stringify(raffleTOken.abi);
const mintContractData = JSON.stringify(MintContract.abi);
const gameContractData = JSON.stringify(game.abi);
const reductContractData = JSON.stringify(reduct.abi);
const helperContractData = JSON.stringify(helper.abi);

// Создаем и записываем данные в файлы
createAndWriteFile(`${path}raffleTokenAbi${datePrefix}.json`, raffleTokenData);
createAndWriteFile(`${path}nftContractAbi${datePrefix}.json`, mintContractData);
createAndWriteFile(`${path}gameContractAbi${datePrefix}.json`, gameContractData);
createAndWriteFile(`${path}reductContractAbi${datePrefix}.json`, reductContractData);
createAndWriteFile(`${path}helperContractAbi${datePrefix}.json`, helperContractData);







console.log(` raffleToken has been deployed to: ${raffletokenContract.address}\n MintContract has been deployed to:  ${mintContract.address}\n GameContract has been deployed to: ${GameContract.address} \n reduct has been deployed to: ${reductContract.address} \n helper has been deployed to: ${helperContract.address}`)





}

// Вызов функции для деплоя контракта
deployContract().catch((err) => {
  console.error('Ошибка при деплое контракта:', err);
});



