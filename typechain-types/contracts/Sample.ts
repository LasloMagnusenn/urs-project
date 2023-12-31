/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
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

export interface SampleInterface extends utils.Interface {
  functions: {
    "callError()": FunctionFragment;
    "callMe()": FunctionFragment;
    "caller()": FunctionFragment;
    "get()": FunctionFragment;
    "message()": FunctionFragment;
    "pay(string)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "callError"
      | "callMe"
      | "caller"
      | "get"
      | "message"
      | "pay"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "callError", values?: undefined): string;
  encodeFunctionData(functionFragment: "callMe", values?: undefined): string;
  encodeFunctionData(functionFragment: "caller", values?: undefined): string;
  encodeFunctionData(functionFragment: "get", values?: undefined): string;
  encodeFunctionData(functionFragment: "message", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "pay",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(functionFragment: "callError", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "callMe", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "caller", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "get", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "message", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pay", data: BytesLike): Result;

  events: {};
}

export interface Sample extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: SampleInterface;

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
    callError(overrides?: CallOverrides): Promise<[void]>;

    callMe(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    caller(overrides?: CallOverrides): Promise<[string]>;

    get(overrides?: CallOverrides): Promise<[BigNumber]>;

    message(overrides?: CallOverrides): Promise<[string]>;

    pay(
      _message: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  callError(overrides?: CallOverrides): Promise<void>;

  callMe(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  caller(overrides?: CallOverrides): Promise<string>;

  get(overrides?: CallOverrides): Promise<BigNumber>;

  message(overrides?: CallOverrides): Promise<string>;

  pay(
    _message: PromiseOrValue<string>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    callError(overrides?: CallOverrides): Promise<void>;

    callMe(overrides?: CallOverrides): Promise<void>;

    caller(overrides?: CallOverrides): Promise<string>;

    get(overrides?: CallOverrides): Promise<BigNumber>;

    message(overrides?: CallOverrides): Promise<string>;

    pay(
      _message: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    callError(overrides?: CallOverrides): Promise<BigNumber>;

    callMe(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    caller(overrides?: CallOverrides): Promise<BigNumber>;

    get(overrides?: CallOverrides): Promise<BigNumber>;

    message(overrides?: CallOverrides): Promise<BigNumber>;

    pay(
      _message: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    callError(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    callMe(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    caller(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    get(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    message(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    pay(
      _message: PromiseOrValue<string>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
