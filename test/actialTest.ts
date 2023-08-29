import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers  } from "hardhat";
import BigNumber from 'big-number'
import { GameContract, GameContract__factory, MintContract, MintContract__factory, RaffleToken, RaffleToken__factory, Reduct, Reduct__factory, Helper, Helper__factory, RaffleNFT, RaffleNFT__factory, Helper1, Helper1__factory } from "../typechain-types"
import  timestamp from 'time-stamp';
import { days } from "@nomicfoundation/hardhat-network-helpers/dist/src/helpers/time/duration";
import bigNumber from "big-number";


function convertToSeconds(hours) {
  var seconds = hours * 3600;
  return seconds;
}


function getHours(unix_timestamp) {
let res = unix_timestamp/3600;
return res;



}

function getSalt(max) {
  return Math.floor(Math.random() * max);
}



function convert(unixtimestamp) {
  var months_arr = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  var date = new Date(unixtimestamp * 1000);
  var year = date.getFullYear();
  var month = months_arr[date.getMonth()];
  var day = date.getDate();
  var hours = date.getHours();
  var minutes = "0" + date.getMinutes();
  var seconds = "0" + date.getSeconds();
  var fulldate = month + ' ' + day + '-' + year + ' ' + hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
  var convdataTime = month + ' ' + day;
  return fulldate;
}




