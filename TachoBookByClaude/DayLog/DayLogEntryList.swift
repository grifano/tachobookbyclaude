import SwiftUI

/// The rows of a `DayLogCard`, each with the separator line above it.
struct DayLogEntryList: View {
    let entries: [DayLogEntry]
    let arrangement: DayLogRow.Arrangement

    var body: some View {
        VStack(spacing: DesignTokens.spacing2) {
            ForEach(entries.enumerated(), id: \.offset) { index, entry in
                VStack(spacing: 4) {
                    Rectangle()
                        .fill(index == 0 ? Color.graysGray3 : Self.rowSeparator)
                        .frame(height: 1)

                    DayLogRow(entry: entry, arrangement: arrangement)
                }
            }
        }
    }

    /// Figma draws the line under the heading in `Grays/Gray 3` and the lines between rows in
    /// #E6E6E6, which has no variable in the file.
    private static let rowSeparator = Color(red: 230 / 255, green: 230 / 255, blue: 230 / 255)
}
