# MD-121: Verified Message Channels (VMC)

- **Description**: Requests verified messages channels as an alternative, cost effective, and ergonomic API to introduce programmable data on-chain. 
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Approval**: 

## Overview

Transactions are expensive containers for some kinds of state transitions. Many dApps already use off-chain mechanisms to aggregate signed user behavior. We request an additional type of channel that allows for cheap submission of data and ergonomic usage thereof.

We believe this API should resemble a pub/sub channel, with topics to which users can publish signed messages and to which smart contract logic can subscribe. We assert ordering of messages on each channel be can independent of each other, making the VMC system on the whole partially-ordered. 

We request a variety of features for programming VMC. Some of these features are mutually exclusive from one another. We do not expect a VMC implementation to meet all desiderata, but instead that MIPers would implicitly or explicitly ascribe to sub-standards.

```rust
// imperative usage
while (!vmc::empty(b"dapp_inputs") {
   let data = vmc::pop(b"dapp_inputs");
   dapp_transition(data);
}

// declarative/combinator-based usage
pipe(b"dapp_inputs", dapp_lazy_combinator, b"dapp_outputs");

dapp_reify(vmc::of(b"dapp_ouputs"), user_index);
```


## Desiderata

### D1: Topic-based API for receiving stream messages

**User journey**: VMC Senders should be able to submit messages to a channel identified `(move_module, topic)`. Smart Contract Developers should be able to read off of this stream within the module in which it was declared. 

**Justification**: The API to which the messages are posted and the smart-contract complement are the two core interfaces of VMC.

**Recommendations**:
1. There are several conceivable ways to declare and access the channel:
    1. Senders and Developers MAY refer to a byte string, e.g., `b"topic"`.
        - Working with the channel would then take a form similar to `vmc::pop(b"dapp_inputs");`.
        - Developers MAY have the module prefix abstracted away within the context of a module. 
        - Senders MUST prefix with a module identifier. 
        - An allowed channels list of byte strings could be initialized with the module to prevent DoS attacks by spamming unprocessed topics. 
    2. Developers MAY declare a `struct Topic {}`. 
        - This MAY have the added benefit of structuring the message type to be sent on the channel. 
        - Senders MAY then use the usual move type serialization when posting to a given channel. 
        - An additional macro `#[topic]` could be added to prevent DoS attacks by spamming unprocessed topics, similar to the [`#[event]`](https://github.com/aptos-foundation/AIPs/blob/main/aips/aip-44.md) macro.
    3. Developers MAY refer to a new class of objects `topic MyTopic {}`.
        - This MAY be useful if topics take a particularly exotic form. See [D.4](#d4-combinator-api) for combinator usage. 

### D2: Partial ordering mechanism for topics

**User journey**: VMC Senders and Developers SHOULD NOT be constrained by total-ordering throughput. VMC messages SHOULD be ordered w.r.t. other messages on the same topic. 

**Justification**: To deterministically process VMC messages, an order will need to be determined. For safe processing on-chain, subsets of this order would likely need to be mapped to block heights where they are first available. However, this does not mean that the ordering of all messages needs to follow total-order constraints. 

**Recommendations**:
1. Review [Narwhal/Bullshark](https://arxiv.org/abs/2201.05677) for viable partial-order finalizing consensus. 

### D3: Gas fee API

**User journey**: VMC Developers SHOULD be able to charge gas fees to users for submitting messages.

**Justification**: Gas fees for any kind of processing are crucial to (a) fairness, (b) utility, and (c) sybil and DoS resistance. 

**Recommendations**:
1. There are several conceivable ways to charge gas fees:
    1. Require the Sender to lock up funds in the module which processes and `topic`. Then, simply allow the Developer to deduct from these funds when the message is processed. 
        - This minimizes opinionization of the core API.
        - However, validation that the user has funds for a message would need to be performed within the contract--leaving some possibility for DoS. 
        - If some native gas is charged for each VMC message, then perhaps the sybil resistance is strong enough to render the DoS vector impracticable. 
    2. Generalize the [intents framework](https://github.com/aptos-foundation/AIPs/pull/511) to allow the Receiver of an intent to perform a critical section with the Sender's signer. 
        - How to validate that the correct intent is submitted becomes a similar problem to the validation above. 
    3. Extend the `Account` framework to associate each account with a VMC account. The Sender then moves funds into the VMC account extension for a given topic. The Developer declares the type of and minimum amount of funds to be used for the `topic`--which are prevalidated in the channel ordering system. Finally, when processing the message, the Developer receives an `&vmc_signer`--which is a special type allowing the Developer to spend the funds from the account for the topic. 
        - In this API, and in general, we are shifting the risk of gas attack to the dApp. The user could still figure out how to send a message that requires more processing than the funds they've locked up. 
        - It may be possible to move the pre-validation into a procedure for which the Developer provides a callback method. In theory, this would be read-only so not generate new dependencies and thus could be run in parallel to normal execution. 
    4. Allow the user to attach a form of UTXO object to the message which can be spent, swapped, or similar for gas. 
        - This is likely a refinement of [2], i.e., some kind of variation on the [intents framework](https://github.com/aptos-foundation/AIPs/pull/511). 

### D4: Combinator API

**User journey**: VMC Developers and Clients of VMC dApps should be able to access an ergonomic API for computing and combining over topics. 

```rust
// compute and combine
pipe(b"dapp_inputs", dapp_lazy_combinator, b"dapp_outputs");

// unwrap a value
dapp_reify(vmc::of(b"dapp_ouputs"), user_index);
```

**Justification**: The low-level benefit of the VMC API is that it provides an eventual guarantee that your partially-ordered messages will have a sync point with the total-ordered L1. This is a useful guarantee for operations that need to work with more sensitive or global state--e.g., account balances, data from other applications, etc. Naively, it is otherwise a form of ordering that dApps could program off-chain with their own DLT. 

However, we assert that there are many forms of computation that lie in between--i.e., which benefit from some kind of on-chain wrapping, intent, promise, closure, etc. which is later unwrapped either on-chain or off-chain. 

**Recommendations**:
1. We anticipate the expressiveness of any Combinator API will be a challenge. We believe it essentially requires a metaprogramming API wherein you will be able to mix some immediate operations, e.g., charge account, update wins-losses table, transfer NFT, with some operations that are captured in a closure. 
2. The prospect of unwrapping on-chain poses the possibility of unwrapping a very large dependency graph of combined operations over a topic. How to provide sane ways to address this possibility will likely be a breaking point for the feasibility of this API. 

## Changelog
