# MIP-58: Trusted-Relayer focused Bridge Design

- **Description**: Proposes a bridge design that capitalizes on the trust-assumption on the relayer, reduces the number of messages, and potentially cost.
- **Authors**: [Primata](mailto:primata@movementlabs.xyz)
- **Desiderata**: [MD-21](../MD/md-21)

## Abstract

This proposal advocates for replacing the current HTLC-based bridge design, which requires four transactions and introduces significant complexity, with a simpler and more efficient two-transaction mechanism. The proposed design reduces costs, enhances security, minimizes user friction, and avoids potential exploits caused by refund logic. It addresses long-standing issues such as reliance on sponsored transactions, outdated audits, and unimplemented fee mechanisms speeding the process to achieve a fully functional bridge that movement yet has been unable to complete, and lots of under issues raised and still pending.

## Motivation

The current bridge design poses numerous challenges, including inefficiency, cost, and user frustration:

1. **Transaction Complexity**: Requires four interactions:
   - Two by the user (initiation and finalization).
   - One by the relayer to complete the transaction.
   - One by a third party (tasked by the relayer) to finalize refunds in case of failure.
   - If any of these fails, users and the protocol face losses.
2. **High Cost**:
   - The multi-transaction setup is expensive for both users and the protocol.
   - Misestimations in fee calculations could result in significant losses.
   - Example: At 16 gwei, bridging costs $20 for 10k transactions. If fees are miscalculated by 25%, this leads to a $25k loss. At 100 gwei, the loss escalates dramatically.
3. **Unfriendly User Experience**:
   - The current design requires users to have funds on the destination chain for finalization. This increases friction and discourages adoption.
   - Sponsored transactions are essential to the current implementation but remain unimplemented, leaving users stranded without funds.
4. **Security Risks**:
   - Relayer keys are a critical point of failure. This assumption cannot be avoided.
   - Refund logic introduces vulnerabilities where attackers could exploit the rate limit and relayer downtime.
   - For instance, if the relayer fails to finalize on the initiator, a malicious actor could:
     - Take over the refund keys.
     - Exploit both directions of the bridge (e.g., ETH→MOVE and MOVE→ETH) repeatedly, draining funds.
5. **Maintenance Burden**:
   - The current audit is outdated and does not reflect the significant changes made since.
   - The current design requires a complete UI/UX overhaul, adding complexity and delay.
