import Foundation
import Testing
@testable import Yasba

struct SieveTestRendererTests {
    private let renderer = SieveTestRenderer()

    @Test func render_boolean_true() async throws {
        let test = SieveTest(primitive: .boolean(true))
        #expect(renderer.render(test: test) == "true")
    }

    @Test func render_boolean_false() async throws {
        let test = SieveTest(primitive: .boolean(false))
        #expect(renderer.render(test: test) == "false")
    }

    @Test func render_header_contains() async throws {
        let test = SieveTest(
            primitive: .header(
                names: ["Subject"],
                match: .contains,
                keys: ["urgent"]
            )
        )
        #expect(renderer.render(test: test) == #"header :contains "Subject" "urgent""#)
    }

    @Test func render_exists() async throws {
        let test = SieveTest(
            primitive: .exists(fields: ["From", "Subject"])
        )
        #expect(renderer.render(test: test) == #"exists ["From", "Subject"]"#)
    }

    @Test func render_size_over() async throws {
        let test = SieveTest(
            primitive: .size(comparator: .over, bytes: 1024)
        )
        #expect(renderer.render(test: test) == "size :over 1024")
    }

    @Test func render_address_all_is() async throws {
        let test = SieveTest(
            primitive: .address(
                part: .all,
                names: ["From"],
                match: .is,
                keys: ["boss@example.com"]
            )
        )
        #expect(renderer.render(test: test) == #"address :all :is "From" "boss@example.com""#)
    }

    @Test func render_envelope_domain_matches() async throws {
        let test = SieveTest(
            primitive: .envelope(
                part: .domain,
                names: ["to"],
                match: .matches,
                keys: ["*@example.com"]
            )
        )
        #expect(renderer.render(test: test) == #"envelope :domain :matches "to" "*@example.com""#)
    }

    @Test func render_negated_wrapsInNot() async throws {
        let test = SieveTest(
            isNegated: true,
            primitive: .boolean(true)
        )
        #expect(renderer.render(test: test) == "not (true)")
    }
}
