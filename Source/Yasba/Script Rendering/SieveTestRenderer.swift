import Foundation

/**
 Responsible for rendering a `SieveTest` into its textual Sieve script representation.

 `SieveTestRenderer` converts individual test primitives (e.g., `header`, `size`, `address`)
 into valid Sieve syntax strings. It also handles negation (`not`) and ensures proper
 quoting and formatting of lists, flags, and match types.
 */
struct SieveTestRenderer  {

    func render(test: SieveTest) -> String {
        let base = render(primitive: test.primitive)
        return test.isNegated ? "not (\(base))" : base
    }

    private func render(primitive: SieveTest.Primitive) -> String {
        switch primitive {
        case .boolean(let value):
            return value ? "true" : "false"

        case .header(let names, let match, let keys):
            // header :contains ["Subject"] ["urgent"]
            return "header \(matchFlag(match)) \(SieveCodeStyle.stringList(names)) \(SieveCodeStyle.stringList(keys))"

        case .exists(let fields):
            // exists ["Subject", "From"]
            return "exists \(SieveCodeStyle.stringList(fields))"

        case .size(let comparator, let bytes):
            // size :over 1024  |  size :under 2048
            let flag = (comparator == .over) ? ":over" : ":under"
            return "size \(flag) \(bytes)"

        case .address(let part, let names, let match, let keys):
            // address :all :contains ["From"] ["boss@example.com"]
            let flags = [addressPartFlag(part), matchFlag(match)].joined(separator: " ")
            return "address \(flags) \(SieveCodeStyle.stringList(names)) \(SieveCodeStyle.stringList(keys))"

        case .envelope(let part, let names, let match, let keys):
            // envelope :all :is ["to"] ["me@example.com"]
            let flags = [addressPartFlag(part), matchFlag(match)].joined(separator: " ")
            return "envelope \(flags) \(SieveCodeStyle.stringList(names)) \(SieveCodeStyle.stringList(keys))"
        }
    }

    private func matchFlag(_ matchType: SieveTest.MatchType) -> String {
        switch matchType {
        case .contains: return ":contains"
        case .is:       return ":is"
        case .matches:  return ":matches"
        }
    }

    private func addressPartFlag(_ part: SieveTest.AddressPart) -> String {
        switch part {
        case .all:       return ":all"
        case .localpart: return ":localpart"
        case .domain:    return ":domain"
        }
    }
}
