// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IERC20.sol";
import "./IMintContract.sol";
import "./IERC721.sol";
import "./console.sol";
import "./IReduct.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./IHelper.sol";
import "./IHelper1.sol";
import "./IHelper2.sol";

// сделать создание румов для тестирования удобнее
// добавить темп дев функции для работы со столами

contract GameContract is Ownable {
    using SafeMath for uint256;



    //Place for Events
    //Place for custom errors (if need)

    //     function onERC721Received() external returns (bytes4) {
    //     // Логика обработки токена
    //     // ...
    //     uselessUint = 3;
    //     console.log("nft transfer registered");
    //     return IERC721Receiver.onERC721Received.selector;
    // }

    mapping(uint256 => bool) public isMintPass; // токен ид к бул значению

    mapping(uint8 => uint256) public currentRoomGameDuration; // сколько длится текущая игра по дефолту ( с учетом увеличения времени согласно каунтерам)
    mapping(uint8 => uint8) public roomGameDurationIncreaseCounter; // просто ограничитель, который не дает увеличивать время в руме больше 16 раз

    uint256 public trump; // козырь карта

    function viewTrump() public view returns(uint256) {
        return trump;
    }
    uint256 public trumpCounter; // каунтер для смены трампа

    IERC20 public RaffleToken; // токен проекта
    IERC721 public RaffleNFT; // NFT для розыгрыша
    IMintContract public Collection;
    IReduct public Reduct;
    IHelper public helper; 
    IHelper1 public helper1;
    IHelper2 public helper2;


    // function viewRaffleTokenAddress() public view returns(address) {
    //     return address(RaffleToken);
    // }

    // возвращает true если токен задан
    function isRaffleTokenSet() public view returns(bool) {
                return (address(RaffleToken) != address(0)) ? true : false;

    }



    function sendRaffleNFTToWinner(address _winner, uint _tokenId) public {

        // всякие проверки если нужны
                RaffleNFT.approve(_winner, _tokenId);

                RaffleNFT.safeTransferFrom(address(this), _winner, _tokenId);
            console.log("success");

    }

    
     function sendRaffleTokens(address _who, uint _amount) public {
        //какие то проверки
            RaffleToken.approve(address(this), _amount);

        RaffleToken.transferFrom(address(this), _who, _amount);

    }


 




    
    function balanceOfRaffleTokens() public view returns(uint) {

                return RaffleToken.balanceOf(address(this));

    }





    // добавить интерфейс NFT коллекции розыгрыша

    //динамический массив из страктов тейблов по ключу рума (examples allTables[1][0] - первый стол в первой руме, allTables[16][1] - второй стол в 16 руме)
    mapping(uint8 => Table[]) public allTables;
    mapping(uint8 => uint256) public currentAmountGamesFinished; //количество завершенных игр в руме   (сбрасывающийся каунтер!)



    uint256 public prizeRadioChoice;
    // либо превращение карточек в нфт пассы = 1
    // либо распределение RaffleToken = 2
    // либо розыгрыш какой то одной дорогой нфт = 3

    function setPrizeRadioChoice(uint8 _value) public {
        prizeRadioChoice = _value;
    }

    //time settings
    uint256 public baseGameDuration = 1 minutes; // первое назначение времени рума
    uint256 public cooldownTime = 2 seconds; // кулдаун времени между играми на столе

    function viewCooldownTime() public view returns(uint) {
        return cooldownTime;
    }


    uint256 public globalLastGameFinishedAt;

    uint256 uselessUint;

    enum Status {
        // статусы для стола
        WaitingPlayers, //0
        Playing, //1
        Cooldown, //2
        Fulfilled, //3
        RaffleHappened // 4
    }

    

    // struct PlayerInfo { // инфо по игроку внутри стола
    //     address playerAddress;
    //     uint256 tokenId;
    // }

    struct Table {
        // стракт стола
        uint256 serialNumber; // количество завершенных игр на конкретном столе (позже пригодится возможно)
        uint8 playersNow;
        address[10] players;
        uint256[10] playingTokenIds;
        uint256[4] playingSuits;
        uint256 currentGameStartedAt; // просто точка во времени когда началась текущая игра на столе               для сверки require при клейме стола
        uint256 lastGameFinishedAt; // просто точка во времени когда закончилась последняя игра на этом столе    для сверки кулдауна при начинании новой игры
        uint256 internalGameReduction; // вычитается из currentGameRoomDuration из за комбинаций всяких
        uint256 status;
        // Status status;
    }

    
    function incrPlayersNow(uint8 _roomLevel, uint256 _table) public {
        allTables[_roomLevel][_table].playersNow++;
    }

     
    function decrPlayersNow(uint8 _roomLevel, uint256 _table) public {
        allTables[_roomLevel][_table].playersNow--;
    }
    
     function decrPlayersNowInBlackTable() public {
        blackTable.playersNow--;
    }


    
       function setCurrentGameStartedAt(uint8 _roomLevel, uint256 _table, uint256 _value) public {
        allTables[_roomLevel][_table].currentGameStartedAt = _value;
    }

        function setLastGameFinishedAt(uint8 _roomLevel, uint256 _table, uint256 _value) public {
        allTables[_roomLevel][_table].lastGameFinishedAt = _value;
    }

  

     function setStatus(uint8 _roomLevel, uint256 _table, uint256 _value) public {
        allTables[_roomLevel][_table].status = _value;
    }

     function incrPlayingSuits(uint8 _roomLevel, uint256 _table, uint _index, uint _value) public {
        allTables[_roomLevel][_table].playingSuits[_index] += _value;
    }

     function decrPlayingSuits(uint8 _roomLevel, uint256 _table, uint _index, uint _value) public {
        allTables[_roomLevel][_table].playingSuits[_index] += _value;
    }

    function addPlayer(uint8 _roomLevel, uint256 _table, uint _index, address _player) public {
                allTables[_roomLevel][_table].players[_index] = _player;

    }


     function addPlayerByPlace(uint8 _roomLevel, uint256 _table, uint place, address _player) public {
                allTables[_roomLevel][_table].players[place-1] = _player;

    }


     function addPlayingTokenId(uint8 _roomLevel, uint256 _table, uint _index, uint _tokenId) public {
                allTables[_roomLevel][_table].playingTokenIds[_index] = _tokenId;

    }




    




        struct blackTableStruct {

        uint256 serialNumber; // количество завершенных игр на конкретном столе
        uint8 playersNow;
        address[] players;
        uint256[] playingTokenIds;
        uint256[] playersTimeMarks;
        // uint256[4] playingSuits;
        uint256 readyToClaimAt; // просто точка во времени когда началась игра для сверки require при клейме
        uint256 timeUntilRaffleExecution; // просто точка во времени когда началась игра для сверки require при начинании новой игры
        uint256 lastGameFinishedAt;
        // uint256 internalGameReduction; // cколько эта игра будет длиться с учетом комбинаций ( будет получено путем вычета комбинации из baseGameDuration)
        uint256 stakingRate; // = 14400 // can be set over function
        uint256 amountPlayersUntilCurrentRaffle; // 15 for testing; can be set over function
        uint256 amountWinnersToPayout; // 3 for testing; (not for single nft raffle!)  can be set over function
        uint256 amountTokensForRaffle;
        uint256 raffleNFTTokenId;


        uint256 status;

        // Status status;

        // other blackTable Variables

    }

    
    function getBlackTable() public view returns(blackTableStruct memory) {
        return blackTable;
    }

    function getBlackTableStatus() public view returns(uint256) {
        return blackTable.status;
    }

      function getBlackTablePlayerByIndex(uint256 _index) public view returns(address) {
        return blackTable.players[_index];
    }

    function getPlayerOnTableByIndex(uint8 _roomLevel, uint256 _table, uint256 _index) public view returns(address) {
        return allTables[_roomLevel][_table].players[_index];
    }

        function getBlackTablePlayingTokenIdByIndex(uint256 _index) public view returns(uint256) {
        return blackTable.playingTokenIds[_index];
    }


         function getPlayingTokenIdInTableByIndex(uint8 _roomLevel, uint256 _table, uint256 _index) public view returns(uint256) {
        return allTables[_roomLevel][_table].playingTokenIds[_index];
    }

          function getPlayersNowForTable(uint8 _roomLevel, uint256 _table) public view returns(uint256) {
        return allTables[_roomLevel][_table].playersNow;
    }


       function getBlackTablePlayersNow() public view returns(uint256) {
        return blackTable.playersNow;
    }

    function getBlackTablePlayerTimeMarkByIndex(uint _index) public view returns(uint) {
        return blackTable.playersTimeMarks[_index];
    }

    function deletePlayerInBlackRoomByIndex(uint256 _index, uint256 _tokenId) public {

        blackTable.players[_index] = address(0);
        blackTable.playingTokenIds[_index] = 0;
        blackTable.playersTimeMarks[_index] = 0;
        blackTable.playersNow--;

        //СЬЮТЫ ДЕКРЕМЕНТИТЬ!!!

                    Collection.setNotTransferable(_tokenId, false);

    }


       function deletePlayerInBlackRoomByIndexV2(uint256 _index) public {

        blackTable.players[_index] = address(0);
        blackTable.playingTokenIds[_index] = 0;
        blackTable.playersTimeMarks[_index] = 0;
        blackTable.playersNow--;


    }


     function deletePlayerInTableByIndex(uint8 _roomLevel, uint256 _table, uint256 _index, uint256 _tokenId) public {

      allTables[_roomLevel][_table].players[_index] = address(0); //удаление и
                    allTables[_roomLevel][_table].playingTokenIds[_index] = 0;
                    allTables[_roomLevel][_table].playersNow--;

                    // СЬЮТЫ ДЕКРЕМЕНТИТЬ!!!

                    Collection.setNotTransferable(_tokenId, false);

    }



        function getPlayersLengthInTable(uint8 _roomLevel, uint256 _table) public view returns(uint256) {
        return allTables[_roomLevel][_table].players.length;
    }

         function getBlackTableAmountPlayersUntilCurrentRaffle() public view returns(uint256) {
        return blackTable.amountPlayersUntilCurrentRaffle;
    }

      function getBlackTablePlayersLength() public view returns(uint256) {
        return blackTable.players.length;
    }

    




    







        function pushInBlackTable(address _player, uint _timestamp, uint _tokenId) public {
        blackTable.players.push(_player);
        blackTable.playersTimeMarks.push(_timestamp);

        blackTable.playingTokenIds.push(_tokenId);
        
    }


    function getAmountTokensRaffleInBlackRoom() public view returns(uint) {
        return blackTable.amountTokensForRaffle;
    }

          function replaceInBlackTable(uint _index, address _player, uint _timestamp, uint _tokenId) public {
        blackTable.players[_index] = _player;
                blackTable.playersTimeMarks[_index] = _timestamp;

        blackTable.playingTokenIds[_index] = _tokenId;
        
    }



      function incrPlayersNowinBlack() public {
        blackTable.playersNow++;
    }

     
    function decrPlayersNowinBlack() public {
        blackTable.playersNow--;
    }
    
       
    function setTimeUntilRaffleExecutionInBlack(uint _value) public {
        blackTable.timeUntilRaffleExecution = _value;
    }




     function setBlackTableStatus( uint256 _value) public {
        blackTable.status = _value;
    }

    function setReadyToClaimAtInBlack(uint _value) public {
        blackTable.readyToClaimAt = _value;
    }


    function getRaffleNFTTokenIdInBlackRoom() public view returns(uint) {
        return blackTable.raffleNFTTokenId;
    }

        function isRaffleNFTSet() public view returns(bool) {
                return (address(RaffleNFT) != address(0)) ? true : false;

    }

  


    function setTempVariablesInBlackTableinBlack(uint _stakingRate, uint _amountPlayersUntilCurrentRaffle, uint _amountWinnersToPayout, uint _amountTokensRaffle, uint _raffleNFTTokenId ) public {
        // 
        blackTable.stakingRate = _stakingRate;
        blackTable.amountPlayersUntilCurrentRaffle = _amountPlayersUntilCurrentRaffle;
        blackTable.amountWinnersToPayout = _amountWinnersToPayout;
        blackTable.amountTokensForRaffle = _amountTokensRaffle;
        blackTable.raffleNFTTokenId = _raffleNFTTokenId;


    }

       function setStakingRateinBlackRoom(uint256 _value) public {
         //may need add arguments for other blackTables?

        blackTable.stakingRate = _value;
    }



    // function getInBlackArrays() public {
                        

    //     blackTable.players.push(msg.sender);
    //     blackTable.playingTokenIds.push(1);
    //     blackTable.playersTimeMarks.push(block.timestamp);


    // }

    blackTableStruct public blackTable;

       constructor( address _MintContract, address _RaffleToken, address _RaffleNFT, address _helper, address _helper1, address _helper2) {

              
           
        RaffleToken = IERC20(_RaffleToken);
        RaffleNFT = IERC721(_RaffleNFT);
        // Reduct = IReduct(_Reduct);
        Collection = IMintContract(_MintContract);
        helper = IHelper(_helper);
        helper1 = IHelper1(_helper1);
        helper2 = IHelper2(_helper2);

        //
        // bulkCreateTablesInRoom(2, 3);

        currentRoomGameDuration[1] = baseGameDuration; // одинаковое время для всех столов по дефолту или разное?
        currentRoomGameDuration[2] = baseGameDuration;
        currentRoomGameDuration[3] = baseGameDuration;
        currentRoomGameDuration[4] = baseGameDuration;
        currentRoomGameDuration[5] = baseGameDuration;
        currentRoomGameDuration[6] = baseGameDuration;
        currentRoomGameDuration[7] = baseGameDuration;
        currentRoomGameDuration[8] = baseGameDuration;
        currentRoomGameDuration[9] = baseGameDuration;
        currentRoomGameDuration[10] = baseGameDuration;
        currentRoomGameDuration[11] = baseGameDuration;
        currentRoomGameDuration[12] = baseGameDuration;
        currentRoomGameDuration[13] = baseGameDuration;
        currentRoomGameDuration[14] = baseGameDuration;
        currentRoomGameDuration[15] = baseGameDuration;
        currentRoomGameDuration[16] = baseGameDuration;

        // createTableInRoom(16);
        // createTableInRoom(16);

        //  createTableInRoom(1);
            // setting blackTable

          blackTable.playersNow = 0;

          blackTable.stakingRate = 10;
          blackTable.amountPlayersUntilCurrentRaffle = 12;
          blackTable.amountWinnersToPayout = 1;
          blackTable.amountTokensForRaffle = 50;
          blackTable.raffleNFTTokenId = 1;
                
          blackTable.timeUntilRaffleExecution = 1 minutes;

          setPrizeRadioChoice(3);
 
        
        
        
        
        
        
        
        
        
        //////////////////////////////////////////////
        
        createTableInRoom(1);
        createTableInRoom(2);

        createTableInRoom(3);

        createTableInRoom(4);

        createTableInRoom(5);

        createTableInRoom(6);

        createTableInRoom(7);

        createTableInRoom(8);

        createTableInRoom(9);

        createTableInRoom(10);

        createTableInRoom(11);

        createTableInRoom(12);

        createTableInRoom(13);

        createTableInRoom(14);
        createTableInRoom(15);

        createTableInRoom(16);
    }

    

    // function forceChangeStatusInRoom(uint8 _roomLevel, uint256 _table) public {
    //     allTables[_roomLevel][_table].status = Status.Cooldown;
    // }

      function onERC721Received(
    address,
    address,
    uint256,
    bytes calldata
  )
    external pure
    returns(bytes4)
  {
    return this.onERC721Received.selector;
  }

    function getCurrentStatusForTable(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (uint)
    {
        return allTables[_roomLevel][_table].status;
    }

    function isTableInRoomExists(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (bool)
    {
        if (_table >= allTables[_roomLevel].length) {
            return false;
        }

        return true;
    }

    function returnSerialNumber(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (uint256)
    {
        return allTables[_roomLevel][_table].serialNumber;
    }


    // на генезис холдеfsров не влияет почасовое увеличение времени

 

    function createTableInRoom(uint8 _room) public {
        uint256[4] memory emptySuits;
        address[10] memory emptyPlayers;
        uint256[10] memory emptyPlayingTokenIds;


        //сделать проверку на то что блекрум еще не существует

        //     Table storage newGame = allTables[viewAmountTablesInRoom(_room)+1];
        // newGame.serialNumber = 1;
        // newGame.playersNow = 0;
        // newGame.playingSuits = emptySuits;
        // newGame.currentGameStartedAt = 0;
        // newGame.lastGameFinishedAt = 0;
        // newGame.internalGameReduction = 0;
        // newGame.status = Status.WaitingPlayers;

        allTables[_room].push(
            Table(
                0, // добавить каунтер serialNumber
                0,
                emptyPlayers,
                emptyPlayingTokenIds,
                emptySuits,
                0,
                0,
                0,
                0
            )
        );

        //     if(_room != 1) {

        //     }
        //     else {
        //            allTables[_room].push(
        //         blackTable(
        //             1,
        //             emptyArr,
        //             emptyArrUint,
        //             emptySuits,
        //             1,
        //             0,
        //             0,
        //             currentRoomGameDuration[_room],
        //             Status.WaitingPlayers,
        //             14400,
        //             15,
        //             3
        //         )
        //     );

        //     }
    }

    function GetWholeRoom(uint8 _room) public view returns (Table[] memory) {
        return allTables[_room]; //shows up as a tuple
    }

    function GetCurrentTableInRoom(uint8 _room, uint256 _table)
        public
        view
        returns (Table memory)
    {
        return allTables[_room][_table]; //shows up as a tuple
    }

    function getPlayingSuitsSlotForTableInRoom(uint8 _roomLevel, uint256 _table, uint _slot) public view returns(uint256) {
        return allTables[_roomLevel][_table].playingSuits[_slot];
    }

    function incrInternalGameReduction(uint8 _roomLevel, uint256 _table, uint _value) public {
        allTables[_roomLevel][_table].internalGameReduction += _value;
    }

    function getActiveTablesForPlayer(address _who)
        public
        view
        returns (uint256[10][16] memory)
    {
        uint256[10][16] memory tempResults;

        for (uint8 r = 0; r <= 16; r++) {
            // здесь r это рум
            for (uint8 i = 0; i < viewAmountTablesInRoom(r); i++) {
                Table storage currentTable = allTables[r][i];
                // здесь i это стол

                for (uint256 p = 0; p < 10; p++) {
                    if (currentTable.players[p] == _who) {
                        tempResults[r - 1][i]++;
                    }
                }
            }
        }
        return tempResults;
    }

    function calculateGameDuration(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (uint256)
    {
        Table storage currentTable = allTables[_roomLevel][_table];

        return
            currentRoomGameDuration[_roomLevel] -
            currentTable.internalGameReduction;
    }

   

    function getValue1(uint256 _value) public view returns (bytes memory) {
        return bytes(Collection.viewSuits(_value));
    }

    function getValue2(uint256 _value) public view returns (bytes32) {
        return keccak256(abi.encodePacked(Collection.viewSuits(_value)));
    }

    // function ForceEnterInGame( uint8 _roomLevel,
    //     uint256 _table, uint _tokenId) public {

    //     allTables[_roomLevel][_table].players[0] = msg.sender;
    //     }

    //        function ForceEnterInGame1( uint8 _roomLevel,
    //     uint256 _table, uint _tokenId) public {

    //                 Table storage currentTable = allTables[_roomLevel][_table];

    //     currentTable.players[0] = msg.sender;
    //     }

    function bulkCheckNFTRoomLevel(uint256[] memory _tokenIds, uint8 _roomLevel) public view returns (bool) {
         


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             
            if(Collection.viewNFTRoomLevel(_tokenIds[i]) != _roomLevel) {
                return false;
            }

         }
       
        return true;
    }
    

    function bulkEnterInBlackRoom(
        uint256[] calldata _tokenIds
    ) public {


        helper.bulkEnterInBlackRoom(_tokenIds);


    //     // сделать проверку того что заходят токены нужного рума на стол
    //     //   НА ВСЕХ СТОЛАХ
    //     require(bulkCheckNFTRoomLevel(_tokenIds, 1), "not all tokens corresponding roomLevel");
        

    //     // сделать проверку на то что msg.sender обладает этим токеном

    //    require(checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 

        
    //     require(blackTable.status != 3); // если стол готов к клейму значит игроки больше не могут заходить а на фронте отображается кнопка клейма стола

    //     //  сделать проверку на прохождение кулдауна
    //     // require(blackTable.playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом
    //     // require(
    //     //     blackTable.status == Status.WaitingPlayers,
    //     //     "try after cooldown or game is going now"
    //     // ); //добавить разрешение для генезиса, однако генезис может войти только если идет кулдаун, а стол не переполнен

    //     //push player in game // до какого количества делать итерацию? до 10 логично с внутренним брейком
        
    //     // каждый k - токенId
    //     bool wasPushed;
    //     for (uint256 k = 0; k < _tokenIds.length; k++) {
            
            
    //         // каждый i - порядковый номер слота на столе
            
    //         // сначала чекаем по существующим ячейкам массива
    //         for (uint256 i = 0; i < blackTable.players.length; i++) {
    //             //players[i] - где i порядковый номер игрока в столе
    //             if (blackTable.players[i] == address(0)) {

    //                     console.log("doing replace");

    //                 blackTable.players[i] = msg.sender;
    //                 blackTable.playersTimeMarks[i] = block.timestamp;
    //                 blackTable.playersNow++; // на каждый токен одно увеличение playersNow
    //                 blackTable.playingTokenIds[i] = _tokenIds[k];
    //                 // pushSuitsInTable(1, 0, _tokenIds[k]); // пушить сьюты в стол может и имеет смысл но делать редакт тайма думаю нет

    //                 // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                 if(Collection.viewNotTransferable(_tokenIds[k]) == false) {
    //                                         Collection.setNotTransferable(_tokenIds[k], true);

    //                 } else {
    //                     revert("tokenId already in Game");
    //                 }
    //                 wasPushed = true;
    //                 break; // выходим из i итерации
    //             } 
    //         }

    //         if(!wasPushed) {

    //                 console.log("doing push");
    //                 blackTable.players.push(msg.sender);
    //                 blackTable.playersTimeMarks.push(block.timestamp);
    //                 blackTable.playingTokenIds.push(_tokenIds[k]);
    //                 blackTable.playersNow++; // на каждый токен одно увеличение playersNow

    //                  if(Collection.viewNotTransferable(_tokenIds[k]) == false) {
    //                                         Collection.setNotTransferable(_tokenIds[k], true);

    //                 } else {
    //                     revert("tokenId already in Game");
    //                 }




    //             //тут пушим
    //         }


    //     }

    //     // провести рафл?

    //     if (blackTable.playersNow == blackTable.amountPlayersUntilCurrentRaffle) {
    //              blackTable.status = 3;
    //              blackTable.readyToClaimAt = block.timestamp;

    //              // тут еще что то с временем добавить


    //     }
    }


    //  возвращает индекс стола который может принять в себя остаток
    function findAvailableTable(uint8 _roomLevel, uint256 _remainAllocation)
        public
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < viewAmountTablesInRoom(_roomLevel); i++) {
            if (
                (10 - allTables[_roomLevel][i].playersNow) >= _remainAllocation
            ) {
                return i;
            }
        }
        revert("cannot find free table");
    }


    
    function checkOwnershipOfTokens(uint256[] memory _tokenIds) public view returns(bool) {

        for (uint i = 0; i < _tokenIds.length; i++) 
        { // tx origin or msg.sender ?
           if(Collection.ownerOf(_tokenIds[i]) != tx.origin) {
               return false;
           }
        }
        return true;
    }

    function checkAllGenesis(uint256[] memory _tokenIds) public view returns(bool) {


        for (uint i = 0; i < _tokenIds.length; i++) 
        {
            if(Collection.viewIsCommon(_tokenIds[i]) == true) {
                return false;
            }
        }

        return true;
    }

    function getStatusForTable(  uint8 _roomLevel, uint256 _table) public view returns(uint) {
        return allTables[_roomLevel][_table].status;
    }


    function getBlackTableStakingRate() public view returns(uint) {
        return blackTable.stakingRate;
    }

    
     function advancedBulkEnterInGameWithPlace(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds, uint256[] calldata _placeIndexes
    ) public {

        helper.advancedBulkEnterInGameWithPlace(_roomLevel, _table, _tokenIds, _placeIndexes);
    }

    






    // добавить распределение по неограниченному количеству столов
    // пушит оставшиеся token ids в свободные столы
    function advancedBulkEnterInGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) public {

        helper.advancedBulkEnterInGame(_roomLevel,_table, _tokenIds);
        
    //     // проверка на существование стола
    //     require(
    //         isTableInRoomExists(_roomLevel, _table),
    //         "table doesn't exists"
    //     );

    //         // проверка на обладание токеном
    //    require(checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 
    //    require(bulkCheckNFTRoomLevel(_tokenIds, _roomLevel), "not all tokens corresponding roomLevel");
    //         // проверка на заполненность стола чтобы не передавать весь объем на freeTable
    //     require(allTables[_roomLevel][_table].playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом




    //     //  проверка на прохождение кулдауна стола

    //     bool allGenesis = checkAllGenesis(_tokenIds);

    //         // СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕПОЛНЕНИЕ либо дальше это уже делается

    //         // если все генезис
    //     if(allGenesis) {
    //         require(allTables[_roomLevel][_table].status != 1, "game is going now");

    //             // если хотя бы один не генезис
    //     } else {

    //          require((block.timestamp >= allTables[_roomLevel][_table].lastGameFinishedAt + cooldownTime), "try later"); // по сути это проверка того что стол вышел из кулдауна
    //          require(allTables[_roomLevel][_table].status != 1, "game is going now");
    //              }

    //              if(allTables[_roomLevel][_table].playersNow == 0) {
    //                  allTables[_roomLevel][_table].status = 0;

    //              }
        
      


    //     // можем сразу расчитать сколько токенов поместится в текущий стол

    //     // uint kCounter;
    //     // uint256 tokenCounter;

    //     // пусть tokenIds length = 4 ( 4 токена)
    //     // пусть playersNow = 3
    //     // тогда amount = 10-3 = 7, 7 >4  значит amount =

    //     uint256 freeTable;
    //     uint256 amountTokensForThisTable = 10 -
    //         allTables[_roomLevel][_table].playersNow;
    //     if (amountTokensForThisTable >= _tokenIds.length) {
    //         amountTokensForThisTable = _tokenIds.length;
    //     } else {
    //          freeTable = findAvailableTable(
    //             _roomLevel,
    //             _tokenIds.length - amountTokensForThisTable
    //         );
    //         console.log(freeTable);
    //     }

    //     // put inside currentTable

    //     uint256 innerCounter;
    //     // итерация по всем инпут токен идс
    //     for (uint256 k = 0; k < _tokenIds.length; k++) {
    //         innerCounter++;

    //         //1,2
    //         if (innerCounter <= amountTokensForThisTable) {
    //             // проходится по всему столу чтобы занять каждое свободное место
    //             for (uint256 i = 0; i <= 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе
    //                 if (
    //                     allTables[_roomLevel][_table].players[i] == address(0)
    //                 ) {
    //                     allTables[_roomLevel][_table].players[i] = msg.sender;
                      

    //                     allTables[_roomLevel][_table].playersNow++; // на каждый токен одно увеличение playersNow
    //                     allTables[_roomLevel][_table].playingTokenIds[
    //                         i
    //                     ] = _tokenIds[k];

    //                     helper.pushSuitsInTable(_roomLevel, _table, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     if (
    //                         Collection.viewNotTransferable(_tokenIds[k]) ==
    //                         false
    //                     ) {
    //                         Collection.setNotTransferable(_tokenIds[k], true);
    //                     } else {
    //                         revert("tokenId already in Game");
    //                     }

    //                     break; // выходим из i итерации
    //                 }
    //             }

    //             if (allTables[_roomLevel][_table].playersNow == 10) {
    //                 allTables[_roomLevel][_table].status = 1;
    //                 allTables[_roomLevel][_table].currentGameStartedAt = block
    //                     .timestamp;
    //                 allTables[_roomLevel][_table].lastGameFinishedAt = 0;
    //                 // Reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }
    //         } else {
    //             // проходится по всему столу чтобы занять каждое свободное место
    //             for (uint256 i = 0; i < 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе
    //                 if (
    //                     allTables[_roomLevel][freeTable].players[i] ==
    //                     address(0)
    //                 ) {
    //                     allTables[_roomLevel][freeTable].players[i] = msg
    //                         .sender;
                   

    //                     allTables[_roomLevel][freeTable].playersNow++; // на каждый токен одно увеличение playersNow
    //                     allTables[_roomLevel][freeTable].playingTokenIds[
    //                         i
    //                     ] = _tokenIds[k];

    //                     helper.pushSuitsInTable(_roomLevel, freeTable, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     if (
    //                         Collection.viewNotTransferable(_tokenIds[k]) ==
    //                         false
    //                     ) {
    //                         Collection.setNotTransferable(_tokenIds[k], true);
    //                     } else {
    //                         revert("tokenId already in Game");
    //                     }

    //                     break; // выходим из i итерации
    //                 }
    //             }

    //             if (allTables[_roomLevel][freeTable].playersNow == 10) {
    //                 allTables[_roomLevel][freeTable].status = 1;
    //                 allTables[_roomLevel][freeTable]
    //                     .currentGameStartedAt = block.timestamp;
    //                 allTables[_roomLevel][freeTable].lastGameFinishedAt = 0;
    //                 // Reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }
    //         }
    //     }
    }

    function setBaseGameDuration(uint256 _newTime) public {
        baseGameDuration = _newTime;
    }

    // function getPlayingTokenIdsInRoomForPlayer(
    //     uint8 _roomLevel,
    //     address _player
    // ) public view returns (uint256[] memory) {
    //     uint256[] memory tempResults = new uint256[](
    //         viewAmountTablesInRoom(_roomLevel)
    //     );
    //     uint256 counter;

    //     // i - итерация по столам
    //     for (uint256 i = 0; i < viewAmountTablesInRoom(_roomLevel); i++) {
    //         Table storage currentTable = allTables[_roomLevel][i];

    //         for (uint256 c = 0; c < currentTable.playersNow; c++) {
    //             if (
    //                 Collection.ownerOf(currentTable.playingTokenIds[c]) ==
    //                 _player
    //             ) {
    //                 tempResults[counter] = currentTable.playingTokenIds[c];
    //                 counter++;
    //             }
    //         }
    //     }
    //     return tempResults;
    // }

    // function pushSuitsInTable(
    //     // в другой контракт возможно
    //     uint8 _roomLevel,
    //     uint256 _table,
    //     uint256 _tokenId
    // ) public {
    //     // прописывание очков комбинаций
    //     Table storage currentTable = allTables[_roomLevel][_table];

    //     if (getValue1(_tokenId).length == 0) {
    //         currentTable.playingSuits[0] += 1; // пики
    //     }

    //     if (
    //         getValue2(_tokenId) ==
    //         0xa766932420cc6e9072394bef2c036ad8972c44696fee29397bd5e2c06001f615
    //     ) {
    //         currentTable.playingSuits[1] += 1; // hearts (red)
    //     }

    //     if (
    //         getValue2(_tokenId) ==
    //         0xf1918e8562236eb17adc8502332f4c9c82bc14e19bfc0aa10ab674ff75b3d2f3
    //     ) {
    //         currentTable.playingSuits[2] += 1; // diamonds (red)
    //     }

    //     if (
    //         getValue2(_tokenId) ==
    //         0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2
    //     ) {
    //         currentTable.playingSuits[3] += 1; //clubs (black)
    //     }
    // }

    //генезис холдер не может выйти из блекрума раньше остальных

    modifier isPlayerInGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) {
        Table storage currentTable = allTables[_roomLevel][_table];
        for (uint256 k = 0; k < _tokenIds.length; k++) {
            require(
                Collection.ownerOf(_tokenIds[k]) == msg.sender,
                "you re not owner for this token"
            );
        } //должен давать
        require(
            currentTable.status != 1,
            "Game is going now"
        );

        //добавить что то еще
        _;
    }

    function setTrump(uint256 _value) public {
        trump = _value;
    }


    
            function leaveGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) public {
        helper.leaveGame(_roomLevel, _table, _tokenIds);
    }
    


    // так же нужно и для обычных столов



 
      function leaveBlackTable(
        uint256[] calldata _tokenIds
    ) public  {

        helper.leaveBlackTable(_tokenIds);


    }

    function getRandomSuit(uint256 salt) public view returns (uint256) {

        return helper.getRandomSuit(salt);

        // return
        //     (uint256(
        //         keccak256(
        //             abi.encodePacked(
        //                 block.timestamp,
        //                 blockhash(block.number),
        //                 msg.sender,
        //                 salt
        //             )
        //         )
        //     ) % 3) + 1; //
    }

    //possible values
    // 0 - spades
    // 1 - hearts
    // 2 = diamonds
    // 3 = clubs

    function getIndexOfPlayerInBlackRoom(address _player)
        public
        view
        returns (uint256)
    {
                


        for (uint256 i = 0; i < blackTable.players.length; i++) {
            if (blackTable.players[i] == _player) {
                return i;
            }
        }

        revert("not player");
    }

    // function getIndexOfPlayerInBlackRoom1(uint i) public view returns(address) {

    //             Table storage currentTable = allTables[1][0];

    //         return currentTable.players[i];

    // }

    // function getIndexOfPlayerInBlackRoom2(uint i, address _player) public view returns(bool) {

    //                Table storage currentTable = allTables[1][0];

    //                 if(currentTable.players[i] == _player) {
    //                 return true;
    //                 }
    //                 return false;

    // }

    //6 токенов в 24 часа
    // 1 токен в 4 часа
    // 1 токен в 14400 секунд
    function calculateStakingRewardsInBlackRoom(

    ) public view returns (uint256) {
        

        uint256 reward = ((blackTable.lastGameFinishedAt -
            blackTable.playersTimeMarks[
                getIndexOfPlayerInBlackRoom(msg.sender)
            ]) / blackTable.stakingRate);
        return reward;
    }

    // function estimateStakingRewardsInBlackRoom(
  
    //     address _player
    // ) public view returns (uint256) {
        



    // //     // на каждый timeMark делаем исчисление
    //    uint256[] memory tempIndexes = getIndexesOfPlayerInBlackRoom(_player);
    //     uint totalReward;
        

    //         console.log(tempIndexes.length, "length");
    // for (uint i = 0; i < tempIndexes.length ; i++)  {
    //     console.log(i,"current i");
    //       uint256 reward = ((blackTable.lastGameFinishedAt -
    //         blackTable.playersTimeMarks[tempIndexes[i]]) / blackTable.stakingRate);
    //         totalReward += reward;

    //         console.log("reward");
    //         console.log(reward);
        
     
    // }
  
    // return totalReward;

      
    



    // }




    function estimateStakingRewardsInBlackRoom(
  
        address _player
    ) public view returns (uint256) {
        



    //     // на каждый timeMark делаем исчисление
       uint256[] memory tempIndexes = getIndexesOfPlayerInBlackRoom(_player);
        uint totalReward;
        

            console.log(tempIndexes.length, "length");
    for (uint i = 0; i < tempIndexes.length ; i++)  {
        console.log(i,"current i");
          uint256 reward = ((block.timestamp -
            blackTable.playersTimeMarks[tempIndexes[i]]) / blackTable.stakingRate);
            totalReward += reward;

            console.log("reward");
            console.log(reward);
        
     
    }
  
    return totalReward;

      
    



    }



    function getActiveTablesForRoom(uint8 _roomLevel)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory results = new uint256[](
            viewAmountTablesInRoom(_roomLevel)
        );
        uint256 counter;

        for (uint256 i = 0; i < viewAmountTablesInRoom(_roomLevel); i++) {
            //итерация по всем столам в руме
            Table storage currentTable = allTables[_roomLevel][i];

            for (uint256 c = 0; c < currentTable.playersNow; c++) {
                if (currentTable.playingTokenIds[c] != 0) {
                    results[counter] = i;
                    counter++;
                }
            }
        }

        return results;
    }

    function generateRandomWinnerIndexInBlackRoom(uint256 salt)
        public
        view
        returns (uint256)
    {
        return helper.generateRandomWinnerIndexInBlackRoom(salt);
    }

    function returnTimesPlayerInBlackRoom(address _player) public view returns(uint){

        uint counter;

        for (uint256 i = 0; i < blackTable.players.length; i++) {
          
            if (blackTable.players[i] == _player) {
                counter++;
             
            }
            
        }

        return counter;
    }

   
    function getIndexesOfPlayerInBlackRoom(address _player)
        public
        view
        returns (uint256[] memory)
    {
        console.log("getIndexesOfPlayerInBlackRoom");

        uint256[] memory tempIndexes = new uint256[](returnTimesPlayerInBlackRoom(_player));

        uint counter;
        for (uint256 i = 0; i < blackTable.players.length; i++) {
            if (blackTable.players[i] == _player) {
                tempIndexes[counter] = i;
                console.log(i);
                counter++;
            }
        }
                console.log("getIndexesOfPlayerInBlackRoom finish");


        return tempIndexes;

    }

    

     
    function claimStakingTokensFromBlackRoom() public {
        helper2.claimStakingTokensFromBlackRoom();
        
        // раффл должен произойти,
        

      
    }



    function checkInMemoryArray(uint256[] memory tempArr, uint256 _currentIndex) public view returns(bool) {

            // for (uint i = 0; i < tempArr.length; i++)

            // {
            //     if(_currentIndex == tempArr[i]) {
            //         return false;
            //     }
            
            // }
            // return true;

            return helper.checkInMemoryArray(tempArr,  _currentIndex);
    }

    function getAmountWinnersToPayoutinBlackRoom() public view returns(uint) {
        return blackTable.amountWinnersToPayout;
    }
      function getPlayersNowInBlackRoom() public view returns(uint) {
        return blackTable.playersNow;
    }
    


    // function generateWinnersForBlackRoom(uint256 _salt) public view returns(uint256[] memory) {
    //     //                 uint256[] memory tempWinners = new uint256[](blackTable.amountWinnersToPayout);
    //     //         uint counter;


    //     //             for (uint i = 0; i < blackTable.amountWinnersToPayout; i++) 
    //     //             {
    //     //                  uint256 currentWinnerIndex =  (uint256(
    //     //         keccak256(
    //     //             abi.encodePacked(
    //     //                 block.timestamp,
    //     //                 blockhash(block.number),
    //     //                 msg.sender,
    //     //                 _salt
    //     //             )
    //     //         )
    //     //     ) % blackTable.playersNow);



    //     // _salt += 1231617; // Увеличение соли для следующего вызова

    //     // if (!checkInMemoryArray(tempWinners,currentWinnerIndex)) {
    //     //     // Если число уже сгенерировано, генерируем новое
    //     //     generateWinnersForBlackRoom(_salt);
    //     //     console.log("already was generated");
    //     // } else {
    //     //     // Добавляем число в массив и отмечаем его как сгенерированное
    //     //     tempWinners[counter] = currentWinnerIndex;
    //     //     counter++;
    //     //                 console.log("pushing");

    //     //     // isWinnerChosen[currentWinnerIndex] = true;
    //     // }
                        
    //     //             }




       

    //     // return tempWinners;

    //     return helper.generateWinnersForBlackRoom(_salt);
    // }

    function getBlackTableReadyToClaimAt() public view returns(uint) {
        return blackTable.readyToClaimAt;
    }

    
    function getBlackTableTimeUntilRaffleExecution() public view returns(uint) {
        return blackTable.timeUntilRaffleExecution;
    }

     function getBlackTableAmountWinnersToPayout() public view returns(uint) {
        return blackTable.amountWinnersToPayout;
    }
    
    function getBlackTablePrizeRadioChoice() public view returns(uint) {
        return prizeRadioChoice;
    }

    function setIsMintPass(uint _tokenId,  bool _value) public {
        isMintPass[_tokenId] = _value;
    }
    
    function setBlackTableLastGameFinishedAt(uint _value) public {
        blackTable.lastGameFinishedAt = _value;
    }

    function getBlackTableLastGameFinishedAt() public view returns(uint) {
        return blackTable.lastGameFinishedAt;
    }

    function incrBlackTableSerialNumber() public {
        blackTable.serialNumber++;
    }

    function viewHelper1() public view returns(address) {
        return address(helper1);
    }

     function viewHelper() public view returns(address) {
        return address(helper);
    }

    function setStatusinBlack(uint256 _value) public {
        blackTable.status = _value;
    }
    

    
    
    event blackRoomClaimedPrizeMintPass(address[] tempWinners, uint256[] tempInvolvedTokenIds, uint256 prizeRadioChoice);        
    event blackRoomClaimedPrizeRaffleToken(address[] tempWinners, uint256 value , uint256 prizeRadioChoice);        
    event blackRoomClaimedPrizeRaffleNFT(address indexed winner, uint256 indexed tokenId, uint256 prizeRadioChoice);        
    // event blackRoomClaimedPrizeRaffleToken(uint256 _payvalue);        

        // нужно изменять соль внутри функции, а то одинаковые значения выбиваются
    function claimBlackRoom(uint _salt) public  {

        helper1.claimBlackRoomForPlayer(_salt);
    //      // первый стол первого рума


        
            

    //     require(block.timestamp >= blackTable.readyToClaimAt + blackTable.timeUntilRaffleExecution, "try later");
        
    //     require(blackTable.status != 4, "raffle already happened");



    //     //сделать проверку что время игры истекло





    //             // uint256[] memory tempIndexes = new uint256[](blackTable.amountWinnersToPayout);
    //  uint256[] memory tempWinners = generateWinnersForBlackRoom(_salt);

    //      address[] memory tempWinnersAddresses = new address[](tempWinners.length);

    //              for (uint256 o = 0; o < tempWinners.length; o++) {
    //                 tempWinnersAddresses[o] = getBlackTablePlayerByIndex(tempWinners[o]);
                    
    //              }
     
    //  uint256[] memory tempInvoldevTokenids = new uint256[](blackTable.amountWinnersToPayout);

    //         // uint salt = _salt;
    //     // Механики по выигрышу

    //     for (uint256 i = 0; i < blackTable.players.length; i++) {
    //                         Collection.setIsCommon(blackTable.playingTokenIds[i], true);

            
    //     }

    //     if (prizeRadioChoice == 1) {
    //         //ПРЕВРАЩЕНИЕ В MINT PASS


    //                 // идет количество итераций равное количество игроков для выигрыша, например у нас стояло количество победителей 3 и даже если игрок один мы делаем 3 прохода и достаем 3 одинаковых индекса игрока ( а вот это странно потому что индексы должны быть разные)
    //         for (uint256 i = 0; i < tempWinners.length; i++) {
            

    //             isMintPass[
    //                 blackTable.playingTokenIds[tempWinners[i]]
    //             ] = true; // юзер владеет этим токеном и нам не нужно больше ничего менять
    //             //     //можем передавать свойство токену таким образом потому что каждый слот отведен под игрока и соответствующий tokenID поменяется у нужного игрока

                     
    //              Collection.setNotTransferable(
    //                 blackTable.playingTokenIds[tempWinners[i]],
    //                 false
    //             );
                
    //               // размораживаем нфт токен при клейме стола
    //             tempInvoldevTokenids[i] = blackTable.playingTokenIds[tempWinners[i]];

    //             // добавить строку в функцию tokenURI для отображения минт пассов
    //         }

    //         //превращение токенов в минт пассы phase


    //             // получение адресов tempWinners

             


    //         emit blackRoomClaimedPrizeMintPass(tempWinnersAddresses, tempInvoldevTokenids, prizeRadioChoice);
    //     }

    //     if (prizeRadioChoice == 2) {
    //         //РОЗЫГРЫШ КАКИХ ТО ТОКЕНОВ ( ПЕРЕД ВЫДАЧЕЙ ТОКЕНОВ ВВЕСТИ АДРЕС КОНТРАКТА ТОКЕНА КОТОРЫЙ РАССЫЛАЕТСЯ И ПО СКОЛЬКО РАССЫЛАТЬ)
    //         uint256 value;
    //         for (uint256 i = 0; i < tempWinners.length; i++) {

    //              value = 1000;
    //             // uint256 currentWinnerIndex = generateRandomWinnerIndex(5341531); //генерирует индекс игрока ( кстати в playerCard можно использовать вложеннный маппинг и тогда игрокам давать порядковые индексы от единицы)
    //             // tempWinners[i] = currentWinnerIndex; // вставляем сгенерированный индекс в темп массив победителей

    //             sendRaffleTokens(blackTable.players[tempWinners[i]], value); // изменить число
    //             console.log("tokens are gone!");
    //             // тут сделать ивенты и вообще везде сделать ивенты

    //             //розыгрыш токенов phase
    //         }

    //         emit blackRoomClaimedPrizeRaffleToken(tempWinnersAddresses,value,prizeRadioChoice);
    //     }



    //         if (prizeRadioChoice == 3) {
    //             //розыгрыш дорогой нфтшки

    //             uint256 indexWinner = generateRandomWinnerIndexInBlackRoom(54354);
    //             uint tokenId = 1;


    //                     sendRaffleNFTToWinner(blackTable.players[indexWinner], tokenId); 
    //             console.log("allgood");
    //             // указать токен id которым владеет смарт контракт либо отдельно его затесапить при трансфере токена на контракт

    //             //Трансфер нфтшки юзеру (она должна быть на контракте, наш контракт должен уметь принимать 721  токены)

    //             address winner = msg.sender;
    //             // либо можно взять повыше

    //             // delete tempWinners; // пробуем занулить значения удалив, если будет ревертиться нужно будет по другому очищать массив, либо
    //             // сделать функцию фиктивного наполнения

    //             emit blackRoomClaimedPrizeRaffleNFT(winner, tokenId, prizeRadioChoice);
    //         }

    //         // сжечь токены проигравших
    //         console.log(blackTable.players.length);
    //         console.log(tempWinners.length);
    //         console.log(tempWinners[0]);
    //         console.log(tempWinners[1]);
    //         console.log(tempWinners[2]);

    //         for (uint256 i = 0; i < blackTable.players.length; i++) {

    //             if(prizeRadioChoice == 3) {
    //                 Collection.burn(blackTable.playingTokenIds[i]); // сжигание нфт токена каждого проигравшего
    //                     console.log(blackTable.playingTokenIds[i]);
    //                     console.log("was burned");

    //             }

    //             // console.log("i");
    //             // for (uint256 k = 0; k < tempWinners.length; k++) {
    //             //     if (i == tempWinners[k] || (prizeRadioChoice == 3)) {
    //             //         // к примеру первый элемент массива tempWinners это четверка
    //             //         // сделать console.log для тестирования
    //             //         console.log("get in something");
    //             //     } else {
    //             //         console.log("get outside something");
    //             //         Collection.burn(blackTable.playingTokenIds[i]); // сжигание нфт токена каждого проигравшего
    //             //         console.log(blackTable.playingTokenIds[i]);
    //             //         console.log("was burned");
    //             //     }
    //             // }
    //         }
    //         // сжигание токенов проигравших phase






            


    //         // currentAmountGamesFinished[1]++; // вот тут вопросик но можно не считать этот каунтер вообще
           

    //         // повышение времени рума в зависимости от количества сыгранных игр
            

    //         // разморозить нфтшки
    //         //повысить уровень нфтшек
    //         //сменить масти нфтшек
    //         // сделать их коммонками
    //         // изменить статус игры
    //         //прочие каунтеры

    //         // проверить сколько игр прошло

    //         //очистить массивы для новой игры
        
     
    //     //   задача: клеймить все available столы при клейме любого стола

    //         //     for (uint256 i = 0; i < blackTable.players.length; i++) {
    //         //     for (uint256 k = 0; i < tempWinners.length; k++) {
    //         //         if (i == tempWinners[k]) {
    //         //             // к примеру первый элемент массива tempWinners это четверка
    //         //             // сделать console.log для тестирования
    //         //         } else {
    //         //             Collection.burn(blackTable.playingTokenIds[i]); // сжигание нфт токена каждого проигравшего
    //         //         }
    //         //     }
    //         // }
    //         // сжигание токенов проигравших phase

        
    //         blackTable.lastGameFinishedAt = block.timestamp;
    //         blackTable.status = 4;
    //         blackTable.serialNumber++;

    }


    receive() external payable {}

    uint public refandRate = 93;

    function setRefundRate(uint _value) public {
        refandRate = _value;
    }

    
    function bulkCheckNotTransferable(uint256[] memory _tokenIds) public view returns (bool) {
         


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             
            if(Collection.viewNotTransferable(_tokenIds[i]) == true ) {
                return true;
            }

         }
       
        return false;
    }
    

    function refundYourNFT(uint256[] calldata _tokenIds) public {
        helper2.refundYourNFT(_tokenIds);
    }

    function isTableClaimReady(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (bool)
    {
        Table storage currentTable = allTables[_roomLevel][_table];
          require(currentTable.status == 1, "game is not going now");
// console.log("result");
        //   console.log(currentTable.currentGameStartedAt +
        
        //         currentRoomGameDuration[_roomLevel] -
        //         currentTable.internalGameReduction);        //   

        if (
            block.timestamp >=
            currentTable.currentGameStartedAt +
                currentRoomGameDuration[_roomLevel] -
                currentTable.internalGameReduction
        ) {
            //  console.log(currentTable.currentGameStartedAt +
            //     currentRoomGameDuration[_roomLevel] -
            //     currentTable.internalGameReduction);
            return true;
           
        } else {
            // console.log("start");
            // console.log(block.timestamp);
            // console.log(currentTable.currentGameStartedAt);
            // console.log(currentRoomGameDuration[_roomLevel]);
            // console.log(currentTable.internalGameReduction);
            //  console.log(currentTable.currentGameStartedAt +
            //     currentRoomGameDuration[_roomLevel] -
            //     currentTable.internalGameReduction);
            return false;
        }
    }


    
   
    // возвращает столы которые доступны к клейму
    // проверка по 205+ столам может быть довольно тяжелой и дорогой
    // а если чекать по 16 румам то это уже 3280+ элементов и только на итерацию
    function getTablesClaimReadyInRoom(uint8 _roomLevel)
        public
        view
        returns (uint256[] memory)
    {

            uint fulfilledTables;
        // возвращает индексы столов которые готовы к клейму
        // столы с нуля или единицы вродя с единицы тк маппинги
        uint256 amountTables = viewAmountTablesInRoom(_roomLevel);

        uint256[] memory tempTablesClaimReady = new uint256[](amountTables);

        for (uint256 i = 0; i < amountTables; i++) {
            Table storage currentTable = allTables[_roomLevel][i];
            if (
                (block.timestamp >=
                    currentTable.currentGameStartedAt +
                        currentRoomGameDuration[_roomLevel] -
                        currentTable.internalGameReduction) &&
                (currentTable.playersNow == 10)
            ) {
                tempTablesClaimReady[i] = i;
                fulfilledTables++;
            }

            if(fulfilledTables == 10) {
                break;
            }
        }


        return tempTablesClaimReady;

    }

    //except BlackRoom
    // function checkTablesClaimReadyForAllRooms()

    //     public
    //     view
    //     returns (uint256[] memory)
    // {
    //     // столы с нуля или единицы вродя с единицы тк маппинги

    //     uint256[] memory tempTablesClaimReady = new uint256[](3280);
    //     uint256 counter;
    //     for (uint8 k = 15; k <= 16; k++) {
    //         for (uint256 i = 0; i <= viewAmountTablesInRoom(k); i++) {
    //             Table storage currentTable = allTables[k][i];
    //             if (
    //                 block.timestamp >=
    //                 currentTable.currentGameStartedAt +
    //                     currentRoomGameDuration[k] -
    //                     currentTable.internalGameReduction
    //             ) {
    //                 tempTablesClaimReady[counter] = i;
    //                 counter++;
    //             }
    //         }
    //     }

    //     return tempTablesClaimReady;
    // }

    function isDoubleIncrNFTRoomLevel(uint256 salt) public view returns (bool) {
        uint256 value = (uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    blockhash(block.number),
                    msg.sender,
                    salt
                )
            )
        ) % 1000) + 1;
        // если попало в 5% шанс то увеличиваем второй раз NFTRoomLevel
        if (value <= 5) {
            return true;
        }
        return false;
    }

    function getGameDuration(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (uint256)
    {
        require(
            isTableInRoomExists(_roomLevel, _table),
            "couldnt find this table"
        );
        Table storage currentTable = allTables[_roomLevel][_table];

        return
            currentRoomGameDuration[_roomLevel] -
            currentTable.internalGameReduction;
    }

    function getTimeWhenTableIsClaimReady(uint8 _roomLevel, uint256 _table)
        public
        view
        returns (uint256)
    {
        require(
            isTableInRoomExists(_roomLevel, _table),
            "couldnt find this table"
        );

        Table storage currentTable = allTables[_roomLevel][_table];

        return
            currentTable.currentGameStartedAt +
            currentRoomGameDuration[_roomLevel] -
            currentTable.internalGameReduction;
    }

    function setGlobalLastGameFinishedAt(uint _value) public {
        globalLastGameFinishedAt = _value;
    }
    
    function viewGlobalLastGameFinishedAt() public view returns(uint256) {
        return globalLastGameFinishedAt;
    }
    

    function claimReadyTablesInRoom(uint8 _roomLevel, uint256 salt) public {
        uint256[] memory _tables = getTablesClaimReadyInRoom(_roomLevel);

        for (uint256 i = 0; i < _tables.length; i++) {
            if (i != 0) {
                if (_tables[i] == 0) {
                    break;
                }
            }
            console.log(_tables[i]);



            uint256 table = _tables[i];


            Table storage currentTable = allTables[_roomLevel][table];

        uint256 tempSalt;

        // internalGameReduction дефайнится во время того как стол собирается
        require(isTableClaimReady(_roomLevel, table), "try later"); // возможность заклеймить игру после currentRoomGameDuration
        //сделать проверку что время игры истекло

        require(currentTable.status == 1, "not playing now");

        for (uint256 c = 0; c < 10; c++) {
            Collection.setNotTransferable(
                currentTable.playingTokenIds[c],
                false
            ); // разморозка нфт для трансфера

            //5% шанс на двойное повышение румлевела нфт
            if ( isDoubleIncrNFTRoomLevel(tempSalt) && (_roomLevel != 1 || _roomLevel != 2 || _roomLevel != 3 || _roomLevel != 4)) {
                Collection.decrNFTRoomLevelForValue(
                    currentTable.playingTokenIds[c],
                    2
                );
            } else {
                Collection.decrNFTRoomLevelForValue(
                    currentTable.playingTokenIds[c],
                    1
                );
            }

            //смена масти для каждого токена

            uint256 newSuit = getRandomSuit(tempSalt);
            if (newSuit == 1) {
                Collection.setSuit(currentTable.playingTokenIds[c], "h");
            }

            if (newSuit == 2) {
                Collection.setSuit(currentTable.playingTokenIds[c], "d");
            }

            if (newSuit == 3) {
                Collection.setSuit(currentTable.playingTokenIds[c], "c");
            }
            ////

            delete currentTable.players[c]; // обратить внимание на выход генезис холдера
            delete currentTable.playingTokenIds[c]; // обратить внимание на выход генезис холдера
            tempSalt += 1227; // edit this number;
        }
        currentTable.currentGameStartedAt = 0; // обнуление старта игры (тк игра не ведется в данный момент)
        currentTable.internalGameReduction = 0; // обнуление комбинаций для следующего стола
        currentTable.lastGameFinishedAt = block.timestamp; // игра завершилась в ... (нужно для сверки coolDown)
        currentTable.status = 2;
        currentTable.serialNumber++;
        currentAmountGamesFinished[_roomLevel]++;
        trumpCounter++;

        //
        globalLastGameFinishedAt = block.timestamp;
        //

        currentTable.playersNow = 0;
        delete currentTable.playingSuits;

        // повышение времени рума в зависимости от количества сыгранных игр
        if (
            currentAmountGamesFinished[_roomLevel] ==
            amountGamesUntilIncrease

        ) {
            if (roomGameDurationIncreaseCounter[_roomLevel] <= 16) {
                currentRoomGameDuration[_roomLevel] += 1 minutes;
                roomGameDurationIncreaseCounter[_roomLevel]++;
            }

            // повышаем на час но тут нужен каунтер и счетчик повторный для 255 или что то такое

            currentAmountGamesFinished[_roomLevel] = 0; // но это может быть плохо для статистики
        }

        if (trumpCounter == amountGamesUntilNewTrump) {
            uint256 newSuit = getRandomSuit(salt);

            trump = newSuit; // добавить пики, а то вроде только 3 масти используются
            trumpCounter = 0;
        }

           
        }
    }

    uint public amountGamesUntilIncrease = 2;
    uint public amountGamesUntilNewTrump = 2;

    function setAmountGamesUntilIncrease(uint _value) public {
     amountGamesUntilIncrease = _value;
    }

     function setAmountGamesUntilNewTrump(uint _value) public {
     amountGamesUntilNewTrump = _value;
    }

        // МОЖЕТ ЗАРЕВЕРТИТЬСЯ ЕСЛИ ГЕНЕЗИС ВЫШЕЛ (ЗАМЕНИТЬ 10 В ИТЕРАЦИИ НА PLAYERSNOW)
    // вариант клейма для всех игроков стола
    function ClaimSingleGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256 salt
    ) public {
        Table storage currentTable = allTables[_roomLevel][_table];

        uint256 tempSalt;

        // internalGameReduction дефайнится во время того как стол собирается
        require(isTableClaimReady(_roomLevel, _table), "try later"); // возможность заклеймить игру после currentRoomGameDuration
        //сделать проверку что время игры истекло

        require(currentTable.status == 1, "not playing now");

        for (uint256 i = 0; i < 10; i++) {
            Collection.setNotTransferable(
                currentTable.playingTokenIds[i],
                false
            ); // разморозка нфт для трансфера
            Collection.setIsCommon(currentTable.playingTokenIds[i], true); // сет в коммонку после любой игры // возможно стоит добавить проверку является ли токен коммонкой уже

            //5% шанс на двойное повышение румлевела нфт
            if (isDoubleIncrNFTRoomLevel(tempSalt)) {
                Collection.decrNFTRoomLevelForValue(
                    currentTable.playingTokenIds[i],
                    2
                );
            } else {
                Collection.decrNFTRoomLevelForValue(
                    currentTable.playingTokenIds[i],
                    1
                );
            }

            //смена масти для каждого токена

            uint256 newSuit = getRandomSuit(tempSalt);
            if (newSuit == 1) {
                Collection.setSuit(currentTable.playingTokenIds[i], "h");
            }

            if (newSuit == 2) {
                Collection.setSuit(currentTable.playingTokenIds[i], "d");
            }

            if (newSuit == 3) {
                Collection.setSuit(currentTable.playingTokenIds[i], "c");
            }
            ////

            delete currentTable.players[i]; // обратить внимание на выход генезис холдера
            delete currentTable.playingTokenIds[i]; // обратить внимание на выход генезис холдера
            tempSalt += 1227; // edit this number;
        }
        currentTable.currentGameStartedAt = 0; // обнуление старта игры (тк игра не ведется в данный момент)
        currentTable.lastGameFinishedAt = block.timestamp; // игра завершилась в ... (нужно для сверки coolDown)
        currentTable.internalGameReduction = 0; // обнуляем эффект данный комбинациями для следующей игры
        currentTable.status = 2;
        currentTable.serialNumber++;
        currentAmountGamesFinished[_roomLevel]++;
        trumpCounter++;


        //
        globalLastGameFinishedAt = block.timestamp;
        //

        currentTable.playersNow = 0;
        delete currentTable.playingSuits;

        // повышение времени рума в зависимости от количества сыгранных игр
        if (
            currentAmountGamesFinished[_roomLevel] == amountGamesUntilIncrease
            // viewAmountTablesInRoom(_roomLevel) 
        ) {
            if (roomGameDurationIncreaseCounter[_roomLevel] <= 16) {
                currentRoomGameDuration[_roomLevel] += 1 minutes;
                roomGameDurationIncreaseCounter[_roomLevel]++;
            }

            // повышаем на час но тут нужен каунтер и счетчик повторный для 255 или что то такое

            currentAmountGamesFinished[_roomLevel] = 0; // но это может быть плохо для статистики
        }

        if (trumpCounter == amountGamesUntilNewTrump) {
            uint256 newSuit = helper.getRandomSuitForTrump(salt);

            trump = newSuit;
            trumpCounter = 0;
        }

 
    }

    //   можно не привязывать к конкретному столу а просто вызывать когда есть столы которые можно заклеймить
    // function BulkClaimTablesInRoom(uint8 _roomLevel, uint256 salt) public {
    //     uint256[] memory tablesClaimReady = getTablesClaimReadyInRoom(
    //         _roomLevel
    //     );

    //     //итерация по столам из результата функции
    //     for (uint256 t = 0; t < tablesClaimReady.length; t++) {
    //         uint256 tempTable = tablesClaimReady[t];

    //         // отдельный стол
    //         Table storage currentTable = allTables[_roomLevel][tempTable];

    //         // internalGameReduction дефайнится во время того как стол собирается
    //         require(
    //             block.timestamp >=
    //                 currentTable.currentGameStartedAt +
    //                     currentRoomGameDuration[_roomLevel] -
    //                     currentTable.internalGameReduction,
    //             "try later"
    //         ); // возможность заклеймить игру после currentRoomGameDuration
    //         //сделать проверку что время игры истекло

    //         for (uint256 i = 1; i <= currentTable.playersNow; i++) {
    //             Collection.setNotTransferable(
    //                 currentTable.playingTokenIds[i],
    //                 false
    //             ); // разморозка нфт для трансфера
    //             Collection.decrNFTRoomLevel(currentTable.playingTokenIds[i]); // но тут добавить рандомное повышение на 2 уровня а не на один и учесть что надо декрементировать а не инкрементировать
    //             Collection.setIsCommon(currentTable.playingTokenIds[i], true); //сделать все нфт коммон

    //             //смена масти

    //             uint256 newSuit = getRandomSuit(salt);
    //             if (newSuit == 1) {
    //                 Collection.setSuit(currentTable.playingTokenIds[i], "h");
    //             }

    //             if (newSuit == 2) {
    //                 Collection.setSuit(currentTable.playingTokenIds[i], "d");
    //             }

    //             if (newSuit == 3) {
    //                 Collection.setSuit(currentTable.playingTokenIds[i], "c");
    //             }
    //             ////

    //             delete currentTable.players[i]; // обратить внимание на выход генезис холдера
    //             delete currentTable.playingTokenIds[i]; // обратить внимание на выход генезис холдера
    //         }
    //         currentTable.currentGameStartedAt = 0; // обнуление старта игры (тк игра не ведется в данный момент)
    //         currentTable.lastGameFinishedAt = block.timestamp; // игра завершилась в ... (нужно для сверки coolDown)
    //         currentTable.status = Status.Cooldown;
    //         currentTable.serialNumber++;
    //         currentAmountGamesFinished[_roomLevel]++;
    //         trumpCounter++;

    //         currentTable.playersNow = 0;

    //         // повышение времени рума в зависимости от количества сыгранных игр
    //         if (
    //             currentAmountGamesFinished[_roomLevel] ==
    //             viewAmountTablesInRoom(_roomLevel)
    //         ) {
    //             require(
    //                 roomGameDurationIncreaseCounter[_roomLevel] <= 16,
    //                 "max time for room already in use"
    //             ); //оформить это не через require а то транза будет падать
    //             currentRoomGameDuration[_roomLevel] += 1 minutes;

    //             //

    //             // повышаем на час но тут нужен каунтер и счетчик повторный для 255 или что то такое

    //             currentAmountGamesFinished[_roomLevel] = 0; // но это может быть плохо для статистики
    //         }

    //         if (trumpCounter == 1000) {
    //             uint256 newSuit = getRandomSuit(salt);

    //             trump = newSuit; // добавить пики, а то вроде только 3 масти используются
    //             trumpCounter = 0;
    //         }

    //         // разморозить нфтшки
    //         //повысить уровень нфтшек
    //         //сменить масти нфтшек
    //         // сделать их коммонками
    //         // изменить статус игры
    //         //прочие каунтеры

    //         // проверить сколько игр прошло

    //         //очистить массивы для новой игры
    //     }
    // }

    //   можно не привязывать к конкретному столу а просто вызывать когда есть столы которые можно заклеймить

    //  переписать эту функцию
    // function checkPlayersGenesisCard(
    //     uint8 _roomLevel,
    //     uint256 _table,
    //     uint256 _tokenId
    // ) public view returns (bool) {
    //     //проверить что токен играет
    //     // проверить что токен генезис
    //     Table storage currentTable = allTables[_roomLevel][_table];

    //     for (uint256 i = 0; i < currentTable.playersNow; i++) {
    //         if (_tokenId == currentTable.playingTokenIds[i]) {
    //             if (!checkSomething()) { // checkSomething принимал tokenId
    //                 return true;
    //             }
    //         }
    //     }

    //     return false;
    // }

    // function checkSomething() public pure returns (bool) {
    //     return true;
    // }

    function viewAmountTablesInRoom(uint8 _roomLevel)
        public
        view
        returns (uint256)
    {
        return allTables[_roomLevel].length;
    }

 
    
    // function getCombo(uint8 _roomLevel, uint256 _table) public {
    //     Table memory currentTable = allTables[_roomLevel][_table];

    //            if(currentTable.playingSuits[0] == 10) {
    //                currentTable.internalGameReduction += 1 minutes;
    //            } else {
    //              console.log("not");
    //            }

    // }


    // function getTableInfoInRoom(uint8 _roomLevel, uint256 _table) public view returns(uint,uint8,uint256[4] memory,uint256,uint256,uint256,Status) {
    //     Table storage currentTable = allTables[_roomLevel][_table];
    //     return (currentTable.serialNumber,currentTable.playerNow,currentTable.playingSuits,currentTable.currentGameStartedAt,currentTable.lastGameFinishedAt,currentTable.internalGameReduction,currentTable.Status);
    // }


    ///////////////////////////////////////
}
