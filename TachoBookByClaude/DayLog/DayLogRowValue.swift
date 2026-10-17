import SwiftUI

/// A row's indicators and value. At accessibility text sizes the indicators move above the value,
/// so the value isn't squeezed and broken up.
struct DayLogRowValue: View {
    let entry: DayLogEntry

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(spacing: DesignTokens.spacing2))

        layout {
            if !entry.indicators.isEmpty {
                DayLogIndicatorStrip(indicators: entry.indicators)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }

            Text(entry.value)
                .foregroundStyle(.labelsSecondary)
        }
    }
}
