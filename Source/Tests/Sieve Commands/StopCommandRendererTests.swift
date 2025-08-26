import Foundation
import Testing
@testable import Yasba

struct StopCommandRendererTests {
    private let renderer = StopCommandRenderer()

    @Test func render_stopCommand_withDefaultIndent() async throws {
        let command = StopCommand()
        let output = renderer.render(command: command, atIndent: 0)

        #expect(output == "stop;")
    }
}