describe("deploy contracts", function () {
    async function deploy() {
      const [acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10] = await ethers.getSigners();
  
      const MintContractFactory = await ethers.getContractFactory("MintContract");
      const MintContract: MintContract = await MintContractFactory.deploy();
      await MintContract.deployed();

      const genceFactory = await ethers.getContractFactory("RaffleToken");
      const token: RaffleToken = await genceFactory.deploy();
      await token.deployed();

      
      const reductFactory = await ethers.getContractFactory("Reduct");
      const reduct: Reduct = await reductFactory.deploy();
      await reduct.deployed();



      const helperFactory = await ethers.getContractFactory("Helper");
      const helper: Helper = await helperFactory.deploy(MintContract.address);
      await helper.deployed();


      
      const helperFactory1 = await ethers.getContractFactory("Helper1");
      const helper1: Helper1 = await helperFactory1.deploy(MintContract.address);
      await helper1.deployed();






      const RaffleNFTFactory = await ethers.getContractFactory("RaffleNFT");
      const spinach: RaffleNFT = await RaffleNFTFactory.deploy();
      await spinach.deployed();

  
      const gameFactory = await ethers.getContractFactory("GameContract");
      const game: GameContract = await gameFactory.deploy(MintContract.address, token.address, spinach.address, helper.address, helper1.address);
      await game.deployed();


      await helper.setGameContract(game.address);
      await helper.setReduct(reduct.address);

      await helper1.setGameContract(game.address);
      await helper1.setHelper(helper.address);




      await reduct.setGameContract(game.address);

      await token.mint(acc1.address, 10000)

      await token.transfer(game.address, 1000)
      await token.transfer(MintContract.address, 1000)

      await MintContract.setGameContract(game.address)


  
  
   
      
      // console.log(acc1.address)
      // console.log(acc2.address)
      // console.log(acc3.address)
      // console.log(acc4.address)
      // console.log(acc5.address)


  
  


        // await MintContract.newSmartMint(30,16, {value: 33});

        // await MintContract.connect(acc2).newSmartMint(5,16, {value: 10});

        // await MintContract.connect(acc3).newSmartMint(5,16, {value: 10});

        // await MintContract.connect(acc4).newSmartMint(6,16, {value: 10});

        // await MintContract.connect(acc5).newSmartMint(1,16, {value: 10});


        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);

        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);

        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);
        await game.createTableInRoom(16);





      
  
      return { game, MintContract, token, spinach, helper, helper1, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 }

    }



    

    it("claimBlackRoom for player", async function() {
  
          


// const tx2 = await game.connect(acc2).bulkEnterInBlackRoom([11,12,13,14,15])
// await tx2.wait()


// const tx3= await game.connect(acc3).bulkEnterInBlackRoom([16,17,18,19,20])
// await tx3.wait()


// const tx4 = await game.connect(acc4).bulkEnterInBlackRoom([21,22,23,24,25,26])
// await tx4.wait()


// const tx5 = await game.connect(acc5).bulkEnterInBlackRoom([27])
// await tx5.wait()

  const { game, helper, helper1, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);
    

  await game.setPrizeRadioChoise(1);
  
  await MintContract.newSmartMint(4, 1, { value: 1000000 });

  await MintContract.connect(acc2).newSmartMint(4, 1, { value: 1000000 });

  await token.mint(game.address, 1000000);

  await game.bulkEnterInBlackRoom([1])
  await game.connect(acc2).bulkEnterInBlackRoom([5])

  await game.bulkEnterInBlackRoom([2])
  await game.connect(acc2).bulkEnterInBlackRoom([6])

  await game.bulkEnterInBlackRoom([3])
  await game.connect(acc2).bulkEnterInBlackRoom([7])

  // await game.bulkEnterInBlackRoom([4])
  // await game.connect(acc2).bulkEnterInBlackRoom([8])

  // await game.connect(acc2).bulkEnterInBlackRoom([11,12,14,15]);


// console.log(await game.getBlackTable())




// await time.increase(600);


const claim = await game.claimBlackRoom(125125);
await claim.wait()

console.log(await game.getBlackTable())


// // console.log(await helper.generateWinnersForBlackRoom(124124));



// //       console.log(await helper1.getBlackTableWinnersInfoOne())

// // // await helper1.generateWinnersForBlackRoom(124124);

// //       await game.claimBlackRoom(124124);

      const t = await helper1.getBlackTableWinnersInfo();

      console.log("winners indexes raw " +  t.tempWinners)

      const winnersArray = await helper1.getBlackTableWinnersInfoWinners();

      console.log("winners places" + await helper1.getBlackTableWinnersInfoWinnersByPlaces());
//       console.log("balance of tokens" + await MintContract.tokensOfOwner(acc1.address));

for (let index = 0; index < winnersArray.length; index++) {
  
    console.log("trying" + winnersArray[index])
    console.log("isMintPass" + await game.isMintPass(winnersArray[index]));
    console.log("isNotTransferAble" + await MintContract.viewNotTransferable(winnersArray[index]));
  
    // expect(await game.isMintPass(winnersArray[index])).to.equal(true);
    // expect(await MintContract.viewNotTransferable(winnersArray[index])).to.equal(false);

  
}

// console.log(await game.getBlackTable())



console.log(await game.getIndexesOfPlayerInBlackRoom(acc1.address) + "is playerIndexes")

console.log(await MintContract.tokensOfOwner(acc1.address) + "acc1 tokens")
console.log(await MintContract.tokensOfOwner(acc2.address) + "acc2 tokens")



  // console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));

  // const receipt = await ethers.provider.getTransactionReceipt(claim.hash);
  // const interfaceTX = new ethers.utils.Interface(["event blackRoomClaimed(address[] tempWinners, uint256[] tempInvolvedTokenIds, uint256 prizeRadioChoice)"]);
  // const data = receipt.logs[0].data;
  // const topics = receipt.logs[0].topics;
  // const event = interfaceTX.decodeEventLog("blackRoomClaimed", data, topics);
  // console.log("event now")
  // console.log(event)

  //   console.log(await game.isMintPass(event.tempInvolvedTokenIds[0]))
  // for (let i = 0; i < event.tempInvolvedTokenIds.length; i++) {
  //   let isMintPass: boolean;
  //   let isTransferable: boolean;
  //   isMintPass = await game.isMintPass(event.tempInvolvedTokenIds[i]);
  //   isTransferable = await MintContract.viewNotTransferable(event.tempInvolvedTokenIds[i])
  //     expect(isMintPass).to.equal(true);
  //     expect(isTransferable).to.equal(false);

  // }


  // console.log("$$$$$$$$")

  // // MINTPASSES WORKS CORRECTLY


  // // test estimate and claim staking rewards;


  // // event ClaimedStakingTokens(address indexed player, uint indexed amount, uint indexed claimTimestamp)

      



  //   // данный клейм меняет свойство 3 токен идсов на минт пассы

  //   // console.log(await game.getBlackTable())

  //   console.log("balance before " + await token.balanceOf(acc1.address) )
  // console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  

  //   await game.claimStakingTokensFromBlackRoom()
  //           console.log(await token.balanceOf(acc1.address))



      


    
  // const stak = await game.claimStakingTokensFromBlackRoom();
  // await stak.wait()


  // console.log( await token.balanceOf(acc1.address))
  















});





















    
      //  0731 test with mint !!!
    //   it("tests with suits distibuting after claim and in general", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   // await (MintContract.newSmartMint(100,16, {value:5000}))
    //   // await (MintContract.newSmartMint(100,15, {value:5000}))
    //   // await (MintContract.newSmartMint(100,14, {value:5000}))
    //   // await (MintContract.newSmartMint(100,13, {value:5000}))
    //   // await (MintContract.newSmartMint(100,12, {value:5000}))
    //   // await (MintContract.newSmartMint(100,11, {value:5000}))
    //   // await (MintContract.newSmartMint(100,10, {value:5000}))
    //   // await (MintContract.newSmartMint(100,9, {value:5000}))
    //   // await (MintContract.newSmartMint(100,8, {value:5000}))
    //   // await (MintContract.newSmartMint(100,7, {value:5000}))
    //   // await (MintContract.newSmartMint(100,6, {value:5000}))
    //   // await (MintContract.newSmartMint(100,5, {value:5000}))
    //   // await (MintContract.newSmartMint(100,4, {value:5000}))
    //   // await (MintContract.newSmartMint(100,3, {value:5000}))
    //   // await (MintContract.newSmartMint(100,2, {value:5000}))
    //   // await (MintContract.newSmartMint(100,1, {value:50000}))



        
    //   //   console.log( await MintContract.bulkViewNFTRoomLevel([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]))



    //     for (let index = 1; index < 50; index++) {
    //       const tempSalt = getSalt(512561261261266);
    //       console.log(await helper.getRandomSuit(tempSalt));
          
    //     }
    //     // чек левелов распределения

    //     // for (let i = 1; i <= 1600; i++) {
    //     //   let expectedLevel: number;
    
    //     //   // Определяем ожидаемый уровень в зависимости от значения i
    //     //   if (i <= 100) {
    //     //     expectedLevel = 1;
    //     //   } else if (i <= 200) {
    //     //     expectedLevel = 2;
    //     //   } else if (i <= 300) {
    //     //     expectedLevel = 3;
    //     //   } else if (i <= 400) {
    //     //     expectedLevel = 4;
    //     //   } else if (i <= 500) {
    //     //     expectedLevel = 5;
    //     //   } else if (i <= 600) {
    //     //     expectedLevel = 6;
    //     //   } else if (i <= 700) {
    //     //     expectedLevel = 7;
    //     //   } else if (i <= 800) {
    //     //     expectedLevel = 8;
    //     //   } else if (i <= 900) {
    //     //     expectedLevel = 9;
    //     //   } else if (i <= 1000) {
    //     //     expectedLevel = 10;
    //     //   } else if (i <= 1100) {
    //     //     expectedLevel = 11;
    //     //   } else if (i <= 1200) {
    //     //     expectedLevel = 12;
    //     //   } else if (i <= 1300) {
    //     //     expectedLevel = 13;
    //     //   } else if (i <= 1400) {
    //     //     expectedLevel = 14;
    //     //   } else if (i <= 1500) {
    //     //     expectedLevel = 15;
    //     //   } else {
    //     //     expectedLevel = 16;
    //     //   }
    
    //     //   // Получаем NFTRoomLevel для текущего токена
    //     //   const NFTRoomLevel = await MintContract.viewNFTRoomLevel(i);
    
    //     //   // Проверяем, что полученный NFTRoomLevel соответствует ожидаемому уровню
    //     //   expect(NFTRoomLevel).to.equal(expectedLevel);

    //     //   // console.log(i + "suit is " + await MintContract.viewSuits(i));
    //     // }




    //   // await (MintContract.newSmartMint(1,10, {value:500}))


    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});


    //   // console.log(await game.GetCurrentTableInRoom(16,0));


      

  
    //   // // // заходим в игру первый раз
    //   // await game.advancedBulkEnterInGame(16,0, [1590,1591,1592,1593,1594,1595,1596,1597,1598,1599]);


    //   // // console.log("/////////")
    //   // // console.log("/////////")
    //   // // console.log("/////////")

    //   // console.log(await game.GetCurrentTableInRoom(16,0));

    //   // await time.increase(122222)


    //   // await game.ClaimSingleGame(16,0,126);
    //   // console.log(await MintContract.bulkViewSuits([1590,1591,1592,1593,1594,1595,1596,1597,1598,1599]))

    //   // // console.log(await game.GetCurrentTableInRoom(16,0));


    //   // // //   пробуем войти в кулдаун стол

    //   // // // console.log(await MintContract.tokensOfOwner(acc2.address))

    //   // // await game.connect(acc2).advancedBulkEnterInGame(16,0, [41,42,43,44,45,46,47,48,49]);
    //   // // console.log(await game.GetCurrentTableInRoom(16,0));


    // });


  //   claim few tables in one tx

    // testing with places

    //  нужно заполнить 2 игры
  
  //    it("tests with places", async function() {
  
  
  //     const { game, MintContract, token, helper, acc1, acc2  } = await loadFixture(deploy);
    
  //     await MintContract.newSmartMint(100,16, {value:1555})


  //     // await  game.advancedBulkEnterInGame(16,0, [1,2,3,4])

  //     // await game.addPlayerByPlace(16,0,1,acc1.address);
  //     // await game.addPlayerByPlace(16,0,3,acc1.address);
  //     // await game.addPlayerByPlace(16,0,4,acc1.address);
  //     // await game.addPlayerByPlace(16,0,9,acc1.address);
  //     // await game.addPlayerByPlace(16,0,10,acc1.address);
      
      
  //     // await game.incrPlayersNow(16,0)
  //     // await game.incrPlayersNow(16,0)     
  //     // await game.incrPlayersNow(16,0)
  //     // await game.incrPlayersNow(16,0)
  //     // await game.incrPlayersNow(16,0)
  //     // await game.incrPlayersNow(16,0)
  //     // console.log("overlay")
  //     //     console.log(await helper.overlayCoincidentalPlaces(16,1,[1,4,4,4,5,8,6]))
  //         await  game.advancedBulkEnterInGameWithPlace(16,1, [1,2,3,4,5,6,7], [1,4,4,4,5,8,6])
       

  //       console.log(await game.GetCurrentTableInRoom(16,1))


  //       console.log("asdasdasdasdasd")


  //       console.log("overlay")
  //       console.log(await helper.overlayCoincidentalPlaces(16,1,[3,3,3]))
  //       await  game.advancedBulkEnterInGameWithPlace(16,1, [8,9,10,11,12,13,14,15], [3,3,3,1,6,8,4,9])
       

  //       console.log(await game.GetCurrentTableInRoom(16,1))
  //       console.log("//////////")
  //       console.log(await game.GetCurrentTableInRoom(16,0))


  //     //   console.log("asdasdasdasdasd")

  //     // console.log(await game.GetCurrentTableInRoom(16,0))


  //     //   console.log("available indexes")

  //       // console.log(await helper.getAvailablePlacesOnTable(16,0))



  //       //trying find values in array

  //       // console.log("finding values in ")

  //       // console.log(await helper.findValueInArray(1, [0,2,3,1]))

  //       // console.log(await helper.findValueInArray(5, [1,2,3,4,5]))

  //       // console.log(await helper.findValueInArray(7, [0,5,5,7]))

  //       // console.log(await helper.findValueInArray(3, [1,2,4,5,6,7]))

  //       //

  //       // testing overlay places in table

  //       // console.log("testing overlay places in table")
  //       // const availableNow = await helper.getAvailablePlacesOnTable(16,0)

  //       // console.log("check available")
  //       // console.log(await helper.findValueInArray(2, availableNow))
  //       // console.log(await helper.findValueInArray(4, availableNow))
  //       // console.log(await helper.findValueInArray(9, availableNow))

  //       // console.log("asd")
  //       // console.log(await helper.overlayPlacesOnTable(16,0,[1,5,8,9]))
  //       // console.log("clears")
  //       // console.log( await helper.sortAscending([1,3,4,5,8]))


  //       // // console.log( await helper.overlayCoincidentalPlaces(16,0,[1,3,4,5,8]))

  //       // const sort =    await helper.overlayCoincidentalPlaces(16,0,[1,3,4,5,8])

  //       // console.log( await helper.reduceArray(sort, 2))

  //       // const enter2 = await  game.advancedBulkEnterInGame(16,1, [11,12,13,14,15,16,17,18,19,20])
  //       // await enter2.wait()
    
  //       // const enter3 = await  game.advancedBulkEnterInGame(16,2, [21,22,23,24,25,26,27,28,29,30])
  //       // await enter3.wait()s
  
  //       // const enter4 = await  game.advancedBulkEnterInGame(16,3, [41,42,43,44,45,46,47,48,49,50])
  //       // await enter4.wait()
  
  //     // / заход в 4 стола
  
      
  
  //       // await time.increase(95000);
  
  //       // console.log(convert(await time.latest()))
  
  //       // const claim1s = await game.ClaimSingleGame(16,0,4444);
  //       // await claim1s.wait();
  
  //       // const claim2s = await game.ClaimSingleGame(16,1,444);
  //       // await claim2s.wait();
  
  //       // console.log(await game.getTablesClaimReadyInRoom(16))
  //       //       console.log(await game.GetCurrentTableInRoom(16,0))


  //   // await time.increase(13*3600)



  //   //   


  //       // console.log(await game.getTablesClaimReadyInRoom(16))


  //       // await game.claimReadyTablesInRoom(16,125125);

  //       // console.log(await game.getTablesClaimReadyInRoom(16))

  //       // console.log('asdasdasdasd')
  //       // console.log(await game.GetCurrentTableInRoom(16,0))

        
   
  // });


    



    
    
    
    
  //   // RoomGameDurationIncreaseCounter works correctly
  //   it("tests with increase time for regular tables", async function() {
  
  
  //     const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10  } = await loadFixture(deploy);
    
      
  //     // for (let index = 1; index <= 20; index++) {
  //     //    await MintContract.newSmartMint(100,16, {value:15000, gasLimit: 3000000})
        
        
  //     // }

     

  //     //   //  прогоним тысячу игр 
  //     //   let step = 1


  //     //   for (let i = 0; i <= 17; i++) {

  //     //     let counter = 1
  
  //     //     for (let index = 1; index <= 2; index++) {
  
  //     //       await game.advancedBulkEnterInGame(16,0, [step,step+1,step+2,step+3,step+4,step+5,step+6,step+7,step+8,step+9]);
  
  
  //     //       await time.increase(80000);
  
  //     //       await game.ClaimSingleGame(16,0,1255);
  //     //       const amount = await game.currentAmountGamesFinished(16);
          
  //     //       console.log("CURRENT COUNTER FINISHED GAMES IS - " + await game.currentAmountGamesFinished(16));
  //     //       console.log("roomGameDurationIncreaseCounter now is " + await game.roomGameDurationIncreaseCounter(16))
  
            
  //     //         step += 10;
  
  
            
  //     //     }
  
  //     //     console.log("currentRoomGameDuration now is  " + await game.currentRoomGameDuration(16))
  
  
          
          
  //     //   }



       
  //     for (let index = 1; index <= 3; index++) {
  //       await MintContract.newSmartMint(100,16, {value:15000, gasLimit: 3000000})
       
       
  //    }

    

  //      //  прогоним тысячу игр 
  //      let step = 1


  //      for (let i = 0; i <= 17; i++) {

  //        let counter = 1
 
  //        for (let index = 1; index <= 2; index++) {
 
  //          await game.advancedBulkEnterInGame(16,0, [step,step+1,step+2,step+3,step+4,step+5,step+6,step+7,step+8,step+9]);
 
 
  //          await time.increase(80000);
 
  //          await game.ClaimSingleGame(16,0,1255);
  //          const amount = await game.currentAmountGamesFinished(16);
         
  //          console.log("CURRENT COUNTER FINISHED GAMES IS - " + await game.currentAmountGamesFinished(16));
  //          console.log("current TrumpCounter " + await game.trumpCounter())
  //          console.log("current Trump is " + await game.trump());
           
  //            step += 10;
 
 
           
  //        }
 
  //       //  console.log("currentRoomGameDuration now is  " + await game.currentRoomGameDuration(16))
 
 
         
         
  //      }



        
       
   
  // });





    
