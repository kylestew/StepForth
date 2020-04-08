import XCTest
@testable import StepForth

class StackTests: XCTestCase {

    var stack = Stack()

    /* Should return pushed value */
    func testPushPop() throws {
        stack.push("5")
        XCTAssertEqual(try? stack.pop(), "5")
    }

    /* Should throw exception on empty stack */
    func testEmptyStackException() {
        XCTAssertThrowsError(try stack.pop())
    }

    /* Should peek stack without removing value */
    func testPeekStack() {
        stack.push("1")
        stack.push("2")
        stack.push("3")
        XCTAssertEqual(stack.peek(), "3")
        XCTAssertEqual(stack.print(), "1 2 3 <- Top ")
    }

    /* Should print stack */
    func testPrintStack() {
        stack.push("1")
        stack.push("2")
        stack.push("3")
        XCTAssertEqual(stack.print(), "1 2 3 <- Top ")
    }
}
