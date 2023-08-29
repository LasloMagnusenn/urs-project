// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./IMintContract.sol";
import "./IGameContract.sol";
import "./IReduct.sol";
import "./console.sol";



contract Helper {

    IMintContract public Collection;
    IGameContract public GameContract;
    IReduct public reduct;
    

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
        Status status;

        // other GameContract.getBlackTable() Variables

    }

            // avoid deep stack errors
        struct EnterParams {

        bool allGenesis;
        uint256[]  NotValidIndexesForFreeTable;
        uint256[]  validIndexesForThisTable;
        uint256[]  validIndexesForFreeTable;
        uint256[]  tokensCaseRemainder;
        uint256 freeTable;
        uint256 remainder;
        uint256 amountTokensForThisTable;
        }

    



    constructor(address _MintContract) {


        Collection = IMintContract(_MintContract);


    }



     function bulkEnterInBlackRoom(
        uint256[] calldata _tokenIds
    ) public {


        // сделать проверку того что заходят токены нужного рума на стол
        //   НА ВСЕХ СТОЛАХ





        require(GameContract.bulkCheckNFTRoomLevel(_tokenIds, 1), "not all tokens corresponding roomLevel");
        require(GameContract.getBlackTablePlayersNow() + _tokenIds.length <= GameContract.getBlackTableAmountPlayersUntilCurrentRaffle(), "overflow black table");

        // сделать проверку на то что tx.origin обладает этим токеном

       require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 

        
        require(GameContract.getBlackTableStatus() != 3); // если стол готов к клейму значит игроки больше не могут заходить а на фронте отображается кнопка клейма стола







        //  сделать проверку на прохождение кулдауна
        // require(GameContract.getBlackTable().playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом
        // require(
        //     GameContract.getBlackTable().status == Status.WaitingPlayers,
        //     "try after cooldown or game is going now"
        // ); //добавить разрешение для генезиса, однако генезис может войти только если идет кулдаун, а стол не переполнен

        //push player in game // до какого количества делать итерацию? до 10 логично с внутренним брейком
        
        // каждый k - токенId




        bool wasPushed;
        for (uint256 k = 0; k < _tokenIds.length; k++) {
            
            
            // каждый i - порядковый номер слота на столе
            
            // сначала чекаем по существующим ячейкам массива
            for (uint256 i = 0; i  < GameContract.getBlackTablePlayersLength(); i++) {
                console.log("not skip");
                //players[i] - где i порядковый номер игрока в столе
                if (GameContract.getBlackTablePlayerByIndex(i) == address(0)) {

                        console.log("doing replace");

                        GameContract.replaceInBlackTable(i,tx.origin,block.timestamp,_tokenIds[k]);
                        GameContract.incrPlayersNowinBlack();// на каждый токен одно увеличение playersNow




                    if(Collection.viewNotTransferable(_tokenIds[k]) == false) {
                        console.log("false");
                                            Collection.setNotTransferable(_tokenIds[k], true);

                    } else {
                        console.log("true");
                        revert("tokenId already in Game");
                    }


                    wasPushed = true;
                    break; // выходим из i итерации

                    // если этот сценарий отрабатывает то пуш не трогается а итерация переходит к следующему токену
                }
            }

            // если wasPushed = false значит реплейса не было и игрока мы пушим

            if(!wasPushed) {

                    console.log("doing push");
                    // GameContract.getBlackTable().players.push(tx.origin);
                    // GameContract.getBlackTable().playersTimeMarks.push(block.timestamp);
                    // GameContract.getBlackTable().playingTokenIds.push(_tokenIds[k]);
                    GameContract.pushInBlackTable(tx.origin,block.timestamp,_tokenIds[k]);
                    GameContract.incrPlayersNowinBlack();// на каждый токен одно увеличение playersNow


                     if(Collection.viewNotTransferable(_tokenIds[k]) == false) {
                                            Collection.setNotTransferable(_tokenIds[k], true);

                    } else {
                        revert("tokenId already in Game");
                    }




                //тут пушим
            }


        }

        // // провести рафл?

        if (GameContract.getBlackTablePlayersNow() == GameContract.getBlackTableAmountPlayersUntilCurrentRaffle()) {
                 GameContract.setStatusinBlack(3);
                 
            
                 GameContract.setReadyToClaimAtInBlack(block.timestamp);

            
                //  // тут еще что то с временем добавить


        }







    }







    //     function advancedBulkEnterInGame(
    //     uint8 _roomLevel,
    //     uint256 _table,
    //     uint256[] calldata _tokenIds
    // ) public {
        
    //     // проверка на существование стола
    //     require(
    //         GameContract.isTableInRoomExists(_roomLevel, _table),
    //         "table doesn't exists"
    //     );

    //         // проверка на обладание токеном
    //    require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 
    //    require(GameContract.bulkCheckNFTRoomLevel(_tokenIds, _roomLevel), "not all tokens corresponding roomLevel");
    //         // проверка на заполненность стола чтобы не передавать весь объем на freeTable
    //     require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом




    //     //  проверка на прохождение кулдауна стола

    //     bool allGenesis = GameContract.checkAllGenesis(_tokenIds);

    //         // СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕПОЛНЕНИЕ либо дальше это уже делается

    //         // если все генезис
    //     if(allGenesis) {
    //             // если статус 0 то стол ждет игроков и мы их пускаем, 
    //             // если статус 2 то стол в кулдауне и мы пускаем генезисов
    //             // статуса 3 для обычных столов нет
    //         require(GameContract.getStatusForTable(_roomLevel, _table) != 1, "game is going now");

    //             // если хотя бы один не генезис
    //     } else {

    //          require((block.timestamp >= GameContract.GetCurrentTableInRoom(_roomLevel, _table).lastGameFinishedAt + GameContract.viewCooldownTime()), "try later"); // по сути это проверка того что стол вышел из кулдауна
    //          require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).status != 1, "game is going now");
    //              }






    //              if(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 0) {
    //                  GameContract.setStatus(_roomLevel, _table, 0);

    //              }
        
      


    //     // можем сразу расчитать сколько токенов поместится в текущий стол

    //     // uint kCounter;
    //     // uint256 tokenCounter;

    //     // пусть tokenIds length = 4 ( 4 токена)
    //     // пусть playersNow = 3
    //     // тогда amount = 10-3 = 7, 7 >4  значит amount =



    //     uint256 freeTable;
     
    //     uint256 amountTokensForThisTable = 10 -
    //         GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow;
    //         // console.log(amountTokensForThisTable);
            
    //                 if (amountTokensForThisTable >= _tokenIds.length) {
    //                     // console.log("amountTokensForThisTable >= _tokenIds.length");
    //         amountTokensForThisTable = _tokenIds.length;
    //     } else {
    //         // console.log("aaa");
    //          freeTable = GameContract.findAvailableTable(
    //             _roomLevel,
    //             _tokenIds.length - amountTokensForThisTable
    //         );
    //         // console.log(freeTable);
    //     }

    //     // put inside currentTable


    //     uint256 innerCounter;
    //     // console.log(amountTokensForThisTable);
    //     // console.log("amountTokensForThisTable");

    //     // итерация по всем инпут токен идс
    //     for (uint256 k = 0; k < _tokenIds.length; k++) {

    //         //1,2
    //         if (innerCounter < amountTokensForThisTable) {
    //                             innerCounter++;

    //             // проходится по всему столу чтобы занять каждое свободное место
    //             for (uint256 i = 0; i < 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе
    //                 if (
    //                     GameContract.GetCurrentTableInRoom(_roomLevel, _table).players[i] == address(0)
    //                 ) {
    //                     GameContract.addPlayer(_roomLevel, _table, i, tx.origin);
                      
    //                     GameContract.incrPlayersNow(_roomLevel, _table);
    //                     GameContract.addPlayingTokenId(_roomLevel, _table, i, _tokenIds[k]);


    //                     pushSuitsInTable(_roomLevel, _table, _tokenIds[k]);

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



    //             if (GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 10) {

    //                 // console.log("get in 10 inside innerCounter");

    //                 GameContract.setStatus(_roomLevel, _table, 1);
    //                 GameContract.setCurrentGameStartedAt(_roomLevel, _table,block.timestamp);
    //                 GameContract.setLastGameFinishedAt(_roomLevel, _table, 0);

                   
    //                 reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }


    //         } else {
    //             // console.log("getInFreeTable");
    //             // проходится по всему столу чтобы занять каждое свободное место
    //             for (uint256 i = 0; i < 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе
    //                 if (
    //                     GameContract.GetCurrentTableInRoom(_roomLevel, freeTable).players[i] ==
    //                     address(0)
    //                 ) {
    //                     GameContract.addPlayer(_roomLevel, freeTable, i, tx.origin);
                       
                   

                          
    //                     GameContract.incrPlayersNow(_roomLevel, freeTable);
    //                     GameContract.addPlayingTokenId(_roomLevel, freeTable, i, _tokenIds[k]);


    //                     pushSuitsInTable(_roomLevel, freeTable, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     if (
    //                         Collection.viewNotTransferable(_tokenIds[k]) ==
    //                         false
    //                     ) {
    //                         Collection.setNotTransferable(_tokenIds[k], true);
    //                     } else {
    //                         revert("tokenId already in Game");
    //                     }

    //                     console.log("waiting break");

    //                     break; // выходим из i итерации
    //                 } else {
    //                     console.log("doing push");
    //                 }
    //             }

    //             if (GameContract.GetCurrentTableInRoom(_roomLevel, freeTable).playersNow == 10) {
                    
    //                 // console.log("get in 10 outside innerCounter");

    //                 GameContract.setStatus(_roomLevel, freeTable, 1);
    //                 GameContract.setCurrentGameStartedAt(_roomLevel, freeTable,block.timestamp);
    //                 GameContract.setLastGameFinishedAt(_roomLevel, freeTable, 0);
    //                 reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }
    //         }
    //     }
    // }

        // возвращает плейсы не индексы
    function getAvailablePlacesOnTable(uint8 _roomLevel,uint256 _table) public view returns(uint256[] memory) {

          uint qtyAvailablePlaces = 10 -  GameContract.getPlayersNowForTable(_roomLevel,_table);
          uint256[] memory placeIndexes = new uint256[](qtyAvailablePlaces);
            uint counter;


                        for (uint256 i = 0; i < 10; i++) {

                            if(GameContract.getPlayerOnTableByIndex(_roomLevel,_table,i) == address(0)) {
                                console.log("get inside");

                                placeIndexes[counter] = i+1;
                                counter++;

                            }


                        }

                        return placeIndexes;

    }
        // возвращает индекс найденного значения
    function findValueInArray(uint256 _value, uint256[] memory _verifiableArray) public pure returns(uint256) {

                                    for (uint256 i = 0; i < _verifiableArray.length; i++) {

                                        if(_verifiableArray[i] == _value) {
                                            return _value;
                                        }


                                    }
                                    return 17;

        
    }


    //  function getQtyDublicatesInArrays(uint256[] memory _availableIndexes, uint256[] memory _modPlaceIndexes) public pure returns(uint) {






    //         uint qty;


    //                       for (uint256 c = 0; c < _availableIndexes.length; c++) {

    //                         if(_availableIndexes[c] == findValueInArray(_availableIndexes[c], _modPlaceIndexes)) {

    //                                 qty++;
    //                         } 

                            
    //                       }

    //                       // получили чистый массив и оттуда уже взяли lowestValue



    //         return qty;


    // }

    //    function getLowestValueInArrayExceptAnotherArray(uint256[] memory _availableIndexes, uint256[] memory _modPlaceIndexes) public view returns(uint256) {

    //     console.log(_modPlaceIndexes[0]);
    //        console.log(_modPlaceIndexes[0]);
    //             console.log(_modPlaceIndexes[1]);

    //     console.log(_modPlaceIndexes[2]);

    //     console.log(_modPlaceIndexes[3]);

    //     console.log("mod");




    //         // сначала нужно удалить дубликаты из массивов

    //                       uint256[] memory clearIndexes = new uint256[](_availableIndexes.length - getQtyDublicatesInArrays(_availableIndexes,_modPlaceIndexes));
    //                         uint clearCounter;


    //                       for (uint256 c = 0; c < _availableIndexes.length; c++) {

    //                         if(_availableIndexes[c] != findValueInArray(_availableIndexes[c], _modPlaceIndexes)) {


    //                             clearIndexes[clearCounter] = _availableIndexes[c];
    //                             clearCounter++;
    //                         } 

                            
    //                       }

    //                       // получили чистый массив и оттуда уже взяли lowestValue




    //         uint lowestValue = clearIndexes[0];

    //         for (uint256 i = 0; i < clearIndexes.length; i++) {

    //             if(clearIndexes[i] <= lowestValue) {
    //                 lowestValue = clearIndexes[i];
    //             }
                
    //         }

    //         return lowestValue;


    // }




    // function getLowestValueInArrayExceptAnotherArray1(uint256[] memory _availableIndexes, uint256[] memory _modPlaceIndexes) public view returns(uint256[] memory) {

    //     console.log(_modPlaceIndexes[0]);
    //             console.log(_modPlaceIndexes[1]);

    //     console.log(_modPlaceIndexes[2]);

    //     console.log(_modPlaceIndexes[3]);

    //     console.log("mod");




    //         // сначала нужно удалить дубликаты из массивов

    //                       uint256[] memory clearIndexes = new uint256[](_availableIndexes.length - getQtyDublicatesInArrays(_availableIndexes,_modPlaceIndexes));
    //                         uint clearCounter;


    //                       for (uint256 c = 0; c < _availableIndexes.length; c++) {

    //                         if(_availableIndexes[c] != findValueInArray(_availableIndexes[c], _modPlaceIndexes)) {


    //                             clearIndexes[clearCounter] = _availableIndexes[c];
    //                             clearCounter++;
    //                         } 

                            
    //                       }

    //                       // получили чистый массив и оттуда уже взяли lowestValue




    //         uint lowestValue = clearIndexes[0];

    //         for (uint256 i = 0; i < clearIndexes.length; i++) {

    //             if(clearIndexes[i] <= lowestValue) {
    //                 lowestValue = clearIndexes[i];
    //             }
                
    //         }

    //         console.log("clear");

    //         return clearIndexes;


    // }

    function removeElementFromArray(uint[] memory array, uint elementToRemove) public pure returns (uint[] memory) {
        uint[] memory result = new uint[](array.length - 1);
        uint resultIndex = 0;

        for (uint i = 0; i < array.length; i++) {
            if (array[i] != elementToRemove) {
                result[resultIndex] = array[i];
                resultIndex++;
            }
        }

        return result;
    }

    function findElementIndexInArray(uint elementToFind, uint[] memory array ) public pure returns (uint) {
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == elementToFind) {
                // Возвращаем индекс элемента, преобразованный в тип int
                return uint(i);
            }
        }

        // Если элемент не найден, возвращаем -1
        revert("could not find");
    }

    function overlayCoincidentalPlaces(uint8 _roomLevel, uint256 _table, uint256[] memory _inputIndexes) public view returns(uint256[] memory) {

           uint256[] memory modPlaceIndexes = new uint256[](_inputIndexes.length);
           uint256[] memory ascendingIndexes = sortAscending(_inputIndexes);
            uint modCounter;


         uint256[] memory _availableIndexes = getAvailablePlacesOnTable(_roomLevel,_table);

         console.log("availableIndexes length", _availableIndexes.length);

         console.log("ascendingIndexes.length", ascendingIndexes.length );
        

        // найти  совпадающие

         for (uint256 c = 0; c < ascendingIndexes.length; c++) {

            //  console.log("c");

                            if(ascendingIndexes[c] == findValueInArray(ascendingIndexes[c], _availableIndexes)) { 
                                console.log("getInsideArray");
                                console.log(ascendingIndexes[c]);


                                modPlaceIndexes[modCounter] = ascendingIndexes[c];
                                 _availableIndexes[findElementIndexInArray(ascendingIndexes[c],_availableIndexes)] = 0;
                                modCounter++;
                            } 

                            
                          }


                          // заполнить остатки lowestValues

                          


             uint256[] memory fillLowest = getSmallestN(_availableIndexes,ascendingIndexes.length - modCounter);
//             console.log("startFillLowest");
//             console.log(fillLowest[0]);
//             console.log(fillLowest[1]);
//             console.log(fillLowest[2]);
// console.log("finishFillLowest");
                      for (uint256 d = 0; d < fillLowest.length; d++) {

                          modPlaceIndexes[modCounter] = fillLowest[d];
                          modCounter++;

                      }
                        console.log(modCounter);
                      return modPlaceIndexes;
        //

    }




       function getSmallestN(uint[] memory array, uint n) public pure returns (uint256[] memory) {
        require(array.length >= n, "Array length should be greater than or equal to n");

        // Копируем исходный массив, чтобы не менять его во время сортировки
        uint[] memory sortedArray = new uint[](array.length);
        uint sortedIndex = 0;

        // Копируем ненулевые элементы в отдельный массив
        for (uint i = 0; i < array.length; i++) {
            if (array[i] != 0) {
                sortedArray[sortedIndex] = array[i];
                sortedIndex++;
            }
        }

        // Сортируем массив с ненулевыми элементами по возрастанию
        quickSort(sortedArray, int(0), int(sortedIndex - 1));

        // Создаем массив для результата и заполняем его первыми n элементами отсортированного массива
        uint256[] memory result = new uint256[](n);
        for (uint i = 0; i < n; i++) {
            result[i] = sortedArray[i];
        }

        return result;
    }

        function sortAscending(uint[] memory arr) public pure returns (uint[] memory) {
        uint[] memory sortedArr = new uint[](arr.length);
        for (uint i = 0; i < arr.length; i++) {
            sortedArr[i] = arr[i];
        }
        
        quickSort(sortedArr, 0, int(sortedArr.length) - 1);
        return sortedArr;
    }

    function quickSort(uint[] memory arr, int left, int right) internal pure {
        int i = left;
        int j = right;
        if (i == j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j) quickSort(arr, left, j);
        if (i < right) quickSort(arr, i, right);
    }


    // function overlayPlacesOnTable(uint8 _roomLevel, uint256 _table, uint256[] calldata _inputIndexes) public view returns(uint256[] memory) {

    //         bool wasZero;
    //         //case 1 
    //         // представим что юзер хочет [1,2,3,6]
    //         // и стол может принять эту комбинацию,
    //         // соответственно на выходе будет modPlaceIndexes [1,2,3,6]



    //             //case 2    
                
    //         // представим что юзер хочет [1,2,3,6]
    //         // но стол не может принять эту комбинацию, а может [1,4,5,6]
    //         // соответственно на выходе будет modPlaceIndexes [1,4,5,6]

    //         // то есть идет сверка один за одним значения и если стол не позволяет, то берется элемент из его матрицы, а не матрицы игрока

                                


    //             // инпут массив желания игрока



    //                 //массив чтения стола
    //             uint256[] memory availableIndexes = getAvailablePlacesOnTable(_roomLevel,_table);
    //                 // uint counter;

    //                 //добавим проверку переполнения стола здесь на случай если далее она где то может баговать из за новой логики
    //                 require(_inputIndexes.length + GameContract.getPlayersNowForTable(_roomLevel,_table) <= 10, "overflow table");
        
    //         // выходящий массив        
    //     uint256[] memory modPlaceIndexes = new uint256[](_inputIndexes.length);
    //         uint modCounter;



    //                         for (uint256 i = 0; i < _inputIndexes.length; i++) {


    //                                 // значение найдено
    //                             if(_inputIndexes[i] == findValueInArray(_inputIndexes[i], availableIndexes) ) {

    //                                 if(_inputIndexes[i] != findValueInArray(_inputIndexes[i], modPlaceIndexes)) {


    //                                 modPlaceIndexes[modCounter] = _inputIndexes[i];
    //                                 modCounter++;
    //                                 console.log("get in case1");
    //                                 }


    //                                 else {

                                        
    //                                 modPlaceIndexes[modCounter] = availableIndexes[i];
    //                                 modCounter++;
    //                                 console.log("get in case12");}

    //                                 }

    //                                 //значение не найдено 
    //                               else {

    //                                  if(_inputIndexes[i] == findValueInArray(_inputIndexes[i], modPlaceIndexes)) {
                                        
    //                                      modPlaceIndexes[modCounter] = availableIndexes[i];
    //                                 modCounter++;
    //                                 console.log("get in innercase21");
    //                                 } else {
    //                                    uint tempLowestValue;

    //                                         if(!wasZero) {
    //                                             console.log("get in !wasZero");
    //                                                 tempLowestValue = 0;
    //                                     console.log("lowestValue");
    //                                     console.log(tempLowestValue);
    //                                         } else {

    //                                                  tempLowestValue =  getLowestValueInArrayExceptAnotherArray(availableIndexes, modPlaceIndexes);
    //                                     console.log("lowestValue");
    //                                     console.log(tempLowestValue);
    //                                         }

                                    

    //                                     if(tempLowestValue != findValueInArray(tempLowestValue, modPlaceIndexes)) {


    //                                      modPlaceIndexes[modCounter] = tempLowestValue;
    //                                        modCounter++;
    //                                 console.log("get in case22");

    //                                     } else {
                                            
    //                                                  modPlaceIndexes[modCounter] = availableIndexes[i];
    //                                 modCounter++;
    //                                 console.log("get in case23");

    //                                     }


                                  
    //                                 }

                                     

                                    
    //                             }
                            
                            
                            
    //                         }

    //             return modPlaceIndexes;







    // }



    //  function advancedBulkEnterInGameWithPlace(
    //     uint8 _roomLevel,
    //     uint256 _table,
    //     uint256[] calldata _tokenIds,
    //     uint256[] calldata _placeIndexes
    // ) public {

    //     require(_tokenIds.length == _placeIndexes.length, "different length of arrays");
        
    //     // проверка на существование стола
    //     require(
    //         GameContract.isTableInRoomExists(_roomLevel, _table),
    //         "table doesn't exists"
    //     );

    //         // проверка на обладание токеном
    //    require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 
    //    require(GameContract.bulkCheckNFTRoomLevel(_tokenIds, _roomLevel), "not all tokens corresponding roomLevel");
    //         // проверка на заполненность стола чтобы не передавать весь объем на freeTable
    //     require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом




    //     //  проверка на прохождение кулдауна стола

    //     bool allGenesis = GameContract.checkAllGenesis(_tokenIds);

    //         // СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕПОЛНЕНИЕ либо дальше это уже делается

    //         // если все генезис
    //     if(allGenesis) {
    //             // если статус 0 то стол ждет игроков и мы их пускаем, 
    //             // если статус 2 то стол в кулдауне и мы пускаем генезисов
    //             // статуса 3 для обычных столов нет
    //         require(GameContract.getStatusForTable(_roomLevel, _table) != 1, "game is going now");

    //             // если хотя бы один не генезис
    //     } else {

    //          require((block.timestamp >= GameContract.GetCurrentTableInRoom(_roomLevel, _table).lastGameFinishedAt + GameContract.viewCooldownTime()), "try later"); // по сути это проверка того что стол вышел из кулдауна
    //          require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).status != 1, "game is going now");
    //              }






    //              if(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 0) {
    //                  GameContract.setStatus(_roomLevel, _table, 0);

    //              }
        
      


    //     // можем сразу расчитать сколько токенов поместится в текущий стол

    //     // uint kCounter;
    //     // uint256 tokenCounter;

    //     // пусть tokenIds length = 4 ( 4 токена)
    //     // пусть playersNow = 3
    //     // тогда amount = 10-3 = 7, 7 >4  значит amount =


    //     /// get valid places

    //               uint256[] memory validIndexes = overlayCoincidentalPlaces(_roomLevel,_table,_placeIndexes);




    //     ///



    //     uint256 freeTable;
     
    //     uint256 amountTokensForThisTable = 10 -
    //         GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow;
    //         console.log(amountTokensForThisTable);
            
    //                 if (amountTokensForThisTable >= _tokenIds.length) {
    //                     console.log("amountTokensForThisTable >= _tokenIds.length");
    //         amountTokensForThisTable = _tokenIds.length;
    //     } else {
    //         console.log("aaa");
    //          freeTable = GameContract.findAvailableTable(
    //             _roomLevel,
    //             _tokenIds.length - amountTokensForThisTable
    //         );
    //         console.log(freeTable);
    //     }

    //     // put inside currentTable


    //     uint256 innerCounter;
    //     console.log(amountTokensForThisTable);
    //     console.log("amountTokensForThisTable");

    //     // итерация по всем инпут токен идс
    //     for (uint256 k = 0; k < _tokenIds.length; k++) {

    //         //1,2
    //         if (innerCounter < amountTokensForThisTable) {
    //                             innerCounter++;

    //             // проходится по всему столу чтобы занять свободные места в соответствии с выбранной схемой мест
    //                     console.log(validIndexes.length);
    //                     console.log("validIndexes.length");
    //                for (uint256 i = 0; i < validIndexes.length; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе

    //                 console.log("get in validIndexes allocation");

                  
    //                     GameContract.addPlayer(_roomLevel, _table, validIndexes[i] - 1 , tx.origin);
                      
    //                     GameContract.incrPlayersNow(_roomLevel, _table);
    //                     console.log("players now was increased");
    //                     GameContract.addPlayingTokenId(_roomLevel, _table, validIndexes[i] -1 , _tokenIds[k]);


    //                     pushSuitsInTable(_roomLevel, _table, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     // if (
    //                     //     Collection.viewNotTransferable(_tokenIds[k]) ==
    //                     //     false
    //                     // ) {
    //                     //     Collection.setNotTransferable(_tokenIds[k], true);
    //                     // } else {
    //                     //     revert("tokenId already in Game");
    //                     // }

                    
    //             }




    //             // for (uint256 i = 0; i < 10; i++) {
    //             //     //players[i] - где i порядковый номер игрока в столе
    //             //     if (

    //             //         GameContract.GetCurrentTableInRoom(_roomLevel, _table).players[i] == address(0)
                    
    //             //     ) {
    //             //         GameContract.addPlayer(_roomLevel, _table, i, tx.origin);
                      
    //             //         GameContract.incrPlayersNow(_roomLevel, _table);
    //             //         GameContract.addPlayingTokenId(_roomLevel, _table, i, _tokenIds[k]);


    //             //         pushSuitsInTable(_roomLevel, _table, _tokenIds[k]);

    //             //         // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //             //         if (
    //             //             Collection.viewNotTransferable(_tokenIds[k]) ==
    //             //             false
    //             //         ) {
    //             //             Collection.setNotTransferable(_tokenIds[k], true);
    //             //         } else {
    //             //             revert("tokenId already in Game");
    //             //         }

    //             //         break; // выходим из i итерации карты
    //             //     }
    //             // }



    //             if (GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 10) {

    //                 console.log("get in 10 inside innerCounter");

    //                 GameContract.setStatus(_roomLevel, _table, 1);
    //                 GameContract.setCurrentGameStartedAt(_roomLevel, _table,block.timestamp);
    //                 GameContract.setLastGameFinishedAt(_roomLevel, _table, 0);

                   
    //                 reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }


    //         } else {
    //             console.log("getInFreeTable");
    //             // проходится по всему столу чтобы занять каждое свободное место
    //             for (uint256 i = 0; i < 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе
    //                 if (
    //                     GameContract.GetCurrentTableInRoom(_roomLevel, freeTable).players[i] ==
    //                     address(0)
    //                 ) {
    //                     GameContract.addPlayer(_roomLevel, freeTable, i, tx.origin);
                       
                   

                          
    //                     GameContract.incrPlayersNow(_roomLevel, freeTable);
    //                     GameContract.addPlayingTokenId(_roomLevel, freeTable, i, _tokenIds[k]);


    //                     pushSuitsInTable(_roomLevel, freeTable, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     if (
    //                         Collection.viewNotTransferable(_tokenIds[k]) ==
    //                         false
    //                     ) {
    //                         Collection.setNotTransferable(_tokenIds[k], true);
    //                     } else {
    //                         revert("tokenId already in Game");
    //                     }

    //                     console.log("waiting break");

    //                     break; // выходим из i итерации
    //                 } else {
    //                     console.log("doing push");
    //                 }
    //             }

    //             if (GameContract.GetCurrentTableInRoom(_roomLevel, freeTable).playersNow == 10) {
                    
    //                 console.log("get in 10 outside innerCounter");

    //                 GameContract.setStatus(_roomLevel, freeTable, 1);
    //                 GameContract.setCurrentGameStartedAt(_roomLevel, freeTable,block.timestamp);
    //                 GameContract.setLastGameFinishedAt(_roomLevel, freeTable, 0);
    //                 reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //                 // начать отсчитывать время и в последствии менять uri токенов
    //             }
    //         }
    //     }
    // }




         function reduceArray(uint[] memory arr, uint reductionAmount) public pure returns (uint[] memory) {
        require(reductionAmount <= arr.length, "Reduction amount exceeds array length");
        
        uint newLength = arr.length - reductionAmount;
        uint[] memory reducedArray = new uint[](newLength);
        
        for (uint i = 0; i < newLength; i++) {
            reducedArray[i] = arr[i];
        }
        
        return reducedArray;
        }


         function reduceAndReturnArrays(uint[] memory arr, uint reductionAmount) public pure returns (uint[] memory, uint[] memory) {
        require(reductionAmount <= arr.length, "Reduction amount exceeds array length");
        
        uint newLength = arr.length - reductionAmount;
        uint[] memory reducedArray = new uint[](newLength);
        uint[] memory removedArray = new uint[](reductionAmount);
        
        for (uint i = 0; i < newLength; i++) {
            reducedArray[i] = arr[i];
        }
        
        for (uint i = 0; i < reductionAmount; i++) {
            removedArray[i] = arr[newLength + i];
        }
        
        return (reducedArray, removedArray);
    }





    
     function advancedBulkEnterInGameWithPlace(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds,
        uint256[] calldata _placeIndexes
    ) public {

        EnterParams memory _enterParams;

        require(_tokenIds.length == _placeIndexes.length, "different length of arrays");
        
        // проверка на существование стола
        require(
            GameContract.isTableInRoomExists(_roomLevel, _table),
            "table doesn't exists"
        );

            // проверка на обладание токеном
       require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 
       require(GameContract.bulkCheckNFTRoomLevel(_tokenIds, _roomLevel), "not all tokens corresponding roomLevel");
            // проверка на заполненность стола чтобы не передавать весь объем на freeTable
        require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом




        //  проверка на прохождение кулдауна стола

        _enterParams.allGenesis = GameContract.checkAllGenesis(_tokenIds);

            // СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕПОЛНЕНИЕ либо дальше это уже делается

            // если все генезис
        if(_enterParams.allGenesis) {
                // если статус 0 то стол ждет игроков и мы их пускаем, 
                // если статус 2 то стол в кулдауне и мы пускаем генезисов
                // статуса 3 для обычных столов нет
            require(GameContract.getStatusForTable(_roomLevel, _table) != 1, "game is going now");

                // если хотя бы один не генезис
        } else {

             require((block.timestamp >= GameContract.GetCurrentTableInRoom(_roomLevel, _table).lastGameFinishedAt + GameContract.viewCooldownTime()), "try later"); // по сути это проверка того что стол вышел из кулдауна
             require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).status != 1, "game is going now");
                 }






                 if(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 0) {
                     GameContract.setStatus(_roomLevel, _table, 0);

                 }
        
      


        // можем сразу расчитать сколько токенов поместится в текущий стол

        // uint kCounter;
        // uint256 tokenCounter;

        // пусть tokenIds length = 4 ( 4 токена)
        // пусть playersNow = 3
        // тогда amount = 10-3 = 7, 7 >4  значит amount =


        /// get valid places

                //   uint256[] memory validIndexes = overlayCoincidentalPlaces(_roomLevel,_table,_placeIndexes);




        ///

        

        // uint256[] memory NotValidIndexesForFreeTable;
        // uint256[] memory validIndexesForThisTable;
        // uint256[] memory tokensCaseRemainder;
        // uint256 freeTable;
        // uint256 remainder;
        _enterParams.amountTokensForThisTable = 10 - GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow;
        console.log("amountTokensForThisTable", _enterParams.amountTokensForThisTable );
            // if(_enterParams.amountTokensForThisTable >= _placeIndexes.length) {
            //     _enterParams.amountTokensForThisTable = _placeIndexes.length;
            // }









            if(_enterParams.amountTokensForThisTable >=  _placeIndexes.length) {

                console.log("get in fullfill");
                // нужно обрезать плейсы и перенести их на другой стол
            
            
            _enterParams.validIndexesForThisTable = overlayCoincidentalPlaces(_roomLevel, _table, _placeIndexes);

            // и другого массива не требуется










            // DISTRIBUTION //////////////


              for (uint256 y = 0; y < _enterParams.validIndexesForThisTable.length; y++) {
                    //players[i] - где i порядковый номер игрока в столе

                    console.log("get in validIndexesForThisTable allocation");

                        GameContract.addPlayer(_roomLevel, _table, _enterParams.validIndexesForThisTable[y] - 1 , tx.origin);
                      
                        GameContract.incrPlayersNow(_roomLevel, _table);
                        console.log("players now was increased");
                        GameContract.addPlayingTokenId(_roomLevel, _table, _enterParams.validIndexesForThisTable[y] -1 , _tokenIds[y]);


                        pushSuitsInTable(_roomLevel, _table, _tokenIds[y]);

                        // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

                        if (
                            Collection.viewNotTransferable(_tokenIds[y]) ==
                            false
                        ) {
                            Collection.setNotTransferable(_tokenIds[y], true);
                        } else {
                            revert("tokenId already in Game");
                        }

                    
                }





                if (GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 10) {

                    console.log("get in 10 inside innerCounter");

                    GameContract.setStatus(_roomLevel, _table, 1);
                    GameContract.setCurrentGameStartedAt(_roomLevel, _table,block.timestamp);
                    GameContract.setLastGameFinishedAt(_roomLevel, _table, 0);

                   
                    reduct.ReductGameTimeForCombinations(_roomLevel, _table);

                    //установить время в соответствии с комбинациями на столе

                    // начать отсчитывать время и в последствии менять uri токенов
                }

            ///////////////////////////////
            











            
            } else {

                console.log("get in freeTable finding");
                // например = 3
                // _enterParams.amountTokensForThisTable = 10 - 6 = 4

                // 7 placeIndexes - (10 -6 playersNow) = 3 remainder


                _enterParams.remainder = _placeIndexes.length - _enterParams.amountTokensForThisTable;
                // _enterParams.tokensCaseRemainder = overlayCoincidentalPlaces(_roomLevel, _table, _placeIndexes);
                

                        (_enterParams.validIndexesForThisTable, _enterParams.NotValidIndexesForFreeTable) = reduceAndReturnArrays(_placeIndexes, _enterParams.remainder);

                                    _enterParams.validIndexesForThisTable = overlayCoincidentalPlaces(_roomLevel, _table, _enterParams.validIndexesForThisTable);


                           _enterParams.freeTable = GameContract.findAvailableTable(_roomLevel, _placeIndexes.length - _enterParams.amountTokensForThisTable);


                    _enterParams.validIndexesForFreeTable = overlayCoincidentalPlaces(_roomLevel, _enterParams.freeTable, _enterParams.NotValidIndexesForFreeTable);
                
                // должны разделить _placeIndexes на два массива, первый для - thisTable, второй - для freeTable

                uint tokenIdCounter;

                console.log("freeTable indexes length",  _enterParams.validIndexesForFreeTable.length );
                                console.log("freeTable index",  _enterParams.validIndexesForFreeTable[0] );



                            //////////////////////// DISTRIBUTION /////////

                    

                    console.log(_enterParams.validIndexesForThisTable[0]);

                    console.log(_enterParams.validIndexesForThisTable[1]);
                    console.log(_enterParams.validIndexesForThisTable[2]);
                    

                                console.log("fin");
              for (uint256 i = 0; i < _enterParams.validIndexesForThisTable.length; i++) {
                    //players[i] - где i порядковый номер игрока в столе

                    console.log("get in validIndexesForThisTable allocation else");

                  
                        // GameContract.addPlayer(_roomLevel, _table, validIndexesForThisTable[i] - 1 , tx.origin);
                        GameContract.addPlayer(_roomLevel, _table, _enterParams.validIndexesForThisTable[i] - 1 , tx.origin);

                        GameContract.incrPlayersNow(_roomLevel, _table);
                        console.log("players now was increased");
                        GameContract.addPlayingTokenId(_roomLevel, _table, _enterParams.validIndexesForThisTable[i] -1 , _tokenIds[tokenIdCounter]);


                        pushSuitsInTable(_roomLevel, _table, _tokenIds[i]);

                        // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

                        if (
                            Collection.viewNotTransferable(_tokenIds[tokenIdCounter]) ==
                            false
                        ) {
                            Collection.setNotTransferable(_tokenIds[tokenIdCounter], true);
                        } else {
                            revert("tokenId already in Game");
                        }

                        tokenIdCounter++;

                    
                }





                if (GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 10) {

                    console.log("get in 10 inside innerCounter");

                    GameContract.setStatus(_roomLevel, _table, 1);
                    GameContract.setCurrentGameStartedAt(_roomLevel, _table,block.timestamp);
                    GameContract.setLastGameFinishedAt(_roomLevel, _table, 0);

                   
                    reduct.ReductGameTimeForCombinations(_roomLevel, _table);

                    //установить время в соответствии с комбинациями на столе

                    // начать отсчитывать время и в последствии менять uri токенов
                }







                      for (uint256 f = 0; f < _enterParams.validIndexesForFreeTable.length; f++) {

                console.log("getInFreeTable");




                        GameContract.addPlayer(_roomLevel, _enterParams.freeTable, _enterParams.validIndexesForFreeTable[f] - 1 , tx.origin);
                      
                        GameContract.incrPlayersNow(_roomLevel, _enterParams.freeTable);
                        console.log("players now was increased");
                        GameContract.addPlayingTokenId(_roomLevel, _enterParams.freeTable, _enterParams.validIndexesForFreeTable[f] -1 , _tokenIds[tokenIdCounter]);


                        pushSuitsInTable(_roomLevel, _enterParams.freeTable, _tokenIds[tokenIdCounter]);

                        // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

                        if (
                            Collection.viewNotTransferable(_tokenIds[tokenIdCounter]) ==
                            false
                        ) {
                            Collection.setNotTransferable(_tokenIds[tokenIdCounter], true);
                        } else {
                            revert("tokenId already in Game");
                        }

                        tokenIdCounter++;


                if (GameContract.GetCurrentTableInRoom(_roomLevel, _enterParams.freeTable).playersNow == 10) {
                    
                    console.log("get in 10 outside innerCounter");

                    GameContract.setStatus(_roomLevel, _enterParams.freeTable, 1);
                    GameContract.setCurrentGameStartedAt(_roomLevel, _enterParams.freeTable,block.timestamp);
                    GameContract.setLastGameFinishedAt(_roomLevel, _enterParams.freeTable, 0);
                    reduct.ReductGameTimeForCombinations(_roomLevel, _table);

                    //установить время в соответствии с комбинациями на столе

                    // начать отсчитывать время и в последствии менять uri токенов
                }


            } // конец for итерации freeTable
                
            




            









                            /////////////////
            } // конец else
            


    




     
   
              
                 


      
                
        
    }




        // модифицировать leaveGame

    function leaveGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) public {


               require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 





        // проверить что игрок находится в игре стоит или нет так как дальше функция которая чекает






            // проверить что игра еще не началась
            require(GameContract.getStatusForTable(_roomLevel,_table) != 1, "game already playing");



            


        uint256[] memory tempIndexes = getIndexesOfInputTokenIdsInTable(_roomLevel, _table, _tokenIds);

        for (uint256 i = 0; i < tempIndexes.length; i++) {

            GameContract.deletePlayerInTableByIndex(_roomLevel,_table,tempIndexes[i], _tokenIds[i]);

                    // currentTable.players[tempIndexes[i]] = address(0); //удаление и
                    // currentTable.playingTokenIds[tempIndexes[i]] = 0;
                    // currentTable.playersNow--;

                    // // СЬЮТЫ ДЕКРЕМЕНТИТЬ!!!

                    // Collection.setNotTransferable(_tokenIds[i], false);

        }






        // for (uint256 k = 0; k < _tokenIds.length; k++) {
        //     console.log(k);



            

        //     for (uint256 i = 0; i < 10; i++) {
        //         if (currentTable.players[i] == msg.sender) {
        //             currentTable.players[i] = address(0); //удаление и
        //             currentTable.playingTokenIds[i] = 0;
        //             // + сделать reductPlayingSuits;
        //             currentTable.playersNow--;

        //             Collection.setNotTransferable(_tokenIds[k], false);
        //             break;
        //         }
        //     }
        //     //удалить игрока из массивов
        //     //разморозить нфтшку
        //     //decr playersnow
        // }
    }



    function leaveBlackTable(
        uint256[] calldata _tokenIds
    ) public  {


       require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 

        uint256[] memory tempIndexes = getIndexesOfInputTokenIdsInBlackTable(_tokenIds);

        for (uint256 i = 0; i < tempIndexes.length; i++) {

            GameContract.deletePlayerInBlackRoomByIndex(tempIndexes[i], _tokenIds[i] );

                    // blackTable.players[tempIndexes[i]] = address(0); //удаление и
                    // blackTable.playingTokenIds[tempIndexes[i]] = 0;
                    // blackTable.playersTimeMarks[tempIndexes[i]] = 0;
                    // blackTable.playersNow--;

                    // Collection.setNotTransferable(_tokenIds[i], false);

        }
    }



       function getIndexesOfInputTokenIdsInBlackTable(uint256[] memory _tokenIds) public view returns(uint256[] memory) {

  uint256[] memory indexes = new uint256[](_tokenIds.length);
        uint256 counter;


        for (uint256 k = 0; k < _tokenIds.length; k++) {


            for (uint256 i = 0; i < GameContract.getBlackTablePlayersLength(); i++) {


                    // наполнение ИНДЕКСАМИ 
            if(_tokenIds[k] == GameContract.getBlackTablePlayingTokenIdByIndex(i)) {
                indexes[counter] = i;
                counter++;
                break;

            }


        }

        }

        return indexes;
        
        
        

    }

    function getIndexesOfInputTokenIdsInTable(uint8 _roomLevel, uint256 _table, uint256[] memory _tokenIds) public view returns(uint256[] memory) {
       
       



  uint256[] memory indexes = new uint256[](_tokenIds.length);
        uint256 counter;


        for (uint256 k = 0; k < _tokenIds.length; k++) {


            for (uint256 i = 0; i < GameContract.getPlayersLengthInTable(_roomLevel, _table); i++) {


                    // наполнение ИНДЕКСАМИ 
            if(_tokenIds[k] == GameContract.getPlayingTokenIdInTableByIndex(_roomLevel,_table,i)) {
                indexes[counter] = i;
                counter++;
                break;

            }


        }

        }

        return indexes;
        
        
        

    }
















    //      function advancedBulkEnterInGame(
    //     uint8 _roomLevel,
    //     uint256 _table,
    //     uint256[] calldata _tokenIds
    // ) public {
        
    //     // проверка на существование стола
    //     require(
    //         GameContract.isTableInRoomExists(_roomLevel, _table),
    //         "table doesn't exists"
    //     );

    //         // проверка на обладание токеном
    //    require(GameContract.checkOwnershipOfTokens(_tokenIds), "you're not owner of token Id"); 
    //    require(GameContract.bulkCheckNFTRoomLevel(_tokenIds, _roomLevel), "not all tokens corresponding roomLevel");
    //         // проверка на заполненность стола чтобы не передавать весь объем на freeTable
    //     require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow != 10, "there are no seats"); // может быть бесполезно так как можно регулировать статусом




    //     //  проверка на прохождение кулдауна стола

    //     bool allGenesis = GameContract.checkAllGenesis(_tokenIds);

    //         // СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕПОЛНЕНИЕ либо дальше это уже делается

    //         // если все генезис
    //     if(allGenesis) {

    //         require(GameContract.getStatusForTable(_roomLevel, _table) != 1, "game is going now");

    //             // если хотя бы один не генезис
    //     } else {

    //          require((block.timestamp >= GameContract.GetCurrentTableInRoom(_roomLevel, _table).lastGameFinishedAt + GameContract.viewCooldownTime()), "try later"); // по сути это проверка того что стол вышел из кулдауна
    //          require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).status != 1, "game is going now");
    //              }

    //              if(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 0) {
    //                  GameContract.setStatus(_roomLevel, _table,0);

    //              }
        
      


    //     // можем сразу расчитать сколько токенов поместится в текущий стол

    //     // uint kCounter;
    //     // uint256 tokenCounter;

    //     // пусть tokenIds length = 4 ( 4 токена)
    //     // пусть playersNow = 3
    //     // тогда amount = 10-3 = 7, 7 >4  значит amount =



    //     // uint256 freeTable;
     
    //     // uint256 _enterParams.amountTokensForThisTable = 10 -
    //     //     GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow;
    //     //     console.log(_enterParams.amountTokensForThisTable);
            
    //     //             if (_enterParams.amountTokensForThisTable >= _tokenIds.length) {
    //     //                 console.log("_enterParams.amountTokensForThisTable >= _tokenIds.length");
    //     //     _enterParams.amountTokensForThisTable = _tokenIds.length;
    //     // } else {
    //     //     console.log("aaa");
    //     //      freeTable = GameContract.findAvailableTable(
    //     //         _roomLevel,
    //     //         _tokenIds.length - _enterParams.amountTokensForThisTable
    //     //     );
    //     //     console.log(freeTable);
    //     // }

    //     // put inside currentTable


    //     // итерация по всем инпут токен идс

    //         // просто итерация по всем инпут токен идс

    //         // проверить что стол может вместить всю длину массива

    //         require(GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow + _tokenIds.length <= 10, "overflow table");


    //     for (uint256 k = 0; k < _tokenIds.length; k++) {

    //         //1,2
    //             // проходится по всему столу чтобы занять каждое свободное место


    //             for (uint256 i = 0; i < 10; i++) {
    //                 //players[i] - где i порядковый номер игрока в столе

    //                 // заменяем пустой слот если он есть
    //                 if (
    //                     GameContract.GetCurrentTableInRoom(_roomLevel, _table).players[i] == address(0)
    //                 ) {
    //                     GameContract.addPlayer(_roomLevel, _table, i, tx.origin);
                      
    //                     GameContract.incrPlayersNow(_roomLevel, _table);
    //                     GameContract.addPlayingTokenId(_roomLevel, _table, i, _tokenIds[k]);


    //                     pushSuitsInTable(_roomLevel, _table, _tokenIds[k]);

    //                     // тут сделать проверку на то что токен может трансфериться, в противном случае он лежит на каком то столе

    //                     if (
    //                         Collection.viewNotTransferable(_tokenIds[k]) ==
    //                         false
    //                     ) {
    //                         Collection.setNotTransferable(_tokenIds[k], true);
    //                     } else {
    //                         revert("tokenId already in Game");
    //                     }

    //                     break; // выходим из i итерации и переходим к итерации по новому token id (но сначала сверяем playersNow == 10)
    //                     // но так как мы поставили условие на переполнение у нас сначала зайдут все токены и только потом отработает проверка на заполненность стола
    //                 }

    //             }



    //             if (GameContract.GetCurrentTableInRoom(_roomLevel, _table).playersNow == 10) {

    //                 console.log("registered 10 players on table");
                    
    //                 GameContract.setStatus(_roomLevel, _table, 1); // set playing
    //                 GameContract.setCurrentGameStartedAt(_roomLevel, _table,block.timestamp);
    //                 GameContract.setLastGameFinishedAt(_roomLevel, _table, 0);

                   
    //                 // reduct.ReductGameTimeForCombinations(_roomLevel, _table);

    //                 //установить время в соответствии с комбинациями на столе

    //             }


            
    //     }
    // }

























 

    function setGameContract(address _GameContract) public {
        GameContract = IGameContract(_GameContract);
    }


    
    function setReduct(address _reduct) public {
        reduct = IReduct(_reduct);
    }

     function getValue1(uint256 _value) public view returns (bytes memory) {
        return bytes(Collection.viewSuits(_value));
    }

     function getValue2(uint256 _value) public view returns (bytes32) {
        return keccak256(abi.encodePacked(Collection.viewSuits(_value)));
    }

    function pushSuitsInTable(
        // в другой контракт возможно
        uint8 _roomLevel,
        uint256 _table,
        uint256 _tokenId
    ) public {
        // прописывание очков комбинаций
        // Table storage currentTable = GameContract.GetCurrentTableInRoom(_roomLevel, _table);

        if (getValue1(_tokenId).length == 0) {
            GameContract.incrPlayingSuits(_roomLevel, _table, 0, 1);
            // currentTable.playingSuits[0] += 1; // пики
        }

        if (
            getValue2(_tokenId) ==
            0xa766932420cc6e9072394bef2c036ad8972c44696fee29397bd5e2c06001f615
        ) {
                        GameContract.incrPlayingSuits(_roomLevel, _table, 1, 1);

            // currentTable.playingSuits[1] += 1; // hearts (red)
        }

        if (
            getValue2(_tokenId) ==
            0xf1918e8562236eb17adc8502332f4c9c82bc14e19bfc0aa10ab674ff75b3d2f3
        ) {
                        GameContract.incrPlayingSuits(_roomLevel, _table, 2, 1);

            // currentTable.playingSuits[2] += 1; // diamonds (red)
        }

        if (
            getValue2(_tokenId) ==
            0x0b42b6393c1f53060fe3ddbfcd7aadcca894465a5a438f69c87d790b2299b9b2
        ) {
                        GameContract.incrPlayingSuits(_roomLevel, _table, 3, 1);

            // currentTable.playingSuits[3] += 1; //clubs (black)
        }
    }


   function initializeArray(uint256[] memory arr, uint256 value) internal pure {
    for (uint256 i = 0; i < arr.length; i++) {
        arr[i] = value;
    }
}
            //   отдает массив ИНДЕКСОВ ИГРОКОВ

