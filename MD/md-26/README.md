# MD-26: User-facing checks
- **Description**: Automate checking user experience by submitting transactions every few minutes
- **Authors**: [Andy Golay](mailto:liam@movementlabs.xyz)


<!--
  This template is for drafting Desiderata. It ensures a structured representation of wishes, requirements, or needs related to the overarching objective mentioned in the title. After filling in the requisite fields, please delete these comments.

  Note that an MD number will be assigned by an editor. When opening a pull request to submit your MD, please use an abbreviated title in the filename, `md-draft_title_abbrev.md`.

  TODO: Remove this comment before finalizing.
-->

## Overview
We need to check that users can submit transactions. This MD outlines a simple automated solution.

## Definitions

Provide definitions that you think will empower the reader to quickly dive into the topic.

## Desiderata

  ### Desideratum Title

  **User Journey**: Users get more assurance that we know when Suzuka testnet has a transaction-processing outage. 

  **Description**:

  1. Spin up an EC2 instance.
  
  2. On the instance, create a shell script `suzuka_user_test.sh`:

        ```
        #!/bin/bash

        # Define variables (replace with actual values)
        ACCOUNT_KEY="your_account_key"
        PRIVATE_KEY="your_private_key"
        APTOS_URL="https://fullnode.testnet.aptoslabs.com"
        
        # Infinite loop to send a transaction every 3 minutes
        while true
        do
        # Get faucet funding
        aptos account fund-with-faucet --account $ACCOUNT_KEY --url $APTOS_URL --faucet-url https://faucet.testnet.aptoslabs.com

        # Send a transaction (replace with something simple e.g. a `movemania::play` (tapping game) call?`)
        movement move run --function-id "0x1::module::function_name" --args "u64:1" \
                --account $ACCOUNT_KEY --private-key $PRIVATE_KEY --url $APTOS_URL

        echo "Transaction submitted at $(date)"
        
        # Wait for 3 minutes
        sleep 180
        done
        ```

3. Run the script:

        ```
        chmod +x suzuka_user_test.sh
        ./suzuka_user_test.sh
        ```

**Justification**:

  It's a high priority to have testnet running and able to process transactions, or alterting us otherwise.

**Guidance and suggestions**: 

  We will need the address for this job allowlisted to use the Suzuka testnet faucet.


## Errata
<!--
  Errata should be maintained after publication.

  1. **Transparency and Clarity**: An erratum acknowledges any corrections made post-publication, ensuring that readers are not misled and are always equipped with the most accurate information.

  2. **Accountability**: By noting errors openly, we maintain a high level of responsibility and ownership over our content. It’s an affirmation that we value precision and are ready to correct oversights.

  Each erratum should briefly describe the discrepancy and the correction made, accompanied by a reference to the date and version of the desiderata in which the error was identified.

  TODO: Maintain this comment.
-->
