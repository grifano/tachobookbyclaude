import SwiftUI

/// The "Day log" card from Figma node 284:5829 (Development page, "Day's Shifts").
///
/// The card takes the width its container offers; give it the screen's horizontal margins
/// (16 pt in Figma). Rows use the designed single-line layout when every row fits, and otherwise
/// all switch to a two-line layout, so titles, values and edit buttons never overlap on narrow
/// screens or at large Dynamic Type sizes.
struct DayLogCard: View {
    let title: LocalizedStringResource
    let entries: [DayLogEntry]

    /// Figma "Footnote/Emphasized" line height; SwiftUI's natural footnote line is about 2 pt shorter.
    @ScaledMetric(relativeTo: .footnote) private var titleLineHeight: CGFloat = 18

    @State private var availableWidth: CGFloat = 0
    @State private var inlineWidth: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .lineHeight(.exact(points: titleLineHeight))
                .foregroundStyle(.labelsPrimary)
                .accessibilityAddTraits(.isHeader)

            // Like `ViewThatFits`, but the rows keep their identity when the arrangement changes.
            DayLogEntryList(entries: entries, arrangement: inlineWidth <= availableWidth ? .inline : .stacked)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { availableWidth = $0 }
                .background(alignment: .topLeading) {
                    // An invisible copy at its natural width shows whether every row fits on one line.
                    DayLogEntryList(entries: entries, arrangement: .inline)
                        .fixedSize()
                        .hidden()
                        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { inlineWidth = $0 }
                }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: DesignTokens.radiusXL)
                .fill(.graysWhite)
                .strokeBorder(.separatorsVibrant, lineWidth: 2)
        }
        .accessibilityElement(children: .contain)
    }
}

#if DEBUG
#Preview("Figma sample") {
    DayLogCardDemoScreen()
}

#Preview("Accessibility text size") {
    DayLogCardDemoScreen()
        .dynamicTypeSize(.accessibility2)
}
#endif
