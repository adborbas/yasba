/**
 A blueprint describing the metadata and initial token(s) needed to create
 the `stop` Sieve control in the UI palette.
 */
struct StopCommandBlueprint: SieveCommandBlueprint {
    static var type = "stop"
    
    var title: String { "Stop" }
    var icon: String  { "stop.fill" }
    var info: String  { "Stops further processing of the script." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: StopCommand())
        ]
    }
}
