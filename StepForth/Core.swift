import Foundation

struct Core {
    static func MakeDictionary() -> Dictionary {
        var dict = Dictionary()

        // MARK: - Control Codes

        // TODO: simplify this
        dict.add(":", .control(":"))
        dict.add(";", .control(";"))

        // MARK: - Output

        dict.add(".", .action({ stack in
            return try stack.pop() + " "
        }))

        dict.add(".s", .action({ stack in
            return stack.print()
        }))

        // MARK: - Math

        dict.add("+", .action({ stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a + b)
            return ""
        }))

        dict.add("*", .action({ stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a * b)
            return ""
        }))

        // MARK: - Stack Manipulation

        dict.add("swap", .action({ stack in
            let a = try stack.pop()
            let b = try stack.pop()
            stack.push(a)
            stack.push(b)
            return ""
        }))


        return dict
    }
}
