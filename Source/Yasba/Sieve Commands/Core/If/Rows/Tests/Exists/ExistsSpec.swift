import Foundation

@Observable
final class ExistsSpec: EditableTestSpec {
    let id: UUID
    var isNegated: Bool
    var fields: [String]

    init(
        id: UUID = UUID(),
        isNegated: Bool = false,
        fields: [String] = ["Subject"]
    ) {
        self.id = id
        self.isNegated = isNegated
        self.fields = fields
    }

    convenience init(from test: SieveTest) {
        switch test.primitive {
        case let .exists(fields):
            self.init(id: test.id, isNegated: test.isNegated, fields: fields)
        default:
            self.init(id: test.id, isNegated: test.isNegated)
        }
    }

    func toDomain() -> SieveTest {
        SieveTest(id: id, isNegated: isNegated, primitive: .exists(fields: fields))
    }
}
