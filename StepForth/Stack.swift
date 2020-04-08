import Foundation

class Stack {
    private var array = [String]()

    var isEmpty: Bool {
        return array.isEmpty
    }

    var count: Int {
        return array.count
    }

    func push(_ item: String) {
        array.append(item)
    }

    func peek() -> String? {
        return array.last
    }

    func pop() throws -> String {
        if let value = array.popLast() {
            return value
        }
        throw ForthError.stackUnderflowError
    }

    // TODO: should the stack only contain numbers?
    func pushNumber(_ number: Int) {
        push(String(number))
    }
    func popNumber() throws -> Int {
        if let val = Int(try pop()) {
            return val
        }
        throw ForthError.stackUnderflowError
    }
}

extension Stack {
    func print() -> String {
        let str = array.map({$0.description}).joined(separator: " ")
        return "\(str) <- Top "
    }
}
