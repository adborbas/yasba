import Testing
@testable import Yasba

struct FileIntoCommandTests {
    @Test func requirements() throws {
        let command = FileIntoCommand(mailbox: "inbox")
        
        #expect(command.requirements == ["fileinto"])
    }
}
