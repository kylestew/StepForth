import Foundation


enum ForthError : Error {
    case missingWordError(String)
    case stackUnderflowError
    case zeroLengthDefinitionName
    case compilationError // TODO: not correct term

    fileprivate func toOutput() -> ForthOutput {
        switch self {
        case .missingWordError(let word):
            return .missingWord(word)
        case .stackUnderflowError:
            return .stackUnderflow
        case .zeroLengthDefinitionName:
            return .zeroLengthName
        case .compilationError:
            return .compilationError
        }
    }
}

fileprivate enum ForthOutput : CustomStringConvertible {

    case ok

    case stackUnderflow
    case missingWord(String)
    case zeroLengthName
    case compilationError

    var description: String {
        get {
            switch self {
            case .ok:
                return "ok"
            case .stackUnderflow:
                return "Stack underflow"
            case .missingWord(let word):
                return "\(word) ? "
            case .zeroLengthName:
                return "Attempt to use zero-length string as a name"
            case .compilationError:
                return "Error compiling"
            }
        }
    }
}

public class Forth {

    private let stack = Stack()
//    private let returnStack = Stack<String>()
    private var dictionary: Dictionary
//    private let memory = Memory()

    private var currentDefinition: DefinitionBuilder?

    public init() {
        // load core word set
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
            return .action { stack in
                stack.push(word)
                return ""
            }

        } else {
            throw ForthError.missingWordError(word)
        }
    }

    /**
     FORTH can be in a few different control modes. Update its state based
     on the passed in key.
     */
    private func setControlMode(with key: String, tokenizer: inout Tokenizer) throws {
        switch key {
        case ":":
            if let token = tokenizer.next() {
                startDefinition(token)
            } else {
                throw ForthError.zeroLengthDefinitionName
            }

        default:
            fatalError("Undefined control mode for \(key)")
        }
    }

    /**
     Process individual token from input. Token is fetched from dictionary.
     FORTH will switch processing modes here based on fetched definition.
     */
    private func process(token: String, tokenizer: inout Tokenizer) throws -> String {
        let def = try definition(for: token)

        if currentDefinition != nil {
            // defining new word
            try addToCurrentDefinition(def)

        } else {
            // execute word
            switch def {
            case .control(let key):
                // update control mode
                try setControlMode(with: key, tokenizer: &tokenizer)

            case .action(let action):
                // execute action
                return try action(stack)

            }
        }

        return ""
    }

    /**
     Process 1 line of input and return the status.
     */
    public func read(line: String) -> String {
        var tokenizer = Tokenizer(line)
        var output = ""
        let result: ForthOutput?

        do {
            // split into tokens and send them off to be processed
            while let token = tokenizer.next() {
                output += try process(token: token, tokenizer: &tokenizer)
            }

            // no result if in the middle of a multiline definition
            result = currentDefinition == nil ? .ok : nil

        } catch let error {
            // all standard FORTH errors should be caught and returned here
            if let error = error as? ForthError {
                result = error.toOutput()
            } else {
                fatalError(error.localizedDescription)
            }
        }

        if let result = result {
            return "\(output) \(result)"
        }
        return output
    }
}

// MARK: - Definition Builder

extension Forth {
    private func startDefinition(_ word: String) {
        currentDefinition = DefinitionBuilder(name: word, actions: [])
    }

    private func addToCurrentDefinition(_ action: Definition) throws {
        if case .control(let key) = action,
            key == ";" {
            try endDefinition()
        } else {
            currentDefinition?.add(action)
        }
    }

    private func endDefinition() throws {
        guard let currentDefinition = currentDefinition else { return }

        // compile and add to dictionary
        let definition = try currentDefinition.compile()
        dictionary.add(currentDefinition.name, definition)

        self.currentDefinition = nil
    }
}

extension Forth {
    /**
     Use to display state of stack.
     */
    func getStack() -> String {
        return stack.print()
    }
}
