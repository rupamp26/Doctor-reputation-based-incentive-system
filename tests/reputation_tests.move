module DoctorRep::ReputationSystemTests {
    use std::signer;
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use DoctorRep::ReputationSystem;

    // Test helper to create a signer
    fun create_account(addr: address): signer {
        if (!account::exists_at(addr)) {
            account::create_account_for_test(addr);
        }
        account::create_test_signer(addr);
    }

    // Test helper to setup testing environment
    fun setup(aptos: &signer, doctor: &signer, reviewer: &signer) {
        // Initialize AptosCoin
        let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(aptos);

        // Fund the reviewer account
        let reviewer_addr = signer::address_of(reviewer);
        coin::register<AptosCoin>(reviewer);
        aptos_coin::mint(aptos, reviewer_addr, 1000000000); // 10 APT

        // Clean up
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test]
    fun test_doctor_registration() {
        // Create test accounts
        let aptos = create_account(@0x1);
        let doctor = create_account(@0x123);
        let reviewer = create_account(@0x456);
        
        // Setup test environment
        setup(&aptos, &doctor, &reviewer);
        
        // Register doctor
        ReputationSystem::register_doctor(&doctor);
        
        // Test successful registration - we verify this by checking
        // that we can rate the doctor without errors
        ReputationSystem::rate_doctor(&reviewer, @0x123, 5);
    }

    #[test]
    #[expected_failure(abort_code = 1)] // EDOCTOR_ALREADY_REGISTERED
    fun test_cannot_register_twice() {
        // Create test accounts
        let aptos = create_account(@0x1);
        let doctor = create_account(@0x123);
        let reviewer = create_account(@0x456);
        
        // Setup test environment
        setup(&aptos, &doctor, &reviewer);
        
        // Register doctor
        ReputationSystem::register_doctor(&doctor);
        
        // Attempt to register again (should fail)
        ReputationSystem::register_doctor(&doctor);
    }

    #[test]
    #[expected_failure(abort_code = 2)] // EDOCTOR_NOT_REGISTERED
    fun test_rate_unregistered_doctor() {
        // Create test accounts
        let aptos = create_account(@0x1);
        let doctor = create_account(@0x123);
        let reviewer = create_account(@0x456);
        
        // Setup test environment
        setup(&aptos, &doctor, &reviewer);
        
        // Try to rate unregistered doctor
        ReputationSystem::rate_doctor(&reviewer, @0x123, 5);
    }

    #[test]
    #[expected_failure(abort_code = 3)] // EINVALID_RATING
    fun test_invalid_rating() {
        // Create test accounts
        let aptos = create_account(@0x1);
        let doctor = create_account(@0x123);
        let reviewer = create_account(@0x456);
        
        // Setup test environment
        setup(&aptos, &doctor, &reviewer);
        
        // Register doctor
        ReputationSystem::register_doctor(&doctor);
        
        // Try to give invalid rating (should fail)
        ReputationSystem::rate_doctor(&reviewer, @0x123, 6);
    }
}