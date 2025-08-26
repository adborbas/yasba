import Foundation
import Testing
@testable import Yasba

/// Minimal non-container command used across tests. Identity is stable via `id`.
final class DummyLeaf: SieveCommand, SieveCommandValueEquatable {
    static let requirement: String = "requirement"
    
    let id: UUID
    var isContainer: Bool { false }
    let text: String

    init(_ text: String, id: UUID = UUID()) {
        self.text = text
        self.id = id
    }

    var requirements: [String] { [DummyLeaf.requirement] }

    func isSemanticallyEqual(to other: any SieveCommand) -> Bool {
        guard let other = other as? DummyLeaf else { return false }
        return id == other.id && text == other.text
    }
}

/// Convenience to build an IfCommand for tests.
func makeIf(
    quantifier: IfQuantifier = .any,
    tests: [SieveTest] = [],
    thenChildren: [any SieveCommand] = [],
    elseChildren: [any SieveCommand] = []
) -> IfCommand {
    IfCommand(
        quantifier: quantifier,
        tests: tests,
        thenChildren: thenChildren,
        elseChildren: elseChildren
    )
}

extension RowToken {
    var debugLabel: String {
        switch self {
        case .beginIf: return "BEGIN"
        case .elseMarker: return "ELSE"
        case .endIf: return "END"
        case .leaf(let command): return "LEAF:\(command.id.uuidString)"
        }
    }
}

/// Convert tokens to a compact signature for equality assertions.
func tokenSignature(_ tokens: [RowToken]) -> [String] {
    tokens.map { $0.debugLabel }
}

/// Extract ordered leaf UUIDs from a token stream.
func leafIDs(in tokens: [RowToken]) -> [UUID] {
    tokens.compactMap {
        if case let .leaf(command: command) = $0 { return command.id } else { return nil }
    }
}

/// Split text into lines for stable assertions.
func lines(_ text: String) -> [String] {
    text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
}

/// Assert two multi-line strings are equal line-by-line for better diffs.
func assertEqualLines(_ rendered: String, _ expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
    #expect(lines(rendered) == lines(expected), sourceLocation: sourceLocation)
}
