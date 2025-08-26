import Foundation

/**
 Base protocol for all Sieve commands rendered and edited by the app.
 */
protocol SieveCommand: AnyObject, Identifiable {
    var id: UUID { get }
    
    var requirements: [String] { get }
}

extension SieveCommand {
    var requirements: [String] { [] }
}

/**
 Marker protocol for commands that can contain child commands.
 */
protocol SieveContainerCommand: SieveCommand {
    var thenChildren: [any SieveCommand] { get set }
    var elseChildren: [any SieveCommand] { get set }
}

/**
 Provides semantic equality for commands beyond identity.
 */
protocol SieveCommandValueEquatable {
    func isSemanticallyEqual(to other: any SieveCommand) -> Bool
}

/** Convenient alias for “any SieveCommand”, used to improve readability at call sites. */
typealias AnySieveCommand = any SieveCommand
