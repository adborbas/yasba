import Foundation

/**
 Marker protocol for UI-editable Sieve test specifications.

 Conforming types wrap a concrete Sieve test shape and provide conversion back
 to the domain-level `SieveTest`.
 */
protocol EditableTestSpec: AnyObject, Identifiable {
    var id: UUID { get }
    var isNegated: Bool { get set }
    func toDomain() -> SieveTest
}
