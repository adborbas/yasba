import Testing
@testable import Yasba

struct ProtonMarkAsReadCommandTests {
    @Test func requirements() throws {
        let command = ProtonMarkAsReadCommand()
        
        #expect(command.requirements == ["imap4flags"])
    }
}
