import XCTest
@testable import StepForth

class TokenizerTests: XCTestCase {

    /* Should parse a single token */
    func testSingleToken() throws {
        var tokenizer = Tokenizer("1")
        XCTAssertEqual(tokenizer.next(), "1")
        XCTAssertNil(tokenizer.next())
    }

    /* Should return correct value, and null when empty */
    func testReturnsCorrectToken() throws {
        var tokenizer = Tokenizer(" 1 21 321 ")
        XCTAssertEqual(tokenizer.next(), "1")
        XCTAssertEqual(tokenizer.next(), "21")
        XCTAssertEqual(tokenizer.next(), "321")
        XCTAssertNil(tokenizer.next())
    }

    /* Handles strings */
    func testHandlesString() throws {
        var tokenizer = Tokenizer(" 1 .\" hello world\" ")
        XCTAssertEqual(tokenizer.next(), "1")
        XCTAssertEqual(tokenizer.next(), "hello world")
        XCTAssertNil(tokenizer.next())
    }

    /* Handles paren comments */
    func testHandlesParenComments() throws {
        var tokenizer = Tokenizer(" 1 ( this is a comment) 2 ")
        XCTAssertEqual(tokenizer.next(), "1")
        XCTAssertEqual(tokenizer.next(), "2")
        XCTAssertNil(tokenizer.next())

        tokenizer = Tokenizer("( this is a comment )");
        XCTAssertNil(tokenizer.next())
    }

    /* Handles slash comments */
    func testHandlesSlashComments() throws {
        var tokenizer = Tokenizer(" 1 \\ this is a comment 2 ")
        XCTAssertEqual(tokenizer.next(), "1")
        XCTAssertNil(tokenizer.next())
    }
}
