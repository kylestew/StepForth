import XCTest
@testable import StepForth

class DictionaryTests: XCTestCase {

    var stack = Stack()
    var dictionary = Dictionary()

    /* Should be able to lookup added definitions */
    func testAddDefinition() {
        dictionary.add("+", .action({ stack in
            let a = try stack.pop()
            let b = try stack.pop()
            stack.push(a + b)
            return ""
        }))
        XCTAssertNotNil(dictionary.lookup("+"))
    }

    /* Should handle missing definitions */
    func testMissingDefinition() {
        XCTAssertNil(dictionary.lookup("missing"))
    }

    /* Should not be case sensitive */
    func testCaseInsensitive() {
        dictionary.add("BOB", .action({ stack in
            return ""
        }))
        XCTAssertNotNil(dictionary.lookup("bob"))
    }

    /* Should be able to re-define word */
    func testCaseRedefineDefinition() throws {
        var firstDefinitionCalled = 0
        var secondDefinitionCalled = 0

        dictionary.add("BOB", .action({ stack in
            firstDefinitionCalled += 1
            return ""
        }))

        dictionary.add("bob", .action({ stack in
            secondDefinitionCalled += 1
            return ""
        }))

        var action = dictionary.lookup("bob")
        XCTAssertNotNil(action)
        switch action {
        case .action(let action):
            _ = try action(stack)
        default: XCTAssert(false)
        }

        dictionary.forget("bob")

        action = dictionary.lookup("bob")
        XCTAssertNotNil(action)
        switch action {
        case .action(let action):
            _ = try action(stack)
        default: XCTAssert(false)
        }

        XCTAssertEqual(firstDefinitionCalled, 1)
        XCTAssertEqual(secondDefinitionCalled, 1)
    }
}
