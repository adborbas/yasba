import Foundation

/**
 Domain model for a single Sieve test.

 Captures negation, identity, and the concrete primitive shape per RFC 5228.
 */
struct SieveTest: Identifiable, Equatable {
    let id: UUID
    var isNegated: Bool
    var primitive: Primitive

    init(id: UUID = UUID(), isNegated: Bool = false, primitive: Primitive) {
        self.id = id
        self.isNegated = isNegated
        self.primitive = primitive
    }
}

extension SieveTest {
    enum Primitive: Equatable {
        case boolean(Bool)

        case header(names: [String], match: MatchType, keys: [String])
        case exists(fields: [String])
        case size(comparator: Comparison, bytes: Int)

        case address(part: AddressPart, names: [String], match: MatchType, keys: [String])
        case envelope(part: AddressPart, names: [String], match: MatchType, keys: [String])
    }

    enum Comparison: String, Equatable, CaseIterable, Identifiable, CustomStringConvertible {
        case over
        case under
        
        var id: Self { self }
        var description: String { rawValue }
    }

    enum MatchType: String, Equatable, CaseIterable, Identifiable, CustomStringConvertible {
        case contains
        case `is`
        case matches
        
        var id: Self { self }
        var description: String { rawValue }
    }

    enum AddressPart: String, Equatable, CaseIterable, Identifiable, CustomStringConvertible {
        case all
        case localpart
        case domain
        
        var id: Self { self }
        var description: String { rawValue }
    }
}

extension SieveTest {
    enum Family: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case header
        case address
        case envelope
    }
}

extension SieveTest {
    static func bool(_ value: Bool, negated: Bool = false) -> SieveTest {
        .init(isNegated: negated, primitive: .boolean(value))
    }

    static func header(
        _ names: [String],
        match: MatchType,
        keys: [String],
        negated: Bool = false
    ) -> SieveTest {
        .init(isNegated: negated, primitive: .header(names: names, match: match, keys: keys))
    }

    static func exists(
        _ fields: [String],
        negated: Bool = false
    ) -> SieveTest {
        .init(isNegated: negated, primitive: .exists(fields: fields))
    }

    static func size(
        _ comparison: Comparison,
        bytes: Int,
        negated: Bool = false
    ) -> SieveTest {
        .init(isNegated: negated, primitive: .size(comparator: comparison, bytes: bytes))
    }

    static func address(
        part: AddressPart,
        names: [String],
        match: MatchType,
        keys: [String],
        negated: Bool = false
    ) -> SieveTest {
        .init(isNegated: negated, primitive: .address(part: part, names: names, match: match, keys: keys))
    }

    static func envelope(
        part: AddressPart,
        names: [String],
        match: MatchType,
        keys: [String],
        negated: Bool = false
    ) -> SieveTest {
        .init(isNegated: negated, primitive: .envelope(part: part, names: names, match: match, keys: keys))
    }
}
