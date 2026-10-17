import Foundation
import Testing
@testable import TachoBookByClaude

/// Control cases C01–C10 from the task "9/11 h Rest Calculator + Tests",
/// based on Regulatory Rules Specification v1 (R-D02 milestones, R-T01, R-U01, R-E01).
/// Expected values are hand-derived literals; local times use explicit time zones.
struct RestMilestoneCalculatorTests {
    @Test("C01/V27: deadlines are 9 h and 11 h of elapsed time after the rest start")
    func deadlinesAreElapsedHoursAfterRestStart() throws {
        let restStart = try instant("2026-10-12T22:57:00+02:00")

        let milestones = try requireMilestones(restStart: restStart, now: restStart)

        #expect(try milestones.nineHours.deadline == instant("2026-10-13T05:57:00Z"))
        #expect(try milestones.elevenHours.deadline == instant("2026-10-13T07:57:00Z"))
    }

    @Test("C01, C03, C04, C05, C07: deadlines shown in local time", arguments: [
        LocalDeadlineCase(
            id: "C01/V27 Berlin",
            restStart: "2026-10-12T22:57:00+02:00", timeZone: "Europe/Berlin",
            nineHours: "2026-10-13 07:57 +02:00", elevenHours: "2026-10-13 09:57 +02:00"
        ),
        LocalDeadlineCase(
            id: "C03/V28 autumn DST, Berlin",
            restStart: "2026-10-24T22:00:00+02:00", timeZone: "Europe/Berlin",
            nineHours: "2026-10-25 06:00 +01:00", elevenHours: "2026-10-25 08:00 +01:00"
        ),
        LocalDeadlineCase(
            id: "C04/V29 spring DST, Berlin",
            restStart: "2026-03-28T22:00:00+01:00", timeZone: "Europe/Berlin",
            nineHours: "2026-03-29 08:00 +02:00", elevenHours: "2026-03-29 10:00 +02:00"
        ),
        LocalDeadlineCase(
            id: "C05/V31 C01 shown in Kyiv",
            restStart: "2026-10-12T22:57:00+02:00", timeZone: "Europe/Kyiv",
            nineHours: "2026-10-13 08:57 +03:00", elevenHours: "2026-10-13 10:57 +03:00"
        ),
        LocalDeadlineCase(
            id: "C07/R-E01 C01 start corrected to 23:12",
            restStart: "2026-10-12T23:12:00+02:00", timeZone: "Europe/Berlin",
            nineHours: "2026-10-13 08:12 +02:00", elevenHours: "2026-10-13 10:12 +02:00"
        ),
    ])
    func deadlinesInLocalTime(_ testCase: LocalDeadlineCase) throws {
        let restStart = try instant(testCase.restStart)

        let milestones = try requireMilestones(restStart: restStart, now: restStart)

        #expect(try localTime(milestones.nineHours.deadline, in: testCase.timeZone) == testCase.nineHours)
        #expect(try localTime(milestones.elevenHours.deadline, in: testCase.timeZone) == testCase.elevenHours)
    }

    @Test("C02/R-D02: 9 h boundary — one second before, exactly at, one second after", arguments: [
        BoundaryCase(now: "2026-10-13T05:56:59Z", remaining: 1, isReached: false),
        BoundaryCase(now: "2026-10-13T05:57:00Z", remaining: 0, isReached: true),
        BoundaryCase(now: "2026-10-13T05:57:01Z", remaining: 0, isReached: true),
    ])
    func nineHourBoundary(_ testCase: BoundaryCase) throws {
        let milestones = try requireMilestones(
            restStart: instant("2026-10-12T22:57:00+02:00"),
            now: instant(testCase.now)
        )

        #expect(milestones.nineHours.remaining == testCase.remaining)
        #expect(milestones.nineHours.isReached == testCase.isReached)
    }

    @Test("C02/R-D02: 11 h boundary — one second before, exactly at, one second after", arguments: [
        BoundaryCase(now: "2026-10-13T07:56:59Z", remaining: 1, isReached: false),
        BoundaryCase(now: "2026-10-13T07:57:00Z", remaining: 0, isReached: true),
        BoundaryCase(now: "2026-10-13T07:57:01Z", remaining: 0, isReached: true),
    ])
    func elevenHourBoundary(_ testCase: BoundaryCase) throws {
        let milestones = try requireMilestones(
            restStart: instant("2026-10-12T22:57:00+02:00"),
            now: instant(testCase.now)
        )

        #expect(milestones.elevenHours.remaining == testCase.remaining)
        #expect(milestones.elevenHours.isReached == testCase.isReached)
    }

    @Test("C02/R-D02: exactly at 9 h, the 11 h milestone has 7200 s remaining")
    func elevenHoursRemainingAtNineHours() throws {
        let milestones = try requireMilestones(
            restStart: instant("2026-10-12T22:57:00+02:00"),
            now: instant("2026-10-13T05:57:00Z")
        )

        #expect(milestones.elevenHours.remaining == 7_200)
        #expect(milestones.elevenHours.isReached == false)
    }

    @Test("R-D02: half a second before the deadline is not rounded up to reached")
    func subSecondBeforeDeadlineIsNotReached() throws {
        let milestones = try requireMilestones(
            restStart: instant("2026-10-12T22:57:00+02:00"),
            now: instant("2026-10-13T05:57:00Z").addingTimeInterval(-0.5)
        )

        #expect(milestones.nineHours.remaining == 0.5)
        #expect(milestones.nineHours.isReached == false)
    }

