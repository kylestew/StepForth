import XCTest
@testable import StepForth

class DictionaryTests: XCTestCase {

    var stack = Stack<String>()
    var dictionary = Dictionary()

    /* Should be able to lookup added definitions */
    func testAddDefinition() {
        dictionary.add("+", { stack in
            let a = try stack.pop()
            let b = try stack.pop()
            stack.push(a + b)
        })
        XCTAssertNotNil(dictionary.lookup("+"))
    }

    /* Should handle missing definitions */
    func testMissingDefinition() {
        XCTAssertNil(dictionary.lookup("missing"))
    }

    /* Should not be case sensitive */
    func testCaseInsensitive() {
        dictionary.add("BOB", { stack in
        })
        XCTAssertNotNil(dictionary.lookup("bob"))
    }

    /* Should be able to re-define word */
    func testCaseRedefineDefinition() throws {
        var firstDefinitionCalled = 0
        var secondDefinitionCalled = 0

        dictionary.add("BOB", { stack in
            firstDefinitionCalled += 1
        })

        dictionary.add("bob", { stack in
            secondDefinitionCalled += 1
        })

        try dictionary.lookup("bob")!(stack)
        dictionary.forget("bob")
        try dictionary.lookup("bob")!(stack)

        XCTAssertEqual(firstDefinitionCalled, 1)
        XCTAssertEqual(secondDefinitionCalled, 1)
    }
}
