/** Represent a type that can  render a command into a string representation with indentation. */
protocol SieveCommandRenderer {
    associatedtype Command
    
    func render(command: Command, atIndent indent: Int) -> String
}
