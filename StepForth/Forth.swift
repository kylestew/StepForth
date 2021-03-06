import Foundation


enum ForthError : Error {
    case missingWordError(String)
    case stackUnderflowError

    fileprivate func toOutput() -> ForthOutput {
        switch self {
        case .missingWordError(let word):
            return .missingWord(word)
        case .stackUnderflowError:
            return .stackUnderflow
        }
    }
}

fileprivate enum ForthOutput : CustomStringConvertible {
    case ok
    case stackUnderflow
    case missingWord(String)

    var description: String {
        get {
            switch self {
            case .ok:
                return "ok"
            case .stackUnderflow:
                return "Stack underflow"
            case .missingWord(let word):
                return "\(word) ? "
            }
        }
    }
}


public struct Forth {

    private let stack = Stack()
//    private let returnStack = Stack<String>()
    private var dictionary: Dictionary
//    private let memory = Memory()

    public init() {
        dictionary = Core.MakeDictionary()
    }

    /**
     Throw `missingWordError` if word cannot be:
     - Fetched as a definition from the dictionary
     - Converted to a number
     - Treated as a string
     */
    private func definition(for word: String) throws -> Definition {

        // TODO: how are string literals handled?

        if let definition = dictionary.lookup(word) {

            return definition

        } else if (Int(word) != nil) {

            // definition to push numeric value on stack
            return { stack in
                stack.push(word)
                return ""
            }

        } else {
            throw ForthError.missingWordError(word)
        }
    }

    /**
     Process individual token from input. Token is fetched from dictionary.
     FORTH can be defining a definition or in regular mode.
     */
    private func process(token: String) throws -> String {
        let def = try definition(for: token)

        // TODO: add to current definition if in define mode

        // execute
        let output = try def(stack)

        //                execute(action, tokenizer: tokenizer)

        return output
    }

    /**
     Handle 1 line of input and return status.
     */
    public func read(line: String) -> String {
        var tokenizer = Tokenizer(line)
        var output = ""
        var result: ForthOutput = .ok

        do {
            while let token = tokenizer.next() {
                output += try process(token: token)
            }
        } catch let error {
            if let error = error as? ForthError {
                result = error.toOutput()
            } else {
                fatalError(error.localizedDescription)
            }
        }

        return "\(output) \(result)"
    }

    /**
     Use to display state of stack.
     */
    func getStack() -> String {
        return stack.print()
    }
}
