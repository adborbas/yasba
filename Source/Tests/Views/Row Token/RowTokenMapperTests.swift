import Foundation
import Testing
@testable import Yasba

struct RowTokenMapperTests {
    let mapper = RowTokenMapper()

    @Test func tokens_from_script_producesExpectedSequence() {
        let a = DummyLeaf("A")
        let b = DummyLeaf("B")
        let c = DummyLeaf("C")
        let iff = makeIf(thenChildren: [a, b], elseChildren: [c])

        let tokens = mapper.tokens(from: [iff])
        #expect(tokens.count == 6)
        let sig = tokenSignature(tokens)
        #expect(sig[0] == "BEGIN")
        #expect(sig[3] == "ELSE")
        #expect(sig[5] == "END")
    }

    @Test func script_from_tokens_rebuildsNestedStructure() {
        let x = DummyLeaf("X")
        let y = DummyLeaf("Y")
        let z = DummyLeaf("Z")
        let w = DummyLeaf("W")
        let iff = makeIf(thenChildren: [y], elseChildren: [z])

        let tokens = mapper.tokens(from: [x, iff, w])
        let rebuilt = mapper.script(from: tokens)

        #expect(rebuilt.count == 3)
        #expect(rebuilt[0] as? DummyLeaf === x)
        #expect(rebuilt[2] as? DummyLeaf === w)

        guard let rebuiltIf = rebuilt[1] as? IfCommand else {
            Issue.record("Second root should be IfCommand"); return
        }
        #expect(rebuiltIf === iff)
        #expect(rebuiltIf.thenChildren.first as? DummyLeaf === y)
        #expect(rebuiltIf.elseChildren.first as? DummyLeaf === z)
    }

    @Test func roundTrip_roots_tokens_script_keepsIdentities() {
        let a = DummyLeaf("A")
        let b = DummyLeaf("B")
        let c = DummyLeaf("C")
        let innerIf = makeIf(thenChildren: [b])
        let roots: [AnySieveCommand] = [a, innerIf, c]

        let tokens = mapper.tokens(from: roots)
        let rebuilt = mapper.script(from: tokens)

        #expect(rebuilt.count == 3)
        #expect(rebuilt[0] as? DummyLeaf === a)
        #expect(rebuilt[2] as? DummyLeaf === c)
        #expect((rebuilt[1] as? IfCommand) === innerIf)
        #expect((rebuilt[1] as? IfCommand)?.thenChildren.first as? DummyLeaf === b)
    }

    @Test func roundTrip_tokens_script_tokens_keepsKinds() {
        let leaf1 = DummyLeaf("L1")
        let leaf2 = DummyLeaf("L2")
        let iff = makeIf(thenChildren: [leaf1], elseChildren: [leaf2])

        let original = mapper.tokens(from: [iff])
        let rebuiltRoots = mapper.script(from: original)
        let relinearized = mapper.tokens(from: rebuiltRoots)

        #expect(tokenSignature(original) == tokenSignature(relinearized))
    }

    @Test func multipleRoots_linearizeInOrder() {
        let a = DummyLeaf("A")
        let b = DummyLeaf("B")
        let c = DummyLeaf("C")
        let iff = makeIf()

        let tokens = mapper.tokens(from: [a, iff, b, c])
        let sig = tokenSignature(tokens)

        #expect(sig.first == "LEAF:\(a.id.uuidString)")
        #expect(sig.contains("BEGIN"))
        #expect(sig.suffix(2).count == 2)
    }

    @Test func malformed_strayElse_isIgnored() {
        let a = DummyLeaf("A")
        let bogusGroup = UUID()
        let tokens: [RowToken] = [
            .leaf(command: a),
            .elseMarker(groupID: bogusGroup, tokenID: UUID())
        ]
        let rebuilt = mapper.script(from: tokens)
        #expect(rebuilt.count == 1)
        #expect(rebuilt.first as? DummyLeaf === a)
    }
}
