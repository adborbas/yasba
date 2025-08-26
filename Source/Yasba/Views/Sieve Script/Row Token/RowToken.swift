import Foundation

enum RowToken: Identifiable, Equatable {
    case beginIf(header: IfCommand, tokenID: UUID)
    case elseMarker(groupID: UUID, tokenID: UUID)
    case endIf(groupID: UUID, tokenID: UUID)
    case leaf(command: AnySieveCommand)

    var id: UUID {
        switch self {
        case .beginIf(_, let tokenID):    return tokenID
        case .elseMarker(_, let tokenID): return tokenID
        case .endIf(_, let tokenID):      return tokenID
        case .leaf(let cmd):              return cmd.id
        }
    }

    static func == (lhs: RowToken, rhs: RowToken) -> Bool {
        lhs.id == rhs.id
    }
    
    var canRemove: Bool {
        switch self {
        case .elseMarker, .endIf: return false
        default: return true
        }
    }
    
    var canDrag: Bool {
        switch self {
        case .elseMarker, .endIf: return false
        default: return true
        }
    }
}
