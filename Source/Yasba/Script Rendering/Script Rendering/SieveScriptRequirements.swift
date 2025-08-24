/**
 Collects and renders Sieve script requirements (e.g., extensions or capabilities).
 
 Ensures uniqueness of requirements and provides a way to render them in a valid
 `require [...]` Sieve statement.
 */
struct SieveScriptRequirements {
    private var requirements: Set<String> = []
    
    mutating func add(_ requirements: [String]) {
        guard !requirements.isEmpty else { return }
        requirements.forEach { self.requirements.insert($0) }
    }
    
    func render() -> String {
        guard !requirements.isEmpty else { return "" }
        
        let list = SieveCodeStyle.stringList(Array(requirements))
        return "require [\(list)]\(SieveCodeStyle.lineBreak)"
    }
}
