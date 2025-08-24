import SwiftUI

enum RowTokenToViewMapper {
    static let registry = SieveCommandViewRegistry.default()

    @ViewBuilder
    static func row(for token: RowToken) -> some View {
        switch token {
        case .beginIf(let header, _):
            IfHeaderRowView(command: header)
        case .elseMarker:
            TextRowView(icon: "arrow.triangle.branch", title: "Else")
        case .endIf:
            EmptyView()
        case .leaf(let command):
            registry.makeView(for: command)
        }
    }
}
