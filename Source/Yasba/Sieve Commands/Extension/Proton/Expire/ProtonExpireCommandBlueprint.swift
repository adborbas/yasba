/**
 A blueprint describing the metadata and initial token(s) needed to create
 the Proton mail specific `expire` Sieve command in the UI palette.
 */
struct ProtonExpireCommandBlueprint: SieveCommandBlueprint {
    static var type = "proton_expire"
    
    var title: String { "Proton Expire" }
    var icon: String  { "hourglass" }
    var info: String  { "One unique feature of Proton Mail is the ability to set an expiration time on sent messages, at which point the message will be deleted from the recipient’s mailbox." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: ProtonExpireCommand(days: 10))
        ]
    }
}
