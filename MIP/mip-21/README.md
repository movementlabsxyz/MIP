# MIP-21: Bridge Based on Attestors
- **Description**: Proposal for simplifying the bridge mechanism using an attestor-based approach inspired by USDC's CCTP, reducing friction, cost, and complexity for Layer 2 onboarding.
- **Authors**: [Primata](mailto:primata@movementlabs.xyz)

## Abstract

A bridge mechanism is essential for any Layer 2 solution, serving as the user's first interaction with the network. This process must be smooth and frictionless, ensuring that dealing with tokens on L1 and bridging to native gas tokens on L2 does not overcomplicate the user experience. The bridge must balance user onboarding, cost-efficiency, and simplicity, while minimizing transaction complexity. We propose a bridge based on attestors, inspired by the [Cross-Chain Transfer Protocol](https://developers.circle.com/stablecoins/cctp-getting-started) (CCTP) by USDC, which offers an elegant solution to these challenges.

## Motivation

Our current bridge solution has been increasing in complexity with each iteration. Originally requiring three on-chain transactions, it now requires four, initiate bridge, lock, complete source chain, complete target chain. Additionally, the bridge does not currently support gas charging mechanisms to prevent exploits, and ongoing discussions are leaning toward adding further components, making it even more complex and computationally expensive.

We believe the best approach is to draw from live implementations that have achieved a streamlined user experience with minimal cost to the user. One such example is USDC's [CCTP](https://www.circle.com/en/cross-chain-transfer-protocol), which offers simplicity, security, and efficiency in cross-chain bridging. Instead of increasing the complexity of our current bridge design, we should aim to adopt this proven mechanism.

## Specification

The Cross-Chain Transfer Protocol (CCTP) operates using a set of attestors that validate all bridge transactions occurring between chains. These attestors listen for bridge events, confirm the validity of transactions, and, if necessary, revert them by providing appropriate proofs. A transfer allowance managed by a centralized authority further ensures that breaches are mitigated by limiting the amount of value transferred.

To align with this approach and reduce complexity:

- **Bridge Relayer as Attestor**: The Bridge Relayer in our system will function as an attestor, operating via a multisig scheme (i.e. the attestor collects signatures from a threshold number of comittee members that approve of the message). This relayer, through aggregated signatures, produces a proof on a signed message.  

- **User Interaction**: Users, or other parties interested in completing the bridge, retrieve their funds on the target chain by submitting the signature and message.

- **Validation Mechanism**: The off-chain signature produced by the multisig scheme is verified against the message on-chain. As a reference, we could use the same automation scheme as the [MIP-18 Stage 0 Upgradeability and Multisigs](https://github.com/movementlabsxyz/MIP/pulls).
The challenge is to make sure that the signature is only used once so no transaction is replayed, but the beauty is that the signature is provided by a multi-party system that do not need to provide onchain signatures. It's also important to use a solid architecture that prevents hash mining attacks.
Relying on a protocol like CCTP that has been tested in live environments significantly reduces the risk of any unexpected utilization of off-chain and on-chain proofs.  

Or on Circle's own words:

1. An on-chain component on source domain emits a message.
2. Circle's off-chain attestation service signs the message.
3. The on-chain component at the destination domain receives the message, and forwards the message body to the specified recipient.

This results in 2 onchain transactions and 1 offchain transaction. Comparatively, HTLC requires 4 onchain transactions.

This approach minimizes the need for additional components and avoids the reliance on synthetic assets, leading to a simplified and cost-effective bridge solution.

### Flow

1. **User Deposits**:  
   - The user deposits tokens on the source chain, which triggers a deposit event.
   
2. **Bridge Relayer**:  
   - The Bridge Relayer, listening for the deposit event, picks up the message or messages associated with the deposit.
   
3. **Multisig Signing**:  
   - The multisig party signs the bridge transaction. The combination of signatures produces an aggregated signature that ties the signatures to the message.

4. **Target Chain Verification**:  
   - On the target chain, the aggregated signature and the message are used to verify the validity of the bridge transaction. The withdrawal can only occur if the multisig-provided signature is valid.

5. **User Withdrawal**:  
   - Once the signature is verified, the user can withdraw the corresponding funds on the target chain.

This process is bi-directional, allowing funds to be bridged between Layer 1 and Layer 2, and vice versa, with minimal complexity and friction.

## Reference Implementation

For more details on how this model operates, refer to USDC's Cross-Chain Transfer Protocol (CCTP) documentation:  
[USDC CCTP Overview](https://developers.circle.com/stablecoins/docs/generic-message-passing)

## Verification

### 1. **Correctness**: 
The correctness of this proposal can be established by leveraging the success of CCTP, which has been operational and widely adopted.

### 2. **Security Implications**:
The use of a multisig setup adds a layer of security, with aggregated signatures preventing unauthorized access. The transfer allowance mechanism further mitigates potential breaches by limiting how much can be transferred.

### 3. **Performance Impacts**:
Because we would use a multisig off-chain signature to complete bridges, the set of attestors and the multisig address to produce the signature that we have to check the message against it could be the same set of the L2 Settlement signers.
This method reduces the computational overhead associated with multiple on-chain transactions and simplifies the bridge process. The reliance on a proven mechanism ensures minimal performance degradation. It also provides a bridging service with 1:1 bridging with minimal logic that could be potentially used for exploits.
It could also facilitate aggregating bridges since a merkle root could be used to handle the validity of the logic.

### 4. **Validation Procedures**:
Formal and machine-aided validation of the off-chain signature and on-chain message handling will be crucial for ensuring the correctness of this proposal.

### 5. **Peer Review and Community Feedback**:
The proposal is subject to review and feedback from the Movement Labs team and the wider community to ensure that it meets the needs of the ecosystem.

## Errata

Any post-publication corrections or updates will be documented in this section to maintain transparency and accuracy.

## Appendix

- [R1] USDC Cross-Chain Transfer Protocol: https://www.circle.com/en/cross-chain-transfer-protocol
- [R2] USDC CCTP Overview: https://developers.circle.com/stablecoins/docs/generic-message-passing

---

This proposal leverages an attestor-based bridge model to create a frictionless, efficient, and secure cross-chain experience for Movement technologies.
