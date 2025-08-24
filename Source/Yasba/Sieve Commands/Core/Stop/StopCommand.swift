import Foundation

@Observable
final class StopCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    var isContainer: Bool { return false }
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        return other is StopCommand
    }
}
