import Testing
@testable import Yasba

struct ProtonExpireCommandTests {
    @Test func requirements() throws {
        let command = ProtonExpireCommand(days: 1)
        
        #expect(command.requirements == ["vnd.proton.expire"])
    }
}
