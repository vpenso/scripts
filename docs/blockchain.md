### Cryptocurrency

Fiat Currency

- Issues by government
- Delays between transaction and settlement
- Need for intermediaries to prevent fraud and loss
- High transaction fees

Cryptocurrency

- No central authority
- No transaction/settlement clearing
- No intermediaries
- Immutable transaction history

Cryptocurrency is build on blockchain technology, aka **Distributed Ledger Technology** (DLT)


## Blockchain

Distributed shared **digital ledger** of cryptographically signed transactions grouped in blocks:

* Distributed - Without central repository and usually without a central authority
* Shared - Blocks replicated across copies of the ledger within the network (conflicts automatically resolved by rules)
* Ledger - (Append only) Transaction registry, providing a full history

Interest in distributed ledgers due to:

* Ownership - Distributed by design making it difficult to lose or destroy the ledger
* Resilience - Hosted by heterogeneous, geographically divers participants (using different infrastructure)
* Validity - Illegal transactions prevented from propagating throughout the network
* Completeness - Network always holds all accepted transactions
* Tamper evident - Blocks cryptographically linked to the previous one (after validation, consensus decision)
* Tamper resistant - As new blocks are added, older blocks become difficult to modify


### Categorization

Blockchain networks categorized based on permission model (determines who can publich blocks):

* **Permissionless** (anyone can publish a new block) 
  - Allows anyone to anonymously create accounts and participate (without a permission by any authority)
  - Anyone can read/write the ledger (issue transactions within published blocks)
  - Utilizes a **multiparty consensus system** (prevents malicious behavior)
  - Consensus requires to expend resources to publish blocks (often rewarded with native cryptocurrency)
* **Permissioned** (trusted users can publish new blocks)
  - Controlled access (users authorized by some authority)
  - Possible to restrict read and/or write access
  - Typically deployed for a group of organizations/individuals (consortium)
  - Consensus model for publishing blocks, typically do not requires to expend resources
  - Consensus model selected according to the level of trust among participants
  - Provides a transparent **shared business process** for participants (enables informed business decisions, and to hold parties accountable)

Permissioned blockchain networks usually faster and less computationally expensive.

### Components

Blockchain gets their properties from cryptography

Technologies used in blockchains:

* **Cryptographic Hash Functions** (one-way function)
  - Algorithm that creates a succinct (shortened) representation (digest) of data (typically fixed length), that uniquely identifies the source data
  - Used for address derivation, creating unique identifiers, and...
  - Securing block data - Block data hashed creating a digest stored in the header
  - Securing block header - The header's hash digest will be included within the next block's header
* **Cryptographic Nonce** (arbitrary number that is only used once)
  - Combined with data to produce different hash digests values (per nonce) for the same data
  - Utilized in the PoW consensus model adjust mining costs
* **Transactions** (represents a interaction between to parties)
  - Each block in an blockchain contains zero or more transactions
  - Data within a transaction different for every blockchain implementation
  - Primarily used to transfer digital assets (ore more generally used to transfer data)
  - Validity and authenticity of a transaction determined by the system
  - Typically digitally signed by the senders associated private key
* **Asymmetric-Key Cryptography** (& Digital Signing)
  - Enables a trust relationship between participants
  - Provides the mechanism to verify the integrity and authenticity of a transaction
* **Address Derivation**
  - Short addresses derived from a users public key
  - Used as to/from endpoints in a transaction
  - Used as public identifier for users within a network
* **Private Key Storage** (aka wallet)
  - Keys-pairs must be managed and the private-key securely stored
  - Often a dedicated hardware device is used to store keys
* **Ledgers** (collection of transactions) with distributed ownership
* **Blocks** (contains header and data)
  - Transactions added to the blockchain when a publishing node publishes a block
  - A block contains a list of validated and authentic transactions
* **Chaining Blocks**
  - Blocks contain a hash digest of the previous block's header
  - Altering a block, alters its header, and subsequently alters all following blocks, which is easy to detect

### Consensus

**Agreement on the order of transactions**

The consensus mechanism defines the rules that decide on the contributions by the various participants of the blockchain. Basically an algorithm to select one (of many) participant to receive the right to add new transactions.

Consensus Mechanisms:

* **Proof of Work** (PoW)
  - **Mining** - Solve a difficult computationally intensive puzzle (with an easy to check solution)
  - Participant publishes the next block by being the first to mine a (valid) proof
  - The difficulty of the proof may be adjusted over time to influence how often blocks are being published
  - An **incentive model** is used to reward publishing nodes to expand computation resources to maintain the blockchain
* **Proof of Stake** (PoS)
  - Stake, investment into the system by a given user (increasing the interest to maintain the blockchain)
  - Amount of stake a participant has is a determining factor for publishing new blocks
  - Less computing intensive compared to PoW, reward usually based on **transaction fees**
  - Approaches to choose a publisher: random selection of staked users, multi-round voting, coin aging, delegate system
* **Proof of Authority/Identity** (PoA)
  - Identity/reputation as a stake (no need to mining)
  - Transactions/blocks checked by approved publishers/accounts aka. validators
  - Only non-consecutive blocks can be approved by any one validator (semi distribute trust)
* **Proof of Elapsed Time** (PoET)
  - Randomized timer system for network system, grants signed time-objects to participants
  - Time-objects determined by a fair lottery system (with equal likelihood for all participants)
  - The winning time-object selects the block leader abel to produce new transactions/blocks
* **Round Robin**, publishers take turns in creating blocks

Other terminology:

* **Genesis Block** - First block (only pre-configured block), initial state of the system
  - All subsequent blocks added to the chain based on the agreed-upon consensus model
  - Users can verify every block independently beginning from the genesis block
* **Ledger Conflict** (forks)
  - Multiple blocks published at the same time, different version of the blockchain at a given moment
  - The blockchain network needs to resolve conflicts to have consistency
  - Resolution, i.e. adopt the longer blockchain