// it("claimBlackRoom with sending raffle nft", async function() {
  
          


// const { game, helper, helper1, spinach, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);


// // console.log(await game.viewHelper1());
// // console.log(game.address +  '  is game contract address')
// // console.log(helper.address + '  is helper address')
// // console.log(helper1.address + '  is helper1 address')

// await game.setPrizeRadioChoise(3);
// await game.setGlobalLastGameFinishedAt(await time.latest())

// // console.log(await game.viewHelper() + " is helper in gameContract");

// // console.log(await game.viewHelper1() + " is helper1 in gameContract");


// await MintContract.newSmartMint(15, 1, { value: 1000000 });

// await token.mint(game.address, 1000000);

// await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11])




// console.log(await game.getBlackTable())


 



// await time.increase(60);



// await spinach.safeMint(game.address)
// await spinach.safeMint(game.address)

// // console.log(await spinach.ownerOf(1))


// // await game.sendRaffleNFTToWinner(acc1.address,1)

// // console.log(await spinach.ownerOf(1))


// // const claim = await game.claimBlackRoom(125125);
// // await claim.wait()


// // const claim = await game.claimBlackRoom(125125);
// // await claim.wait()

// // const receipt = await claim.wait()

// // for (const event of receipt.events) {
// //   console.log(`Event ${event.event} with args ${event.args}`);
// // }


// console.log(await spinach.ownerOf(1))
// console.log(await MintContract.tokensOfOwner(acc1.address))

// // await time.increase(4*3600)

// await MintContract.bulkBurn([13,14,15])
// console.log(await MintContract.tokensOfOwner(acc1.address))




