import SwiftUI

/// The circular edit button that ends a Day log row (Figma "Button - Content Area", Bordered, Large).
///
/// A plain-style `Button` drawn with the Figma tokens: the system `.bordered` style would use its own
/// fill and tint the background, which doesn't match `Fills/Tertiary` behind an orange glyph.
struct DayLogEditButton: View {
    let title: LocalizedStringResource
    let action: () -> Void

    @ScaledMetric(relativeTo: .body) private var diameter: CGFloat = 50

    var body: some View {
        Button(action: action) {
            Label {
                Text("Edit \(Text(title))")
            } icon: {
                Image(systemName: "pencil")
            }
            .labelStyle(.iconOnly)
            .font(.body)
            .foregroundStyle(.fillsVibrantPrimary)
            .frame(width: diameter, height: diameter)
            .background(.fillsTertiary, in: .circle)
            .contentShape(.circle)
        }
        .buttonStyle(.plain)
    }
}
