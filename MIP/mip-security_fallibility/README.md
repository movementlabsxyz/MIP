# MIP-\<number\>: Security Assumptions and Fallibility
- **Description**: ????
- **Authors**: Richard, [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)

<!--
  READ MIP-1 BEFORE USING THIS TEMPLATE!

  This is the suggested template for new MIPs. After you have filled in the requisite fields, please delete these comments.

  Note that an MIP number will be assigned by an editor. When opening a pull request to submit your MIP, please use an abbreviated title in the filename, `mip-draft_title_abbrev.md`.

  The title should be 44 characters or less. It should not repeat the MIP number in title, irrespective of the category.

  The author should add himself as a code owner in the `.github/CODEOWNERS` file for the MIP.

  TODO: Remove this comment before finalizing.
-->

## Abstract

The Native Bridge design presented in [MIP-39](../mip-39/) has the following assumptions to achieve secure operation, and which we detail in [Motivation](#motivation).

Given that these hold, the sum of the token supply of `$L1MOVE` and `$L2MOVE` is equal to `MOVE_MAX`. To improve the security of the relayer and protect the total token supply against violations of the above assumptions, we propose several safety mechanisms:

1. The token supply of `$L1MOVE`, as well as `$L2MOVE` cannot exceed the total supply individually.
1. The total amount of bridge transfers is rate limited.
1. The relayer shall maximize security measurements to protect its keys.


## Motivation

Two security assumptions underpin the secure operation of the bridge.

1. **Liveness of the relayer**. It is assumed that the relayer is active within some time Delta. For further details on this we refer to [MIP-39](../mip-39/).

2. **Secure relayer**. It is assumed that the relayer keys are operated securely. More specifically we require that the key access and the signing process of the relayer is not compromised. For example the keys could get compromised if a malicious entity could get access to the key(s). In the basic design, see [MIP-????](???), the relayer has the capability to mint `$L2MOVE` tokens, thus could increase the total supply if compromised.

To increase the the reliability and security of the Native Bridge design, measures to improve the above assumptions are proposed.


## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119 and RFC 8174.

##### 1. Fix the Potential Supply

As described in the [Abstract](#abstract), the sum of the token supply of `$L1MOVE` and `$L2MOVE` is equal to `MOVE_MAX`. Since the bridge is the sole point of creation (or release) of `$L2MOVE` token, the L2 contract MUST monitor the `$L2MOVE` supply. The L2 bridge contract MUST not release more `$L2MOVE` than the maximum supply `MOVE_MAX`.

##### 2. Native Bridge rate limitation

The total amount of bridge transfers should be rate limited to $(X, T)$ where $X$ is the maximum transferable amount per time period $T$. I.e. the bridge should not allow more than $X$ total transaction value in any $T$ period.

To not impact honest traffic heavily, a governance body MAY be overseeing, whether the `bridge_rate` SHOULD be increased temporarily and for what interval. However, such a mechanism impacts the security assumptions as this governance body also would have to adhere to stringent security requirements and a compromise of the governance body could effectively disable the rate limitation. Also the above mentioned Crypto-economic security guarantees do not hold any longer.



##### 3. Relayer key protection

The relayer shall maximize security measurements to protect its keys. For example, it SHOULD implement a multi-signature scheme to sign its messages, as is proposed in [MIP-21](https://github.com/movementlabsxyz/MIP/pull/21). The owners of the constituent keys should be distinct entities with distinct access to their keys.

[This article](https://medium.com/@j2abro/a-visual-guide-to-blockchain-bridge-security-e982fec671a7) describes some of the considerations that have to be taken into account:

 **Multisigs**: 
 > It’s likely that the bridge is controlled by one or more multisigs —wallets that require multiple individuals to sign before a transaction is executed. Multisigs add an element of security by ensuring that a single signer can’t control the bridge. Multisigs might be used to enable the bridge contracts to be upgraded or paused. While multisigs are an essential security control for bridges, they are not foolproof and require proper management. In fact multisigs have been targeted in some major bridge exploits.

**Contract Exploits**: 
> Multisigs are implemented as smart contracts and are thus potentially vulnerable to exploits. Many of the popular multisig contracts have been used to store billions in assets over time and are somewhat battle tested. Nonetheless, these contracts do represent additional attack surface.

**Signers are People**: 
> Multisigs are controlled by a group of signers; you must trust that the private keys of those signers are kept secure. Any individual that is a singer on a multisig must be trusted to not be an adversary of course, but also must be trusted to adhere to basic security practices. Multisig signers are ripe targets for phishing and malware attacks.

## Reference Implementation

<!--
  The Reference Implementation section should include links to and an overview of a minimal implementation that assists in understanding or implementing this specification. The reference implementation is not a replacement for the Specification section, and the proposal should still be understandable without it.

  TODO: Remove this comment before submitting
-->

## Verification

##### 1. Fix the Potential Supply

Since the maximal released supply of `$L1MOVE` is `MOVE_MAX` the maximum *Potential Supply* (of the sum of the supply of `$L1MOVE` and `$L2MOVE`) is 2 $\times$ `MOVE_MAX`, even in the case of a compromised relayer and a maximum exploit.

##### 2. Native Bridge rate limitation


Eigenlayer AVS does suggest a similar model and provides the following Definition on Strong Economic Security in their [white paper (EIGEN: The Universal Intersubjective Work Token)](https://docs.eigenlayer.xyz/assets/files/EIGEN_Token_Whitepaper-0df8e17b7efa052fd2a22e1ade9c6f69.pdf):

> *Formal Definition of Strong Cryptoeconomic Security*
If [a bridge] acquires more [cryptoeconomic] security than the harm it can suffer from an attack within the interval $T_{redeem}$ slots, then it achieves strong cryptoeconomic security, i.e.<br>
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*[Economic]-security ≥ Harm-from-corruption [..] in $T_{redeem}$ slots* 

> [..] consider a [..] bridge [..] for a rollup, which has a $(X, T)$-rate-limit [..]. Now if [$T<T_{redeem}$,] the total value transacted by the bridge is less than $X$ during any attack period, and therefore the harm from corruption for the $T$ period is less than or equal to $X$. If the [cryptoeconomic] security is greater than X then this [bridge] works correctly. [..] we have the following conditions for strong cryptoeconomic safety.

##### 3. Relayer key protection

Multisignature approaches are common praxis, for example see [MIP-21](https://github.com/movementlabsxyz/MIP/tree/primata/bridge-attestors/MIP/mip-21) or see [this article](https://medium.com/@j2abro/a-visual-guide-to-blockchain-bridge-security-e982fec671a7).


<!--

  All proposals must contain a section that discusses the various aspects of verification pertinent to the introduced changes. This section should address:

  1. **Correctness**: Ensure that the proposed changes behave as expected in all scenarios. Highlight any tests, simulations, or proofs done to validate the correctness of the changes.

  2. **Security Implications**: Address the potential security ramifications of the proposal. This includes discussing security-relevant design decisions, potential vulnerabilities, important discussions, implementation-specific guidance, and pitfalls. Mention any threats, risks, and mitigation strategies associated with the proposal.

  3. **Performance Impacts**: Outline any performance tests conducted and the impact of the proposal on system performance. This could be in terms of speed, resource consumption, or other relevant metrics.

  4. **Validation Procedures**: Describe any procedures, tools, or methodologies used to validate the proposal against its requirements or objectives. 

  5. **Peer Review and Community Feedback**: Highlight any feedback from peer reviews or the community that played a crucial role in refining the verification process or the proposal itself.


  TODO: Remove this comment before submitting
-->

Needs discussion.

---

## Errata


## Appendix


### A1
Nothing important here.

---
## Copyright

Copyright and related rights waived via [CC0](../LICENSE.md).