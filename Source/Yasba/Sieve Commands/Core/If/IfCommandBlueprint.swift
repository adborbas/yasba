import UniformTypeIdentifiers

/**
 A blueprint describing the metadata and initial token(s) needed to create
 the `if` Sieve control in the UI palette.
 */
struct IfCommandBlueprint: SieveCommandBlueprint {
    static var type = "if"
    
    var title: String { "If" }
    var icon: String  { "arrow.triangle.branch" }
    var info: String  { "Executes commands conditionally based on tests." }
    
    func makeTokens() -> [RowToken] {
        let ifCommand = IfCommand(quantifier: .any, tests: [], thenChildren: [])
        let groupID = ifCommand.id
        return [
            .beginIf(header: ifCommand, tokenID: UUID()),
            .elseMarker(groupID: groupID, tokenID: UUID()),
            .endIf(groupID: groupID, tokenID: UUID())
        ]
    }
}