6. **Unnecessary Complexity**:
   - HTLC-based bridges are largely abandoned in favor of simpler, more effective designs.
   - Examples like the [Consensys HTLC](https://github.com/Consensys/htlc-bridge) bridge demonstrate the [pitfalls of such approaches](https://entethalliance.org/crosschain-bridges-overview-where-we-are-now/).
7. **Infrastructure Simplification**:
   - Infrastructure is still incomplete for the current HTLC bridge design and we are struggling to find sound solutions that balance UI/UX and security. For example, [this issue](https://github.com/movementlabsxyz/movement/issues/838) regarding UX vs number of confirmations to require on the Ethereum side, is still under debate.
   - Because of the over-engineered design, infrastructure is prone to error and we might end up being damaged by the amount of infrastructure we have not built yet and has to be built for the relayer to fully function.
   - We could strip down the Relayer code and achieve a final design much more quickly.

The proposed lock/mint bridge design mitigates these issues, creating a safer, faster, and user-friendly bridge while maintaining operational reliability.

## Specification

The lock/mint bridge design focuses on minimizing complexity and maximizing security:

### Protocol Description

The bridge is a simpler version of the current implementation, which relies on the assumption that the Relayer Keys are not to be compromised.

L1 -> L2

1. User initiates a bridge transfer on L1. Contract stores a mapping of the user bridgeTransferIds for easy access. It transfers from the user MOVE amount to the contract. Transaction emits originator, recipient, amount and nonce.
2. Relayer awaits for finalization of the transaction on L1.
3. Relayer completes the bridge on L2.
4. Completion transaction verifies that the transaction is truthful by comparing the provided bridgeTransferId hash and the emitted values of originator, recipient, amount and nonce. Finally, it mints MOVE to the recipient address.
5. User is notified on the frontend that their transaction has been completed.
6. In case of a rare case of a reorg on the recipient network that leads to the transaction removal from the user perspective, the transaction can be redone and relayer multisig can handle it.

![L1-L2](L1ToL2.png)

L2 -> L1

1. User initiates a bridge transfer on L2. Contract stores a mapping of the user nonce to bridge details for easy access. It transfers from the user MOVE amount to the contract and burns it. Transaction emits originator, recipient, amount and nonce.
2. Relayer awaits for finalization of the transaction on L2.
3. Relayer completes the bridge on L1.
4. Completion transaction verifies that the transaction is truthful by comparing the provided bridgeTransferId hash and the emitted values of initiator, recipient, amount and nonce. Finally, it transfers MOVE to the recipient address, which has been previously bridged from L1.
5. User is notified on the frontend that their transaction has been completed.
6. In case of a rare caase of a reorg on the recipient network that leads to the transaction removal from the user perspective, the transaction can be redone and relayer multisig can handle it.

![L2-L1](L2ToL1.png)

### Key Features

1. **Lock/Mint mechanism**:
   - **Initiation**: User sends a transaction to initiate the bridge containing recipient and amount.
   - **Completion**: A relayer or multi-signature group completes the transfer on the counterparty contract with the originator, recipient, amount and noce for hash verification.
   - **No Funds Requirement**: User is not required to have funds on receiving chain and we do not have to build sponsored transactions.
   - **Delivery by Relayer**: Because the relayer delivers the funds, there is no requirement for the user to complete the transaction on receiving chain, therefore massively simplifying the user experience and allowing a smooth onboarding on the network for bridges from L1 to L2. User only has to await for the finalization on the source chain and for the relayer to perform the completion on receiving chain. This is standard practice for every major bridge in the ecosystem.
   - **Less parameters**: Because there is no exchange of secrets between the user and relayer, we have a substantial reduction of logic.
   - **Only Completable**: Currently we reserve a refunder role to revert transactions. This approach is different where we guarantee delivery of funds through the same party that would guarantee funds being refunded, because bridges can ONLY be completed.

2. **Consolidation of Logic**:
   - Merge lock and completion functionality on the counterparty contract. Once lock is called, funds are already in the control of the user. On the HTLC implementation, once the timelock is over and complete on initiator has not been called, both the initiator and counterparty funds are available to the user, opening up for an exploit.
   - Remove refund functionality entirely to eliminate associated exploits.

3. **Parameter Validation**:
   - Ensure parameter validation on the counterparty to prevent invalid transactions.

4. **Relayer Redundancy**:
   - Use two types of relayers:
     - **Automated Relayer**: Operated with minimal human involvement; its private key is highly secured.
     - **Multi-Signature Relayer**: Managed by the team to guarantee transaction completion in case of failures.

5. **Cost Efficiency**:
   - Minimize gas costs by reducing the number of interactions and simplifying fee calculations.

6. **Enhanced Security**:
   - Avoid refund logic to close exploit windows.
   - Protect against key compromise through key isolation or known by no parties and multi-signature relayer setups.
   - There is no scenario where a bridge could lead to double-spending. It's either completed by relayers or not.
   - User currently can loose its bridge `preImage` which could lead to them being unable to complete the bridge. By not relying on a `preImage` from the user, it minimizes issues. It is not a loss in security because the purpose of the `preImage` is solely for refunding.

7. **Batch Processing for Downtime**:
   - Multi-signature relayers can process multiple pending transactions in a single batch during downtime.

8. **BridgeTransferId**:
   - Continue using unique identifier to prevent double-spending and track transactions securely.

9. **Bridge Fee**:
   - On the L1 to L2 bridge, do not charge fees.
   - On the L2 to L1 bridge, charge a fee estimated by admin. It's set to the gas spent in ethereum in move. This requires an oracle and can only be implemented after oracles are live and we are able to have a maintainer that is able to set the fees on L2.
   - Bridge fee should be a estimated by being a threshold between the current cost to perform the completeBridgeTransfer transaction on L1 (aka. `cost`) + 20%. Then, we set `cost` as the `upperbound`. The `lowerbound` is the `cost` - 10%. This prevents us from updating the fee too often and guaranteeing profit on bridges. We do have to consider gas spikes, but it should be a momentarily loss compensated by the extra charged and maintained by the `upperbound` and `lowerbound`.

   ```
   entry fun set_fee(caller: &signer, fee: u64) {
      assert_is_maintainer(caller);
      borrow_global<BridgeConfig>(@aptos_framework).fee = fee;
   }
   ```

10. **Best Practices**:
   - Adopt currently used bridge designs from established designs like Arbitrum, LayerZero and Blast bridges which use a relayer to finalize the bridge.
   - User is not required to have funds on counterparty contract to finalize the bridge.

## Exploits and Potential Losses

1. **Key Compromise**:
   - The compromise of the Relayer keys would lead to unauthorized transactions up to the rate-limit value. The protocol must absorb the losses and rotate Relayers.
2. **Fee Misestimation**:
   - Incorrect fee calculations (e.g., underestimating gas) can cause significant financial losses for the protocol.

## Reference Implementation

1. **Two-Transaction Flow**:
   - User initiates the transfer.
   - Relayer or multisig completes the transfer with parameter validation.
   - Current HasuraDB built internally can provide enough infrastructure for users to know if their transaction has been completed. It does not differ from the current design in any way since user is not able to see if their transaction is in-flight. We could introduce this by notifying the user if the relayer has been ordered to complete the transaction.
   - There would be two states for user to reference, initiated or completed and those are the only two possible states. Funds can only be returned by bridging back.

   ![Transaction History](tx-history.png)
   Here users would be able to see if the bridge has been completed. It's either pending or completed.

2. **Batch Completion**:
   - Multisig relayers process pending transactions in batches during downtime, ensuring timely resolution.

3. **Contract Simplification**:
   - Combine lock and completion functionality on the counterparty contract.
   - Remove refund logic to streamline operations and improve security.
   - Cheaper transactions because of reduction of logic.
   - Consolidate Initiator and Counterparty into a single contract (this might be the most dangerous thing proposed but it has already been proposed for current implementation).

4. **Rate Limiting**:
   - Rate limiting should be implemented on the L1 and maps each day to a budget, for each direction. Once the budget is reached on one of the directions, no more tokens can be transferred on that direction. The bridge is financially secured by an insurance fund maintained by Movement Labs and the maximum amount of tokens to be transferred per day, per direction is one quarter of the insurance fund balance. This is meant to account for the insurance fund to be able to insure all current funds already transferred and all tokens inflight, per direction.

5. **Bridge Fee**:
   - When bridging from L1 to L2, the protocol, through the Relayer, sponsors the gas cost on Movement. We do not need to make any modification on contracts or Relayer to support it.
   - When bridging from L2 to L1, we have a few viable solutions but it's preferrable to highlight two.
      1. Relayer sets a fee on L2, a global variable that can be set at any given time. Considering that block validation time on L1 is bigger than on L2, it becomes a viable approach since L2 can rapidly adjust the fee according to the current block and always charge an above gas cost fee to assure that despite hiccups, the bridge is net positive. $MOVE is deducted from the amount of tokens that are currently being bridged and transferred to a funds manager. Input of the user is on the final value of tokens that it should receive on the L1. This gives the protocol a very reliable way to estimate how much MOVE will be charged and feed to the user a precise amount of tokens.
      2. Enable the Relayer to specify on the L1 completeBridgeTransfer transaction, the bridge fee per transaction. The amount is deducted from the total amount of tokens that were bridged and transferred to a funds manager. The dangerous situation is that we expect to way for over 10 minutes before the transfer can occur, and this could lead to a big disparity between the expected amout of funds and the actual amount of tokens received.


[Solidity Implementation](https://github.com/movementlabsxyz/movement/tree/primata/simple-native-bridge)

[Move Implementation](https://github.com/movementlabsxyz/aptos-core/tree/andygolay/simplified-bridge)

## Verification

1. **Correctness**:
   - Simulate multiple transaction scenarios to ensure robustness.
   - Test edge cases, including relayer downtime and batch processing.

2. **Security Implications**:
   - Conduct audits focused on the simplified design.
   - Implement rate-limiting safeguards and validate parameters in contracts.

3. **Performance Impacts**:
   - Benchmark gas costs and transaction throughput.

4. **Validation Procedures**:
   - Perform an audit and thorough testing, alongside an open invite to the community to verify the bridge.
   - Seek community feedback and incorporate suggestions.

## Appendix

### A1: Related Issues

- [Movement Issue #838](https://github.com/movementlabsxyz/movement/issues/838)
- [Movement Issue #842](https://github.com/movementlabsxyz/movement/issues/842)

### A2: Gas Cost Comparison

- **Current Design**: ~400k gas per bridge round trip.
- **Simplified Design**: ~200k gas per bridge round trip.

### A3: Referenced Designs

- [Arbitrum Bridge](https://bridge.arbitrum.io/?destinationChain=arbitrum-one&sourceChain=ethereum)
- [Blast Bridge](https://docs.blast.io/building/bridges/mainnet)

---

## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).
