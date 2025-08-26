import Foundation
import Testing
@testable import Yasba

struct ProtonExpireCommandRendererTests {
    private let renderer = ProtonExpireCommandRenderer()

    @Test func render_expire_withSingleDay() async throws {
        let command = ProtonExpireCommand(days: 1)
        let output = renderer.render(command: command, atIndent: 0)
        #expect(output == "expire \"days\" \"1\";")
    }
}
