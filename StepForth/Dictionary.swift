import Foundation

/**
 # The Dictionary
 Words in Forth are stored in a dictionary
 */

typealias Definition = (Stack) throws -> (String)

struct Dictionary {
    private var dict = [(String,Definition)]()

    mutating func add(_ name: String, _ definition: @escaping Definition) {
        dict.insert((name, definition), at: 0)
    }

    func lookup(_ name: String) -> Definition? {
        if let entry = dict.first(where: { $0.0.lowercased() == name.lowercased() }) {
            return entry.1
        }
        return nil
    }

    mutating func forget(_ name: String) {
        if let idx = dict.firstIndex(where: { $0.0.lowercased() == name.lowercased() }) {
            dict.remove(at: idx)
        }
    }
}
