# MIP-59: Asynchronous Bridge UI to Accomodate Finalized Ethereum Blocks

- **Description**: Introduces a solution to make the bridge interface usable if the bridge relies on finalized Ethereum blocks
- **Authors**: [Andy Golay](mailto:andy.golay@movementlabs.xyz)
- **Desiderata**: $\emptyset$
- **Approval**: Stagnant

## Abstract 1 (Philippe?)

The current implementation of the bridge transaction processing, suppose that all produced block are final and would never change. It's not the case to we need to add some finality or block change management.
This proposition explore the finality waiting case. For all bridged blockchain (L1/L2), only finale transaction are processed.
This change change the behavior in the `relayer` that need to wait finalized block to propagate event and in the UI where only finalized TX can be used to notify user bridge state change.

This proposition describe an update of the UI where rather than users waiting for their L2 wallet to pop up to complete a bridge transfer on the destination chain, if we require several minutes to consider a block finalized, then users can refer to their transfer history in the wallet UI and click a "Complete" button to sign the transaction to complete the bridge transfer. The wallet pop up will automatically be populated with the bridge transfer ID and pre-image.

## Motivation

Research has rightly expressed concerns with block finality on Ethereum posing the rest of a chain reorganization (reorg). 

Source: https://github.com/movementlabsxyz/movement/issues/838

The current bridge design only waits for 1 Ethereum confirmation, which provides a fast user experience with, for example when bridging from L1 (Ethereum) to L2 (Movement), the L2 wallet popping up automatically so users can complete their transfer on L2.

### Tx finality

Finalized block has different meaning depending on the blockchain. Some blockchain need a few second and other need minutes. So the way Tx finalized will be managed will depend on the blockchain.
For Ethereum blockchain the finality is part of the Casper protocol:

```
finalized Block

    Definition: The most recent block accepted by more than two-thirds of Ethereum validators, making it crypto-economically secure. Finalization typically occurs after two epochs (~12-13 minutes), making it nearly impossible to re-org without coordinated community action.
```

So it needs around 10 minutes to finalize a Tx on Ethereum.

For movement blockchain the finality depends on the sum of the Tx propagation/DA/execution and settlement. The first steps take around 15 second, the last one depend s on the settlement blockchain. As it uses Ethereum, it's the same as Ethereum finality so around 10 minutes. This behavior will change depending on the settlement implementation.

So on both chain finality is around 10 minutes. The Bridge protocol use 4 tx executed one after the others. 3 tx define the transfer duration (initiate, lock, complete) for the user. So the bridge transfer average duration with finality is 30 minutes.

So it implies these modifications:
 * the relayer must wait for Tx finality and must be able to recover these waiting data in case of crash.
 * the UI must be rethink because waiting for a wallet popup is not feasible.

The bridge UI must still provide a pleasant user experience in light of the finality requirements.

## Specification

This specification includes a user persona, use case, and user scenarios, as well as an implementation specification.

### Persona

- User: the bridge user is interested in bridging assets between Ethereum and Movement network. They may be assumed to have some past experience and knowledge of using crypto wallets and apps.
- Movement: the movement organization that run the Bridge.
- Relayer: process lock transfer and complete initator Tx needed by the bridge protocol.

### Use case

"As a User, I want to swap MOVE on L1 to MOVE on L2, and back from L2 to L1, so that I can use Movement network apps, and move value bidirectionally between Movement network and Ethereum."
"As a User, I want to have a secure bridge process, so that I can't lost my fund."
"As Movement, I want the user to use have a good experience with the bridge transfer so that it come back and use the movement blockchain."
"As Movement, I want the bridge to be secured so that Movement or User don't lost fund.

### Scenario of main use case

#### Current "wallet pop up" implementation scenario, with bad UX if the bridge wait for long finality:

As it is right now with immediate block production, the user performs two transactions on L1 to initiate a transfer: 

0. The user open the Bridge UI.
1. The User define the Amount of MOVE to transfer between L1 and L2 blockchain.
2. User UI: call `initiateBridgeTransfer` L1 contract function to initiate the transfer and pay the fee.
3. The Relayer get the L1 `initiateBridgeTransfer` bridge transfer event that is  finalized.
4. The Relayer call `LockBridgeTransfer` on L2 and pay the fee.
5. The User UI get the `LockBridgeTransfer` on L2 event that is finalized.
6. The User get notified to complete the transfer
7. The User complete the transfer.
8. The user UI send the `CompleteBridgeTransfer` on L2
9. The user UI get the `CompleteBridgeTransfer` on L2 that is finalized
10. The Relayer get the `CompleteBridgeTransfer` on L2 that is finalized and send the `CompleteBridgeTransfer` on L1 Tx
11. The user UI get the `CompleteBridgeTransfer` on L2 event that is finalized
12. The user is notified that the transfer is completed.

