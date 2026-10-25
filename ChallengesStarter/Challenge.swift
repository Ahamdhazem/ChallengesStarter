import Foundation

/// Starter identity only. Extend this with the actual MyChallenges response fields.
struct Challenge: Decodable, Identifiable {
    let id: Int

    // TODO: Decode only the required name, challenge_type, state/state_color, dates/activity,
    // progress_title, progress_pct/progress_value/target_value/remaining_value and reward names.
    // Add response-envelope and compact Leave response models. Extra API fields can be ignored.
    // Example: Fixtures/my-challenges-provided-response.json. Full rules: README.md.
}
