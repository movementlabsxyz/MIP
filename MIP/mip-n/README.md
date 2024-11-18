# MIP-n: Asynchronous Bridge UI to Accomodate Finalized Ethereum Blocks
- **Description**: Introduces a solution to make the bridge interface usable if the bridge relies on finalized Ethereum blocks
- **Authors**: [Andy Golay](mailto:andy.golay@movementlabs.xyz)
- **Reviewer**: [Andreas Penzkofer](mailto:andreas.penzkofer@movementlabs.xyz)
- **Desiderata**: $\emptyset$

## Abstract

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