function generateWinnersForBlackRoom(uint256 _salt) public view returns(uint256[] memory) {
    uint256[] memory tempWinners = new uint256[](GameContract.getAmountWinnersToPayoutinBlackRoom());
    initializeArray(tempWinners,27);
    uint256 counter = 0;
    uint256 attempts = 0;

    while (counter < GameContract.getAmountWinnersToPayoutinBlackRoom() && attempts < 1000) {
        uint256 currentWinnerIndex = (uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    blockhash(block.number),
                    tx.origin,
                    _salt
                )
            )
        ) % GameContract.getPlayersNowInBlackRoom());

        _salt += 1231617; // Увеличение соли для следующего вызова

        if (checkInMemoryArray(tempWinners, currentWinnerIndex)) {
            tempWinners[counter] = currentWinnerIndex;
            counter++;
        }

        attempts++;
    }

    return tempWinners;
}









    
    function checkInMemoryArray(uint256[] memory tempArr, uint256 _currentIndex) public pure returns(bool) {

            for (uint i = 0; i < tempArr.length; i++)

            {
                if(_currentIndex == tempArr[i]) {
                    return false;
                }
            
            }
            return true;


    }


      function generateRandomWinnerIndex(uint256 salt)
        internal
        view
        returns (uint256)
    {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        blockhash(block.number),
                        tx.origin,
                        salt
                    )
                )
            ) % 5; // здесь изменить с 5 на другое число вариативное
    }

         function generateRandomWinnerIndexInBlackRoom(uint256 salt)
        external
        view
        returns (uint256)
    {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        blockhash(block.number),
                        tx.origin,
                        salt
                    )
                )
            ) % GameContract.getPlayersNowInBlackRoom(); // здесь изменить с 5 на другое число вариативное
    }


      function getRandomSuit(uint256 salt) public view returns (uint256) {
        return
            (uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        blockhash(block.number),
                        tx.origin,
                        salt
                    )
                )
            ) % 3) + 1; //
    }

         function getRandomSuitForTrump(uint256 salt) public view returns (uint256) {
        return
            (uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        blockhash(block.number),
                        tx.origin,
                        salt
                    )
                )
            ) % 4); //
    }






    function getBulkNFTRoomLevels(uint256[] memory _tokenIds) public view returns(uint256[] memory) {

                uint256[] memory tempLevels = new uint256[](_tokenIds.length);

        for (uint i = 0; i < _tokenIds.length; i++) 
        {
                uint level = Collection.viewNFTRoomLevel(_tokenIds[i]);

            tempLevels[i] = level;
        
        }
        return tempLevels;
    }

    



}