During all this process the user must keep the Bridge UI running and interact to complete the transfer.

#### Proposed "async" scenario with good UX if the bridge uses 64 Ethereum confirmations:

Instead of a wallet popup, users can check their transfer history in the bridge UI, and manually press a "Complete" button.

The scenario will be:

0. The user open the Bridge UI.
1. The User define the Amount of MOVE to transfer between L1 and L2 blockchain.
2. User UI: call `initiateBridgeTransfer` L1 contract function to initiate the transfer and pay the fee.
3. The user is notified the transfer has been started and can close the UI if he needs.
3. The Relayer get the L1 `initiateBridgeTransfer` bridge transfer event that is  finalized.
4. The Relayer call `LockBridgeTransfer` on L2 and pay the fee.
5. At any moment the user can open the UI to see the state of its transfer in the history.
6. The user see that the transfer has changed its state and can be completed. The UI has detect the `LockBridgeTransfer` on L2  event in a finalized state.
7. The User complete the transfer.
8. The user UI send the `CompleteBridgeTransfer` on L2
9. The user can close the UI or wait looking at the transfer state in the history.
9. The user UI detect the `CompleteBridgeTransfer` on L2 that is finalized
10. The UI change the transfer state to completed.
10. The Relayer get the `CompleteBridgeTransfer` on L2 that is finalized and send the `CompleteBridgeTransfer` on L1 Tx
12. The user see in the history that the transfer is completed.

Optionally, the UI can be open on any device and show the history. On notification compatible device the lock and completed state change can be notified to the user. 

### Software implementation (sketch of possible Rust code)
No code in the spec only description.

### History data

The new part from existing code is how to get the user history. There's 2 possibilities: use the blockchain and query the smart contract to have pending transfer for a user or user the indexer and query the DB.
Use smart contract:

 Pro:
  * no specific infra and decentralized.
  
 Cons:
  * increase the fee of the contract Tx to manage the data onchain.
  * can me more complexe to develop because the hisotry need to be fetch from 2 chains: L1/L2.

Use indexer:

 Pro:
  * easier to develop only a graphql query

 Cons:
  * centralized need a specific infra.
  * likeness issue.

### Wait for finality
### Ethereum
On Ethereum RPC API, there's a specific [parameters](https://docs.tatum.io/docs/evm-block-finality-and-confidence#checking-the-latest-finalized-block) to get finalized block. So the actual event monitoring pulling will be updated to get only finalized block.

On Movement, Suzuka node provide a specific RPC API entry point for finalized data. The same as Eth the Movement monitoring will be updated to use this access point.

## Verification

## Errata

## Appendix



------


## Abstract 2 (Andy?)

Rather than users waiting for their L2 wallet to pop up to complete a bridge transfer on the destination chain, if we require 64 confirmations to consider a block finalized, then users can refer to their transfer history in the wallet UI and click a "Complete" button to sign the transaction to complete the bridge transfer. The wallet pop up will automatically be populated with the bridge transfer ID and pre-image.

## Motivation

Research has rightly expressed concerns with block finality on Ethereum posing the rest of a chain reorganization (reorg). 

Source: https://github.com/movementlabsxyz/movement/issues/838

The current bridge design only waits for 1 Ethereum confirmation, which provides a fast user experience with, for example when bridging from L1 (Ethereum) to L2 (Movement), the L2 wallet popping up automatically so users can complete their transfer on L2.

If 64 or more confirmations are required to consider the risk of a reorg negligible, then waiting for a wallet popup is not feasible. 

The bridge UI must still provide a pleasant user experience in light of the finality requirements.

## Specification

This specification includes a user persona, use case, and user scenarios, as well as an implementation specification.

### Persona

The bridge user is interested in bridging assets between Ethereum and Movement network. They may be assumed to have some past experience and knowledge of using crypto wallets and apps.

### Use case 

"As a bridge user, I want to swap MOVE on L1 to MOVE on L2, and back from L2 to L1, so that I can use Movement network apps, and move value bidirectionally between Movement network and Ethereum."

### Scenario of main use case

#### Current "wallet pop up" implementation scenario, with bad UX if the bridge uses 64 Ethereum confirmations:

