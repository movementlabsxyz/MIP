# MIP-52: Aptos Gas Pool
- **Description**: Introduces implementation specification for the Gas Pool in the Aptos Framework
- **Authors**: [Liam Monninger](mailto:liam@movementlabs.xyz)
- **Desiderata**: [MD-38](https://github.com/movementlabsxyz/MIP/pulls)

## Abstract

We propose a means of implementing a Gas Pool in Aptos to satisfy the token recirculation requirements indicated in [MD-38](https://github.com/movementlabsxyz/MIP/pulls). This solution will allow for gas used to be stored in the pool. The re-use of said gas is not a subject of this MIP. However, [MIP-44](https://github.com/movementlabsxyz/MIP/pull/44), [MIP-41](https://github.com/movementlabsxyz/MIP/pull/41), et al.  provide suggestions to this end.

## Motivation

The introduction of a Gas Pool in Aptos will allow for the recirculation of gas used in the Aptos Framework based ecosystem. This ensures the supply can remain fixed and the gas can be re-used for purposes such as rewarding. 

## Specification

Aptos pays gas in the [epilogue](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/aptos-vm/src/transaction_validation.rs#L194) of a transaction [dispatching](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/aptos-vm/src/transaction_validation.rs#L34) to [`epilogue_gas_payer`](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/transaction_validation.move#L274). Depending on the [validator reward setting](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/transaction_validation.move#L305), [`epilogue_gas_payer`](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/transaction_validation.move#L274) will either call `transaction_fee::collect_fee` or `transaction_fee::burn_fee`. 

At the time of writing the `transaction_fee::collect_fee` path is still experimental.

[`transaction_fee::burn_fee`](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/transaction_fee.move#L218) internally calls [`coin::burn_from`](https://github.com/movementlabsxyz/aptos-core/blob/70be3926ff79ff4cdb0cee928f717fafcd41ecdd/aptos-move/framework/aptos-framework/sources/transaction_fee.move#L229C17-L233C19) which can be replaced with a transfer.

We thus suggest two paths to implement the Gas Pool in Aptos:

- **Custom Rewards Collection**
- **Burn Replacement**

### Custom Rewards Collection

The custom rewards collection approach replaces Aptos' experimental `transaction_fee::collect_fee` with a custom rewards collection mechanism. This mechanism calls `coin::transfer_from` to move the gas to the Gas Pool at a known address.

Coin burning logic can be kept in place and a similar features-based approach can be used to determine ensure the `transaction_fee::collect_fee` approach is used.

### Burn Replacement

The burn replacement approach replaces the `coin::burn_from` call in `transaction_fee::burn_fee` with a `coin::transfer_from` call to the Gas Pool.

## Verification

**Outstanding**:

- Verify that the AptosVM does not validate burns. Otherwise, there may be logic outside of the framework `epilogue_gas_payer` path which needs to be updated. 
- Identify any sponsorship or other gas payment mechanisms which may need to be updated to use the Gas Pool.

## Appendix

## Changelog
