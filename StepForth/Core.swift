import Foundation

struct Core {
    static func MakeDictionary() -> Dictionary {
        var dict = Dictionary()


        // MARK: - Output

        dict.add(".") { stack in
            return try stack.pop() + " "
        }

        dict.add(".s") { stack in
            return stack.print()
        }

        // MARK: - Math

        dict.add("+") { stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a + b)
            return ""
        }

        dict.add("*") { stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a * b)
            return ""
        }

        // MARK: - Stack Manipulation

        dict.add("swap") { stack in
            let a = try stack.pop()
            let b = try stack.pop()
            stack.push(a)
            stack.push(b)
            return ""
        }


        return dict
    }
}
