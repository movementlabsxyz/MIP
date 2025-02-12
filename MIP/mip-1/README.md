# MIP-1: ENTL (Enclave Nonce Time-lock)

- **Description**: ENTL proposes a simple challenge-reponse protocol to link Enclave usage to a given program. It additionally proposes a means of time-locking to allow the replacement of said program while maintaining security.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Desiderata**: [MD-1](../../MD/md-1)
- **Approval**: :white_check_mark:

## Abstract

ENTL proposes a simple challenge-response protocol to link Enclave usage to a given program. It additionally proposes a means of time-locking to allow the replacement of said program while maintaining security. This approach is demonstrated to be both generalizable and cryptographically sound.

## Motivation

This protocol was originally suggested as a solution to minimizing trust assumptions in the Atomic Bridge under [MD-1](../MD/md-1). However, similar problems were encountered under Movement Labs Governance Stage 0 concerning general key usage.

## Specification

_The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174._

### Protocol Description

The protocol is a simple challenge-response scheme performed between two parties: the Enclave, a presumed secure compute unit, and the Client, the program requesting the Enclave's services.

The following messages types are exchanged between the Enclave and the Client:

- **SYN**: the Client sends a 256-bit nonce to the Enclave.
- **SYN-OK**: the Enclave responds indicating it has received and accepted the nonce. This can be sent as a response to either SYN or SYN-CHECK.
- **SYN-TL**: the Enclave responds indicating it has the received the nonce and subjected it to a time-lock and queuer. The time-lock and place in the queue are provided as response.
- **APP**: the Client sends an application message to the Enclave, a 256-bit nonce for the current message, and a 256-bit nonce for the next message.
- **APP-OK**: the Enclave responds indicating it has processed the application message and has updated the nonce for the next message.
- **APP-OK-CON**: the Enclave responds indicating that it has processed the application message, has updated the nonce for the next message, and has aborted a contentious synchronization attempt.
- **APP-REJ**: the Enclave responds indicating it has received the application message but is rejecting it and will not update the nonce for the next message.

These messages are exchanged as follows:

**Synchronization Phase**

1. Prior to sending its first application message, the Client generates and safely stores CSPRNG nonce and sends it to the Enclave in a SYN message.
2. The Enclave processes the SYN message:
    - If enclave does not have a stored nonce, this indicates that no other client has attempted to synchronize with the Enclave. The Enclave MUST accept the nonce, store the nonce, and respond with a SYN-OK message.
    - If the Enclave has a record of the nonce, this indicates that another client has attempted to synchronize with the Enclave in the past. It MUST check queue and time-lock conditions:
        - If the nonce is at the top of the queue and has passed its time-lock, the Enclave MUST accept, store, and respond with a SYN-OK message.
        - If the nonce is not at the top of the queue or has not passed its time-lock, the Enclave MUST respond with a SYN-TL message.

**Application Phase**

1. The Client sends an APP message to the Enclave with the application message and the nonce for the current message and the nonce for the next message.
2. The Enclave processes the APP message:
    - If the nonce for the current message is the expected nonce, the Enclave MUST process the application message and update the nonce for the next message. It MUST responds with an APP-OK message.
    - If the nonce for the current message is not the expected nonce, the Enclave MUST respond with an APP-REJ message.
    - If the nonce for the current message is the expected nonce but the Enclave has nonces in its time-lock queue, i.e., from other SYN messages, the Enclave MUST:
        1. Empty the queue of all other nonces;
        2. Process the application message;
        3. Respond with an APP-OK-CON message.
3. The Client MUST wait for an APP-OK, APP-REJ, or APP-OK-CON message before sending the next application message.
    - If the message is APP-OK or APP-OK-CON, the Client MUST send the next application message with the "next nonce" specified in the previous message.
    - If the message is APP-REJ, the Client MUST re-send the application message with the "current nonce" it used in the previous message.

### Example Application: Atomic Bridge Service

To demonstrate how this protocol can be used, consider the Atomic Bridge Service.

To minimize trust in MLABSO, an enclave is booted which generates its own signing keys and is prepared to sign transactions to send to bridge contracts. This enclave can additionally be tooled with other application messages handlers to, for example, allow for the replacement of an initial trusted and directly accessible signing key.

Once the enclave has been configured, the MLABSO configures the bridge service software to start signing transactions via ENTL protocol. It synchronizes for a nonce which is immediately accepted as it is the first SYN message. The bridge service then exchanges application messages with the enclave to sign transactions. The bridge service never directly accesses the signing key, only sending application messages to the enclave.

