import Testing
@testable import Yasba

struct SieveScriptRequirementsTests {
    @Test func render_isEmpty_whenNoRequirementsAdded() async throws {
        let requirements = SieveScriptRequirements()
        #expect(requirements.render().isEmpty)
    }

    @Test func render_containsSingleRequirement_andTrailingLineBreak() async throws {
        var requirements = SieveScriptRequirements()
        requirements.add(["fileinto"])
        let rendered = requirements.render()
        #expect(rendered.hasPrefix("require ["))
        #expect(rendered.contains(#""fileinto""#))
        #expect(rendered.hasSuffix(SieveCodeStyle.lineBreak))
    }

    @Test func render_deduplicatesAcrossAdds() async throws {
        var requirements = SieveScriptRequirements()
        requirements.add(["fileinto", "imap4flags"])
        requirements.add(["fileinto"])
        let rendered = requirements.render()
        #expect(rendered.contains(#""fileinto""#))
        #expect(rendered.contains(#""imap4flags""#))
        #expect(occurrences(of: #""fileinto""#, in: rendered) == 1)
        #expect(occurrences(of: #""imap4flags""#, in: rendered) == 1)
    }

    @Test func add_ignoresEmptyInput() async throws {
        var requirements = SieveScriptRequirements()
        requirements.add([])
        #expect(requirements.render().isEmpty)

        requirements.add(["envelope"])
        requirements.add([])
        #expect(requirements.render().contains(#""envelope""#))
    }

    @Test func render_hasValidSieveRequireShape() async throws {
        var requirements = SieveScriptRequirements()
        requirements.add(["fileinto", "imap4flags"])
        let rendered = requirements.render()
        #expect(rendered.starts(with: "require ["))
        #expect(rendered.contains("]"))
        #expect(rendered.hasSuffix(SieveCodeStyle.lineBreak))

        if let open = rendered.firstIndex(of: "["),
           let close = rendered.firstIndex(of: "]"),
           open < close {
            let inner = rendered[rendered.index(after: open)..<close]
            #expect(inner.contains(","))
        } else {
            Issue.record("Malformed require list: \(rendered)")
        }
    }
}

private func occurrences(of needle: String, in haystack: String) -> Int {
    guard !needle.isEmpty, !haystack.isEmpty else { return 0 }
    var count = 0
    var searchRange = haystack.startIndex..<haystack.endIndex
    while let range = haystack.range(of: needle, options: [], range: searchRange) {
        count += 1
        searchRange = range.upperBound..<haystack.endIndex
    }
    return count
}
