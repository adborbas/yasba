import Foundation

@Observable
final class HeaderSpec: EditableTestSpec {
    let id: UUID
    var isNegated: Bool
    var names: [String]
    var match: SieveTest.MatchType
    var keys: [String]

    init(
        id: UUID = UUID(),
        isNegated: Bool = false,
        names: [String] = ["Subject"],
        match: SieveTest.MatchType = .contains,
        keys: [String] = [""]
    ) {
        self.id = id
        self.isNegated = isNegated
        self.names = names
        self.match = match
        self.keys = keys
    }

    convenience init(from test: SieveTest) {
        switch test.primitive {
        case let .header(names, match, keys):
            self.init(id: test.id, isNegated: test.isNegated, names: names, match: match, keys: keys)
        default:
            self.init(id: test.id, isNegated: test.isNegated)
        }
    }

    func toDomain() -> SieveTest {
        SieveTest(id: id, isNegated: isNegated, primitive: .header(names: names, match: match, keys: keys))
    }
}
