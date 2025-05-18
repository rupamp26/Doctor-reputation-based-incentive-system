module DoctorRep::ReputationSystem {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// Error codes
    const EDOCTOR_ALREADY_REGISTERED: u64 = 1;
    const EDOCTOR_NOT_REGISTERED: u64 = 2;
    const EINVALID_RATING: u64 = 3;

    /// Struct to store doctor information and reputation
    struct DoctorProfile has key, store {
        ratings: vector<u8>,       // Vector of ratings received (1-5)
        total_reviews: u64,        // Number of reviews received
        rewards_claimed: u64,      // Amount of rewards claimed
    }

    /// Register a new doctor in the system
    public entry fun register_doctor(doctor: &signer) {
        let doctor_addr = signer::address_of(doctor);
        
        // Check if doctor is already registered
        assert!(!exists<DoctorProfile>(doctor_addr), EDOCTOR_ALREADY_REGISTERED);
        
        // Create new doctor profile
        let profile = DoctorProfile {
            ratings: vector::empty<u8>(),
            total_reviews: 0,
            rewards_claimed: 0,
        };
        
        // Store the profile under doctor's address
        move_to(doctor, profile);
    }

    /// Rate a doctor and distribute reputation-based rewards
    public entry fun rate_doctor(
        reviewer: &signer, 
        doctor_addr: address, 
        rating: u8
    ) acquires DoctorProfile {
        // Validate rating (1-5 stars)
        assert!(rating >= 1 && rating <= 5, EINVALID_RATING);
        
        // Ensure doctor exists in the system
        assert!(exists<DoctorProfile>(doctor_addr), EDOCTOR_NOT_REGISTERED);
        
        // Get doctor's profile
        let doctor_profile = borrow_global_mut<DoctorProfile>(doctor_addr);
        
        // Add the new rating
        vector::push_back(&mut doctor_profile.ratings, rating);
        doctor_profile.total_reviews = doctor_profile.total_reviews + 1;
        
        // Calculate reward based on rating (higher rating = higher reward)
        let reward_amount = rating * 10000000; // 0.1 APT per star
        
        // Transfer reward to doctor
        if (rating >= 4) { // Only reward for good ratings (4-5 stars)
            let reward = coin::withdraw<AptosCoin>(reviewer, reward_amount);
            coin::deposit<AptosCoin>(doctor_addr, reward);
            doctor_profile.rewards_claimed = doctor_profile.rewards_claimed + reward_amount;
        }
    }
}