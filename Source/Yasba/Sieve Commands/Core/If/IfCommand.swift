import Foundation
import Observation

enum IfQuantifier: String, CaseIterable, Identifiable, Equatable, CustomStringConvertible {
    case all
    case any

    var id: String { rawValue }

    var hint: String {
        switch self {
        case .all: return "are true"
        case .any: return "is true"
        }
    }
    
    var description: String { rawValue }
}

@Observable
final class IfCommand: SieveContainerCommand, SieveCommandValueEquatable {
    let id = UUID()
    var quantifier: IfQuantifier
    var tests: [SieveTest]
    var thenChildren: [AnySieveCommand]
    var elseChildren: [AnySieveCommand]
    
    var requirements: [String]  {
        return (thenChildren + elseChildren).flatMap { $0.requirements }
    }

    init(
        quantifier: IfQuantifier = .any,
        tests: [SieveTest],
        thenChildren: [AnySieveCommand],
        elseChildren: [AnySieveCommand] = []
    ) {
        self.quantifier = quantifier
        self.tests = tests
        self.thenChildren = thenChildren
        self.elseChildren = elseChildren
    }

    var displayName: String { "If" }
    var isContainer: Bool { true }

    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        guard let other = other as? IfCommand else { return false }
        return quantifier == other.quantifier
            && tests == other.tests
            && thenChildren.count == other.thenChildren.count
            && elseChildren.count == other.elseChildren.count
    }
}
