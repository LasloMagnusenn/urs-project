// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

   import "@openzeppelin/contracts/access/Ownable.sol";
   import "./console.sol";

   import "./IGameContract.sol";


        contract Reduct is Ownable {
            IGameContract GameContract;


    //           enum Status {
    //     // статусы для стола
    //     WaitingPlayers, //0
    //     Playing, //1
    //     Cooldown, //2
    //     ReadyToClaim, //3
    //     RaffleHappened // 4
    // }


    //       struct Table {
    //     // стракт стола
    //     uint256 serialNumber; // количество завершенных игр на конкретном столе (позже пригодится возможно)
    //     uint8 playersNow;
    //     address[10] players;
    //     uint256[10] playingTokenIds;
    //     uint256[4] playingSuits;
    //     uint256 currentGameStartedAt; // просто точка во времени когда началась текущая игра на столе               для сверки require при клейме стола
    //     uint256 lastGameFinishedAt; // просто точка во времени когда закончилась последняя игра на этом столе    для сверки кулдауна при начинании новой игры
    //     uint256 internalGameReduction; // вычитается из currentGameRoomDuration из за комбинаций всяких
    //     Status status;
    //     }





            constructor() {
        

            }

            function setGameContract(address _iGameContract) public {
                GameContract = IGameContract(_iGameContract);

            }


            
    function ReductGameTimeForCombinations(uint8 _roomLevel, uint256 _table)
        public
    {
        // Table storage currentTable = GameContract.GetCurrentTableInRoom(_roomLevel, _table);

        //комбинации отдельно по картам
        // 13 УРОВЕНЬ ИЛИ ТРЕТИЙ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if ( GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 10) {
            if (_roomLevel <= 13) {

                GameContract.incrInternalGameReduction(_roomLevel, _table, 3 minutes);

                //GameContract.incrInternalGameReduction(_roomLevel, _table, 3 minutes);
            // console.log("1st case");
            }
                GameContract.incrInternalGameReduction(_roomLevel, _table, 5 minutes);
            // console.log("2nd case");
        } else {
            // console.log("not");
        }

        if (
            GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 &&
            (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2)
        ) {
            //минус 4 часа
            GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        }

        if (
            GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 &&
            (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4)
        ) {
            //минус 3 часа
           GameContract.incrInternalGameReduction(_roomLevel, _table, 3 minutes);
        }

        if (
            GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 5 &&
            (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 5 ||
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 5)
        ) {
            //минус 2 часа
            GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        }

        if (
            GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 5 &&
            GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 5
        ) {
            GameContract.incrInternalGameReduction(_roomLevel, _table, 1 minutes);

            //минус 1 час
        }

        // добавляем комбинации по козырю

        // здесь мы например знаем что козырь это h
        // пика может быть старшей мастью, в этом случае

        if (GameContract.viewTrump() == 0) {
            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);  
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
            // пики
        }

        if (GameContract.viewTrump() == 1) {
            // червы

            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }

        if (GameContract.viewTrump() == 2) {
            // бубны

            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }

        if (GameContract.viewTrump() == 3) {
            // трефы
            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }
    }

    function checkReduct(uint8 _roomLevel, uint256 _table)
        public view returns(uint)
    {

         if (GameContract.viewTrump() == 0) {

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                return 1;
            }
            return 2;

         }
         return 3;

    }

    function ReductTrump(uint8 _roomLevel, uint256 _table)
        public
    {


        // добавляем комбинации по козырю

        // здесь мы например знаем что козырь это h
        // пика может быть старшей мастью, в этом случае

        if (GameContract.viewTrump() == 0) {

            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
            // пики
        }

        if (GameContract.viewTrump() == 1) {
            // червы

            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }

        if (GameContract.viewTrump() == 2) {
            // бубны

            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }

        if (GameContract.viewTrump() == 3) {
            // трефы
            if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 10) {
                // понизить еще на 6 часов
                GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 8 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2)
            ) {
                //понизить на 4 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
            }

            if (
                GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 6 &&
                (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
                    GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4)
            ) {
                //понизить на 2 часа
                GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
            }
        }
    }

     function ReductWithoutTrump(uint8 _roomLevel, uint256 _table)
        public
    {
        //комбинации отдельно по картам
        // 13 УРОВЕНЬ ИЛИ ТРЕТИЙ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 10) {
            if (_roomLevel <= 13) {
               GameContract.incrInternalGameReduction(_roomLevel, _table, 3 minutes);
            }
           GameContract.incrInternalGameReduction(_roomLevel, _table, 5 minutes);
        }

            // 8 пик + сумма красных карт = 2; 8 пик + сумма черных карт = 2

        if ( (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 && (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) + GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2))  ||  (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 && GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)) {
            //минус 4 часа
            GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        }
            // 6 пик + 4 красных или 4 черных
        if ( (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 && (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) + GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4)) || ( GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 && GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4 )) {
            //минус 3 часа
           GameContract.incrInternalGameReduction(_roomLevel, _table, 3 minutes);
        }

        // 5 пик  + 5 красных или черных
        if ( (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 5 && (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) + GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 5)) ||  (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 5 && GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 5 )) {
            //минус 2 часа
            GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        }

           // 4 пики + 6 красных или черных
        if ( (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 && (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) + GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 6)) ||  ( GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 && GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 6) ) {
            //минус 1 часа
            GameContract.incrInternalGameReduction(_roomLevel, _table, 1 minutes);
        }

            // 5 красных и черных

        if (
            (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) + GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 5 ) &&  GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 5
        ) {
            GameContract.incrInternalGameReduction(_roomLevel, _table, 1 minutes);

            //минус 1 час
        }

        // добавляем комбинации по козырю

        // здесь мы например знаем что козырь это h
        // пика может быть старшей мастью, в этом случае

        // if (trump == 0) {
        //     if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 10) {
        //         // понизить еще на 6 часов
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 8 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
        //     ) {
        //         //понизить на 4 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 6 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
        //     ) {
        //         //понизить на 2 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        //     }
        //     // пики
        // }

        // if (trump == 1) {
        //     // червы

        //     if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 10) {
        //         // понизить еще на 6 часов
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 8 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
        //     ) {
        //         //понизить на 4 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 6 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
        //     ) {
        //         //понизить на 2 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        //     }
        // }

        // if (trump == 2) {
        //     // бубны

        //     if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 10) {
        //         // понизить еще на 6 часов
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 8 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 2)
        //     ) {
        //         //понизить на 4 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 6 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 4)
        //     ) {
        //         //понизить на 2 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        //     }
        // }

        // if (trump == 3) {
        //     // трефы
        //     if (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 10) {
        //         // понизить еще на 6 часов
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 6 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 8 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 2 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 2)
        //     ) {
        //         //понизить на 4 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 4 minutes);
        //     }

        //     if (
        //         GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 3) == 6 &&
        //         (GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 1) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 2) == 4 ||
        //             GameContract.getPlayingSuitsSlotForTableInRoom(_roomLevel, _table, 0) == 4)
        //     ) {
        //         //понизить на 2 часа
        //         GameContract.incrInternalGameReduction(_roomLevel, _table, 2 minutes);
        //     }
        // }
    }





        


        }