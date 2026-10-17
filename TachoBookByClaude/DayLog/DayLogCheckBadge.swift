import SwiftUI

/// The green check circle at the start of each Day log row (Figma "_Edit Buttons/Light").
///
/// Hidden from VoiceOver: the design shows only this checked state and doesn't say what it means.
struct DayLogCheckBadge: View {
    @ScaledMetric(relativeTo: .title3) private var diameter: CGFloat = 22
    @ScaledMetric(relativeTo: .title3) private var glyphSize: CGFloat = 14.5

    var body: some View {
        Image(systemName: "checkmark")
            .font(.system(size: glyphSize, weight: .semibold))
            .foregroundStyle(.graysWhite)
            .frame(width: diameter, height: diameter)
            .background(.accentsGreen, in: .circle)
            .padding(.leading, 2)
            .padding(.trailing, 1)
            .accessibilityHidden(true)
    }
}
