/**
 Describes a palette item that can create one or more initial `RowToken`s
 representing a Sieve command in the editor.

 Blueprints provide metadata used for the action library (title, icon, info)
 and a stable `type` identifier for serialization/drag & drop.
 */
protocol SieveCommandBlueprint: Codable {
    static var type: String { get }
    
    var title: String { get }
    var icon: String { get }
    var info: String { get }
    
    func makeTokens() -> [RowToken]
}
