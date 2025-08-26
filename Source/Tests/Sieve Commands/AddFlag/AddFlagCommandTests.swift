import Testing
@testable import Yasba

struct AddFlagCommandTests {
    @Test func requirements() throws {
        let command = AddFlagCommand(tag: "tag")
        
        #expect(command.requirements == ["imap4flags"])
    }
}
