import Foundation

/// One row of a `DayLogCard`: a labelled, already formatted value with an edit affordance.
///
/// The card only displays these inputs. It does not format, store, or validate shift data,
/// and `onEdit` is whatever the caller decides an edit request should do.
struct DayLogEntry {
    let title: LocalizedStringResource
    /// Display text for the value, formatted by the caller (for example a time or a duration).
    let value: String
    /// Activity glyphs shown before the value, in order; empty when the row has none.
    let indicators: [DayLogIndicator]
    let onEdit: () -> Void

    init(
        title: LocalizedStringResource,
        value: String,
        indicators: [DayLogIndicator] = [],
        onEdit: @escaping () -> Void
    ) {
        self.title = title
        self.value = value
        self.indicators = indicators
        self.onEdit = onEdit
    }
}
