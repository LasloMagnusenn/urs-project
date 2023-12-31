/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../common";

export interface HelperInterface extends utils.Interface {
  functions: {
    "Collection()": FunctionFragment;
    "GameContract()": FunctionFragment;
    "advancedBulkEnterInGameWithPlace(uint8,uint256,uint256[],uint256[])": FunctionFragment;
    "bulkEnterInBlackRoom(uint256[])": FunctionFragment;
    "checkInMemoryArray(uint256[],uint256)": FunctionFragment;
    "findElementIndexInArray(uint256,uint256[])": FunctionFragment;
    "findValueInArray(uint256,uint256[])": FunctionFragment;
    "generateRandomWinnerIndexInBlackRoom(uint256)": FunctionFragment;
    "generateWinnersForBlackRoom(uint256)": FunctionFragment;
    "getAvailablePlacesOnTable(uint8,uint256)": FunctionFragment;
    "getBulkNFTRoomLevels(uint256[])": FunctionFragment;
    "getIndexesOfInputTokenIdsInBlackTable(uint256[])": FunctionFragment;
    "getIndexesOfInputTokenIdsInTable(uint8,uint256,uint256[])": FunctionFragment;
    "getRandomSuit(uint256)": FunctionFragment;
    "getRandomSuitForTrump(uint256)": FunctionFragment;
    "getSmallestN(uint256[],uint256)": FunctionFragment;
    "getValue1(uint256)": FunctionFragment;
    "getValue2(uint256)": FunctionFragment;
    "leaveBlackTable(uint256[])": FunctionFragment;
    "leaveGame(uint8,uint256,uint256[])": FunctionFragment;
    "overlayCoincidentalPlaces(uint8,uint256,uint256[])": FunctionFragment;
    "pushSuitsInTable(uint8,uint256,uint256)": FunctionFragment;
    "reduceAndReturnArrays(uint256[],uint256)": FunctionFragment;
    "reduceArray(uint256[],uint256)": FunctionFragment;
    "reduct()": FunctionFragment;
    "removeElementFromArray(uint256[],uint256)": FunctionFragment;
    "setGameContract(address)": FunctionFragment;
    "setReduct(address)": FunctionFragment;
    "sortAscending(uint256[])": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "Collection"
      | "GameContract"
      | "advancedBulkEnterInGameWithPlace"
      | "bulkEnterInBlackRoom"
      | "checkInMemoryArray"
      | "findElementIndexInArray"
      | "findValueInArray"
      | "generateRandomWinnerIndexInBlackRoom"
      | "generateWinnersForBlackRoom"
      | "getAvailablePlacesOnTable"
      | "getBulkNFTRoomLevels"
      | "getIndexesOfInputTokenIdsInBlackTable"
      | "getIndexesOfInputTokenIdsInTable"
      | "getRandomSuit"
      | "getRandomSuitForTrump"
      | "getSmallestN"
      | "getValue1"
      | "getValue2"
      | "leaveBlackTable"
      | "leaveGame"
      | "overlayCoincidentalPlaces"
      | "pushSuitsInTable"
      | "reduceAndReturnArrays"
      | "reduceArray"
      | "reduct"
      | "removeElementFromArray"
      | "setGameContract"
      | "setReduct"
      | "sortAscending"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "Collection",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "GameContract",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "advancedBulkEnterInGameWithPlace",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[],
      PromiseOrValue<BigNumberish>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkEnterInBlackRoom",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "checkInMemoryArray",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "findElementIndexInArray",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "findValueInArray",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "generateRandomWinnerIndexInBlackRoom",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "generateWinnersForBlackRoom",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getAvailablePlacesOnTable",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getBulkNFTRoomLevels",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "getIndexesOfInputTokenIdsInBlackTable",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "getIndexesOfInputTokenIdsInTable",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "getRandomSuit",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getRandomSuitForTrump",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getSmallestN",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getValue1",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getValue2",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "leaveBlackTable",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "leaveGame",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "overlayCoincidentalPlaces",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>[]
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "pushSuitsInTable",
    values: [
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>,
      PromiseOrValue<BigNumberish>
    ]
  ): string;
  encodeFunctionData(
    functionFragment: "reduceAndReturnArrays",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "reduceArray",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(functionFragment: "reduct", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "removeElementFromArray",
    values: [PromiseOrValue<BigNumberish>[], PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setGameContract",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "setReduct",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "sortAscending",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;

  decodeFunctionResult(functionFragment: "Collection", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "GameContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "advancedBulkEnterInGameWithPlace",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bulkEnterInBlackRoom",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "checkInMemoryArray",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "findElementIndexInArray",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "findValueInArray",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "generateRandomWinnerIndexInBlackRoom",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "generateWinnersForBlackRoom",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getAvailablePlacesOnTable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getBulkNFTRoomLevels",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getIndexesOfInputTokenIdsInBlackTable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getIndexesOfInputTokenIdsInTable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRandomSuit",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getRandomSuitForTrump",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "getSmallestN",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "getValue1", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "getValue2", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "leaveBlackTable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "leaveGame", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "overlayCoincidentalPlaces",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "pushSuitsInTable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "reduceAndReturnArrays",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "reduceArray",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "reduct", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "removeElementFromArray",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setGameContract",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setReduct", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "sortAscending",
    data: BytesLike
  ): Result;

  events: {};
}

export interface Helper extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: HelperInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    Collection(overrides?: CallOverrides): Promise<[string]>;

    GameContract(overrides?: CallOverrides): Promise<[string]>;

    advancedBulkEnterInGameWithPlace(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      _placeIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    bulkEnterInBlackRoom(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    checkInMemoryArray(
      tempArr: PromiseOrValue<BigNumberish>[],
      _currentIndex: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    findElementIndexInArray(
      elementToFind: PromiseOrValue<BigNumberish>,
      array: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    findValueInArray(
      _value: PromiseOrValue<BigNumberish>,
      _verifiableArray: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    generateRandomWinnerIndexInBlackRoom(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    generateWinnersForBlackRoom(
      _salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getAvailablePlacesOnTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getBulkNFTRoomLevels(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getIndexesOfInputTokenIdsInBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getIndexesOfInputTokenIdsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getRandomSuit(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getRandomSuitForTrump(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    getSmallestN(
      array: PromiseOrValue<BigNumberish>[],
      n: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    getValue1(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    getValue2(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;

    leaveBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    leaveGame(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    overlayCoincidentalPlaces(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _inputIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    pushSuitsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    reduceAndReturnArrays(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[], BigNumber[]]>;

    reduceArray(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    reduct(overrides?: CallOverrides): Promise<[string]>;

    removeElementFromArray(
      array: PromiseOrValue<BigNumberish>[],
      elementToRemove: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    setGameContract(
      _GameContract: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setReduct(
      _reduct: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    sortAscending(
      arr: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;
  };

  Collection(overrides?: CallOverrides): Promise<string>;

  GameContract(overrides?: CallOverrides): Promise<string>;

  advancedBulkEnterInGameWithPlace(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    _tokenIds: PromiseOrValue<BigNumberish>[],
    _placeIndexes: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  bulkEnterInBlackRoom(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  checkInMemoryArray(
    tempArr: PromiseOrValue<BigNumberish>[],
    _currentIndex: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  findElementIndexInArray(
    elementToFind: PromiseOrValue<BigNumberish>,
    array: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  findValueInArray(
    _value: PromiseOrValue<BigNumberish>,
    _verifiableArray: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  generateRandomWinnerIndexInBlackRoom(
    salt: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  generateWinnersForBlackRoom(
    _salt: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getAvailablePlacesOnTable(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getBulkNFTRoomLevels(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getIndexesOfInputTokenIdsInBlackTable(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getIndexesOfInputTokenIdsInTable(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getRandomSuit(
    salt: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getRandomSuitForTrump(
    salt: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  getSmallestN(
    array: PromiseOrValue<BigNumberish>[],
    n: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  getValue1(
    _value: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  getValue2(
    _value: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  leaveBlackTable(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  leaveGame(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  overlayCoincidentalPlaces(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    _inputIndexes: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  pushSuitsInTable(
    _roomLevel: PromiseOrValue<BigNumberish>,
    _table: PromiseOrValue<BigNumberish>,
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  reduceAndReturnArrays(
    arr: PromiseOrValue<BigNumberish>[],
    reductionAmount: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<[BigNumber[], BigNumber[]]>;

  reduceArray(
    arr: PromiseOrValue<BigNumberish>[],
    reductionAmount: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  reduct(overrides?: CallOverrides): Promise<string>;

  removeElementFromArray(
    array: PromiseOrValue<BigNumberish>[],
    elementToRemove: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  setGameContract(
    _GameContract: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setReduct(
    _reduct: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  sortAscending(
    arr: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  callStatic: {
    Collection(overrides?: CallOverrides): Promise<string>;

    GameContract(overrides?: CallOverrides): Promise<string>;

    advancedBulkEnterInGameWithPlace(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      _placeIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    bulkEnterInBlackRoom(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    checkInMemoryArray(
      tempArr: PromiseOrValue<BigNumberish>[],
      _currentIndex: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    findElementIndexInArray(
      elementToFind: PromiseOrValue<BigNumberish>,
      array: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    findValueInArray(
      _value: PromiseOrValue<BigNumberish>,
      _verifiableArray: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    generateRandomWinnerIndexInBlackRoom(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    generateWinnersForBlackRoom(
      _salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getAvailablePlacesOnTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getBulkNFTRoomLevels(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getIndexesOfInputTokenIdsInBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getIndexesOfInputTokenIdsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getRandomSuit(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRandomSuitForTrump(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSmallestN(
      array: PromiseOrValue<BigNumberish>[],
      n: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    getValue1(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    getValue2(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    leaveBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    leaveGame(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    overlayCoincidentalPlaces(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _inputIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    pushSuitsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    reduceAndReturnArrays(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber[], BigNumber[]]>;

    reduceArray(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    reduct(overrides?: CallOverrides): Promise<string>;

    removeElementFromArray(
      array: PromiseOrValue<BigNumberish>[],
      elementToRemove: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    setGameContract(
      _GameContract: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    setReduct(
      _reduct: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    sortAscending(
      arr: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;
  };

  filters: {};

  estimateGas: {
    Collection(overrides?: CallOverrides): Promise<BigNumber>;

    GameContract(overrides?: CallOverrides): Promise<BigNumber>;

    advancedBulkEnterInGameWithPlace(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      _placeIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    bulkEnterInBlackRoom(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    checkInMemoryArray(
      tempArr: PromiseOrValue<BigNumberish>[],
      _currentIndex: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    findElementIndexInArray(
      elementToFind: PromiseOrValue<BigNumberish>,
      array: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    findValueInArray(
      _value: PromiseOrValue<BigNumberish>,
      _verifiableArray: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    generateRandomWinnerIndexInBlackRoom(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    generateWinnersForBlackRoom(
      _salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getAvailablePlacesOnTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getBulkNFTRoomLevels(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getIndexesOfInputTokenIdsInBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getIndexesOfInputTokenIdsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRandomSuit(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getRandomSuitForTrump(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getSmallestN(
      array: PromiseOrValue<BigNumberish>[],
      n: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getValue1(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    getValue2(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    leaveBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    leaveGame(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    overlayCoincidentalPlaces(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _inputIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    pushSuitsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    reduceAndReturnArrays(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    reduceArray(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    reduct(overrides?: CallOverrides): Promise<BigNumber>;

    removeElementFromArray(
      array: PromiseOrValue<BigNumberish>[],
      elementToRemove: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    setGameContract(
      _GameContract: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setReduct(
      _reduct: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    sortAscending(
      arr: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    Collection(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    GameContract(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    advancedBulkEnterInGameWithPlace(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      _placeIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    bulkEnterInBlackRoom(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    checkInMemoryArray(
      tempArr: PromiseOrValue<BigNumberish>[],
      _currentIndex: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    findElementIndexInArray(
      elementToFind: PromiseOrValue<BigNumberish>,
      array: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    findValueInArray(
      _value: PromiseOrValue<BigNumberish>,
      _verifiableArray: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    generateRandomWinnerIndexInBlackRoom(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    generateWinnersForBlackRoom(
      _salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getAvailablePlacesOnTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getBulkNFTRoomLevels(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getIndexesOfInputTokenIdsInBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getIndexesOfInputTokenIdsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRandomSuit(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getRandomSuitForTrump(
      salt: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getSmallestN(
      array: PromiseOrValue<BigNumberish>[],
      n: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getValue1(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getValue2(
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    leaveBlackTable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    leaveGame(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    overlayCoincidentalPlaces(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _inputIndexes: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    pushSuitsInTable(
      _roomLevel: PromiseOrValue<BigNumberish>,
      _table: PromiseOrValue<BigNumberish>,
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    reduceAndReturnArrays(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    reduceArray(
      arr: PromiseOrValue<BigNumberish>[],
      reductionAmount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    reduct(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    removeElementFromArray(
      array: PromiseOrValue<BigNumberish>[],
      elementToRemove: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    setGameContract(
      _GameContract: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setReduct(
      _reduct: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    sortAscending(
      arr: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}
