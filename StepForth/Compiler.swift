import Foundation

// TODO: I have no idea how FORTH compilation works

struct DefinitionBuilder {
    let name: String
    var actions: [Definition]

    mutating func add(_ action: Definition) {
        actions.append(action)
    }

    func compile() throws -> Definition {
        // return simple definition that captures the actions
        return Definition.action { [actions] stack in
            var output = ""
            for action in actions {
                switch action {
                case .action(let action):
                    output += try action(stack)
                default:
                    fatalError("Should not be handling control structures here?")
                }
            }
            return ""
        }
//        throw ForthError.compilationError
    }
}