// // // const receipt = await ethers.provider.getTransactionReceipt(claim.hash);
// // // const interfaceTX = new ethers.utils.Interface(["event blackRoomClaimedPrizeRaffleNFT(address indexed winner, uint256 indexed tokenId, uint256 prizeRadioChoice)"]);
// // // const data = receipt.logs[0].data;
// // // const topics = receipt.logs[0].topics;
// // // const event = interfaceTX.decodeEventLog("blackRoomClaimedPrizeRaffleNFT", data, topics);
// // // console.log("event now")
// // // console.log(event)

// // for (let i = 1; i <= 12; i++) {


// //         await expect(MintContract.tokenURI(i)).to.be.rejectedWith('ERC721URIStorage: URI query for nonexistent token');


// // }




// //   // console.log("game address is _ " + game.address)

// //   // const balance  = await spinach.ownerOf(0)

// //   // expect(balance).to.equal(game.address)

// //   // await game.sendRaffleNFTToWinner(acc1.address, 1);

// //   // const newOwner = await spinach.ownerOf(1);
// //   // expect(newOwner).to.equal(acc1.address)
// //   console.log("new owner of tokenId 1 is " +  await spinach.ownerOf(1))




// // console.log("$$$$$$$$")

// // // MINTPASSES WORKS CORRECTLY


// // // test estimate and claim staking rewards;


// // // event ClaimedStakingTokens(address indexed player, uint indexed amount, uint indexed claimTimestamp)

  



// // // данный клейм меняет свойство 3 токен идсов на минт пассы

// // // console.log(await game.getBlackTable())

// // // console.log("balance before " + await token.balanceOf(acc1.address) )
// // // console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  

// // // await game.claimStakingTokensFromBlackRoom()
// // //         console.log(await token.balanceOf(acc1.address))



  



// // // const stak = await game.claimStakingTokensFromBlackRoom();
// // // await stak.wait()


// // // console.log( await token.balanceOf(acc1.address))
















