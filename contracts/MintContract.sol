// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "./ERC721AURIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import {DefaultOperatorFilterer} from "./DefaultOperatorFilterer.sol";
import "./IERC20.sol";
import "./console.sol";
import "./IGameContract.sol";

contract MintContract is
    ERC721AURIStorage,
    DefaultOperatorFilterer,
    Ownable,
    ReentrancyGuard
{


    IGameContract public game;
    // using Strings for uint256;

    mapping(uint8 => uint32) public currentRoomSupply; //румлевел к currentSupply //текущее количество nft токенов по руму
    mapping(uint8 => uint32) public maxSupplyForRoom; //румлевел к maxсаплаю   нельзя минтить больше суммарного лимита на комнату
    mapping(uint8 => uint32) public dailyMintLimit; //румлевел к дейлилимиту
    mapping(uint8 => uint32) public currentDailyMintCounter; //румлевел к количеству сминченных сегодня // добавить обнуление через день
    mapping(uint8 => bool) public isDailyMintIncreasedNow; // проверяет увеличен ли лимит минта по руму ( он увеличивается если раскупается больше половины)
    mapping(uint8 => uint256) public dailyMintIncreasedTimestamp; // проверяет увеличен ли лимит минта по руму ( он увеличивается если раскупается больше половины)

    // mapping(uint8 => bool) public isDayIncreased;

    mapping(uint8 => uint256) public dayTimestamps;

    uint256 public startTimestamp;

    // проверяет  isDailyMintIncreasedNow
   



    mapping(uint8 => bool[16]) public dayIncreased;
        // здесь день передается порядковым числом а не индексом
    function isDayInRoomIncreased(
        uint8 _roomLevel,
        uint256 _day
    ) public view returns (bool) {

        // [16][0] -- первый день в 16м руме
        if (dayIncreased[_roomLevel][_day - 1]) {
            return true;
        }
        return false;
    }

    function setGameContract(address _game) public {
        game = IGameContract(_game);
    }

 

    function viewCardsInfo(
        uint256[] calldata _tokenIds
    ) public view returns (uint256[] memory, string[] memory, bool[] memory) {
        // , string[] memory tempSuits, bool[] memory tempActive
        // for (uint256 i = 0; i < _tokenIds.length; i++) {

        // tempSuits[i] = viewSuits(_tokenIds[i]);

        uint256[] memory tempLevels = new uint256[](_tokenIds.length);
        string[] memory tempSuits = new string[](_tokenIds.length);
        bool[] memory tempActive = new bool[](_tokenIds.length);

        for (uint i = 0; i < _tokenIds.length; i++) {
            bool isInGame = viewNotTransferable(_tokenIds[i]);
            if (isInGame) {
                tempActive[i] = true;
            } else {
                tempActive[i] = false;
            }

            tempLevels[i] = viewNFTRoomLevel(_tokenIds[i]);
            tempSuits[i] = viewSuits(_tokenIds[i]);
        }

     
        return (tempLevels, tempSuits, tempActive);
    }

    function getCurrentDay() public view returns (uint) {
        return ((block.timestamp - dayTimestamps[1]) / 1 days) + 1;
    }


    // day передается в нормальном виде
    function adjustSupply(
        uint8 _roomLevel,
        uint _day
    ) public view returns (uint32) {
        if (isDayInRoomIncreased(_roomLevel, _day)) {
            return dailyMintLimit[_roomLevel] * 2;
        } else {
            return dailyMintLimit[_roomLevel];
        }
    }

    function getCurrentLimitInRoom(uint8 _roomLevel) public view returns (uint32) {
        uint256 currentDay = ((block.timestamp - dayTimestamps[1]) / 1 days) +
            1;



                if (isDayInRoomIncreased(_roomLevel, currentDay)) {
            return dailyMintLimit[_roomLevel] * 2;
        } else {
            return dailyMintLimit[_roomLevel];
        }



    }

    // function getCurrentDay() public view returns(uint) {
    //     return ((block.timestamp - dayTimestamps[1]) / 1 days) +
    //         1;
    // }



    function setIncreaseDay(uint8 _roomLevel, uint256 _day) public {
        dayIncreased[_roomLevel][_day - 1] = true;
    }

    function newSmartMint(uint32 _mintAmount, uint8 _roomLevel) public payable {
        require(
            msg.value >= costs[_roomLevel] * _mintAmount,
            "Insufficient funds!"
        ); // проверка что средств на покупку хватает

        require(
            currentRoomSupply[_roomLevel] + _mintAmount <=
                maxSupplyForRoom[_roomLevel],
            "Max Supply for room reached"
        ); // сверка лимита maxSupply

        // для первого дня = 1

        uint256 currentDay = ((block.timestamp - dayTimestamps[1]) / 1 days) +
            1;

        // console.log(currentDay);

        if (currentDay != lastRegisterDayInRoom[_roomLevel]) {
            currentDailyMintCounter[_roomLevel] = 0;
        }

        if (isDayInRoomIncreased(_roomLevel, currentDay)) {
            // console.log("enter in positive isDayIncreased ");

            // тут и идет промежуток завтра
            require(
                currentDailyMintCounter[_roomLevel] + _mintAmount <=
                    adjustSupply(_roomLevel, currentDay),
                "all nfts for today has been minted with increase limit already"
            );
        } else {
            // console.log("enter in negative isDayIncreased");

            require(
                currentDailyMintCounter[_roomLevel] + _mintAmount <=
                    dailyMintLimit[_roomLevel],
                "all nfts for today has been minted without increase"
            );
        }

        // сверка дейлилимита + учесть то что в adjust
        uint256 curIndex = _currentIndex;
        currentDailyMintCounter[_roomLevel] += _mintAmount;
        currentRoomSupply[_roomLevel] += _mintAmount;
        _safeMint(_msgSender(), _mintAmount);

        if (lastRegisterDayInRoom[_roomLevel] != currentDay) {
            lastRegisterDayInRoom[_roomLevel] = currentDay;
        }

        for (uint256 i = curIndex; i < curIndex + _mintAmount; i++) {
            setNFTRoomLevel(i, _roomLevel);
        }


                // && !isDayInRoomIncreased(_roomLevel, currentDay)
        // проверяет сминчено ли больше половины дейлилимита
        if((currentDailyMintCounter[_roomLevel] >= (dailyMintLimit[_roomLevel]/2))   ) {
                    // инкрис дня передается по currentDay т.е. актив падает на завтра из за навигации в массиве
            dayIncreased[_roomLevel][currentDay] = true;
            console.log("was increased");

        //         // проверяет что isDailyMintIncreasedNow выключен и включает его если он выключен
        // if (!isDayInRoomIncreased(_roomLevel, currentDay)) {
        //     setIncreaseDay(_roomLevel, currentDay);

        //     console.log(" isDayInRoomIncreased set to true");
        // }
    }}

    function getBulkRoomLevelsForCards(
        uint256[] calldata _tokenIds
    ) public view returns (uint256[] memory) {
        uint256[] memory tempResults = new uint256[](_tokenIds.length);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            tempResults[i] = viewNFTRoomLevel(_tokenIds[i]);
        }

        return tempResults;
    }

    //    function  getBulkSuitsForCards(uint256[] calldata _tokenIds) public view returns(string[] memory) {

    //        string[] memory tempResults = new string[](_tokenIds.length);

    //             for (uint256 i = 0; i < _tokenIds.length; i++) {

    //                 tempResults[i] = viewSuits(_tokenIds[i]);

    //             }

    //             return tempResults;
    //         }

    mapping(uint8 => uint256) public lastRegisterDayInRoom;
    mapping(uint256 => uint8) public NFTRoomLevel; //tokenId к руму
    mapping(uint256 => bool) public isCommon;

    mapping(uint256 => uint256) public costs;
    mapping(uint256 => string) public GenesisUris; //рум левел к строке
    mapping(uint256 => string) public CommonUris; // рум левел к строке

    //for uris
    mapping(uint256 => string) public suits; // токен id к леттеру (автоматически spades)

    string public currentUriPrefixForMintPass; // for prizes or should i turn this into massive потому что у нас 200 столов а не один

    string public uriSuffix = ".json";
    // uint256 public maxSupply;
    uint256 public maxMintAmountPerTx;

    bool public paused = false;

    /////////////////////////////////////////////////////////////

    //  string memory _tokenName,
    //     string memory _tokenSymbol,
    //     uint256 _cost,
    //     uint256 _maxSupply,
    //     uint256 _maxMintAmountPerTx,
    constructor()
        // address _paymentToken

        ERC721A("WWW", "www")
    {
        // maxSupply = 65535;
        // setMaxMintAmountPerTx(500);

        // создать 5 столов 16 игры и 5 столов 15 игры

        // for(uint8 i = 1; i <=16; i++) {
        //       costs[i] = 16-i;
        //       GenesisUris[i] = string(abi.encodePacked("site.com/meta/gen/",i,"/")); //исключить 16 вариант или какой там
        //       CommonUris[i] = string(abi.encodePacked("site.com/meta/сom/",i,"/")); //исключить какой то вариант
        //       dailyMintLimit[i] = i; // тут друг

        // }

        dayTimestamps[1] = block.timestamp;
        dayTimestamps[2] = block.timestamp + 1 days;
        dayTimestamps[3] = block.timestamp + 2 days;
        dayTimestamps[4] = block.timestamp + 3 days;
        dayTimestamps[5] = block.timestamp + 4 days;
        dayTimestamps[6] = block.timestamp + 5 days;
        dayTimestamps[7] = block.timestamp + 6 days;
        dayTimestamps[8] = block.timestamp + 7 days;
        dayTimestamps[9] = block.timestamp + 8 days;
        dayTimestamps[10] = block.timestamp + 9 days;
        dayTimestamps[11] = block.timestamp + 10 days;
        dayTimestamps[12] = block.timestamp + 11 days;
        dayTimestamps[13] = block.timestamp + 12 days;
        dayTimestamps[14] = block.timestamp + 13 days;
        dayTimestamps[15] = block.timestamp + 14 days;
        dayTimestamps[16] = block.timestamp + 15 days;

        costs[1] = 16;
        costs[2] = 15;
        costs[3] = 14;
        costs[4] = 13;
        costs[5] = 12;
        costs[6] = 11;
        costs[7] = 10;
        costs[8] = 9;
        costs[9] = 8;
        costs[10] = 7;
        costs[11] = 6;
        costs[12] = 5;
        costs[13] = 4;
        costs[14] = 3;
        costs[15] = 2;
        costs[16] = 1;

        GenesisUris[1] = "site.com/meta/gen/1/";
        GenesisUris[2] = "site.com/meta/gen/2/";
        GenesisUris[3] = "site.com/meta/gen/3/";
        GenesisUris[4] = "site.com/meta/gen/4/";
        GenesisUris[5] = "site.com/meta/gen/5/";
        GenesisUris[6] = "site.com/meta/gen/6/";
        GenesisUris[7] = "site.com/meta/gen/7/";
        GenesisUris[8] = "site.com/meta/gen/8/";
        GenesisUris[9] = "site.com/meta/gen/9/";
        GenesisUris[10] = "site.com/meta/gen/10/";
        GenesisUris[11] = "site.com/meta/gen/11/";
        GenesisUris[12] = "site.com/meta/gen/12/";
        GenesisUris[13] = "site.com/meta/gen/13/";
        GenesisUris[14] = "site.com/meta/gen/14/";
        GenesisUris[15] = "site.com/meta/gen/15/";

        CommonUris[1] = "site.com/meta/com/1/";
        CommonUris[2] = "site.com/meta/com/2/";
        CommonUris[3] = "site.com/meta/com/3/";
        CommonUris[4] = "site.com/meta/com/4/";
        CommonUris[5] = "site.com/meta/com/5/";
        CommonUris[6] = "site.com/meta/com/6/";
        CommonUris[7] = "site.com/meta/com/7/";
        CommonUris[8] = "site.com/meta/com/8/";
        CommonUris[9] = "site.com/meta/com/9/";
        CommonUris[10] = "site.com/meta/com/10/";
        CommonUris[11] = "site.com/meta/com/11/";
        CommonUris[12] = "site.com/meta/com/12/";
        CommonUris[13] = "site.com/meta/com/13/";
        CommonUris[14] = "site.com/meta/com/14/";
        CommonUris[15] = "site.com/meta/com/15/";
        CommonUris[16] = "site.com/meta/com/16/";

        // dailyMintLimit[1] = 100;
        // dailyMintLimit[2] = 100;
        // dailyMintLimit[3] = 160;
        // dailyMintLimit[4] = 160;
        // dailyMintLimit[5] = 160;
        // dailyMintLimit[6] = 260;
        // dailyMintLimit[7] = 400;
        // dailyMintLimit[8] = 800;
        // dailyMintLimit[9] = 160;
        // dailyMintLimit[10] = 32;
        // dailyMintLimit[11] = 64;
        // dailyMintLimit[12] = 64; //was edited if this isnt 128
        // dailyMintLimit[13] = 256;
        // dailyMintLimit[14] = 512;
        // dailyMintLimit[15] = 1024;
        // dailyMintLimit[16] = 2048;

        

        // maxSupplyForRoom[1] = 160;
        // maxSupplyForRoom[2] = 16;
        // maxSupplyForRoom[3] = 16;
        // maxSupplyForRoom[4] = 16;
        // maxSupplyForRoom[5] = 16;
        // maxSupplyForRoom[6] = 32;
        // maxSupplyForRoom[7] = 64;
        // maxSupplyForRoom[8] = 128;
        // maxSupplyForRoom[9] = 256;
        // maxSupplyForRoom[10] = 512;
        // maxSupplyForRoom[11] = 1024;
        // maxSupplyForRoom[12] = 2048;
        // maxSupplyForRoom[13] = 4096;
        // maxSupplyForRoom[14] = 8192;
        // maxSupplyForRoom[15] = 16384;
        // maxSupplyForRoom[16] = 32768; //65 535 in total

         dailyMintLimit[1] = 100;
        dailyMintLimit[2] = 100;
        dailyMintLimit[3] = 160;
        dailyMintLimit[4] = 160;
        dailyMintLimit[5] = 160;
        dailyMintLimit[6] = 260;
        dailyMintLimit[7] = 400;
        dailyMintLimit[8] = 800;
        dailyMintLimit[9] = 160;
        dailyMintLimit[10] = 320;
        dailyMintLimit[11] = 640;
        dailyMintLimit[12] = 640; //was edited if this isnt 128
        dailyMintLimit[13] = 256;
        dailyMintLimit[14] = 512;
        dailyMintLimit[15] = 1024;
        dailyMintLimit[16] = 20480;

        

        maxSupplyForRoom[1] = 160;
        maxSupplyForRoom[2] = 160;
        maxSupplyForRoom[3] = 160;
        maxSupplyForRoom[4] = 160;
        maxSupplyForRoom[5] = 160;
        maxSupplyForRoom[6] = 320;
        maxSupplyForRoom[7] = 640;
        maxSupplyForRoom[8] = 128;
        maxSupplyForRoom[9] = 256;
        maxSupplyForRoom[10] = 512;
        maxSupplyForRoom[11] = 1024;
        maxSupplyForRoom[12] = 2048;
        maxSupplyForRoom[13] = 4096;
        maxSupplyForRoom[14] = 8192;
        maxSupplyForRoom[15] = 16384;
        maxSupplyForRoom[16] = 32768; //65 535 in total

    }

    //////////////////////////////////////////////////////////////

    function viewCosts(uint256 _roomLevel) public view returns (uint) {
        return costs[_roomLevel];
    }

     function bulkViewCosts(uint256[] memory _tokenIds) public view returns (uint[] memory) {
         
         uint[] memory tempCosts = new uint[](_tokenIds.length);


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             tempCosts[i] = costs[_tokenIds[i]];
         }
       
        return tempCosts;
    }

    function burn(uint256 tokenId) public virtual {
        require(ownerOf(tokenId) == tx.origin, "not owner");
        require(block.timestamp <= game.viewGlobalLastGameFinishedAt() + 3 hours, "too late");

        _burn(tokenId, false);
    }

            // сделать интернал или убрать при тесте со столами регулар
     function _claimBurn(uint256 tokenId) public {
                console.log("trying burn", tokenId);


        _burn(tokenId, false);
    }


    
    function bulkBurn(uint256[] memory _tokenIds) public virtual {

        for (uint i = 0; i < _tokenIds.length; i++) 
        {
               require(ownerOf(_tokenIds[i]) == tx.origin, "not owner");
               require(block.timestamp <= game.viewGlobalLastGameFinishedAt() + 3 hours, "too late");

        _burn(_tokenIds[i], false);
        }
     
    }

    function getDataAboutLimitsForRooms()
        public
        view
        returns (uint32[16] memory, uint32[16] memory)
    {
        uint32[16] memory tempDailyMintLimitForRoom;
        uint32[16] memory tempCurrentDailyMintCounter;

        for (uint8 i = 0; i <= 15; i++) {
            tempDailyMintLimitForRoom[i] = dailyMintLimit[i + 1];
            tempCurrentDailyMintCounter[i] = currentDailyMintCounter[i + 1];
        }

        return (tempDailyMintLimitForRoom, tempCurrentDailyMintCounter);
    }

    function getDataAboutCostsForRooms()
        public
        view
        returns (uint256[16] memory)
    {
        uint256[16] memory tempPrices;

        for (uint8 i = 0; i <= 15; i++) {
            tempPrices[i] = costs[i + 1];
        }
        return tempPrices;
    }

    function viewSuits(uint256 _tokenId) public view returns (string memory) {
        return suits[_tokenId];
    }

     function bulkViewSuits(uint256[] memory _tokenIds) public view returns (string[] memory) {
         
         string[] memory tempSuits = new string[](_tokenIds.length);


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             tempSuits[i] = suits[_tokenIds[i]];
         }
       
        return tempSuits;
    }

    function setSuit(uint256 _tokenId, string memory _value) public {
        suits[_tokenId] = _value;
    }

    function viewNotTransferable(uint256 _tokenId) public view returns (bool) {
        return notTransferable[_tokenId];
    }

     function bulkViewNotTransferable(uint256[] memory _tokenIds) public view returns (bool[] memory) {
         
         bool[] memory tempNotTransferable = new bool[](_tokenIds.length);


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             tempNotTransferable[i] = notTransferable[_tokenIds[i]];
         }
       
        return tempNotTransferable;
    }


    function viewIsCommon(uint256 _tokenId) public view returns (bool) {
        return isCommon[_tokenId];
    }


      function bulkViewIsCommon(uint256[] memory _tokenIds) public view returns (bool[] memory) {
         
         bool[] memory tempIsCommon = new bool[](_tokenIds.length);


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             tempIsCommon[i] = isCommon[_tokenIds[i]];
         }
       
        return tempIsCommon;
    }

    

    // function checkIsCommon(uint256 _tokenId) public view returns (uint256) {
    //     if (isCommon[_tokenId]) {
    //         return 1;
    //     } else {
    //         return 0;
    //     }
    // }

    function viewNFTRoomLevel(uint256 _tokenId) public view returns (uint256) {
        return NFTRoomLevel[_tokenId];
    }

      function bulkViewNFTRoomLevel(uint256[] memory _tokenIds) public view returns (uint[] memory) {
         
         uint[] memory tempNFTRoomLevels = new uint[](_tokenIds.length);


         for (uint i = 0; i < _tokenIds.length; i++) 
         {
             tempNFTRoomLevels[i] = NFTRoomLevel[_tokenIds[i]];
         }
       
        return tempNFTRoomLevels;
    }

    function setIsCommon(uint256 _tokenId, bool _value) public {
        isCommon[_tokenId] = _value;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
            "Invalid mint amount!"
        );
        _;
    }

    // обращается к родительскому контракту
    function setNotTransferable(uint256 _tokenId, bool _value) public {
        notTransferable[_tokenId] = _value;
    }

    function viewCostForRoom(uint8 _roomLevel) public view returns (uint256) {
        return costs[_roomLevel];
    }

    function viewCurrentRoomSupply(
        uint8 _roomLevel
    ) public view returns (uint256) {
        return currentRoomSupply[_roomLevel];
    }

    function setNFTRoomLevel(uint256 _tokenId, uint8 _roomLevel) internal {
        NFTRoomLevel[_tokenId] = _roomLevel;
    }

    function payoutForRefunder(address _refunder, uint _value) public  {

      (bool oa, ) = payable(_refunder).call{value: _value }('');
      require(oa);
    }

    // function decrNFTRoomLevel(uint256 _tokenId) public {
    //     NFTRoomLevel[_tokenId]--;
    // }

    //         function doubleDecrNFTRoomLevel(uint256 _tokenId) public {

    //                     NFTRoomLevel[_tokenId]--;
    //                        NFTRoomLevel[_tokenId]--;

    //         }

    function decrNFTRoomLevelForValue(uint256 _tokenId, uint8 _value) public {
        unchecked {
            NFTRoomLevel[_tokenId] -= _value;
        }
    }

    // function returnURIS(uint256 _tokenId) public view returns (string memory) {
    //     return string(abi.encodePacked(GenesisUris[NFTRoomLevel[_tokenId]]));
    // }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    // function tokenURI(uint256 _tokenId)
    //     public
    //     view
    //     virtual
    //     override
    //     returns (string memory)
    // {
    //     require(
    //         _exists(_tokenId),
    //         "ERC721Metadata: URI query for nonexistent token"
    //     );

    //     //   string memory _tokenURI = _tokenURIs[_tokenId]; // появляется при условии изменения uri вручную

    //     //  if (bytes(_tokenURI).length > 0) {
    //     //                 return string(abi.encodePacked(_tokenURI));
    //     //       }

    //     // для коммона
    //     if (isCommon[_tokenId]) {
    //         return
    //             string(
    //                 abi.encodePacked(
    //                     CommonUris[NFTRoomLevel[_tokenId]],
    //                     suits[_tokenId],
    //                     _tokenId.toString(),
    //                     uriSuffix
    //                 )
    //             );
    //     }
    //     // для генезиса
    //     else {
    //         return
    //             string(
    //                 abi.encodePacked(
    //                     GenesisUris[NFTRoomLevel[_tokenId]],
    //                     _tokenId.toString(),
    //                     uriSuffix
    //                 )
    //             );
    //     }
    // }

    // function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
    //   _setTokenURI(tokenId, _tokenURI);

    // }

    //  function setCost(uint256 _position, uint256 _value) public onlyOwner {
    //     costs[_position] = _value;
    //   }

    // function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
    //   maxMintAmountPerTx = _maxMintAmountPerTx;
    // }

    // function setUriSuffix(string memory _uriSuffix) public onlyOwner {
    //   uriSuffix = _uriSuffix;
    // }

    // function setPaused(bool _state) public onlyOwner {
    //   paused = _state;
    // }

    // function withdraw() public onlyOwner nonReentrant {

    //   (bool oa, ) = payable(owner()).call{value: address(this).balance}('');
    //   require(oa);
    // }
}
