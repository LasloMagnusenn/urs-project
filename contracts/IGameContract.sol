// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IGameContract {
    function getPlayingSuitsSlotForTableInRoom(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _slot
    ) external view returns (uint256);

    function incrInternalGameReduction(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _value
    ) external;

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

        function getBlackTablePlayerTimeMarkByIndex(uint _index) external view returns(uint);

        function getBlackTableLastGameFinishedAt() external view returns(uint);


    function getBlackTableStakingRate() external view returns(uint);
    struct blackTableStruct {
        uint256 serialNumber; // количество завершенных игр на конкретном столе
        uint8 playersNow;
        address[] players;
        uint256[] playingTokenIds;
        uint256[] playersTimeMarks;
        uint256[4] playingSuits;
        uint256 readyToClaimAt; // просто точка во времени когда началась игра для сверки require при клейме
        uint256 timeUntilRaffleExecution; // просто точка во времени когда началась игра для сверки require при начинании новой игры
        uint256 lastGameFinishedAt;
        uint256 internalGameReduction; // cколько эта игра будет длиться с учетом комбинаций ( будет получено путем вычета комбинации из baseGameDuration)
        uint256 stakingRate; // = 14400 // can be set over function
        uint256 amountPlayersUntilCurrentRaffle; // 15 for testing; can be set over function
        uint256 amountWinnersToPayout; // 3 for testing; (not for single nft raffle!)  can be set over function
        uint256 status;

        // Status status;

        // other blackTable Variables
    }

    //   function GetCurrentTableInRoom(uint8 _room, uint256 _table) external  view returns (Table memory);

    function viewTrump() external view returns (uint256);

    function getBlackRoom() external view returns (blackTableStruct memory);

    function getAmountWinnersToPayoutinBlackRoom()
        external
        view
        returns (uint256);

    function getPlayersNowInBlackRoom() external view returns (uint256);

    function incrPlayingSuits(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index,
        uint256 _value
    ) external;

    function decrPlayingSuits(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index,
        uint256 _value
    ) external;

    function setReadyToClaimAtInBlack(uint _value) external;

    function isTableInRoomExists(
        uint8 _roomLevel,
        uint256 _table
    ) external view returns (bool);

    function checkOwnershipOfTokens(
        uint256[] memory _tokenIds
    ) external view returns (bool);

    function bulkCheckNFTRoomLevel(
        uint256[] memory _tokenIds,
        uint8 _roomLevel
    ) external view returns (bool);

    function GetCurrentTableInRoom(
        uint8 _room,
        uint256 _table
    ) external view returns (Table memory);

    function checkAllGenesis(
        uint256[] memory _tokenIds
    ) external view returns (bool);

    function viewCooldownTime() external view returns (uint256);

    function setPlayersNowInTable(
        uint8 _roomLevel,
        uint256 _table,
        uint8 _value
    ) external;

    function findAvailableTable(
        uint8 _roomLevel,
        uint256 _remainAllocation
    ) external view returns (uint256);

    function getStatusForTable(
        uint8 _roomLevel,
        uint256 _table
    ) external view returns (uint256);

    function getBlackTable() external view returns (blackTableStruct memory);

    function incrPlayersNow(uint8 _roomLevel, uint256 _table) external;

    function decrPlayersNow(uint8 _roomLevel, uint256 _table) external;

    function setCurrentGameStartedAt(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _value
    ) external;

    function setLastGameFinishedAt(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _value
    ) external;

    function setStatus(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _value
    ) external;

    function addPlayer(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index,
        address _player
    ) external;

    function addPlayingTokenId(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index,
        uint256 _tokenId
    ) external;

    function pushInBlackTable(
        address _player,
        uint _timestamp,
        uint _tokenId
    ) external;

    function incrPlayersNowinBlack() external;

    function decrPlayersNowinBlack() external;

    function setTimeUntilRaffleExecutionInBlack(uint _value) external;

    function setStatusinBlack(uint256 _value) external;

    function setTempVariablesInBlackTableinBlack(
        uint _stakingRate,
        uint _amountPlayersUntilCurrentRaffle,
        uint _amountWinnersToPayout
    ) external;

    function setStakingRateinBlackRoom(uint256 _value) external;

        function getAmountTokensRaffleInBlackRoom() external view returns(uint);

            function getRaffleNFTTokenIdInBlackRoom() external view returns(uint);

       function deletePlayerInBlackRoomByIndexV2(uint256 _index) external;

           function claimStakingTokensFromBlackRoom() external;

                function decrPlayersNowInBlackTable() external;


                   
    function getIndexesOfPlayerInBlackRoom(address _player)
        external
        view
        returns (uint256[] memory);


        function viewRaffleTokenAddress() external view returns(address);

            function isRaffleTokenSet() external view returns(bool);


    function replaceInBlackTable(
        uint _index,
        address _player,
        uint _timestamp,
        uint _tokenId
    ) external;

        function isRaffleNFTSet() external view returns(bool);

    function getBlackTableStatus() external view returns (uint256);

    function getBlackTablePlayerByIndex(
        uint256 _index
    ) external view returns (address);

    function getBlackTablePlayersNow() external view returns (uint256);

    function getBlackTablePlayingTokenIdByIndex(
        uint256 _index
    ) external view returns (uint256);

    function getPlayersLengthInTable(
        uint8 _roomLevel,
        uint256 _table
    ) external view returns (uint256);

    function getPlayingTokenIdInTableByIndex(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index
    ) external view returns (uint256);

    function deletePlayerInBlackRoomByIndex(
        uint256 _index,
        uint256 _tokenId
    ) external;

    function deletePlayerInTableByIndex(
        uint8 _roomLevel,
        uint256 _table,
        uint256 _index,
        uint256 _tokenId
    ) external;

    function getBlackTableAmountPlayersUntilCurrentRaffle()
        external
        view
        returns (uint256);

    function getBlackTablePlayersLength() external view returns (uint256);

              function getPlayersNowForTable(uint8 _roomLevel, uint256 _table) external view returns(uint256);

                  function getPlayerOnTableByIndex(uint8 _roomLevel, uint256 _table, uint256 _index) external view returns(address);

                     function getBlackTableReadyToClaimAt() external view returns(uint);


    
    function getBlackTableTimeUntilRaffleExecution() external view returns(uint);

         function getBlackTableAmountWinnersToPayout() external view returns(uint);

         
    function getBlackTablePrizeRadioChoice() external view returns(uint);

        function setIsMintPass(uint _tokenId, bool _value) external;


            function sendRaffleNFTToWinner(address _winner, uint _tokenId) external;

                 function sendRaffleTokens(address _who, uint _amount) external;

                    function setBlackTableStatus( uint256 _value) external;
        function setBlackTableLastGameFinishedAt(uint _value) external;
            function incrBlackTableSerialNumber() external;
    function claimBlackRoom(uint _salt) external;


    function bulkEnterInBlackRoom(
        uint256[] calldata _tokenIds
    ) external;


        function setGlobalLastGameFinishedAt(uint _value) external;


                function viewGlobalLastGameFinishedAt() external view returns(uint256);
                    function bulkCheckNotTransferable(uint256[] memory _tokenIds) external view returns (bool);

}
