import XCTest
@testable import StepForth

class ForthTests: XCTestCase {

    let forth = Forth()

    /* Should read and execute a line of FORTH */
    func testSimpleLineExecution() throws {
        let output = forth.read(line: "10 20 30")

        XCTAssertEqual(forth.getStack(), "10 20 30 <- Top ")
        XCTAssertEqual(output, " ok")
    }

    /* Should handle weird spacing */
    func testWeirdSpacing() throws {
        forth.read(line: "100\t200     300 ")

        XCTAssertEqual(forth.getStack(), "100 200 300 <- Top ")
    }

}
