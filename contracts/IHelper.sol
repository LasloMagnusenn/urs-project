// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IHelper {
    function getRandomSuit(uint256 salt) external view returns (uint256);

    function generateRandomWinnerIndex(uint256 salt)
        external
        view
        returns (uint256);

    function checkInMemoryArray(uint256[] memory tempArr, uint256 _currentIndex)
        external
        pure
        returns (bool);

    function generateWinnersForBlackRoom(uint256 _salt)
        external
        view
        returns (uint256[] memory);

    function pushSuitsInTable(
        // в другой контракт возможно
        uint8 _roomLevel,
        uint256 _table,
        uint256 _tokenId
    ) external;

    function advancedBulkEnterInGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) external;

    function bulkEnterInBlackRoom(uint256[] calldata _tokenIds) external;


       function leaveBlackTable(
        uint256[] calldata _tokenIds
    ) external;


            function leaveGame(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds
    ) external;



     function advancedBulkEnterInGameWithPlace(
        uint8 _roomLevel,
        uint256 _table,
        uint256[] calldata _tokenIds,
        uint256[] calldata _placeIndexes
    ) external;


             function generateRandomWinnerIndexInBlackRoom(uint256 salt)
        external
        view
        returns (uint256);

         function getRandomSuitForTrump(uint256 salt) external view returns (uint256);

}
