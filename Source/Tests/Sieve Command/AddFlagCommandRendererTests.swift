import Foundation
import Testing
@testable import Yasba

struct AddFlagCommandRendererTests {
    private let renderer = AddFlagCommandRenderer()

    @Test func render_addflag_withSimpleTag() async throws {
        let command = AddFlagCommand(tag: "Important")
        let output = renderer.render(command: command, atIndent: 0)
        #expect(output == "addflag \"\\\\Important\";")
    }

    @Test func render_addflag_withSpecialCharacters() async throws {
        let command = AddFlagCommand(tag: "Spam-Filter")
        let output = renderer.render(command: command, atIndent: 1)
        #expect(output == "  addflag \"\\\\Spam-Filter\";")
    }
}
