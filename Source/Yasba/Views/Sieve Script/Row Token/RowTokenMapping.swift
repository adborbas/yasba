import Foundation

protocol RowTokenMapping {
    func tokens(from roots: [AnySieveCommand]) -> [RowToken]
    func script(from tokens: [RowToken]) -> [AnySieveCommand]
}

struct RowTokenMapper: RowTokenMapping {
    func tokens(from roots: [AnySieveCommand]) -> [RowToken] {
        var out: [RowToken] = []
        
        func walk(_ nodes: [AnySieveCommand]) {
            for node in nodes {
                if let iff = node as? IfCommand {
                    let groupID = iff.id
                    out.append(.beginIf(header: iff, tokenID: UUID()))
                    walk(iff.thenChildren)
                    out.append(.elseMarker(groupID: groupID, tokenID: UUID()))
                    walk(iff.elseChildren)
                    out.append(.endIf(groupID: groupID, tokenID: UUID()))
                } else {
                    out.append(.leaf(command: node))
                }
            }
        }
        
        walk(roots)
        return out
    }
    
    func script(from tokens: [RowToken]) -> [AnySieveCommand] {
        struct IfFrame {
            var header: IfCommand
            var thenAcc: [AnySieveCommand] = []
            var elseAcc: [AnySieveCommand] = []
            var inElse = false
        }
        
        var stack: [IfFrame] = []
        var out: [AnySieveCommand] = []
        
        func append(_ node: AnySieveCommand) {
            if var top = stack.popLast() {
                if top.inElse { top.elseAcc.append(node) } else { top.thenAcc.append(node) }
                stack.append(top)
            } else {
                out.append(node)
            }
        }
        
        for token in tokens {
            switch token {
            case .leaf(let command):
                append(command)
                
            case .beginIf(let header, _):
                stack.append(IfFrame(header: header))
                
            case .elseMarker:
                guard var top = stack.popLast() else { break }
                top.inElse = true
                stack.append(top)
                
            case .endIf:
                guard let top = stack.popLast() else { break }
                top.header.thenChildren = top.thenAcc
                top.header.elseChildren = top.elseAcc
                append(top.header)
            }
        }
        return out
    }
}
