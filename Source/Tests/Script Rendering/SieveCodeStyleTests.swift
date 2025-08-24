import Foundation
import Testing
@testable import Yasba

struct SieveCodeStyleTests {
    @Test func indent_forLevel() async throws {
        #expect(SieveCodeStyle.indent(for: 0) == "")
        #expect(SieveCodeStyle.indent(for: 1) == "  ")
        #expect(SieveCodeStyle.indent(for: 3) == "      ")
    }

    @Test func quote_escapesSpecialCharacters() async throws {
        #expect(SieveCodeStyle.quote("abc") == "\"abc\"")
        #expect(SieveCodeStyle.quote("a\"b") == "\"a\\\"b\"")
        #expect(SieveCodeStyle.quote("a\\b") == "\"a\\\\b\"")
    }

    @Test func stringList_empty_single_multiple() async throws {
        #expect(SieveCodeStyle.stringList([]) == "[]")
        #expect(SieveCodeStyle.stringList(["one"]) == "\"one\"")
        #expect(SieveCodeStyle.stringList(["a", "b"]) == "[\"a\", \"b\"]")
    }
}
