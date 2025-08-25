import SwiftUI

#if canImport(AppKit)
import AppKit
#endif

// MARK: - Root

struct SieveScriptBuilderView: View {
    @StateObject var model: SieveScriptViewModel
    @State private var libraryWidth: CGFloat = 320
    @State private var shouldPresentSheet = false
    @State private var renderedScriptText: String = ""
    @State private var shouldShowClearConfirmation = false

    var body: some View {
        HSplitView {
            ZStack(alignment: .topLeading) {
                Color.primary.colorInvert()
                    .ignoresSafeArea()
                
                Toolbar(
                    onRender: {
                        renderedScriptText = model.render()
                        shouldPresentSheet = true
                    }, onNew: {
                        shouldShowClearConfirmation = true
                    })
                .ignoresSafeArea()

                SieveScriptView(viewModel: model)
                    .padding([.leading, .top], 24)
                    .frame(minWidth: 420,
                           maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .topLeading)
            }
            
            Sidebar()
                .frame(minWidth: 260,
                       idealWidth: libraryWidth,
                       maxWidth: 480,
                       maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Text("Yasba")
            }
        }
        .sheet(isPresented: $shouldPresentSheet) {
            
        } content: {
            RenderedSieveScriptView(scriptText: $renderedScriptText)
        }
        .alert("Clear Script?", isPresented: $shouldShowClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                model.clear()
            }
        } message: {
            Text("This will remove all commands from the script. This action cannot be undone.")
        }
    }
}

private struct Toolbar: View {
    var onRender: () -> Void
    var onNew: () -> Void
    
    var body: some View {
        HStack(spacing: 32) {
            Spacer()
            ToolbarButton(icon: "document.badge.plus") { onNew() }
            ToolbarButton(icon: "note.text") { onRender() }
        }
        .padding(.trailing, 24)
        .frame(height: 50)
    }
}

private struct ToolbarButton: View {
    private let size: CGFloat = 22
    
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .resizable()
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SieveScriptBuilderView(model: SieveScriptViewModel())
        .frame(width: 1120, height: 720)
}
