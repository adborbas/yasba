/**
 A blueprint describing the metadata and initial token(s) needed to create
 the Proton mail specific `Spam filtering` Sieve command in the UI palette.
 */
struct ProtonSpamCommandBlueprint: SieveCommandBlueprint {
    static var type = "proton_spam"
    
    var title: String { "Proton Spam Filter" }
    var icon: String  { "flame.fill" }
    var info: String  { "Filters messages based on Proton's spam classification." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: ProtonSpamCommand())
        ]
    }
}
