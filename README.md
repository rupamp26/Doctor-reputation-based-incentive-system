### Doctor Reputation System
A Move-based smart contract system on Aptos for rating doctors and providing incentives based on reputation.

### Vision
In healthcare systems worldwide, there's often a disconnect between patient experiences, doctor compensation, and quality metrics. MedTrust envisions a future where:

- Trust is Transparent: Patient feedback becomes an immutable, verifiable record that follows doctors throughout their careers
- Quality is Rewarded: Top-performing doctors receive immediate financial incentives directly tied to patient satisfaction
- Data is Decentralized: No single entity controls the reputation system, making it resistant to manipulation or centralized control
- Access is Universal: Anyone can view doctor ratings and participate in the ecosystem regardless of geographic location

MedTrust aims to fundamentally realign incentives in healthcare by creating a direct relationship between patient experiences and provider rewards, ultimately improving healthcare outcomes through stronger accountability and properly aligned incentives.

### Project Structure
```bash
doctor-reputation-system/
├── Move.toml                  # Project configuration
└── sources/
    └── reputation_system.move # Main contract module
```

### Overview
This smart contract implements a reputation system for doctors with the following features:

- Doctors can register in the system
- Users can rate doctors on a scale of 1-5
- High-rated doctors (4-5 stars) receive automatic rewards in APT tokens
- The system tracks all ratings and review history

### Key Functions

- `register_doctor`: Allows a doctor to register in the system
 - `rate_doctor`: Allows a user to rate a doctor and triggers automatic rewards for high ratings

Quick Start
Setup

Install the Aptos CLI:
```
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
```

2. Compile the contract:

```
aptos move compile
```

3. Test the contract:

```
aptos move test
```


Deployment
 Create a new account on Aptos (if needed):

```
aptos init
```

2. Publish the module:

```
aptos move publish
```

Interact with the Contract
1. Register as a doctor:

```
aptos move run --function-id {your_address}::ReputationSystem::register_doctor
```

2. Rate a doctor:

```
aptos move run --function-id {your_address}::ReputationSystem::rate_doctor \
    --args address:{doctor_address} u8:5
```
