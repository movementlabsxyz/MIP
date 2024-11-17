# MIP-28: Simplified Bridge Design

- **Description**: Proposes a simplified bridge design to address inefficiencies, security risks, and high costs in the current implementation.
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
   - Sponsored transactions are essential but remain unimplemented, leaving users stranded without funds.
4. **Security Risks**:
   - Relayer keys are a critical point of failure.
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

The proposed two-transaction design mitigates these issues, creating a safer, faster, and user-friendly bridge while maintaining operational reliability.

## Specification

The simplified bridge design focuses on minimizing complexity and maximizing security:

### Key Features

1. **Two-Transaction Model**:
   - **Initiation**: User sends a transaction to initiate the bridge.
   - **Completion**: A relayer or multi-signature group completes the transfer on the counterparty contract.

2. **Consolidation of Logic**:
   - Merge lock and completion functionality on the counterparty contract. Once lock is called, funds are already in the control of the user. Once the timelock is over and complete on initiator has not been callde, both the initiator and counterparty funds are available to the user.
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

9. **Best Practices**:
   - Adopt currently used bridge designs from established designs like Arbitrum, LayerZero and Blast bridges which use a relayer to finalize the bridge.
   - User is not required to have funds on counterparty contract to finalize the bridge.

## Exploits and Potential Losses

1. **Rate-Limit Exploits**:
   - If the relayer is down, an attacker could exploit refund functionality to repeatedly bridge funds within the rate limit.
2. **Key Compromise**:
   - Relayer or refund keys could be compromised, leading to unauthorized transactions.
3. **Fee Misestimation**:
   - Incorrect fee calculations (e.g., underestimating gas) can cause significant financial losses for the protocol.
4. **User Abandonment**:
   - High costs and complexity deter users, leading to lower adoption and reputational damage.

## Reference Implementation

1. **Two-Transaction Flow**:
   - User initiates the transfer.
   - Relayer or multisig completes the transfer with parameter validation.
   - Current HasuraDB built internally can provide enough infrastructure for users to know if their transaction has been completed. It does not differ from the current design in any way since user is not able to see if their transaction is in-flight. We could introduce this by notifying the user if the relayer has been ordered to complete the transaction.

2. **Batch Completion**:
   - Multisig relayers process pending transactions in batches during downtime, ensuring timely resolution.

3. **Contract Simplification**:
   - Combine lock and completion functionality on the counterparty contract.
   - Remove refund logic to streamline operations and improve security.
   - Cheaper transactions because of reduction of logic.
   - Consolidate Initiator and Counterparty into a single contract (this might be the most dangerous thing proposed but it has already been proposed for current implementation).

Initiator

```solidity
using EnumerableSet for EnumerableSet.Bytes32Set;

mapping(address users => EnumerableSet.Bytes32Set bridgeTransferIds) bridgeTransfers;

bridgeTransfers
function initiateBridge(uint256 recipient, uint256 amount) external returns (bytes32 bridgeTransferId)
    {
        address originator = msg.sender;

        // Ensure there is a valid amount
        require(amount > 0, ZeroAmount());

        // Transfer the MOVE tokens from the user to the contract
        if (moveToken.transferFrom(originator, address(this), amount)) revert MOVETransferFailed();

        // Generate a unique nonce to prevent replay attacks, and generate a transfer ID
        bridgeTransferId =
            keccak256(abi.encodePacked(originator, recipient, amount, ++_nonce));

        // We have all bridgeTransferIds available by user because we don't have to re-access it.
        bridgeTransfers[originator].add(bridgeTransferId); 

        emit BridgeTransferInitiated(bridgeTransferId, originator, recipient, amount, _nonce);
        return bridgeTransferId;
    }

function completeBridgeTransfer(
        bytes32 bridgeTransferId,
        bytes32 originator,
        address recipient,
        uint256 amount,
        uint256 nonce
        ) external onlyRole(RELAYER_ROLE) {
         require(bridgeTransferId == keccak256(abi.encodePacked(originator, recipient, amount, nonce)), InvalidBridgeTransferId());
        if (moveToken.transfer(recipient, amount)) revert MOVETransferFailed();
        emit BridgeTransferCompleted(bridgeTransferId, originator, recipient, amount, nonce);
    }
```

```move
// tbd
```

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
