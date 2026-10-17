#if DEBUG
import Foundation

extension DayLogEntry {
    /// The sample rows drawn in Figma node 284:5829, for previews and the DEBUG demo screen.
    /// They are display content only, not recorded or calculated shift data.
    static func designSamples(onEdit: @escaping (LocalizedStringResource) -> Void) -> [DayLogEntry] {
        let samples: [(title: LocalizedStringResource, value: String, indicators: [DayLogIndicator])] = [
            ("Day start", "6:30AM", []),
            ("Driving log", "9H30M", [.drivingFaint, .driving]),
            ("Day end", "8:30PM", [.restFaint, .rest, .rest]),
        ]

        return samples.map { sample in
            DayLogEntry(title: sample.title, value: sample.value, indicators: sample.indicators) {
                onEdit(sample.title)
            }
        }
    }
}
#endif
