import Foundation

@Observable
final class StopCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        return other is StopCommand
    }
}