// });



      //  0731 test with mint !!!
    //   it("tests with mint nft room level and suits ", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(100,1, {value:5000}))
    //   await (MintContract.newSmartMint(100,2, {value:5000}))
    //   await (MintContract.newSmartMint(100,3, {value:5000}))
    //   await (MintContract.newSmartMint(100,4, {value:5000}))
    //   await (MintContract.newSmartMint(100,5, {value:5000}))
    //   await (MintContract.newSmartMint(100,6, {value:5000}))
    //   await (MintContract.newSmartMint(100,7, {value:5000}))
    //   await (MintContract.newSmartMint(100,8, {value:5000}))
    //   await (MintContract.newSmartMint(100,9, {value:5000}))
    //   await (MintContract.newSmartMint(100,10, {value:5000}))
    //   await (MintContract.newSmartMint(100,11, {value:5000}))
    //   await (MintContract.newSmartMint(100,12, {value:5000}))
    //   await (MintContract.newSmartMint(100,13, {value:5000}))
    //   await (MintContract.newSmartMint(100,14, {value:5000}))
    //   await (MintContract.newSmartMint(100,15, {value:5000}))
    //   await (MintContract.newSmartMint(100,16, {value:50000}))



        
    //     console.log( await MintContract.bulkViewNFTRoomLevel([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]))


    //     // чек левелов распределения

    //     // for (let i = 1; i <= 1600; i++) {
    //     //   let expectedLevel: number;
    
    //     //   // Определяем ожидаемый уровень в зависимости от значения i
    //     //   if (i <= 100) {
    //     //     expectedLevel = 1;
    //     //   } else if (i <= 200) {
    //     //     expectedLevel = 2;
    //     //   } else if (i <= 300) {
    //     //     expectedLevel = 3;
    //     //   } else if (i <= 400) {
    //     //     expectedLevel = 4;
    //     //   } else if (i <= 500) {
    //     //     expectedLevel = 5;
    //     //   } else if (i <= 600) {
    //     //     expectedLevel = 6;
    //     //   } else if (i <= 700) {
    //     //     expectedLevel = 7;
    //     //   } else if (i <= 800) {
    //     //     expectedLevel = 8;
    //     //   } else if (i <= 900) {
    //     //     expectedLevel = 9;
    //     //   } else if (i <= 1000) {
    //     //     expectedLevel = 10;
    //     //   } else if (i <= 1100) {
    //     //     expectedLevel = 11;
    //     //   } else if (i <= 1200) {
    //     //     expectedLevel = 12;
    //     //   } else if (i <= 1300) {
    //     //     expectedLevel = 13;
    //     //   } else if (i <= 1400) {
    //     //     expectedLevel = 14;
    //     //   } else if (i <= 1500) {
    //     //     expectedLevel = 15;
    //     //   } else {
    //     //     expectedLevel = 16;
    //     //   }
    
    //     //   // Получаем NFTRoomLevel для текущего токена
    //     //   const NFTRoomLevel = await MintContract.viewNFTRoomLevel(i);
    
    //     //   // Проверяем, что полученный NFTRoomLevel соответствует ожидаемому уровню
    //     //   expect(NFTRoomLevel).to.equal(expectedLevel);

    //     //   // console.log(i + "suit is " + await MintContract.viewSuits(i));
    //     // }




    //   // await (MintContract.newSmartMint(1,10, {value:500}))


    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});


    //   // console.log(await game.GetCurrentTableInRoom(16,0));


      

  
    //   // // заходим в игру первый раз
    //   await game.advancedBulkEnterInGame(16,0, [1590,1591,1592,1593,1594,1595,1596,1597,1598,1599]);


    //   // console.log("/////////")
    //   // console.log("/////////")
    //   // console.log("/////////")

    //   console.log(await game.GetCurrentTableInRoom(16,0));

    //   await time.increase(122222)


    //   await game.ClaimSingleGame(16,0,126);
    //   console.log(await MintContract.bulkViewSuits([1590,1591,1592,1593,1594,1595,1596,1597,1598,1599]))

    //   // console.log(await game.GetCurrentTableInRoom(16,0));


    //   // //   пробуем войти в кулдаун стол

    //   // // console.log(await MintContract.tokensOfOwner(acc2.address))

    //   // await game.connect(acc2).advancedBulkEnterInGame(16,0, [41,42,43,44,45,46,47,48,49]);
    //   // console.log(await game.GetCurrentTableInRoom(16,0));


    // });


    //claim few tables in one tx

    //testing with places

     // нужно заполнить 2 игры
  
  //    it("tests with places", async function() {
  
  
  //     const { game, MintContract, token, helper, acc1, acc2  } = await loadFixture(deploy);
    
  //     await MintContract.newSmartMint(100,16, {value:1555})


  //     // await  game.advancedBulkEnterInGame(16,0, [1,2,3,4])

  //     await game.addPlayerByPlace(16,0,1,acc1.address);
  //     await game.addPlayerByPlace(16,0,3,acc1.address);
  //     await game.addPlayerByPlace(16,0,4,acc1.address);
  //     await game.addPlayerByPlace(16,0,9,acc1.address);
  //     await game.addPlayerByPlace(16,0,10,acc1.address);
      
      
  //     await game.incrPlayersNow(16,0)
  //     await game.incrPlayersNow(16,0)     
  //     await game.incrPlayersNow(16,0)
  //     await game.incrPlayersNow(16,0)
  //     await game.incrPlayersNow(16,0)
  //     // await game.incrPlayersNow(16,0)
      
  //         // await  game.advancedBulkEnterInGameWithPlace(16,0, [1,2,3,4,5], [1,3,5,7,9])
       

  //       console.log(await game.GetCurrentTableInRoom(16,0))

  //       console.log("available indexes")

  //       console.log(await helper.getAvailablePlacesOnTable(16,0))


  //       //trying find values in array

  //       // console.log("finding values in ")

  //       // console.log(await helper.findValueInArray(1, [0,2,3,1]))

  //       // console.log(await helper.findValueInArray(5, [1,2,3,4,5]))

  //       // console.log(await helper.findValueInArray(7, [0,5,5,7]))

  //       // console.log(await helper.findValueInArray(3, [1,2,4,5,6,7]))

  //       //

  //       // testing overlay places in table

  //       // console.log("testing overlay places in table")
  //       // const availableNow = await helper.getAvailablePlacesOnTable(16,0)

  //       // console.log("check available")
  //       // console.log(await helper.findValueInArray(2, availableNow))
  //       // console.log(await helper.findValueInArray(4, availableNow))
  //       // console.log(await helper.findValueInArray(9, availableNow))

  //       // console.log("asd")
  //       // console.log(await helper.overlayPlacesOnTable(16,0,[1,5,8,9]))
  //       console.log("clears")

  //       console.log( await helper.overlayCoincidentalPlaces(16,0,[7,8,9,10]))



  //       // const enter2 = await  game.advancedBulkEnterInGame(16,1, [11,12,13,14,15,16,17,18,19,20])
  //       // await enter2.wait()
    
  //       // const enter3 = await  game.advancedBulkEnterInGame(16,2, [21,22,23,24,25,26,27,28,29,30])
  //       // await enter3.wait()
  
  //       // const enter4 = await  game.advancedBulkEnterInGame(16,3, [41,42,43,44,45,46,47,48,49,50])
  //       // await enter4.wait()
  
  //     // / заход в 4 стола
  
      
  
  //       // await time.increase(95000);
  
  //       // console.log(convert(await time.latest()))
  
  //       // const claim1s = await game.ClaimSingleGame(16,0,4444);
  //       // await claim1s.wait();
  
  //       // const claim2s = await game.ClaimSingleGame(16,1,444);
  //       // await claim2s.wait();
  
  //       // console.log(await game.getTablesClaimReadyInRoom(16))
  //       //       console.log(await game.GetCurrentTableInRoom(16,0))


  //   // await time.increase(13*3600)



  //   //   


  //       // console.log(await game.getTablesClaimReadyInRoom(16))


  //       // await game.claimReadyTablesInRoom(16,125125);

  //       // console.log(await game.getTablesClaimReadyInRoom(16))

  //       // console.log('asdasdasdasd')
  //       // console.log(await game.GetCurrentTableInRoom(16,0))

        
   
  // });




    
    // нужно заполнить 2 игры
  
  //   it("fulfill 2 games", async function() {
  
  
  //     const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10  } = await loadFixture(deploy);
    
  //     await MintContract.newSmartMint(200,16, {value:1555})
  
  //       const enter1 = await  game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10])
  //       await enter1.wait()

  //       const enter2 = await  game.advancedBulkEnterInGame(16,1, [11,12,13,14,15,16,17,18,19,20])
  //       await enter2.wait()
    
  //       const enter3 = await  game.advancedBulkEnterInGame(16,2, [21,22,23,24,25,26,27,28,29,30])
  //       await enter3.wait()
  
  //       const enter4 = await  game.advancedBulkEnterInGame(16,3, [41,42,43,44,45,46,47,48,49,50])
  //       await enter4.wait()

  //       await game.advancedBulkEnterInGame(16,4, [51,52,53,54,55,56,57,58,59,60]);
  //       await game.advancedBulkEnterInGame(16,5, [61,62,63,64,65,66,67,68,69,70]);
  //       await game.advancedBulkEnterInGame(16,6, [71,72,73,74,75,76,77,78,79,80]);
  //       await game.advancedBulkEnterInGame(16,7, [81,82,83,84,85,86,87,88,89,90]);
  //       await game.advancedBulkEnterInGame(16,8, [91,92,93,94,95,96,97,98,99,100]);
  //       await game.advancedBulkEnterInGame(16,9, [101,102,103,104,105,106,107,108,109,110]);
  //       await game.advancedBulkEnterInGame(16,10, [111,112,113,114,115,116,117,118,119,120]);
  //       await game.advancedBulkEnterInGame(16,11, [121,122,123,124,125,126,127,128,129,130]);
  //       await game.advancedBulkEnterInGame(16,12, [131,132,133,134,135,136,137,138,139,140]);

  
  //     // / заход в 4 стола
  
      
  
  //       // await time.increase(95000);
  
  //       // console.log(convert(await time.latest()))
  
  //       // const claim1s = await game.ClaimSingleGame(16,0,4444);
  //       // await claim1s.wait();
  
  //       // const claim2s = await game.ClaimSingleGame(16,1,444);
  //       // await claim2s.wait();
  
  //       // console.log(await game.getTablesClaimReadyInRoom(16))
  //       //       console.log(await game.GetCurrentTableInRoom(16,0))



  //   //   const t = await game.GetCurrentTableInRoom(16,1)
      
  //   //   console.log("time " + await time.latest())  
  //   //   console.log("startedAt " + t.currentGameStartedAt);

  //   //     console.log("current Room game duration " + await game.currentRoomGameDuration(16))
  //   //     console.log("reduct " + t.internalGameReduction);

  //   //     console.log("time1 " + await time.latest())

  //   //     console.log("residual is " +  (t.currentGameStartedAt + await game.currentRoomGameDuration(16) -  t.internalGameReduction - await time.latest() ))

  //   //     console.log("residual is " +  (t.currentGameStartedAt - await time.latest() + await game.currentRoomGameDuration(16) -  t.internalGameReduction ))




  //   // //     // get game durations
  //   // //   console.log("get game durations")
  //   // //     // console.log( getHours(await game.getGameDuration(16,0)))
  //   //     console.log( (await game.getGameDuration(16,1)))
  //   //     console.log(getHours(await game.getGameDuration(16,2)))
  //   //     console.log(getHours(await game.getGameDuration(16,3)))



  //       // console.log( (await game.getGameDuration(16,0)))
  //       // console.log( (await game.getGameDuration(16,1)))
  //       // console.log((await game.getGameDuration(16,2)))
  //       // console.log((await game.getGameDuration(16,3)))


  //   await time.increase(13*3600)



  //   //   // console.log("get isTableClaimReady")
  //   //   // console.log("blockTimestamp is " + await time.latest())

  //       // console.log(await game.isTableClaimReady(16,0))      
  //       // console.log(await game.isTableClaimReady(16,1))
  //       // console.log(await game.isTableClaimReady(16,2))
  //       // console.log(await game.isTableClaimReady(16,3))

  //   //     // console.log(await game.getTablesClaimReadyInRoom(16))


  //   //     // await time.increase(46900)


  //   // //  console.log(await game.isTableClaimReady(16,0))      
  //   //     console.log(await game.isTableClaimReady(16,1))
  //   //     // console.log(await game.isTableClaimReady(16,2))
  //   //     // console.log(await game.isTableClaimReady(16,3))
  //   //     // await game.ClaimSingleGame(16,0,1255)
  
  
  //   //     // const claimtwo = await game.claimReadyTablesInRoom(16,125125);
  //   //     // await claimtwo.wait()

  //       // await game.ClaimSingleGame(16,0,125512);
  //       // await game.ClaimSingleGame(16,1,125512);
  //       // await game.ClaimSingleGame(16,2,125512);
  //       // await game.ClaimSingleGame(16,3,125512);

  //       // console.log(await game.GetCurrentTableInRoom(16,3))


  //       console.log(await game.getTablesClaimReadyInRoom(16))


  //       // await game.claimReadyTablesInRoom(16,125125);

  //       // console.log(await game.getTablesClaimReadyInRoom(16))


  //       // console.log('asdasdasdasd')
  //       // console.log(await game.GetCurrentTableInRoom(16,0))

        
   
  // });





    //  // 0726 !!!
    //  it("tests with amount card after claim regular table", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

      
    //   await (MintContract.newSmartMint(10,6, {value:50111}))
      
    //   console.log(await MintContract.tokensOfOwner(acc1.address))
      
    //   await game.advancedBulkEnterInGame(6,0, [1,2,3,4,5,6,7,8,9,10] )
      
    //   await time.increase(95000);


    //   await game.ClaimSingleGame(6,0,9997)

    //   console.log(await MintContract.tokensOfOwner(acc1.address))
      



    // });



































    // нужно протестировать просто что они становятся коммонками после игры на столе
    // первый уровень становится коммонкой только после клейма блекрума получается

  
    //       // 0725 !!!
    //   it("tests with high levels  IS COMMON", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(10,3, {value:50111}))
      
    //   await (MintContract.connect(acc2).newSmartMint(10,2, {value:50111}))
      
    //   await (MintContract.connect(acc3).newSmartMint(12,1, {value:50111}))
      
      
    //   await game.setPrizeRadioChoise(1);

    //   await game.advancedBulkEnterInGame(3,0, [1,2,3,4,5,6,7,8,9,10] )
    //   await game.connect(acc2).advancedBulkEnterInGame(2,0, [11,12,13,14,15,16,17,18,19,20])
    //   await game.connect(acc3).bulkEnterInBlackRoom([21,22,23,24,25,26,27,28,29,30,31,32])

    //   await time.increase(95000);


    //   await game.ClaimSingleGame(3,0,9997)
    //   await game.ClaimSingleGame(2,0,5688)
    //   await game.claimBlackRoom(125125);
      
    //   for (let i = 1; i < 33; i++) {
    //     console.log(await MintContract.isCommon(i))
    //     expect(await MintContract.isCommon(i)).to.be.true;
        
    //   }



    // });

    

