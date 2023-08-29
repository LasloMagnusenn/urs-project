const { ethers } = require('ethers');
const fs = require("fs");

const providerPrivateKey = '';
const rpcUrl = 'https://polygon-mumbai.g.alchemy.com/v2/WRYcJ3AqrRfEiw5P_vrnN2bsACAoLpDt';



const MintContract = require("../artifacts/contracts/MintContract.sol/MintContract.json");
const gameInfo = require("../artifacts/contracts/GameContract.sol/GameContract.json");


const provider = new ethers.providers.JsonRpcProvider(rpcUrl);

const wallet = new ethers.Wallet(providerPrivateKey, provider);


// деплой raffleTOken, MintContract, GameContract

async function readData() {
  


//after deploy settings

const collection = new ethers.Contract("0xE18B31DEa7C26fB969aafcAbe3231387783d528D", MintContract.abi, wallet);
const game = new ethers.Contract("0xc9aE106834893511984d9edE78f12EBd69Eaeb48", gameInfo.abi, wallet);


// console.log(await game.GetCurrentTableInRoom(16,0))

const tokens = await collection.tokensOfOwner("0x6735646dba76763695be5395bf2f4245046db44c")

// console.log(tokens.toNumber())

// for (let index = 0; index < tokens.length; index++) {
//     console.log((tokens[index]).toNumber())
    
// }



for (let i = 0; i < tokens.length; i++) {


  let nftLevel = await collection.viewNFTRoomLevel(tokens[i])
  let suit = await collection.viewSuits(tokens[i])
    console.log(`tokenId ${tokens[i].toNumber()} is  ${nftLevel.toNumber()} level and ${suit} suit`)      
}







}

// Вызов функции для деплоя контракта
readData().catch((err) => {
  console.error('Ошибка:', err);
});





