import Foundation

/**
 UI-editable specification for the Sieve `address` test.

 Bridges between the domain model (`SieveTest`) and concrete UI bindings,
 allowing the editor to mutate fields while preserving a stable test identity.
 */
@Observable
final class AddressSpec: EditableTestSpec {
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
        names: [String] = ["From"],
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
        case let .address(part, names, match, keys):
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
                  primitive: .address(part: part, names: names, match: match, keys: keys))
    }
}
