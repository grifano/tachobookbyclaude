import SwiftUI

/// One Day log row: check badge, title, optional indicators, value, and edit button.
///
/// Both arrangements are built from the same views, so switching between them keeps each element's
/// identity, including for VoiceOver. The badge, indicators and edit button stop growing at the
/// largest non-accessibility text size, leaving the width to the text.
struct DayLogRow: View {
    enum Arrangement {
        /// The Figma layout: one line, with the value and edit button at the trailing edge.
        case inline
        /// For widths where the line doesn't fit: indicators and value move under the title.
        case stacked
    }

    let entry: DayLogEntry
    let arrangement: Arrangement

    var body: some View {
        HStack(spacing: DesignTokens.spacing2) {
            contentLayout {
                // Figma "Col".
                HStack(spacing: DesignTokens.spacing2) {
                    DayLogCheckBadge()
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    Text(entry.title)
                        .alignmentGuide(.dayLogTitle) { $0[.leading] }
                }
                .layoutPriority(1)

                if isInline {
                    Spacer(minLength: 4)
                }

                // Figma "Action", without the edit button. Highest priority, so on one line the
                // value gets its full width first and the spacer only gets what's left.
                DayLogRowValue(entry: entry)
                    .alignmentGuide(.dayLogTitle) { $0[.leading] }
                    .layoutPriority(2)
            }
            .lineLimit(isInline ? 1 : nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.labelsPrimary)
            .accessibilityElement(children: .combine)

            DayLogEditButton(title: entry.title, action: entry.onEdit)
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        }
    }

    private var isInline: Bool {
        arrangement == .inline
    }

    private var contentLayout: AnyLayout {
        switch arrangement {
        case .inline: AnyLayout(HStackLayout(spacing: 0))
        case .stacked: AnyLayout(VStackLayout(alignment: .dayLogTitle, spacing: 4))
        }
    }
}

private extension HorizontalAlignment {
    /// The leading edge of a row's title text, so a stacked value lines up under the title.
    nonisolated enum DayLogTitle: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.leading]
        }
    }

    static let dayLogTitle = HorizontalAlignment(DayLogTitle.self)
}
