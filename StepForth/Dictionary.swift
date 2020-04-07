import Foundation

/**
 # The Dictionary
 Words in Forth ar stored in a dictionary (linked list of dictionary entries)
 */

public class LinkedListNode<T> {
    let value: T
    let next: LinkedListNode

    public init(value: T, next: LinkedListNode) {
        self.value = value
        self.next = next
    }
}

struct Word {
//    let link: Word
    let len: UInt
    let name: String
    let definition: Any
}


