import XCTest
@testable import Dialogflow

final class DialogflowTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Dialogflow().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
