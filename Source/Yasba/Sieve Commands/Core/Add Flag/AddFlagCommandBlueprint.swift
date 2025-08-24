/**
 A blueprint describing the metadata and initial token(s) needed to create
 an `addflag` Sieve command in the UI palette.
 */
struct AddFlagCommandBlueprint: SieveCommandBlueprint {
    static var type = "add_flag"
    
    var title: String { "Add Flag" }
    var icon: String  { "flag.fill" }
    var info: String  { "Adds the specified IMAP flag to the message." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: AddFlagCommand(tag: ""))
        ]
    }
}
