/**
 A blueprint describing the metadata and initial token(s) needed to create
 a `fileinto` Sieve command in the UI palette.
 */
struct FileIntoCommandBlueprint: SieveCommandBlueprint {
    static var type = "file_into"
    
    var title: String { "File Into" }
    var icon: String  { "folder.fill" }
    var info: String  { "Delivers the message into the specified mailbox." }
    
    func makeTokens() -> [RowToken] {
        return [
            .leaf(command: FileIntoCommand(mailbox: ""))
        ]
    }
}
