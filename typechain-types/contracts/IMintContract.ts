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

export interface IMintContractInterface extends utils.Interface {
  functions: {
    "_claimBurn(uint256)": FunctionFragment;
    "bulkViewCosts(uint256[])": FunctionFragment;
    "bulkViewIsCommon(uint256[])": FunctionFragment;
    "bulkViewNFTRoomLevel(uint256[])": FunctionFragment;
    "bulkViewNotTransferable(uint256[])": FunctionFragment;
    "bulkViewSuits(uint256[])": FunctionFragment;
    "burn(uint256)": FunctionFragment;
    "checkIsCommon(uint256)": FunctionFragment;
    "decrNFTRoomLevel(uint256)": FunctionFragment;
    "decrNFTRoomLevelForValue(uint256,uint8)": FunctionFragment;
    "doubleDecrNFTRoomLevel(uint256)": FunctionFragment;
    "ownerOf(uint256)": FunctionFragment;
    "payoutForRefunder(address,uint256)": FunctionFragment;
    "setIsCommon(uint256,bool)": FunctionFragment;
    "setNFTRoomLevel(uint256,uint8)": FunctionFragment;
    "setNotTransferable(uint256,bool)": FunctionFragment;
    "setSuit(uint256,string)": FunctionFragment;
    "viewCosts(uint256)": FunctionFragment;
    "viewIsCommon(uint256)": FunctionFragment;
    "viewNFTRoomLevel(uint256)": FunctionFragment;
    "viewNotTransferable(uint256)": FunctionFragment;
    "viewSuits(uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "_claimBurn"
      | "bulkViewCosts"
      | "bulkViewIsCommon"
      | "bulkViewNFTRoomLevel"
      | "bulkViewNotTransferable"
      | "bulkViewSuits"
      | "burn"
      | "checkIsCommon"
      | "decrNFTRoomLevel"
      | "decrNFTRoomLevelForValue"
      | "doubleDecrNFTRoomLevel"
      | "ownerOf"
      | "payoutForRefunder"
      | "setIsCommon"
      | "setNFTRoomLevel"
      | "setNotTransferable"
      | "setSuit"
      | "viewCosts"
      | "viewIsCommon"
      | "viewNFTRoomLevel"
      | "viewNotTransferable"
      | "viewSuits"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "_claimBurn",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkViewCosts",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkViewIsCommon",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkViewNFTRoomLevel",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkViewNotTransferable",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "bulkViewSuits",
    values: [PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "burn",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "checkIsCommon",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "decrNFTRoomLevel",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "decrNFTRoomLevelForValue",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "doubleDecrNFTRoomLevel",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "ownerOf",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "payoutForRefunder",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setIsCommon",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<boolean>]
  ): string;
  encodeFunctionData(
    functionFragment: "setNFTRoomLevel",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setNotTransferable",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<boolean>]
  ): string;
  encodeFunctionData(
    functionFragment: "setSuit",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<string>]
  ): string;
  encodeFunctionData(
    functionFragment: "viewCosts",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "viewIsCommon",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "viewNFTRoomLevel",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "viewNotTransferable",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "viewSuits",
    values: [PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(functionFragment: "_claimBurn", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "bulkViewCosts",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bulkViewIsCommon",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bulkViewNFTRoomLevel",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bulkViewNotTransferable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "bulkViewSuits",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "burn", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "checkIsCommon",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "decrNFTRoomLevel",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "decrNFTRoomLevelForValue",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "doubleDecrNFTRoomLevel",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "ownerOf", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "payoutForRefunder",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setIsCommon",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setNFTRoomLevel",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setNotTransferable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setSuit", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "viewCosts", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "viewIsCommon",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "viewNFTRoomLevel",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "viewNotTransferable",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "viewSuits", data: BytesLike): Result;

  events: {};
}

export interface IMintContract extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: IMintContractInterface;

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
    _claimBurn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    bulkViewCosts(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    bulkViewIsCommon(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[boolean[]]>;

    bulkViewNFTRoomLevel(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    bulkViewNotTransferable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[boolean[]]>;

    bulkViewSuits(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<[string[]]>;

    burn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    checkIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    decrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    decrNFTRoomLevelForValue(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    doubleDecrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    ownerOf(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string] & { owner: string }>;

    payoutForRefunder(
      _refunder: PromiseOrValue<string>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setNotTransferable(
      _tokendId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setSuit(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    viewCosts(
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    viewIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    viewNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    viewNotTransferable(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    viewSuits(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<[string]>;
  };

  _claimBurn(
    tokenId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  bulkViewCosts(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  bulkViewIsCommon(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<boolean[]>;

  bulkViewNFTRoomLevel(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  bulkViewNotTransferable(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<boolean[]>;

  bulkViewSuits(
    _tokenIds: PromiseOrValue<BigNumberish>[],
    overrides?: CallOverrides
  ): Promise<string[]>;

  burn(
    tokenId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  checkIsCommon(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  decrNFTRoomLevel(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  decrNFTRoomLevelForValue(
    _tokenId: PromiseOrValue<BigNumberish>,
    _value: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  doubleDecrNFTRoomLevel(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  ownerOf(
    tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  payoutForRefunder(
    _refunder: PromiseOrValue<string>,
    _value: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setIsCommon(
    _tokenId: PromiseOrValue<BigNumberish>,
    _value: PromiseOrValue<boolean>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setNFTRoomLevel(
    _tokenId: PromiseOrValue<BigNumberish>,
    _roomLevel: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setNotTransferable(
    _tokendId: PromiseOrValue<BigNumberish>,
    _value: PromiseOrValue<boolean>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setSuit(
    _tokenId: PromiseOrValue<BigNumberish>,
    _value: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  viewCosts(
    _roomLevel: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  viewIsCommon(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  viewNFTRoomLevel(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  viewNotTransferable(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<boolean>;

  viewSuits(
    _tokenId: PromiseOrValue<BigNumberish>,
    overrides?: CallOverrides
  ): Promise<string>;

  callStatic: {
    _claimBurn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    bulkViewCosts(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    bulkViewIsCommon(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<boolean[]>;

    bulkViewNFTRoomLevel(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    bulkViewNotTransferable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<boolean[]>;

    bulkViewSuits(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<string[]>;

    burn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    checkIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    decrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    decrNFTRoomLevelForValue(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    doubleDecrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    ownerOf(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;

    payoutForRefunder(
      _refunder: PromiseOrValue<string>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<void>;

    setNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setNotTransferable(
      _tokendId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: CallOverrides
    ): Promise<void>;

    setSuit(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    viewCosts(
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    viewIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    viewNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    viewNotTransferable(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<boolean>;

    viewSuits(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<string>;
  };

  filters: {};

  estimateGas: {
    _claimBurn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    bulkViewCosts(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bulkViewIsCommon(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bulkViewNFTRoomLevel(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bulkViewNotTransferable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    bulkViewSuits(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    burn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    checkIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    decrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    decrNFTRoomLevelForValue(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    doubleDecrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    ownerOf(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    payoutForRefunder(
      _refunder: PromiseOrValue<string>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setNotTransferable(
      _tokendId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setSuit(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    viewCosts(
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    viewIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    viewNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    viewNotTransferable(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    viewSuits(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    _claimBurn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    bulkViewCosts(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    bulkViewIsCommon(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    bulkViewNFTRoomLevel(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    bulkViewNotTransferable(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    bulkViewSuits(
      _tokenIds: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    burn(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    checkIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    decrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    decrNFTRoomLevelForValue(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    doubleDecrNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    ownerOf(
      tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    payoutForRefunder(
      _refunder: PromiseOrValue<string>,
      _value: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setNotTransferable(
      _tokendId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<boolean>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setSuit(
      _tokenId: PromiseOrValue<BigNumberish>,
      _value: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    viewCosts(
      _roomLevel: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    viewIsCommon(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    viewNFTRoomLevel(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    viewNotTransferable(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    viewSuits(
      _tokenId: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}