import Foundation

/**
 Type-erased wrapper for any `EditableTestSpec`.

 Enables heterogeneous collections of test specs in the UI while preserving
 identity and supporting safe downcasts when needed.
 */
struct AnyTestSpec: Identifiable {
    private let base: any EditableTestSpec
    
    init(_ base: any EditableTestSpec) {
        self.base = base
    }
    
    var id: UUID { base.id }

    var isNegated: Bool {
        get { base.isNegated }
        nonmutating set { base.isNegated = newValue }
    }

    func toDomain() -> SieveTest {
        base.toDomain()
    }

    func base<TestSpec: EditableTestSpec>(as type: TestSpec.Type) -> TestSpec? {
        base as? TestSpec
    }
}
