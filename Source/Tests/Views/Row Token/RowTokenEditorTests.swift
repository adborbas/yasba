import Foundation
import Testing
@testable import Yasba

struct RowTokenEditorTests {

    private var editor: RowTokenEditing { RowTokenEditor() }

    private func leaf(_ id: UUID = UUID()) -> RowToken { .leaf(command: DummyLeaf("leaf", id: id)) }
    private func beginIf(_ tokenID: UUID = UUID()) -> RowToken { .beginIf(header: makeIf(), tokenID: tokenID) }
    private func elseMarker(group groupID: UUID, tokenID: UUID = UUID()) -> RowToken { .elseMarker(groupID: groupID, tokenID: tokenID) }
    private func endIf(group groupID: UUID, tokenID: UUID = UUID()) -> RowToken { .endIf(groupID: groupID, tokenID: tokenID) }

    private func isBeginIf(_ token: RowToken) -> Bool { if case .beginIf = token { return true } else { return false } }
    private func isElse(_ token: RowToken) -> Bool { if case .elseMarker = token { return true } else { return false } }
    private func isEndIf(_ token: RowToken) -> Bool { if case .endIf = token { return true } else { return false } }
    private func isLeaf(_ token: RowToken) -> Bool { if case .leaf = token { return true } else { return false } }

    @Test func indentation_singleLeaf() {
        let tokens: [RowToken] = [leaf()]
        #expect(editor.indentation(for: tokens) == [0])
    }

    @Test func indentation_ifElse_block() {
        let groupID = UUID()
        let tokens: [RowToken] = [
            beginIf(),
            leaf(),
            elseMarker(group: groupID),
            leaf(),
            endIf(group: groupID),
            leaf()
        ]
        #expect(editor.indentation(for: tokens) == [0, 1, 0, 1, 0, 0])
    }

    @Test func span_leaf_selectsItself() {
        let tokens: [RowToken] = [leaf(), leaf(), leaf()]
        #expect(editor.dragSpan(at: 1, in: tokens) == 1..<2)
    }

    @Test func span_ifHeader_selectsWholeBlock() {
        let outer = UUID()
        let inner = UUID()
        let tokens: [RowToken] = [
            beginIf(),                // 0
            leaf(),                   // 1
            beginIf(),                // 2
            leaf(),                   // 3
            endIf(group: inner),      // 4
            elseMarker(group: outer), // 5
            leaf(),                   // 6
            endIf(group: outer),      // 7
            leaf()                    // 8
        ]
        #expect(editor.dragSpan(at: 0, in: tokens) == 0..<8)
    }

    @Test func move_singleLeaf_forward() {
        let a = UUID(), b = UUID(), c = UUID(), d = UUID()
        let tokens: [RowToken] = [leaf(a), leaf(b), leaf(c), leaf(d)]
        let moved = editor.move(tokens: tokens, span: 2..<3, toGap: 4)
        #expect(leafIDs(in: moved) == [a, b, d, c])
    }

    @Test func move_ifBlock_keptTogether() {
        let groupID = UUID()
        let tokens: [RowToken] = [beginIf(), leaf(), endIf(group: groupID), leaf()]
        let moved = editor.move(tokens: tokens, span: 0..<3, toGap: 4)
        #expect(moved.count == 4)
        #expect(isLeaf(moved[0]))
        #expect(isBeginIf(moved[1]))
        #expect(isLeaf(moved[2]))
        #expect(isEndIf(moved[3]))
    }

    @Test func remove_leaf_onlyThatRow() {
        let a = UUID(), b = UUID(), c = UUID()
        let tokens: [RowToken] = [leaf(a), leaf(b), leaf(c)]
        let removed = editor.remove(tokens: tokens, at: 1)
        #expect(leafIDs(in: removed) == [a, c])
    }

    @Test func remove_ifHeader_wholeBlock() {
        let groupID = UUID()
        let tailLeafID = UUID()
        let tokens: [RowToken] = [
            beginIf(),
            leaf(),
            elseMarker(group: groupID),
            leaf(),
            endIf(group: groupID),
            leaf(tailLeafID)
        ]
        let removed = editor.remove(tokens: tokens, at: 0)
        #expect(removed.count == 1)
        #expect(isLeaf(removed[0]))
        if case let .leaf(command: command) = removed[0] { #expect(command.id == tailLeafID) }
    }

    @Test func move_leaf_intoIf_thenBack_yieldsOriginalOrder() {
        let a = UUID(), b = UUID(), c = UUID(), d = UUID()
        let groupID = UUID()
        let original: [RowToken] = [
            leaf(a),
            beginIf(),
            leaf(b),
            elseMarker(group: groupID),
            leaf(c),
            endIf(group: groupID),
            leaf(d)
        ]
        let originalSig = tokenSignature(original)
        let intoIf = editor.move(tokens: original, span: 0..<1, toGap: 2)
        guard let indexOfA = intoIf.firstIndex(where: { if case let .leaf(command: cmd) = $0 { return cmd.id == a } else { return false } }) else {
            Issue.record("leaf 'a' should be present after first move"); return
        }
        let backOut = editor.move(tokens: intoIf, span: indexOfA..<(indexOfA+1), toGap: 0)
        #expect(tokenSignature(backOut) == originalSig)
    }
}
