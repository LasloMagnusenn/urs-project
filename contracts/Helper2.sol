// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;


import "./IGameContract.sol";
import "./console.sol";
import "./IMintContract.sol";


contract Helper2 {

        event ClaimedStakingTokens(address indexed player, uint indexed amount, uint indexed claimTimestamp);




            IGameContract public GameContract;
            IMintContract public Collection;


        constructor(address _collection) {
            Collection = IMintContract(_collection);

        }



        
    function setGameContract(address _GameContract) public {
        GameContract = IGameContract(_GameContract);
    }


    function setCollection(address _collection) public {
        Collection = IMintContract(_collection);
    }




        function claimStakingTokensFromBlackRoom() public {
            
                
    require(GameContract.getBlackTableStatus() == 4, "raffle not happened yet");

    //     // на каждый timeMark делаем исчисление
       uint256[] memory tempIndexes = GameContract.getIndexesOfPlayerInBlackRoom(tx.origin);
       console.log("length of tempIndexes", tempIndexes.length);


        uint reward;
    for (uint i = 0; i < tempIndexes.length ; i++)  {
        // console.log(blackTable.lastGameFinishedAt, "lastGameFinished value");
        // console.log("timeMark",blackTable.playersTimeMarks[tempIndexes[i]]);
           reward += ((GameContract.getBlackTableLastGameFinishedAt() - GameContract.getBlackTablePlayerTimeMarkByIndex(tempIndexes[i]))/GameContract.getBlackTableStakingRate());
            // console.log("result of ", ((GameContract.getBlackTableLastGameFinishedAt() -
            // blackTable.playersTimeMarks[tempIndexes[i]]) / blackTable.stakingRate) );
            // console.log("increase staking reward to", reward);
           
            // console.log("getBlackLastGameFinishedAT", GameContract.getBlackTableLastGameFinishedAt() );
            // console.log("i timemarks", GameContract.getBlackTablePlayerTimeMarkByIndex(tempIndexes[i]));
            // console.log("staking rate", GameContract.getBlackTableStakingRate());
        

     
    }
    console.log("need to send", reward);
               GameContract.sendRaffleTokens(tx.origin, reward);
                           emit ClaimedStakingTokens(tx.origin, reward, block.timestamp);

            console.log("reward", reward);
  

        }




        
    function refundYourNFT(uint256[] calldata _tokenIds) public {




                       //  //may need add arguments for other blackTables?
                require(GameContract.getBlackTableStatus() == 3, "black table is not fullfiled");
                require(block.timestamp <= GameContract.viewGlobalLastGameFinishedAt() + 3 hours, "too late");
                require(!GameContract.bulkCheckNotTransferable(_tokenIds), "one of tokens in game");
                

        for (uint256 i = 0; i < _tokenIds.length; i++) {
         
            require(
                !Collection.viewIsCommon(_tokenIds[i]),
                "not genesis token"
            );

            

            Collection.burn(_tokenIds[i]);

            // uint value = (Collection.viewCosts(Collection.viewNFTRoomLevel(_tokenIds[i]) * refandRate) / 100);
            uint value = Collection.viewCosts(Collection.viewNFTRoomLevel(_tokenIds[i]));


            Collection.payoutForRefunder(msg.sender,  value);


            console.log(
                Collection.viewCosts(Collection.viewNFTRoomLevel(_tokenIds[i]))
            );
        }



    }





}