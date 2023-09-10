// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./IMintContract.sol";
import "./IGameContract.sol";
import "./console.sol";
import "./IHelper.sol";

contract Helper1 {
    IMintContract public Collection;
    IGameContract public GameContract;
    IHelper public helper;

    enum Status {
        // статусы для стола
        WaitingPlayers, //0
        Playing, //1
        Cooldown, //2
        ReadyToClaim, //3
        RaffleHappened // 4
    }

    struct blackTableStruct {
        uint256 serialNumber; // количество завершенных игр на конкретном столе
        uint8 playersNow;
        address[] players;
        uint256[] playingTokenIds;
        uint256[] playersTimeMarks;
        uint256 readyToClaimAt; // просто точка во времени когда началась игра для сверки require при клейме
        uint256 timeUntilRaffleExecution; // просто точка во времени когда началась игра для сверки require при начинании новой игры
        uint256 lastGameFinishedAt;
        uint256 stakingRate; // = 14400 // can be set over function
        uint256 amountPlayersUntilCurrentRaffle; // 15 for testing; can be set over function
        uint256 amountWinnersToPayout; // 3 for testing; (not for single nft raffle!)  can be set over function
        uint256 amountTokensForRaffle;
        Status status;

        // other GameContract.getBlackTable() Variables
    }

    constructor(address _collection) {
        Collection = IMintContract(_collection);
        initBlackTableWinners();
    }

    function setHelper(address _helper) public {
        helper = IHelper(_helper);
    }

    function setGameContract(address _GameContract) public {
        GameContract = IGameContract(_GameContract);
    }

    function returnSMH() public pure returns (uint256) {
        return 12;
    }

    event blackRoomClaimedPrizeMintPass(
        address[] tempWinnersAddresses,
        uint256[] tempInvolvedTokenIds,
        uint256 prizeRadioChoice
    );

    event UserClaimedPartBlackRoom(
        address _player,
        uint _value,
        uint _prizeRadioChoice
    );

    event blackRoomClaimedPrizeRaffleToken(
        address[] tempWinnersAddresses,
        uint256 value,
        uint256 prizeRadioChoice
    );
    event blackRoomClaimedPrizeRaffleNFT(
        address indexed winner,
        uint256 indexed tokenId,
        uint256 prizeRadioChoice
    );

    // function claimBlackRoom(uint256 _salt) public {
    //     require(
    //         block.timestamp >=
    //             GameContract.getBlackTableReadyToClaimAt() +
    //                 GameContract.getBlackTableTimeUntilRaffleExecution(),
    //         "try later"
    //     );

    //     require(
    //         GameContract.getBlackTableStatus() != 4,
    //         "raffle already happened"
    //     );

    //     //сделать проверку что время игры истекло

    //     // uint256[] memory tempIndexes = new uint256[](blackTable.amountWinnersToPayout);
    //     uint256[] memory tempWinners = helper.generateWinnersForBlackRoom(
    //         _salt
    //     );

    //     address[] memory tempWinnersAddresses = new address[](
    //         tempWinners.length
    //     );

    //     for (uint256 o = 0; o < tempWinners.length; o++) {
    //         tempWinnersAddresses[o] = GameContract.getBlackTablePlayerByIndex(
    //             tempWinners[o]
    //         );
    //     }

    //     uint256[] memory tempInvolvedTokenIds = new uint256[](
    //         GameContract.getBlackTableAmountWinnersToPayout()
    //     );

    //     // uint salt = _salt;
    //     // Механики по выигрышу

    //     for (
    //         uint256 i = 0;
    //         i < GameContract.getBlackTablePlayersLength();
    //         i++
    //     ) {
    //         Collection.setIsCommon(
    //             GameContract.getBlackTablePlayingTokenIdByIndex(i),
    //             true
    //         );
    //     }

    //     if (GameContract.getBlackTablePrizeRadioChoice() == 1) {
    //         //ПРЕВРАЩЕНИЕ В MINT PASS

    //         // идет количество итераций равное количество игроков для выигрыша, например у нас стояло количество победителей 3 и даже если игрок один мы делаем 3 прохода и достаем 3 одинаковых индекса игрока ( а вот это странно потому что индексы должны быть разные)
    //         for (uint256 i = 0; i < tempWinners.length; i++) {
    //             // isMintPass[
    //             //     blackTable.playingTokenIds[tempWinners[i]]
    //             // ] = true;

    //             GameContract.setIsMintPass(
    //                 GameContract.getBlackTablePlayingTokenIdByIndex(
    //                     tempWinners[i]
    //                 ),
    //                 true
    //             );
    //             // юзер владеет этим токеном и нам не нужно больше ничего менять
    //             //     //можем передавать свойство токену таким образом потому что каждый слот отведен под игрока и соответствующий tokenID поменяется у нужного игрока

    //             Collection.setNotTransferable(
    //                 GameContract.getBlackTablePlayingTokenIdByIndex(
    //                     tempWinners[i]
    //                 ),
    //                 false
    //             );

    //             // размораживаем нфт токен при клейме стола
    //             tempInvolvedTokenIds[i] = GameContract
    //                 .getBlackTablePlayingTokenIdByIndex(tempWinners[i]);

    //             // добавить строку в функцию tokenURI для отображения минт пассов
    //         }

    //         //превращение токенов в минт пассы phase

    //         // получение адресов tempWinners

    //         // emit blackRoomClaimedPrizeMintPass(
    //         //     tempWinnersAddresses,
    //         //     tempInvolvedTokenIds,
    //         //     GameContract.getBlackTablePrizeRadioChoice()
    //         // );
    //     }

    //     if (GameContract.getBlackTablePrizeRadioChoice() == 2) {
    //         //РОЗЫГРЫШ КАКИХ ТО ТОКЕНОВ ( ПЕРЕД ВЫДАЧЕЙ ТОКЕНОВ ВВЕСТИ АДРЕС КОНТРАКТА ТОКЕНА КОТОРЫЙ РАССЫЛАЕТСЯ И ПО СКОЛЬКО РАССЫЛАТЬ)
    //         uint256 value;
    //         for (uint256 i = 0; i < tempWinners.length; i++) {
    //             value = 1000;
    //             // uint256 currentWinnerIndex = generateRandomWinnerIndex(5341531); //генерирует индекс игрока ( кстати в playerCard можно использовать вложеннный маппинг и тогда игрокам давать порядковые индексы от единицы)
    //             // tempWinners[i] = currentWinnerIndex; // вставляем сгенерированный индекс в темп массив победителей

    //             GameContract.sendRaffleTokens(
    //                 GameContract.getBlackTablePlayerByIndex(tempWinners[i]),
    //                 value
    //             ); // изменить число
    //             console.log("tokens are gone!");
    //             // тут сделать ивенты и вообще везде сделать ивенты

    //             //розыгрыш токенов phase
    //         }

    //         emit blackRoomClaimedPrizeRaffleToken(
    //             tempWinnersAddresses,
    //             value,
    //             GameContract.getBlackTablePrizeRadioChoice()
    //         );
    //     }

    //     if (GameContract.getBlackTablePrizeRadioChoice() == 3) {
    //         //розыгрыш дорогой нфтшки

    //         uint256 indexWinner = helper.generateRandomWinnerIndexInBlackRoom(
    //             54354
    //         );
    //         uint256 tokenId = 1;

    //         GameContract.sendRaffleNFTToWinner(
    //             GameContract.getBlackTablePlayerByIndex(indexWinner),
    //             tokenId
    //         );
    //         console.log("allgood");
    //         // указать токен id которым владеет смарт контракт либо отдельно его затесапить при трансфере токена на контракт

    //         //Трансфер нфтшки юзеру (она должна быть на контракте, наш контракт должен уметь принимать 721  токены)

    //         address winner = msg.sender;
    //         // либо можно взять повыше

    //         // delete tempWinners; // пробуем занулить значения удалив, если будет ревертиться нужно будет по другому очищать массив, либо
    //         // сделать функцию фиктивного наполнения

    //         emit blackRoomClaimedPrizeRaffleNFT(
    //             winner,
    //             tokenId,
    //             GameContract.getBlackTablePrizeRadioChoice()
    //         );
    //     }

    //     // сжечь токены проигравших
    //     // console.log(blackTable.players.length);
    //     // console.log(tempWinners.length);
    //     // console.log(tempWinners[0]);
    //     // console.log(tempWinners[1]);
    //     // console.log(tempWinners[2]);

    //     for (
    //         uint256 i = 0;
    //         i < GameContract.getBlackTablePlayersLength();
    //         i++
    //     ) {
    //         if (GameContract.getBlackTablePrizeRadioChoice() == 3) {
    //             Collection.burn(
    //                 GameContract.getBlackTablePlayingTokenIdByIndex(i)
    //             ); // сжигание нфт токена каждого проигравшего
    //             // console.log(blackTable.playingTokenIds[i]);
    //             // console.log("was burned");
    //         }

    //         // console.log("i");
    //         // for (uint256 k = 0; k < tempWinners.length; k++) {
    //         //     if (i == tempWinners[k] || (prizeRadioChoice == 3)) {
    //         //         // к примеру первый элемент массива tempWinners это четверка
    //         //         // сделать console.log для тестирования
    //         //         console.log("get in something");
    //         //     } else {
    //         //         console.log("get outside something");
    //         //         Collection.burn(blackTable.playingTokenIds[i]); // сжигание нфт токена каждого проигравшего
    //         //         console.log(blackTable.playingTokenIds[i]);
    //         //         console.log("was burned");
    //         //     }
    //         // }
    //     }
    //     // сжигание токенов проигравших phase

    //     // currentAmountGamesFinished[1]++; // вот тут вопросик но можно не считать этот каунтер вообще

    //     // повышение времени рума в зависимости от количества сыгранных игр

    //     // разморозить нфтшки
    //     //повысить уровень нфтшек
    //     //сменить масти нфтшек
    //     // сделать их коммонками
    //     // изменить статус игры
    //     //прочие каунтеры

    //     // проверить сколько игр прошло

    //     //очистить массивы для новой игры

    //     //   задача: клеймить все available столы при клейме любого стола

    //     //     for (uint256 i = 0; i < blackTable.players.length; i++) {
    //     //     for (uint256 k = 0; i < tempWinners.length; k++) {
    //     //         if (i == tempWinners[k]) {
    //     //             // к примеру первый элемент массива tempWinners это четверка
    //     //             // сделать console.log для тестирования
    //     //         } else {
    //     //             Collection.burn(blackTable.playingTokenIds[i]); // сжигание нфт токена каждого проигравшего
    //     //         }
    //     //     }
    //     // }
    //     // сжигание токенов проигравших phase

   

    //     // blackTable.lastGameFinishedAt = block.timestamp;
    //     // blackTable.status = 4;
    //     // blackTable.serialNumber++;
    // }



        function findValueInArray(uint256 _value, uint256[] memory _verifiableArray) public pure returns(uint256) {

                                    for (uint256 i = 0; i < _verifiableArray.length; i++) {

                                        if(_verifiableArray[i] == _value) {
                                            return _value;
                                        }


                                    }
                                    return 17;

        
    }


            function isValueInArray(uint256 _value, uint256[] memory _verifiableArray) public pure returns(bool) {

                                    for (uint256 i = 0; i < _verifiableArray.length; i++) {

                                        if(_verifiableArray[i] == _value) {
                                            return true;
                                        }


                                    }
                                    return false;

        
    }


    struct blackTableWinnersInfo {
        uint256[] tempWinners;
        uint256[] tempInvolvedTokenIds;
        address[] tempWinnersAddresses;
    }




    mapping(uint256 => blackTableWinnersInfo) blackTableWinners;
    mapping(address => bool) public blackTableClaimed;

    event blackRoomWinnersDetermined(
          uint256[] tempWinners,
        address[] tempWinnersAddresses,
        uint256[] tempInvolvedTokenIds
    );


       



    function getBlackTableWinnersInfo()
        public
        view
        returns (blackTableWinnersInfo memory)
    {
        return blackTableWinners[0];
    }

        function getBlackTableWinnersInfoOne()
        public
        view
        returns (uint)
    {
        return blackTableWinners[0].tempWinners.length;
    }

        function getBlackTableWinnersInfoWinners()
        public
        view
        returns (uint256[] memory)
    {
        return blackTableWinners[0].tempWinners;
    }


            function getBlackTableWinnersInfoTempInvolvedTokenIds()
        public
        view
        returns (uint256[] memory)
    {
        return blackTableWinners[0].tempInvolvedTokenIds;
    }



    function getBlackTableWinnersInfoWinnersByPlaces()
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory res = new uint256[](blackTableWinners[0].tempWinners.length);

        for (uint256 index = 0; index < blackTableWinners[0].tempWinners.length; index++) {

                res[index] = blackTableWinners[0].tempWinners[index] + 1;
            
        }
        return res;
            }


    function initBlackTableWinners() public {

         uint256[] memory emptyTempWinners;
        address[] memory emptyTempWinnersAddresses;
        uint256[] memory emptyTempInvolvedTokenIds;


        blackTableWinners[0].tempWinners = emptyTempWinners;
        blackTableWinners[0].tempWinnersAddresses = emptyTempWinnersAddresses;
        blackTableWinners[0].tempInvolvedTokenIds = emptyTempInvolvedTokenIds;


    }

    function generateWinnersForBlackRoom(uint256 _salt) public {
        blackTableWinners[0].tempWinners = helper.generateWinnersForBlackRoom(
            _salt
        );

        ////

        address[] memory tempWinnersAddresses = new address[](
            GameContract.getBlackTableAmountWinnersToPayout()
        );

        for (
            uint256 o = 0;
            o < GameContract.getBlackTableAmountWinnersToPayout();
            o++
        ) {
            tempWinnersAddresses[o] = GameContract.getBlackTablePlayerByIndex(
                blackTableWinners[0].tempWinners[o]
            );
        }

        blackTableWinners[0].tempWinnersAddresses = tempWinnersAddresses;

        /////

        uint256[] memory tempInvolvedTokenIds = new uint256[](
            GameContract.getBlackTableAmountWinnersToPayout()
        );

        for (
            uint256 g = 0;
            g < GameContract.getBlackTableAmountWinnersToPayout();
            g++
        ) {
            tempInvolvedTokenIds[g] = GameContract
                .getBlackTablePlayingTokenIdByIndex(
                    blackTableWinners[0].tempWinners[g]
                );
        }

        blackTableWinners[0].tempInvolvedTokenIds = tempInvolvedTokenIds;

             GameContract.setBlackTableLastGameFinishedAt(block.timestamp);
        GameContract.setBlackTableStatus(4);
        GameContract.incrBlackTableSerialNumber();

        emit blackRoomWinnersDetermined(
            blackTableWinners[0].tempWinners,
            blackTableWinners[0].tempWinnersAddresses,
            blackTableWinners[0].tempInvolvedTokenIds

        );




    }

    bool public wasDetermined;

    function globalDeterminationBlackTable(uint256 _salt) public {
       if(!wasDetermined) {
               // генерация виннеров / проставление коммонок / сжигание всех чойсов

        // check 1st element of array if it is exists
        if (blackTableWinners[0].tempWinners.length == 0) {
            console.log("get in generate");

            generateWinnersForBlackRoom(_salt);
            
                     // сетап в коммонки всех токенов (имеет ли смысл если их все равно сжигать?)
        for (
            uint256 i = 0;
            i < GameContract.getBlackTablePlayersLength();
            i++
        ) {
            Collection.setIsCommon(
                GameContract.getBlackTablePlayingTokenIdByIndex(i),
                true
            );
        }


        /// СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ
        // СЖИШАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ СЖИГАНИЕ ТОКЕНОВ ПРОИГРАВШИХ


            //   бред какой то сверять по k, нужно сверять по isValueInArray

            if(GameContract.getBlackTablePrizeRadioChoice() == 1) {
            for (uint256 k = 0; k < GameContract.getBlackTablePlayersLength(); k++) {

                        // распределение по виннерам
                if (isValueInArray(GameContract.getBlackTablePlayingTokenIdByIndex(k), blackTableWinners[0].tempInvolvedTokenIds)) {

                    console.log("we are not burning winner", GameContract.getBlackTablePlayingTokenIdByIndex(k));

                }
                    
                    // к примеру первый элемент массива tempWinners это четверка
                    // сделать console.log для тестирования
                 else {
                             Collection.setNotTransferable(
                           GameContract.getBlackTablePlayingTokenIdByIndex(k), false); // does it matter? да и вообще стоит ли это делать

                    Collection._claimBurn(GameContract.getBlackTablePlayingTokenIdByIndex(k)); // сжигание нфт токена каждого проигравшего
                    console.log(GameContract.getBlackTablePlayingTokenIdByIndex(k),"was burned loser");
                    
                }
            }
            }

            /////





        if ( GameContract.getBlackTablePrizeRadioChoice() == 2 || GameContract.getBlackTablePrizeRadioChoice() == 3 ) {


          // сжигание второго и третьего чойса
        for ( uint256 i = 0; i < GameContract.getBlackTablePlayersLength(); i++) {

                    // просто не сжигаем индекс виннера для третьего чойса?
                if (isValueInArray(i, blackTableWinners[0].tempWinners) && GameContract.getBlackTablePrizeRadioChoice() == 3 ) {



                    console.log("REGISTERED WINNER IN 3TH CHOICE");
                        // виннера не сжигаем только для третьего чойса
                        
                } else {
                    console.log("get in else");
                Collection._claimBurn(
                    GameContract.getBlackTablePlayingTokenIdByIndex(i)
                ); 
                console.log("BURNING BY 2ND OR 3TH CHOICE is ", GameContract.getBlackTablePlayingTokenIdByIndex(i));

                }


            }

       
        }

        }

            // transform tokens for 1st 
        if(GameContract.getBlackTablePrizeRadioChoice() == 1) {

        for (uint256 o = 0; o < blackTableWinners[0].tempWinners.length; o++)
         {


                         //transform in mintpass
                       GameContract.setIsMintPass(
                           GameContract.getBlackTablePlayingTokenIdByIndex(blackTableWinners[0].tempWinners[o]), true
                    );
                           GameContract.setIsMintPass(
                           GameContract.getBlackTablePlayingTokenIdByIndex(blackTableWinners[0].tempWinners[o]), true
                    );
                    
                        // лишнее действие? Так как они сжигаются + сжигаются они до и это может дать ошибку
                        // сжигания несуществующего токена
                        // unfreeze token
                Collection.setNotTransferable(
                           GameContract.getBlackTablePlayingTokenIdByIndex(blackTableWinners[0].tempWinners[o]), false);



                    console.log("transform", blackTableWinners[0].tempWinners[o]);
                    
        }
        }

        wasDetermined = true;

       } 
        

    }





      function claimBlackRoomForPlayer(uint256 _salt) public {
        require(
            block.timestamp >=
                GameContract.getBlackTableReadyToClaimAt() +
                    GameContract.getBlackTableTimeUntilRaffleExecution(),
            "try later"
        );
        // только по времени получается сверяем или ниже добавить двойное условие какое то?

            // не работает?



        globalDeterminationBlackTable(_salt);



     

        // get indexes of player in black room ( на случай того что игрок зашел несколькими картами)

                                                                        //msg.sender or tx.origin
        uint256[] memory playerIndexes = GameContract.getIndexesOfPlayerInBlackRoom(tx.origin);
        console.log(playerIndexes.length, " is playerIndexes length");
        console.log(playerIndexes[0], "is first element of playerIndexes");
        


                            //превращение токенов в минт пассы phase



                            // сделать итерацию по индексам игрока
                            // если какой то его индекс в победителях - превратить его в минт пасс, остальное сжечь
                            // и удалять записи об индексах из стракта блектейбла
        if (GameContract.getBlackTablePrizeRadioChoice() == 1) {
                console.log("here trying claim staking tokens");
            GameContract.claimStakingTokensFromBlackRoom();

            //ПРЕВРАЩЕНИЕ В MINT PASS
            // идет количество итераций равное количество игроков для выигрыша, 
            //например у нас стояло количество победителей 3 и даже если игрок один мы
            // делаем 3 прохода и достаем 3 одинаковых индекса игрока
            // ( а вот это странно потому что функция должна отдавать разные индексы(?))
            

            for (uint256 i = 0; i < playerIndexes.length; i++) {

                    // смотрим есть ли индексы игрока в массиве индексов победителей
                    // если есть сетапим минтпассы на нужны индексы
                if(isValueInArray(playerIndexes[i], blackTableWinners[0].tempWinners)) {
                //             //transform in mintpass
                //        GameContract.setIsMintPass(
                //            GameContract.getBlackTablePlayingTokenIdByIndex(playerIndexes[i]), true
                //     );
                    
                //         // лишнее действие? Так как они сжигаются + сжигаются они до и это может дать ошибку
                //         // сжигания несуществующего токена
                //         // unfreeze token
                // Collection.setNotTransferable(
                //            GameContract.getBlackTablePlayingTokenIdByIndex(playerIndexes[i]), false);



                //     console.log("get inside", playerIndexes[i]);
                    
                } 

                    GameContract.deletePlayerInBlackRoomByIndexV2(playerIndexes[i]);
                                    //delete index of player

            }

        
            if(GameContract.getBlackTablePlayersNow() == 0) {
                console.log("registered zero players in blackRoom");
            //emit ивента по соответствующему исходу
            emit blackRoomClaimedPrizeMintPass(
                blackTableWinners[0].tempWinnersAddresses,
                blackTableWinners[0].tempInvolvedTokenIds,
                GameContract.getBlackTablePrizeRadioChoice()
            );
            }

                
        }


        //     //РОЗЫГРЫШ КАКИХ ТО ТОКЕНОВ ( ПЕРЕД ВЫДАЧЕЙ ТОКЕНОВ ВВЕСТИ АДРЕС КОНТРАКТА ТОКЕНА КОТОРЫЙ РАССЫЛАЕТСЯ И ПО СКОЛЬКО РАССЫЛАТЬ)

        if (GameContract.getBlackTablePrizeRadioChoice() == 2) {

            console.log("get in 2nd choice");

            require(GameContract.isRaffleTokenSet(), "RaffleToken not set");
                        GameContract.claimStakingTokensFromBlackRoom();


                // добавить ли require на то что raffleToken должен быть установлен?

            uint256 value = GameContract.getAmountTokensRaffleInBlackRoom();
               for (uint256 i = 0; i < playerIndexes.length; i++) {

                    // смотрим есть ли индексы игрока в массиве индексов победителей
                if(isValueInArray(playerIndexes[i], blackTableWinners[0].tempWinners)) {
          
                        // логика если виннер

                          GameContract.sendRaffleTokens(
                    GameContract.getBlackTablePlayerByIndex(playerIndexes[i]),
                    value
                    
                ); // изменить число
                console.log("sent tokens to ", GameContract.getBlackTablePlayerByIndex(playerIndexes[i]));
                                emit UserClaimedPartBlackRoom(tx.origin, value, GameContract.getBlackTablePrizeRadioChoice());

                    
                } 

                    GameContract.deletePlayerInBlackRoomByIndexV2(playerIndexes[i]);
                                    //delete index of player

            }

            console.log("registered ", GameContract.getBlackTablePlayersNow(), " players in game");
             if(GameContract.getBlackTablePlayersNow() == 0) {
                console.log("registered zero players in blackRoom and doing event");
            //emit ивента по соответствующему исходу
                //подумать над логикой емита генерал опустошения рума и надо ли это вообще
            emit blackRoomClaimedPrizeRaffleToken(
                 blackTableWinners[0].tempWinnersAddresses,
                value,
                GameContract.getBlackTablePrizeRadioChoice()
            );
             
             }



        }


                //розыгрыш дорогой нфтшки
        if (GameContract.getBlackTablePrizeRadioChoice() == 3) {

            require(GameContract.isRaffleNFTSet() && GameContract.getRaffleNFTTokenIdInBlackRoom() != 0, "Raffle NFT Options has not been set");

                        GameContract.claimStakingTokensFromBlackRoom();

            // ТУТ МЫ ПРЕДПОЛАГАЕМ ЧТО ПЕРЕД КЛЕЙМОМ МЫ ИЗМЕНИЛИ КОЛИЧЕСТВО ВИННЕРОВ
            // В БЛЕК РУМЕ НА ОДИН (ОДИН ЭЛЕМЕНТ В МАССИВЕ)
            // И БУДЕМ ТАК ЖЕ КАК В ПРЕДЫДУЩИХ ЧОЙСАХ ПРОХОДИТЬСЯ ПО ЭТОМУ МАССИВУ



                   for (uint256 i = 0; i < playerIndexes.length; i++) {

                    // смотрим есть ли индексы игрока в массиве ИНДЕКСА ПОБЕДИТЕЛЯ
                if(isValueInArray(playerIndexes[i], blackTableWinners[0].tempWinners)) {
          
                        
                    

                        GameContract.sendRaffleNFTToWinner(
                GameContract.getBlackTablePlayerByIndex(playerIndexes[i]),
                GameContract.getRaffleNFTTokenIdInBlackRoom()
            );
            console.log("raffle nft sent");
            // указать токен id которым владеет смарт контракт либо отдельно его сетапить функцией перед клеймом рума

            //Трансфер нфтшки юзеру (она должна быть на контракте, наш контракт должен уметь принимать 721  токены)


            // delete tempWinners; // пробуем занулить значения удалив, если будет ревертиться нужно будет по другому очищать массив, либо
            // сделать функцию фиктивного наполнения

            emit blackRoomClaimedPrizeRaffleNFT(
                tx.origin, // or tx origin?
                GameContract.getRaffleNFTTokenIdInBlackRoom(),
                GameContract.getBlackTablePrizeRadioChoice()
            );
                    
                } 




                    GameContract.deletePlayerInBlackRoomByIndexV2(playerIndexes[i]);
                                    //delete index of player в любом случае надо удалить юзера из игры

            }



    
        }

   

        //    //сменить масти нфтшек ИМЕЕТ СМЫСЛ?
     
        // проверить сколько игр прошло

        //очистить массивы для новой игры (НЕ ДЛЯ НОВОЙ ИГРЫ НО ПРОСТО ОЧИСТИТЬ)

                    if(GameContract.getBlackTablePlayersNow() == 0) {

        console.log("registered zero players in blackRoom");
        GameContract.setBlackTableLastGameFinishedAt(block.timestamp);
        GameContract.setBlackTableStatus(4);
        GameContract.incrBlackTableSerialNumber();
                    }
        // blackTable.lastGameFinishedAt = block.timestamp;
        // blackTable.status = 4;
        // blackTable.serialNumber++;
    }
}
