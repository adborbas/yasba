import Foundation

/**
 Concrete Sieve command that delivers the message into a target mailbox.
 */
@Observable
final class FileIntoCommand: SieveCommand, SieveCommandValueEquatable{
    let id = UUID()
    var mailbox: String
    let requirements = ["fileinto"]
    
    init(mailbox: String) {
        self.mailbox = mailbox
    }
    
    func isSemanticallyEqual(to other: AnySieveCommand) -> Bool {
        guard let other = other as? FileIntoCommand else {
            return false
        }
        
        return self.mailbox == other.mailbox
    }
}
