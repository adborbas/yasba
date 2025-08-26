import Testing
@testable import Yasba

struct ProtonSpamCommandTests {
    @Test func requirements() throws {
        let command = ProtonSpamCommand()
        
        #expect(command.requirements == ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"])
    }
}