//       // 0725 !!!
//       it("tests with refund", async function() {
  
  
//       const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

//       await (MintContract.newSmartMint(40,1, {value:50111}))
//       await game.setPrizeRadioChoise(1);


        

//       await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11])
//       await game.leaveBlackTable([1,2,3,4,5,6,7,8,9,10,11])

//       console.log(await MintContract.viewNotTransferable(1))

//       console.log(await MintContract.viewNotTransferable(2))
//       console.log(await MintContract.viewNotTransferable(3))
//       console.log(await game.bulkCheckNotTransferable([1,2,3]))

//       console.log("balance before " + await ethers.provider.getBalance(acc1.address))


//       // await game.refundYourNFT([1,2,3])


//       // Default behavior
// await expect(await game.refundYourNFT([1,2,3]))
// .to.changeEtherBalance(acc1.address, 48);

//       // console.log("balance after" + await ethers.provider.getBalance(acc1.address))
      
//     // await time.increase(96400);

//     // await game.claimBlackRoom(2135236);

    
//     // console.log(await game.getBlackTable())
//     // console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  






//     });



  //   it("claimBlackRoom with transform in mintPasses", async function() {
  
  
  //     const { game, helper, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);
        
  //     console.log(game.address +  '  is game contract address')
  //     console.log(helper.address + '  is helper address')

  //     await game.setPrizeRadioChoise(1);

      
  //       await MintContract.newSmartMint(100, 1, { value: 1000000 });
   


  
  //     await token.mint(game.address, 1000000);


  //       const set = await game.setPrizeRadioChoise(1)
  //       await set.wait();

  //       // console.log(await game.getBlackTablePlayerByIndex(0));



  //       // for (let i = 1; i <= 5; i++) {
  //       //   console.log(await MintContract.viewNotTransferable(i));
          
  //       // }

  //  await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11,12])


  // //  console.log( await game.getIndexesOfInputTokenIdsInBlackRoom([1,3,5]))

  // //  await game.leaveBlackTable([1,3,4])

   
  
  //   // const tx2 = await game.connect(acc2).bulkEnterInBlackRoom([11,12,13,14,15])
  //   // await tx2.wait()

    
  //   // const tx3= await game.connect(acc3).bulkEnterInBlackRoom([16,17,18,19,20])
  //   // await tx3.wait()

  
  //   // const tx4 = await game.connect(acc4).bulkEnterInBlackRoom([21,22,23,24,25,26])
  //   // await tx4.wait()

  
  //   // const tx5 = await game.connect(acc5).bulkEnterInBlackRoom([27])
  //   // await tx5.wait()


    
  //   console.log(await token.balanceOf(acc1.address))


  //   await time.increase(96400);

  //   await game.claimBlackRoom(2135236);


  //       // данный клейм меняет свойство 3 токен идсов на минт пассы

  //       console.log(await game.getBlackTable())
  //     console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  

  //       // await game.claimStakingTokensFromBlackRoom()
  //       //         console.log(await token.balanceOf(acc1.address))



          


  //   //     console.log(await game.generateWinnersForBlackRoom(125125)
  //   //     )

  //   //     await time.increase(8640)



  //   // const claim = await game.claimBlackRoom(125125);
  //   // await claim.wait()
    
    
    
    
  //   // //   // console.log(claim)


  //     // const receipt = await ethers.provider.getTransactionReceipt(claim.hash);
  //     // const interfaceTX = new ethers.utils.Interface(["event blackRoomClaimed(uint256[] tempWinners, uint256[] tempInvolvedTokenIds, uint256 prizeRadioChoice)"]);
  //     // const data = receipt.logs[0].data;
  //     // const topics = receipt.logs[0].topics;
  //     // const event = interfaceTX.decodeEventLog("blackRoomClaimed", data, topics);

  //     // console.log("///////////////")


  //     // console.log("$$$$$$$$")

      
  //     // console.log(await game.getBlackRoom())








  //     // console.log("$$$$$$$$")



  //     //       console.log(await game.returnTimesPlayerInBlackRoom(acc1.address));
  //     //       console.log(await game.getIndexesOfPlayerInBlackRoom());
  //     //       console.log(await game.getIndexesOfPlayerInBlackRoom());

  //     //       console.log("$$$$$$$$")

            



      

  //     // const stak = await game.claimStakingTokensFromBlackRoom();
  //     // await stak.wait()


  //     // console.log( await token.balanceOf(acc1.address))
      











      

  //     // const receipt = await ethers.provider.getTransactionReceipt(stak.hash);
  //     // const interfaceTX = new ethers.utils.Interface(["event some(uint256[]  _data)"]);
  //     // const data = receipt.logs[0].data;
  //     // const topics = receipt.logs[0].topics;
  //     // const event = interfaceTX.decodeEventLog("some", data, topics);
      
  //     // console.log(event)

      
  
  //     // expect(event.from).to.equal(<addr-of-signer-account>);
  //     // expect(event.to).to.equal(<addr-of-receipent>);
  //     // expect(event.amount.toString()).to.equal(<amount-BigNumber>.toString());



  //   // await expect(game.claimBlackRoom()).to.emit(game, "blackRoomClaimed").withArgs(3);

    

   
   
  
  //   });









    

    //  0725 test with supply !!!
    //   it("tests with mint supply", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(32,10, {value:500}))

    //   console.log(await MintContract.isDayInRoomIncreased(10,1))
    //   console.log(await MintContract.isDayInRoomIncreased(10,2))
    //   console.log(await MintContract.isDayInRoomIncreased(10,3))


    //   // await (MintContract.newSmartMint(1,10, {value:500}))

    //         // для первого дня может быть только такая ошибка потому что первый день нельзя удвоить
    //         await expect(MintContract.newSmartMint(1,10, {value:500})).to.be.revertedWith("all nfts for today has been minted without increase");
        

    //         // скипаем день чтобы попать в currentDay = 2

    //         await time.increase(86401)

    //         console.log('day ' + await MintContract.getCurrentDay());


    //         await (MintContract.newSmartMint(64,10, {value:500}))

    //         await expect(MintContract.newSmartMint(1,10, {value:500})).to.be.revertedWith("all nfts for today has been minted with increase limit already");

    //         console.log(await MintContract.isDayInRoomIncreased(10,3))
    //         console.log(await MintContract.isDayInRoomIncreased(10,4))


    //         await time.increase(86401)

    //         await expect(MintContract.newSmartMint(128,10, {value:5000})).to.be.revertedWith("all nfts for today has been minted with increase limit already");

    //         await (MintContract.newSmartMint(64,10, {value:500}))



    //         console.log(await MintContract.isDayInRoomIncreased(10,4))
    //         console.log(await MintContract.isDayInRoomIncreased(10,5))









    //   // await (MintContract.newSmartMint(1,10, {value:500}))


    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});


    //   // console.log(await game.GetCurrentTableInRoom(16,0));


      

  
    //   // заходим в игру первый раз
    //   // await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10]);


    //   // console.log("/////////")
    //   // console.log("/////////")
    //   // console.log("/////////")

    //   // console.log(await game.GetCurrentTableInRoom(16,0));


    //   // await game.ClaimSingleGame(16,0,126);

    //   // console.log(await game.GetCurrentTableInRoom(16,0));


    //   // //   пробуем войти в кулдаун стол

    //   // // console.log(await MintContract.tokensOfOwner(acc2.address))

    //   // await game.connect(acc2).advancedBulkEnterInGame(16,0, [41,42,43,44,45,46,47,48,49]);
    //   // console.log(await game.GetCurrentTableInRoom(16,0));


    // });






    //   // 0725 !!!
    //   it("clam single game", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(40,16, {value:50}))
    //   await (MintContract.connect(acc2).newSmartMint(40,16, {value:50}))

    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});


    //   // console.log(await game.GetCurrentTableInRoom(16,0));


      

  
    //   // заходим в игру первый раз
    //   await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10]);


    //   console.log("/////////")
    //   console.log("/////////")
    //   console.log("/////////")

    //   console.log(await game.GetCurrentTableInRoom(16,0));


    //   await game.ClaimSingleGame(16,0,126);

    //   console.log(await game.GetCurrentTableInRoom(16,0));


    //   //   пробуем войти в кулдаун стол

    //   // console.log(await MintContract.tokensOfOwner(acc2.address))

    //   await game.connect(acc2).advancedBulkEnterInGame(16,0, [41,42,43,44,45,46,47,48,49]);
    //   console.log(await game.GetCurrentTableInRoom(16,0));


    // });









  //       it("claimBlackRoom with transfor in mintpasses", async function() {
  
          
  //         //  console.log( await game.getIndexesOfInputTokenIdsInBlackRoom([1,3,5]))

  // //  await game.leaveBlackTable([1,3,4])

   
  
  //   // const tx2 = await game.connect(acc2).bulkEnterInBlackRoom([11,12,13,14,15])
  //   // await tx2.wait()

    
  //   // const tx3= await game.connect(acc3).bulkEnterInBlackRoom([16,17,18,19,20])
  //   // await tx3.wait()

  
  //   // const tx4 = await game.connect(acc4).bulkEnterInBlackRoom([21,22,23,24,25,26])
  //   // await tx4.wait()

  
  //   // const tx5 = await game.connect(acc5).bulkEnterInBlackRoom([27])
  //   // await tx5.wait()

  //     const { game, helper, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);
        
  //     console.log(game.address +  '  is game contract address')
  //     console.log(helper.address + '  is helper address')

  //     await game.setPrizeRadioChoise(1);

      
  //     await MintContract.newSmartMint(100, 1, { value: 1000000 });
   
  //     await token.mint(game.address, 1000000);

  //     await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11,12])


  

  //   console.log(await game.getBlackTable())

    


  //   await time.increase(60);


  //   const claim = await game.claimBlackRoom(125125);
  //   await claim.wait()
    
  //     const receipt = await ethers.provider.getTransactionReceipt(claim.hash);
  //     const interfaceTX = new ethers.utils.Interface(["event blackRoomClaimed(address[] tempWinners, uint256[] tempInvolvedTokenIds, uint256 prizeRadioChoice)"]);
  //     const data = receipt.logs[0].data;
  //     const topics = receipt.logs[0].topics;
  //     const event = interfaceTX.decodeEventLog("blackRoomClaimed", data, topics);
  //     console.log("event now")
  //     console.log(event)

  //       console.log(await game.isMintPass(event.tempInvolvedTokenIds[0]))
  //     for (let i = 0; i < event.tempInvolvedTokenIds.length; i++) {
  //       let isMintPass: boolean;
  //       let isTransferable: boolean;
  //       isMintPass = await game.isMintPass(event.tempInvolvedTokenIds[i]);
  //       isTransferable = await MintContract.viewNotTransferable(event.tempInvolvedTokenIds[i])
  //         expect(isMintPass).to.equal(true);
  //         expect(isTransferable).to.equal(false);

  //     }


  //     console.log("$$$$$$$$")

  //     // MINTPASSES WORKS CORRECTLY


  //     // test estimate and claim staking rewards;


  //     // event ClaimedStakingTokens(address indexed player, uint indexed amount, uint indexed claimTimestamp)

          



  //       // данный клейм меняет свойство 3 токен идсов на минт пассы

  //       // console.log(await game.getBlackTable())

  //       console.log("balance before " + await token.balanceOf(acc1.address) )
  //     console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  

  //       await game.claimStakingTokensFromBlackRoom()
  //               console.log(await token.balanceOf(acc1.address))



          


        
  //     // const stak = await game.claimStakingTokensFromBlackRoom();
  //     // await stak.wait()


  //     // console.log( await token.balanceOf(acc1.address))
      










    

   
   
  
  //   });

