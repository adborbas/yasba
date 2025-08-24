import Foundation

@Observable
final class ProtonExpireCommand: SieveCommand, SieveCommandValueEquatable {
    let id = UUID()
    
    var days: Int
    var isContainer: Bool { false }
    let requirements = ["imap4flags"]
    
    init(days: Int) {
        self.days = days
    }
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        guard let other = other as? ProtonExpireCommand else {
            return false
        }
        
        return self.days == other.days
    }
}
