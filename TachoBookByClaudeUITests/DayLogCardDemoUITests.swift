import XCTest

/// Checks the DEBUG Day log card demo: the edit controls are real, labelled buttons,
/// and tapping one only reports the tap.
final class DayLogCardDemoUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testEditButtonsAreLabelledAndOnlyReportTheTap() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-DayLogCardDemo"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Day log"].waitForExistence(timeout: 10))
        for title in ["Day start", "Driving log", "Day end"] {
            let editButton = app.buttons["Edit \(title)"]
            XCTAssertTrue(editButton.exists, "Missing edit button for \(title)")
            XCTAssertTrue(editButton.isHittable, "Edit button for \(title) can't be tapped")
        }

        try app.performAccessibilityAudit()

        app.buttons["Edit Driving log"].tap()

        let message = app.staticTexts["dayLogDemo.editMessage"]
        XCTAssertTrue(message.waitForExistence(timeout: 5))
        XCTAssertEqual(message.label, "Edit tapped for Driving log. Nothing was changed or saved.")
    }
}
