# MD-61: Relayer algorithm for the lock/mint Native Bridge

- **Description**: A desiderata for the relayer in the lock/mint bridge, focusing on event processing, transfer completion, and robust recovery mechanisms.
- **Authors**: Andreas Penzkofer, Philippe
- **Approval**: :white_check_mark:

## Overview

This desiderata outlines the desired functionalities and recovery mechanisms for a Relayer handling the completion of transfers in the lock/mint Native Bridge protocol. It emphasizes uninterrupted operation, recovery from failure, and minimal dependencies.

## Desiderata

### D1: Continuous event processing

**User journey**: The relayer continuously processes events from the source chain, created from user transfer requests, and ensures their completion on the target chain.

**Justification**: Guarantees the seamless execution of cross-chain transfers and minimizes delays or interruptions.

### D2: Robust bootstrapping mechanism

**User journey**: Upon restart, the relayer automatically determines the state of pending transfers and resumes processing without requiring manual intervention.

**Justification**: Ensures resilience and reliability even after unexpected failures or downtime.

### D3: Finality-aware processing

**User journey**: The relayer respects the finality rules of both source and target chains. It ensures transfers are only processed once finalized on the source chain. It considers the finality of the target chain for completing transactions.

**Justification**: Prevents inconsistencies and sending duplicate transfer-completing transactions.

### D4: Minimal trusted components

**User journey**: The relayer operates independently without reliance on external indexers or databases.

**Justification**: Reduces operational complexity and points of failure, enhancing system robustness.

### D5: Timeout and retry mechanism

**User journey**: Pending transfers are retried automatically after a timeout, ensuring eventual completion without manual oversight.

**Justification**: Improves the reliability of the relayer by handling transient errors and network issues gracefully.

**Recommendations**: Implement a configurable timeout period for retries.

## Changelog
