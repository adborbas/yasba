import Foundation

@Observable
final class BooleanSpec: EditableTestSpec {
    let id: UUID
    var isNegated: Bool
    var value: Bool

    init(
        id: UUID = UUID(),
        isNegated: Bool = false,
        value: Bool = false
    ) {
        self.id = id
        self.isNegated = isNegated
        self.value = value
    }

    convenience init(from test: SieveTest) {
        switch test.primitive {
        case let .boolean(value):
            self.init(id: test.id, isNegated: test.isNegated, value: value)
        default:
            self.init(id: test.id, isNegated: test.isNegated, value: false)
        }
    }

    func toDomain() -> SieveTest {
        SieveTest(id: id, isNegated: isNegated, primitive: .boolean(value))
    }
}
