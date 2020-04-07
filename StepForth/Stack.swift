import Foundation

/**
 Generic LIFO stack
 */
struct Stack<T> {
    enum StackError: Error {
        case StackUnderflowError
    }

    private var array = [T]()

    var isEmpty: Bool {
        return array.isEmpty
    }

    var count: Int {
        return array.count
    }

    mutating func push(_ item: T) {
        array.append(item)
    }

    func peek() -> T? {
        return array.last
    }

    mutating func pop() throws -> T {
        if let value = array.popLast() {
            return value
        }
        throw StackError.StackUnderflowError
    }
}

extension Stack where T:CustomStringConvertible {
    func print() -> String {
        let str = array.map({$0.description}).joined(separator: " ")
        return "\(str) <- Top "
    }
}
