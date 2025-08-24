import Foundation

@Observable
final class ProtonMarkAsReadCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    
    var isContainer: Bool { false }
    let requirements = ["imap4flags"]
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        return other is ProtonMarkAsReadCommand
    }
}