    @Test("C06/R-T01: a rest start restored after relaunch gives elapsed 4 h, remaining 5 h / 7 h")
    func restoredRestStartAfterRelaunch() throws {
        let persisted = try instant("2026-10-12T22:57:00+02:00").timeIntervalSince1970
        let restored = Date(timeIntervalSince1970: persisted)
        let now = try instant("2026-10-13T02:57:00+02:00")

        let milestones = try requireMilestones(restStart: restored, now: now)

        #expect(milestones.elapsed == 14_400)
        #expect(milestones.nineHours.remaining == 18_000)
        #expect(milestones.elevenHours.remaining == 25_200)
    }

    @Test("C08/V34: a missing rest start gives no data, not milestones from an assumed start")
    func missingRestStartGivesNoData() throws {
        let result = try RestMilestoneCalculator.evaluate(restStart: nil, now: instant("2026-10-13T02:57:00+02:00"))

        #expect(result == .noData)
    }

    @Test("C08: a rest start later than now is invalid input, not a negative or clamped timer")
    func restStartAfterNowIsInvalidInput() throws {
        let result = try RestMilestoneCalculator.evaluate(
            restStart: instant("2026-10-12T22:57:01+02:00"),
            now: instant("2026-10-12T22:57:00+02:00")
        )

        #expect(result == .invalidInput)
    }

    @Test("C08 boundary: now equal to the rest start is valid with zero elapsed time")
    func nowEqualToRestStartIsValid() throws {
        let restStart = try instant("2026-10-12T22:57:00+02:00")

        let milestones = try requireMilestones(restStart: restStart, now: restStart)

        #expect(milestones.elapsed == 0)
        #expect(milestones.nineHours.remaining == 32_400)
        #expect(milestones.elevenHours.remaining == 39_600)
        #expect(milestones.nineHours.isReached == false)
    }

    @Test("C09/R-U01: with unknown weekly history and reduction count, the result holds only duration facts")
    func resultHoldsOnlyDurationFacts() throws {
        // The calculator takes no weekly history or reduction count, and its result has no
        // eligibility, rest classification, or counter: a reached 9 h milestone is only a time fact.
        let restStart = try instant("2026-10-12T22:57:00+02:00")
        let expected = try RestMilestones(
            restStart: restStart,
            elapsed: 36_000,
            nineHours: RestMilestone(deadline: instant("2026-10-13T05:57:00Z"), remaining: 0, isReached: true),
            elevenHours: RestMilestone(deadline: instant("2026-10-13T07:57:00Z"), remaining: 3_600, isReached: false)
        )

        let result = try RestMilestoneCalculator.evaluate(restStart: restStart, now: instant("2026-10-13T08:57:00+02:00"))

        #expect(result == .milestones(expected))
    }

    @Test("C10/R-T01: 30 h after the rest start both milestones are reached and the rest is unchanged")
    func thirtyHoursAfterRestStart() throws {
        let restStart = try instant("2026-10-12T22:57:00+02:00")

        let milestones = try requireMilestones(restStart: restStart, now: instant("2026-10-14T04:57:00+02:00"))

        #expect(milestones.restStart == restStart)
        #expect(milestones.elapsed == 108_000)
        #expect(milestones.nineHours.remaining == 0)
        #expect(milestones.elevenHours.remaining == 0)
        #expect(milestones.nineHours.isReached)
        #expect(milestones.elevenHours.isReached)
    }
}

struct LocalDeadlineCase: Sendable, CustomTestStringConvertible {
    let id: String
    let restStart: String
    let timeZone: String
    let nineHours: String
    let elevenHours: String

    var testDescription: String { id }
}

struct BoundaryCase: Sendable, CustomTestStringConvertible {
    let now: String
    let remaining: TimeInterval
    let isReached: Bool

    var testDescription: String { "now \(now): remaining \(remaining) s, reached \(isReached)" }
}

extension RestMilestoneResult {
    var milestones: RestMilestones? {
        if case .milestones(let milestones) = self { milestones } else { nil }
    }
}

/// Evaluates a rest that must produce milestones; records an issue for no-data or invalid-input results.
private func requireMilestones(
    restStart: Date,
    now: Date,
    sourceLocation: SourceLocation = #_sourceLocation
) throws -> RestMilestones {
    let result = RestMilestoneCalculator.evaluate(restStart: restStart, now: now)
    return try #require(result.milestones, "Expected milestones, got \(result)", sourceLocation: sourceLocation)
}

/// Parses an ISO 8601 timestamp with an explicit offset or `Z`.
private func instant(_ iso8601: String, sourceLocation: SourceLocation = #_sourceLocation) throws -> Date {
    try #require(ISO8601DateFormatter().date(from: iso8601), "Invalid timestamp \(iso8601)", sourceLocation: sourceLocation)
}

/// Formats a date as `yyyy-MM-dd HH:mm ±HH:MM` in the given zone, independent of the device locale and zone.
private func localTime(
    _ date: Date,
    in timeZoneIdentifier: String,
    sourceLocation: SourceLocation = #_sourceLocation
) throws -> String {
    let timeZone = try #require(TimeZone(identifier: timeZoneIdentifier), sourceLocation: sourceLocation)
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    let offset = timeZone.secondsFromGMT(for: date)
    return String(
        format: "%04d-%02d-%02d %02d:%02d %@%02d:%02d",
        parts.year ?? 0, parts.month ?? 0, parts.day ?? 0, parts.hour ?? 0, parts.minute ?? 0,
        offset < 0 ? "-" : "+", abs(offset) / 3_600, abs(offset) % 3_600 / 60
    )
}
