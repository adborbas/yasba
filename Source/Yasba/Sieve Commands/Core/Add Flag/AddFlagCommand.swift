import Foundation

/// Concrete Sieve command that appends an IMAP flag to the current message.
@Observable
final class AddFlagCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    
    var tag: String
    var isContainer: Bool { false }
    let requirements = ["imap4flags"]
    
    init(tag: String) {
        self.tag = tag
    }
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        guard let other = other as? AddFlagCommand else {
            return false
        }
        
        return self.tag == other.tag
    }
}
