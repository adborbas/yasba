import Foundation
import Testing
@testable import Yasba

struct FileIntoCommandRendererTests {
    private let renderer = FileIntoCommandRenderer()

    @Test func render_fileinto_withSimpleMailbox() async throws {
        let command = FileIntoCommand(mailbox: "Inbox")
        let output = renderer.render(command: command, atIndent: 0)
        #expect(output == "fileinto \"Inbox\";")
    }

    @Test func render_fileinto_withSpecialCharacters() async throws {
        let command = FileIntoCommand(mailbox: "Work-Projects/2025")
        let output = renderer.render(command: command, atIndent: 0)
        #expect(output == "fileinto \"Work-Projects/2025\";")
    }
}
