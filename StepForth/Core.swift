import Foundation

struct Core {
    static func MakeDictionary() -> Dictionary {
        var dict = Dictionary()



        // MARK: - Math

        dict.add("+") { stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a + b)
        }

        dict.add("*") { stack in
            let a = try stack.popNumber()
            let b = try stack.popNumber()
            stack.pushNumber(a * b)
        }

        // MARK: - Stack Manipulation

        dict.add("swap") { stack in
            let a = try stack.pop()
            let b = try stack.pop()
            stack.push(a)
            stack.push(b)
        }


        return dict
    }
}