As it is right now with 1 confirmation, the user performs two transactions on L1 to initiate a transfer: 

1. Approve an Amount of MOVE for `AtomicBridgeInitiatorMOVE.sol` to transfer on behalf of the user
2. Call `initiateBridgeTransfer`

After that, the relayer locks the transfer on L2 and then the UI pops up the connected L2 wallet for the user to complete the transfer.

Given the need to wait 64 confirmations, we can assume a wait of several minutes or more for each transaction. This results in a scenario where the user grows impatient and gets confused, abandons the bridge attempt and complains on social media about the poor UX.

#### Proposed "async" scenario with good UX if the bridge uses 64 Ethereum confirmations:

Instead of a wallet popup, users can check their transfer history in the bridge UI, and manually press a "Complete" button.

In this way, the user doesn't need to sit at the computer, frustrated and confused, waiting for a wallet popup.

Optionally, the UI could have a way for users to get the pre-image for a transfer, so they can complete on any device. 

### Software implementation (sketch of possible Rust code)

The `run_bridge` function in the `bridge-service` crate can be modified as follows. 

1. Add a helper function `wait_for_ethereum_finality` to simulate waiting for 64 blocks:

```
/// Simulate waiting for finality by ensuring 64 blocks have passed
async fn wait_for_ethereum_finality(
    provider: &Provider, // Replace with your JSON-RPC provider instance
    transaction_block: u64,
) -> Result<(), anyhow::Error> {
    loop {
        // Fetch the latest block
        let latest_block = provider
            .get_block(BlockId::Number(BlockNumber::Latest))
            .await
            .map_err(|e| anyhow::anyhow!("Failed to fetch latest block: {}", e))?;

        let latest_block_number = latest_block
            .number
            .ok_or_else(|| anyhow::anyhow!("Latest block number is missing"))?;

        // Check if 64 blocks have passed since the transaction block
        if latest_block_number >= transaction_block + 64 {
            tracing::info!("Block finalized: {}", transaction_block);
            break;
        }

        // Wait before polling again
        tokio::time::sleep(std::time::Duration::from_secs(12)).await;
    }
    Ok(())
}
```

2. In `run_bridge`, modify the `// Wait on chain one events` step to call `wait_for_ethereum_finality` before processing the event:

```
Some(event_res_one) = stream_one.next() =>{
    match event_res_one {
        Ok(event_one) => {
            let event : TransferEvent<A1> = (event_one, ChainId::ONE).into();
            tracing::info!("Receive event from chain ONE:{} ", event.contract_event);

            // Get the block number of the event
            let event_block_number = event_one.block_number.ok_or_else(|| {
                anyhow::anyhow!("Event from Chain One is missing block number")
            })?;

            // Wait for finality before processing the event
            tracing::info!("Waiting for finality of block: {}", event_block_number);
            wait_for_ethereum_finality(&stream_one, event_block_number).await?;

            // Process the event after finality
            match state_runtime.process_event(event) {
                Ok(action) => {
                    // Execute action
                    match action.chain {
                        ChainId::ONE => {
                            let fut = process_action(action, client_one.clone());
                            if let Some(fut) = fut {
                                let jh = tokio::spawn({
                                    let client_lock_clone = client_lock_one.clone();
                                    async move {
                                        let _lock = client_lock_clone.lock().await;
                                        fut.await
                                    }
                                });
                                client_exec_result_futures_one.push(jh);
                            }
                        },
                        ChainId::TWO => {
                            let fut = process_action(action, client_two.clone());
                            if let Some(fut) = fut {
                                let jh = tokio::spawn({
                                    let client_lock_clone = client_lock_two.clone();
                                    async move {
                                        let _lock = client_lock_clone.lock().await;
                                        fut.await
                                    }
                                });
                                client_exec_result_futures_two.push(jh);
                            }
                        }
                    }
                },
                Err(err) => tracing::warn!("Received an invalid event: {err}"),
            }
        }
        Err(err) => tracing::error!("Chain one event stream return an error:{err}"),
    }
}
```

3. Modify the front-end UI to make it so users don't expect a wallet to pop up, but rather they are expected to manually press "Complete" for transfers in their transfer history. The most developed state of the bridge UI transfer history can be found in the branch https://github.com/movementlabsxyz/bridge-interface/tree/fetch-txs. We should get input from the product team and front-end team regarding the best front-end integration to help users avoid confusion and instead enjoy a successful asychronous bridging experience. 

## Verification

## Errata

## Appendix
