import Foundation

struct Forth {

    struct Action {
    }

    private func tokenToAction(_ token: String) -> Action? {
        return nil
    }

    private func execute(_ action: Action, tokenizer: Tokenizer) -> String {
        return ""
    }

    func read(line: String) -> String {
        let tokenizer = Tokenizer(line)
//        while let token = tokenizer.next() {
//            let action = tokenToAction(token)!
//
//            execute(action, tokenizer: tokenizer)
//        }

        return " ok"
    }

    func getStack() -> String {
        return "TODO"
    }
}
