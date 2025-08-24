/**
 A blueprint describing the metadata and initial token(s) needed to create
 the Proton mail specific `Mark as Read` Sieve command in the UI palette.
 */
struct ProtonMarkAsReadCommandBlueprint: SieveCommandBlueprint {
    static var type = "proton_mark_as_read"
    
    var title: String { "Proton Mark as read" }
    var icon: String  { "envelope.open.fill" }
    var info: String  { "Marks the email as read in Proton Mail." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: ProtonMarkAsReadCommand())
        ]
    }
}
