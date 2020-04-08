import Foundation

struct Forth {

    private let dictionary = Dictionary()
    private let stack = Stack<String>()

    private func isFinite() -> Bool {
        return false
    }

    private func action(for token: String) -> Definition? {
        // TODO: string literals? Tokens may need to be enum
        let word = token

        if let definition = dictionary.lookup(word) {

            return definition

        } else if (Int(word) != nil) {

            return { stack in
                stack.push(word)
            }

        }

        return nil
    }

//    private func execute(_ action: Action, tokenizer: Tokenizer) -> String {
//        return ""
//    }

//    private func

    func read(line: String) -> String {

        var tokenizer = Tokenizer(line)
        while let token = tokenizer.next() {
            if let def = action(for: token) {

                try! def(stack)
//                execute(action, tokenizer: tokenizer)

            }

        }

        return " ok"
    }

    func getStack() -> String {
        return stack.print()
    }
}
