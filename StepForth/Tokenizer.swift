import Foundation


fileprivate extension String {
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
}

struct Tokenizer {
    private var input: String

    init(_ input: String) {
        self.input = input
    }

    /**
     Returns next token in input or nil if parsing is commplete.
     */
    mutating func next() -> String? {
        input = input.removingLeadingSpaces()

        let isStringLiteral = input.starts(with: ".\" ")
        let isParenComment = input.starts(with: "( ")
        let isSlashComment = input.starts(with: "\\ ")

        var token: String?
        if (isStringLiteral) {

            // skip '." ' string start
            input.removeFirst(3)

            if let range = input.range(of: #"[^\"]*"#, options: .regularExpression) {
                token = String(input[range])

                // skip over final "
                let idx = input.index(range.upperBound, offsetBy: 1)
                input = String(input[idx...])
            }

        } else if (isParenComment) {

            // find end of comment
            if let range = input.range(of: #"[^)]*"#, options: .regularExpression) {
                token = String(input[range])

                // skip over ")"
                let idx = input.index(range.upperBound, offsetBy: 1)
                input = String(input[idx...])
            }

            // ignore this token and return the next one
            return next()

        } else if (isSlashComment) {

            // nothing can come after a slash comment
            return nil

        } else {
            // normal token
            if let range = input.range(of: #"\S+"#, options: .regularExpression) {
                token = String(input[range])

                // trim input to current end of token range
                input = String(input[range.upperBound...])
            }
        }

        return token
    }
}

