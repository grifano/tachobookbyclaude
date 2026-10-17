import SwiftUI

/// A row's activity glyphs (Figma "Driving Count" / "Rest Count"): 18 pt icons, 8 pt apart.
///
/// Hidden from VoiceOver because the design doesn't define what the glyphs or their tones mean.
struct DayLogIndicatorStrip: View {
    let indicators: [DayLogIndicator]

    @ScaledMetric(relativeTo: .title3) private var side: CGFloat = 18

    var body: some View {
        HStack(spacing: DesignTokens.spacing2) {
            ForEach(indicators.enumerated(), id: \.offset) { _, indicator in
                Image(indicator.image)
                    .resizable()
                    .frame(width: side, height: side)
            }
        }
        .accessibilityHidden(true)
    }
}