//   it("claimBlackRoom with sending raffle tokens", async function() {
  
          

// const { game, helper, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);
  
// console.log(game.address +  '  is game contract address')
// console.log(helper.address + '  is helper address')

// await game.setPrizeRadioChoise(2);


// await MintContract.newSmartMint(100, 1, { value: 1000000 });

// await token.mint(game.address, 1000000);

// await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11,12])




// console.log(await game.getBlackTable())




// await time.increase(60);


// const claim = await game.claimBlackRoom(125125);
// // await claim.wait()

// const receipt = await claim.wait()

// for (const event of receipt.events) {
//   console.log(`Event ${event.event} with args ${event.args}`);
// }


    
//       // const receipt = await ethers.provider.getTransactionReceipt(claim.hash);
//       // const interfaceTX = new ethers.utils.Interface(["event blackRoomClaimedPrizeRaffleToken(uint256 _payvalue)"]);
//       // const data = receipt.logs[0].data;
//       // const topics = receipt.logs[0].topics;
//       // const event = interfaceTX.decodeEventLog("blackRoomClaimedPrizeRaffleToken", data, topics);
//       // console.log("event now")
//       // console.log(event)


// //   console.log(await game.isMintPass(event.tempInvolvedTokenIds[0]))
// // for (let i = 0; i < event.tempInvolvedTokenIds.length; i++) {
// //   let isMintPass: boolean;
// //   let isTransferable: boolean;
// //   isMintPass = await game.isMintPass(event.tempInvolvedTokenIds[i]);
// //   isTransferable = await MintContract.viewNotTransferable(event.tempInvolvedTokenIds[i])
// //     expect(isMintPass).to.equal(true);
// //     expect(isTransferable).to.equal(false);

