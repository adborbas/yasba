import Foundation

@Observable
final class EnvelopeSpec: EditableTestSpec {
    let id: UUID
    var isNegated: Bool
    var part: SieveTest.AddressPart
    var names: [String]
    var match: SieveTest.MatchType
    var keys: [String]

    init(
        id: UUID = UUID(),
        isNegated: Bool = false,
        part: SieveTest.AddressPart = .all,
        names: [String] = ["from"],
        match: SieveTest.MatchType = .contains,
        keys: [String] = [""]
    ) {
        self.id = id
        self.isNegated = isNegated
        self.part = part
        self.names = names
        self.match = match
        self.keys = keys
    }

    convenience init(from test: SieveTest) {
        switch test.primitive {
        case let .envelope(part, names, match, keys):
            self.init(id: test.id,
                      isNegated: test.isNegated,
                      part: part,
                      names: names,
                      match: match,
                      keys: keys)
        default:
            self.init(id: test.id, isNegated: test.isNegated)
        }
    }

    func toDomain() -> SieveTest {
        SieveTest(id: id,
                  isNegated: isNegated,
                  primitive: .envelope(part: part, names: names, match: match, keys: keys))
    }
}
