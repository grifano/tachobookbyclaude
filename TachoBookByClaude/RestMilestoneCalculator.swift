import Foundation

/// Calculates when one continuous rest reaches 9 h and 11 h.
///
/// Covers only the time milestones of Regulatory Rules Specification v1 (R-D02 milestones, R-T01, R-U01).
/// Inputs are absolute instants and thresholds are elapsed seconds, so time zones and DST change only how
/// a deadline is displayed. A reached milestone states that the duration has elapsed; it does not classify
/// the rest as regular or reduced, permit driving, start a new shift, or consume a reduced-rest allowance.
nonisolated enum RestMilestoneCalculator {
    private static let nineHourRest: TimeInterval = 9 * 3_600
    private static let elevenHourRest: TimeInterval = 11 * 3_600

    /// - Parameters:
    ///   - restStart: The saved start of the current continuous rest, or `nil` when it is unknown.
    ///   - now: The current instant, passed in rather than read from the system clock.
    static func evaluate(restStart: Date?, now: Date) -> RestMilestoneResult {
        guard let restStart else { return .noData }
        guard now >= restStart else { return .invalidInput }

        return .milestones(RestMilestones(
            restStart: restStart,
            elapsed: now.timeIntervalSince(restStart),
            nineHours: milestone(after: nineHourRest, from: restStart, now: now),
            elevenHours: milestone(after: elevenHourRest, from: restStart, now: now)
        ))
    }

    private static func milestone(after duration: TimeInterval, from restStart: Date, now: Date) -> RestMilestone {
        let deadline = restStart.addingTimeInterval(duration)
        return RestMilestone(
            deadline: deadline,
            remaining: max(0, deadline.timeIntervalSince(now)),
            isReached: now >= deadline
        )
    }
}

/// The outcome of evaluating a rest. Missing or inconsistent input is reported, never corrected.
nonisolated enum RestMilestoneResult: Equatable, Sendable {
    /// The rest start is unknown, so no milestones are calculated and no start is assumed.
    case noData
    /// `now` is earlier than the rest start; reported instead of a negative or clamped timer.
    case invalidInput
    case milestones(RestMilestones)
}

nonisolated struct RestMilestones: Equatable, Sendable {
    let restStart: Date
    /// Time since the rest started.
    let elapsed: TimeInterval
    let nineHours: RestMilestone
    let elevenHours: RestMilestone
}

/// One elapsed-time threshold of a continuous rest.
nonisolated struct RestMilestone: Equatable, Sendable {
    /// The rest start plus the threshold in elapsed seconds.
    let deadline: Date
    /// Time left until `deadline`; zero once it is reached.
    let remaining: TimeInterval
    /// Whether `now` is at or after `deadline`.
    let isReached: Bool
}
