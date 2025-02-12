# MD-1: Minimize Risk of Compromised Bridge Key without Governance

- **Description**: Provide a mechanism to minimize the risk of a compromised bridge key without relying on governance.
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Approval**: :white_check_mark:

## Overview
The Atomic Bridge service relies on trusted keys for relaying events between chains. Without governance or multisig contracts, the risk entailed by a compromised bridge key is significant. Even with logic safeguarding against direct mint operations, fraudulent events on either chain can still be synthesized. 

The desiderata herein recognize standard governance as generally the best means of managing these kinds of risks in general. Specialized contracts can be used to accumulate votes and make it difficult for a single actor to compromise bridge security. 

However, in the case of bridging, inactive or unreliable governance can be a significant risk as well. In effect, the changes represented by the in-flight message represent those already agreed upon by the destination chain's governance. These are then subject to a smaller, potentially less-secure governance process before being relayed to the destination chain. The risk of DOS attacks on this governance process is thus high.

Until a robust design for relaying bridge messages based on votes is attained, bridge trust assumptions are offset by a presumed trustworthy bridge signing service which uses known keys that would be controlled by Movement Labs.

This desiderata requests a means to minimize the risk of a compromised bridge key without relying on on-chain governance.

## Desiderata

<!--
  List out the specific desiderata. Each entry should consist of:

  1. Title: A concise name for the desideratum.
  2. User Journey: A one or two-sentence statement focusing on the "user" (could be a human, machine, software, etc.) and their interaction or experience.
  3. Description (optional): A more detailed explanation if needed.
  4. Justification: The reasoning behind the desideratum. Why is it necessary or desired?
  5. Recommendations (optional): Suggestions or guidance related to the desideratum.

  Format as:

  ### Desideratum Title

  **User Journey**: [user] can [action].

  **Description**: <More detailed explanation if needed (optional)>

  **Justification**: <Why this is a significant or required desideratum>

  **Recommendations**: <Any specific guidance or suggestions (optional)>

  TODO: Remove this comment before finalizing.
-->
### D1: Minimize Direct Access to Bridge Keys while Maintaining Use
**User Journey**: Movement Labs Atomic Bridge Service Operators (MLABSO) can run the service with appropriate signing keys without direct access to said keys.

**Justification**: Without direct access to the keys, MLABSO are forced to use a more secure mechanism for signing messages which can be more easily secured audited such as an HSM or enclave.

### D2: Only Allow Attested Usage of Bridge Keys
**User Journey**: Only attested software can use bridge keys.

**Justification**: Even without direct access to the keys, MLABSO could still abuse bridge keys by abusing their access to the secure signing mechanism. Enforcing attestation of software using the keys can help mitigate this risk.

### D3: Time-Lock Key Usage
**User Journey**: MLABSO can only reliably replace software using a key in a time-locked manner.

**Justification**: The software using a given key may require updates or replacement. Time-locking can allow this to occur without diminishing the benefits of attestations.

## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