A MLABSO is informed that the bridge service needs to be upgraded. Because the previous bridge service securely stored its nonce (challenges related to this discussed below), the MLABSO will need to rely on the ENTL protocol to run a new synchronization phase. This enforces a time-lock of say 20 minutes before the new bridge service has been synchronized with the enclave and can continue signing transactions.

Now, a malicious MLABSO decides to attempt to abuse the key. She knows she cannot directly access the key. She also knows that she will not be able to use the key until the program has synchronized to a nonce she controls. She deems discovering or replacing the nonce used in the existing program intractable. So, she must stop the service and start a new synchronization phase. This will time-lock the service for 20 minutes. However, in the end, she will have the ability to sign with the key. The MLABSO begins the synchronization phase. However, during this time, a legitimate MLABSO notices that the bridge service is being upgraded (perhaps even that it is down). The legitimate MLABSO then reviews access logs to discover the malicious MLABSO's actions. The malicious MLABSO and her program are then removed from the system before the new bridge service can be synchronized.

### Practical Considerations

In practice, there are several phenomena regarded as external to the ENTL protocol which need to be considered in order to make it safely usable.

#### Securing the Nonce

In order to avoid the possibility of malicious usage, both the current nonce and the next nonce need to be stored in a manner that is difficult to access except by the current program. We do not intend to impose cryptographically secure requirements on this storage, as that begins to invoke concepts related to the literature on succinct arguments for programs. However, there are several simpler ways that can make accessing the and using the outside  nonce difficult.

To describe these, it first helps to consider what enables a nonce attack and to consider the time these operations take.

1. The attacker must first obtain the nonce which takes some duration $d_E = t_E' - t_E$.
2. The attacker then must use the nonce to send in an APP message which the Enclave will process. This takes some duration $d_S = t_S' - t_S$.
3. In total, we may say the attack takes some duration $d_A = t_S' - t_E'$.
4. Meanwhile, the legitimate Client will have some duration $d_L = t_L' - t_L$ over which the nonce is stored as either the current or next nonce and has not yet been used.
5. The period between when the legitimate Client first stores this nonce and when the Enclave would process it is bounded by a time $t_S'$ wherein the attacker sends the malicious APP message and $t_L$.

This model of an attack leads to several prevention strategies:

- **High Temporal Resolution**: frequently updating the nonce narrows the window $d_L$ in which the attacker can obtain the nonce and use it before the legitimate Client does. If this exceeds, the time to obtain the nonce and send it, i.e., $d_A$, the attack is impossible. It may thus be ideal for the Client to update the nonce even without a message that corresponds to is APP logic.
- **Security via Obscurity**: the implication throughout this MIP is that Client stores its nonce in program memory. As program memory is highly-dynamic, particularly on the stack, it would be difficult to identify the location of the nonce in memory, increasing $d_A$. This is a form of security via obscurity which could be further upgraded by data structures which further randomize the location of the nonce in memory.
- **ISA-specific Approaches**: there a number of ISA-specific tools which can used to make accessing certain sections of memory very difficult for even though most privileged attackers. Consider reviewing [Intel TSX](https://www.intel.com/content/www/us/en/developer/articles/community/exploring-tsx-with-software-development-emulator.html#:~:text=Intel%C2%AE%20Transactional%20Synchronization%20Extensions%20(Intel%C2%AE%20TSX)%20is%20perhaps,%E2%84%A2%20microarchitecture%20code%20name%20Haswell.) and [ARM PAC](https://www.qualcomm.com/content/dam/qcomm-martech/dm-assets/documents/pointer-auth-v7.pdf).
- **ENTL Hot Potato and Generalizations**: the ENTL protocol can be made bidirectional and two-staged such that the Enclave also synchronizes a nonce with the Client which it expects the Client to echo with the eventual APP message. This could further reduce the time the ultimate nonce is stored in the Client's memory and increase the time the attacker must spend to obtain and use the nonce. Generalizations and variations of this protocol could use more parties and commit-reveal schemes like Pedersen commitments to further secure the nonce.

#### Crash Resistance and Recovery

Enclave products such as [AWS Nitro Enclaves](https://aws.amazon.com/ec2/nitro/nitro-enclaves/) and [Intel SGX](https://www.intel.com/content/www/us/en/products/docs/accelerator-engines/software-guard-extensions.html)-based products generally [do not allow backups](https://ieeexplore.ieee.org/document/9743462). This means that if you were to generate keys within an enclave, as suggested above, you may not be able to recover them if the enclave crashes.

Several suggestions are made to resolve this problem in [MD-2](../MD/md-2).

## Reference Implementation

## Verification

ENTL assumes a valid Client program is one that (1) can provide the correct nonce and (2)

## Changelog

## Appendix
