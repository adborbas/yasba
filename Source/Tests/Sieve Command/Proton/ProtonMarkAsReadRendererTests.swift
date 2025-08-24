import Foundation
import Testing
@testable import Yasba

struct ProtonMarkAsReadRendererTests {
    private let renderer = ProtonMarkAsReadRenderer()

    @Test func render_markAsRead_withDefaultIndent() async throws {
        let command = ProtonMarkAsReadCommand()
        let output = renderer.render(command: command, atIndent: 0)
        #expect(output == "addflag \"\\\\Seen\"")
    }
}