// // }


// console.log("$$$$$$$$")

// // MINTPASSES WORKS CORRECTLY


// // test estimate and claim staking rewards;


// // event ClaimedStakingTokens(address indexed player, uint indexed amount, uint indexed claimTimestamp)

    



// //   // данный клейм меняет свойство 3 токен идсов на минт пассы

// //   // console.log(await game.getBlackTable())

// //   console.log("balance before " + await token.balanceOf(acc1.address) )
// // console.log("available to claim   " + await game.estimateStakingRewardsInBlackRoom(acc1.address));  

// //   await game.claimStakingTokensFromBlackRoom()
// //           console.log(await token.balanceOf(acc1.address))



    


  
// // const stak = await game.claimStakingTokensFromBlackRoom();
// // await stak.wait()


// // console.log( await token.balanceOf(acc1.address))
















// });














//   it("testing with bulkEnter and Bulkleave in blackTable and tables", async function() {
  
  
//     const { game, helper, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);
      
//     console.log(game.address +  '  is game contract address')
//     console.log(helper.address + '  is helper address')

    

//       // regular tables
//       await MintContract.newSmartMint(20, 16, { value: 20 });
//       await MintContract.connect(acc2).newSmartMint(20,16, {value:20});


//       //black tables
//       await MintContract.connect(acc3).newSmartMint(10,1, {value:1000});

//       await MintContract.connect(acc4).newSmartMint(10,1, {value:1000});

      



//     // await game.bulkEnterInBlackRoom([1,2,3,4,5,6,7,8,9,10,11,12])


//     //reg

//     await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7])

//     await game.leaveGame(16,0, [1,2,3,4,5,6,7])

//     const t1 = await game.GetCurrentTableInRoom(16,0);
//            expect(t1.playersNow).to.equal(0);

//     console.log(await MintContract.tokensOfOwner(acc2.address));



    
//     await game.connect(acc2).advancedBulkEnterInGame(16,1, [21,22,23,24,25,26,27])


//     await game.connect(acc2).leaveGame(16,1, [21,22,23,24,25,26,27])

//     const t2 = await game.GetCurrentTableInRoom(16,1);
//            expect(t2.playersNow).to.equal(0);
//         // console.log(t2)

//            /// blackTable


//             await game.connect(acc3).bulkEnterInBlackRoom([41,42,43,44,45,46,47,48,49,50])
//             console.log("///")
//             // console.log(await helper.getIndexesOfInputTokenIdsInBlackTable([41,42,43,44,45,46,47,48,49,50]))
//             // await game.connect(acc3).leaveBlackTable([41,42,43,44,45,46,47,48,49,50])
//             // const t3 = await game.getBlackTable();
//             // expect(t3.playersNow).to.equal(0);

//             // console.log(t3)



            
//             await game.connect(acc4).bulkEnterInBlackRoom([51,52,53])
//             // await game.connect(acc4).leaveBlackTable([51,52,53,54,55])
//             const t4 = await game.getBlackTable();
//             // expect(t4.playersNow).to.equal(0);
//             console.log(t4)

//             await game.claimBlackRoom







// //  console.log( await game.getIndexesOfInputTokenIdsInBlackRoom([1,3,5]))

// //  await game.leaveBlackTable([1,3,4])

 

//   // const tx2 = await game.connect(acc2).bulkEnterInBlackRoom([11,12,13,14,15])
//   // await tx2.wait()

  
//   // const tx3= await game.connect(acc3).bulkEnterInBlackRoom([16,17,18,19,20])
//   // await tx3.wait()


//   // const tx4 = await game.connect(acc4).bulkEnterInBlackRoom([21,22,23,24,25,26])
//   // await tx4.wait()


//   // const tx5 = await game.connect(acc5).bulkEnterInBlackRoom([27])

 
 

//   });








    // it("claim 1 game ", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(40,16, {value:50}))
    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});
      

    //   // console.log(await game.GetCurrentTableInRoom(16,0))
    //   // console.log("!!!!!!!!!!!!!!")

    //   // заходим в игру первый раз
    //   await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9]);
    //   // await game.advancedBulkEnterInGame(16,2, [10,11,13]);

    //   await game.leaveGame(16,0, [3,7,8])


    //   console.log(await game.GetCurrentTableInRoom(16,0))
    //   //   console.log("//////////")
    //   //   console.log("//////////")

    //   // console.log(await game.GetCurrentTableInRoom(16,1))
    //   // console.log("//////////")
    //   // console.log("//////////")


    //   // console.log(await game.GetCurrentTableInRoom(16,2))


  

  
    // });

  




    // it("tests with time for genesis and common for regular tables", async function() {
  
  
    //   const { game, MintContract, token, helper, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   // await (MintContract.newSmartMint(20,16, {value:50}))
    //   // await MintContract.connect(acc1).newSmartMint(10,16, {value:50});
      

  
    //   // // заходим в игру первый раз
    //   // await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9]);

    //   // await game.leaveGame(16,0, [1,2,3,4,5,6,7,8,9] )

    //   // for (let i = 0; i < 10; i++) {
    //   //   // expect(await MintContract.viewNotTransferable(i)).to.equal(false);
    //   //   console.log( ` after leave ${i}` + await MintContract.viewNotTransferable(i))      
    //   //   }
    //   // await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10]);

    //   // for (let i = 0; i <10; i++) {
    //   //   // expect(await MintContract.viewNotTransferable(i)).to.equal(true);
    //   //   console.log( ` after enter ${i}` + await MintContract.viewNotTransferable(i))      
        
    //   // }

      

     

        
            

  
    // });











    // it("tests with proper amount after claim Game", async function() {
  
  
    //   const { game, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(16,16, {value:50}))

  
    // });





    // it("tests with time for genesis and common for regular tables", async function() {
  
  
    //   const { game, MintContract, token, acc1, acc2, acc3, acc4, acc5, acc6, acc7, acc8, acc9, acc10 } = await loadFixture(deploy);

    //   await (MintContract.newSmartMint(20,16, {value:50}))
    //   await MintContract.connect(acc1).newSmartMint(10,16, {value:50});
      

    //   expect((await game.getCurrentStatusForTable(16,0))).to.equal(0);
  
    //   // заходим в игру первый раз
    //   await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10]);

    //   expect((await game.getCurrentStatusForTable(16,0))).to.equal(1);

      

    //   await time.increase(89000)
        
             
    //   await game.ClaimSingleGame(16,0,125125);

    //    expect((await game.getCurrentStatusForTable(16,0))).to.equal(2);



    //   //  // теперь пробуем войти коммонкой


    //   // await expect(game.advancedBulkEnterInGame(16,0, [1])).to.be.rejectedWith('try later');

    //   // await game.advancedBulkEnterInGame(16,0, [1])
    //   await game.advancedBulkEnterInGame(16,0, [11,12])
    //   // await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5])
    //   // await game.advancedBulkEnterInGame(16,0, [1,2,3,4,5,6,7,8,9,10])


    //   // await game.connect(acc1).advancedBulkEnterInGame(16,0, [11]);

    //   // expect((await game.getCurrentStatusForTable(16,0))).to.equal(1);





        
            

  
    // });





  
  
  
  
  
  });