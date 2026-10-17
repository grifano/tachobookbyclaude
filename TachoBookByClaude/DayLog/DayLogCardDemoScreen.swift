#if DEBUG
import SwiftUI

/// DEBUG-only screen for checking `DayLogCard` in the Simulator.
///
/// Launch a Debug build with the `-DayLogCardDemo` argument to show it instead of the normal root view.
/// The card shows the Figma sample values; tapping an edit button only reports the tap on screen.
struct DayLogCardDemoScreen: View {
    static let launchArgument = "-DayLogCardDemo"

    @State private var lastEditRequest: LocalizedStringResource?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DayLogCard(title: "Day log", entries: DayLogEntry.designSamples(onEdit: showEditRequest))

                    Label(
                        "Demo with sample values from Figma. Nothing here is recorded shift data, and editing isn't implemented.",
                        systemImage: "info.circle"
                    )
                    .font(.footnote)

                    if let lastEditRequest {
                        Text("Edit tapped for \(Text(lastEditRequest)). Nothing was changed or saved.")
                            .font(.footnote)
                            .accessibilityIdentifier("dayLogDemo.editMessage")
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(.background.secondary)
            .navigationTitle("Day Log Card Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func showEditRequest(for title: LocalizedStringResource) {
        lastEditRequest = title
    }
}
#endif
