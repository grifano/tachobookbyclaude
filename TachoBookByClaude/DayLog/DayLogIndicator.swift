import SwiftUI

/// A small activity glyph from the Figma "Driving Count" and "Rest Count" components.
///
/// Figma draws each glyph in two tones: `Labels/Secondary` and the fainter `Labels/Quaternary`.
/// The design does not define what the tones mean, so they are named by appearance only.
enum DayLogIndicator {
    case driving
    case drivingFaint
    case rest
    case restFaint

    var image: ImageResource {
        switch self {
        case .driving: .iconDriveSecondary
        case .drivingFaint: .iconDriveQuaternary
        case .rest: .iconRestSecondary
        case .restFaint: .iconRestQuaternary
        }
    }
}
