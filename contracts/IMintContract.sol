// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IMintContract {
    function viewSuits(uint256 _tokenId)
        external
        view
        returns (string calldata);

    function viewNotTransferable(uint256 _tokenId) external view returns (bool);

    function setNotTransferable(uint256 _tokendId, bool _value) external;

    function viewIsCommon(uint256 _tokenId) external view returns (bool);

    function viewNFTRoomLevel(uint256 _tokenId) external view returns (uint256);

    function setNFTRoomLevel(uint256 _tokenId, uint8 _roomLevel) external;

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function checkIsCommon(uint256 _tokenId) external view returns (uint256);

    function decrNFTRoomLevel(uint256 _tokenId) external;

    function doubleDecrNFTRoomLevel(uint256 _tokenId) external;

    function decrNFTRoomLevelForValue(uint256 _tokenId, uint8 _value) external;

    function setIsCommon(uint256 _tokenId, bool _value) external;

    function setSuit(uint256 _tokenId, string memory _value) external;

    function burn(uint256 tokenId) external;

    function viewCosts(uint256 _roomLevel) external returns (uint256);

    function bulkViewCosts(uint256[] memory _tokenIds)
        external
        view
        returns (uint256[] memory);

    function bulkViewSuits(uint256[] memory _tokenIds)
        external
        view
        returns (string[] memory);

    function bulkViewNotTransferable(uint256[] memory _tokenIds)
        external
        view
        returns (bool[] memory);

    function bulkViewIsCommon(uint256[] memory _tokenIds)
        external
        view
        returns (bool[] memory);

    function bulkViewNFTRoomLevel(uint256[] memory _tokenIds)
        external
        view
        returns (uint256[] memory);

            function payoutForRefunder(address _refunder, uint _value) external;
     function _claimBurn(uint256 tokenId)  external;

}
