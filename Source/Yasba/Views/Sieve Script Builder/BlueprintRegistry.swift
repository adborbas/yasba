import Foundation

struct BlueprintEnvelope: Codable {
    let type: String
    let payload: Data

    init<Blueprint: SieveCommandBlueprint>(_ blueprint: Blueprint) throws {
        self.type = Blueprint.type
        self.payload = try JSONEncoder().encode(blueprint)
    }
}

enum BlueprintRegistry {
    private static var decoders: [String: (Data) throws -> any SieveCommandBlueprint] = [:]
    private static var didRegisterDefaults = false

    static func register<T: SieveCommandBlueprint>(_ type: T.Type) {
        decoders[T.type] = { data in
            try JSONDecoder().decode(T.self, from: data)
        }
    }

    static func registerDefaults() {
        guard !didRegisterDefaults else { return }
        didRegisterDefaults = true
        
        register(AddFlagCommandBlueprint.self)
        register(FileIntoCommandBlueprint.self)
        register(StopCommandBlueprint.self)
        register(IfCommandBlueprint.self)
        register(ProtonSpamCommandBlueprint.self)
        register(ProtonMarkAsReadCommandBlueprint.self)
        register(ProtonExpireCommandBlueprint.self)
    }

    static func decode(from data: Data) throws -> any SieveCommandBlueprint {
        let env = try JSONDecoder().decode(BlueprintEnvelope.self, from: data)
        guard let decode = decoders[env.type] else {
            fatalError("Unknown blueprint type: \(env.type). Have you registered it in BlueprintRegistry?")
        }
        return try decode(env.payload)
    }
}

enum SieveCommandFactory {
    static func make(from data: Data) -> (tokens: [RowToken], previewTitle: String)? {
        BlueprintRegistry.registerDefaults()
        do {
            let blueprint = try BlueprintRegistry.decode(from: data)
            return (blueprint.makeTokens(), blueprint.title)
        } catch {
            return nil
        }
    }
}

