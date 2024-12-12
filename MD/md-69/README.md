# MD-69: Bridge fees 
- **Description**: This MD provides some background on the bridge fees mechanism requirements.
- **Authors**: [Franck Cassez](franck.cassez@movementlabs.xyz)

## Overview

To use the Movement Mainnet, users need to pay for _transaction fees_ in \$L2MOVE tokens. As the \$MOVE token is minted on Ethereum (\$L1MOVE), users need to transfer some \$L1MOVE tokens from the Ethereum network to the Movement Mainnet (to get \$L2MOVE), and back.
This asset transfer capability is provided by the Movement Mainnet **native bridge**, which is a [lock/mint bridge](https://chain.link/education-hub/cross-chain-bridge#types-of-cross-chain-bridges) described in [MIP-58](tdc).  

This bridge (transfer) operation requires several steps, two of which are transactions:

1. initiate a transfer on source chain;
2. finalize the transfer on the target chain.

Step (1) is performed by the user on the network (Ethereum or Movement), and step (2) is performed by the bridge operator via a _relayer_ (**ADD link to relayer MIP here**). 
As a result, the operator has to cover the transaction fees for the _finalize_ step.
When transferring from Ethereum to Movement, the fees are expected to be very low so we can consider that the operator can cover them using a pool of transaction fees collected from the users on the Movement Mainnet.
In the other direction, bridging from Movement to Ethereum, the Ethereum fees are expected to be higher, and the operator may not be able to cover them all. 

> [!IMPORTANT] 
> We need to define a mechanism to collect the Ethereum fees from the users.


> [!TIP] 
> This MD describes the requirements for this fee collection mechanism when bridging from Movement Mainnet to Ethereum.

## Desiderata

### D1: User bridges from Movement Mainnet to Ethereum

**User Journey**: A user can initiate a _bridge_ transaction on the Movement Mainnet.

**Description**: When a user initiates a bridge transaction from the Movement Mainnet to Ethereum, the user pays the Movement Mainnet transaction fees in \$L2MOVE tokens. They request a transfer of \$L2MOVE to \$L1MOVE.

**Justification**: The user should be able to transfer their tokens from the Movement Mainnet to Ethereum. 

### D2: Operator covers the Ethereum transaction fees 

**User Journey**: Once initiated, the bridge transaction is completed by the operator of the Movement Mainnet via a _relayer_. 

**Description**: The operator must cover the Ethereum transaction fees for the completion step. 

**Justification**: Only the operator can finalize the transfer on the Ethereum network. 


### D3: Operator collects the Ethereum transaction fees from the user

**User Journey**: The operator collects the Ethereum transaction fees from the user in \$MOVE.

**Description**: The operator collects the Ethereum transaction fees from the user in \$MOVE tokens.

**Justification**: We must collect the fees in \$MOVE tokens.
The fees cannot be collected in \$ETH as 

1) we cannot ask the user to approve the relayer to transfer \$ETH to them; and 
2) even if we could, the user may not have enough \$ETH and they initiated the transfer on the Movement Mainnet.

### D4: The operator does not run a deficit

**User Journey**: The operator pays the Ethereum transaction fees in \$ETH and charges the user for bridge fees in \$MOVE. The operator must not run a deficit

**Description**: The operator must ensure that the fees collected from the users are sufficient to cover the Ethereum transaction fees to complete transfers. This implies that 

1) we accurately estimate the Ethereum fees in advance, and 
2) we also estimate the ratio \$MOVE/\$ETH.

**Justification**: The operator must not run a deficit. We must decide how much the user is charged when they initiate a transfer at time $t$ from the Movement Mainnet to Ethereum. 
The counterpart complete transactions will be executed on the Ethereum at a later time $t' > t$. To cover the transaction fees, we have to 

1) estimate the Ethereum fees at $t'$, and 
2) the ratio \$MOVE/\$ETH at $t'$. 
