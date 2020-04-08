import XCTest
@testable import StepForth

extension XCTest {
    func ReadLine(_ forth: Forth, _ command: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(forth.read(line: command), " ok", file: file, line: line)
    }

    func StackShouldEqual(_ forth: Forth, _ expected: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(forth.getStack(), expected, file: file, line: line)
    }
}

