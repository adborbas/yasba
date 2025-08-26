import Testing
@testable import Yasba

struct IfCommandTests {
    @Test func example() throws {
        let command = IfCommand(
            quantifier: .any,
            tests: [ ],
            thenChildren: [ DummyLeaf("do1") ],
            elseChildren: [ DummyLeaf("do2") ]
        )
        
        #expect(command.requirements == [DummyLeaf.requirement, DummyLeaf.requirement])
    }
}

