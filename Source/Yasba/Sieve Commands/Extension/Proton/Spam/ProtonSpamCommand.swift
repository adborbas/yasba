import Foundation

@Observable
final class ProtonSpamCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    let requirements = ["include", "environment", "variables", "relational", "comparator-i;ascii-numeric", "spamtest"]
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        return other is ProtonSpamCommand
    }
}
