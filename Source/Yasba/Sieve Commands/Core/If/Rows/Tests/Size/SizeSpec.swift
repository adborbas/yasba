import Foundation

@Observable
final class SizeSpec: EditableTestSpec {
    let id: UUID
    var isNegated: Bool
    var comparison: SieveTest.Comparison
    var bytes: Int

    init(
        id: UUID = UUID(),
        isNegated: Bool = false,
        comparison: SieveTest.Comparison = .over,
        bytes: Int = 1024
    ) {
        self.id = id
        self.isNegated = isNegated
        self.comparison = comparison
        self.bytes = bytes
    }

    convenience init(from test: SieveTest) {
        switch test.primitive {
        case let .size(comparator, bytes):
            self.init(id: test.id, isNegated: test.isNegated, comparison: comparator, bytes: bytes)
        default:
            self.init(id: test.id, isNegated: test.isNegated)
        }
    }

    func toDomain() -> SieveTest {
        SieveTest(id: id, isNegated: isNegated, primitive: .size(comparator: comparison, bytes: bytes))
    }
}
