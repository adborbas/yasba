import SwiftUI

#if canImport(AppKit)
import AppKit
#endif

// MARK: - Root

struct SieveScriptBuilderView: View {
    @State var model: SieveScriptViewModel
    @State private var libraryWidth: CGFloat = 320
    @State private var shouldPresentSheet = false
    @State private var renderedScriptText: String = ""

    var body: some View {
        HSplitView {
            ZStack(alignment: .topLeading) {
                Color.primary.colorInvert()
                    .ignoresSafeArea()
                
                Toolbar() {
                    renderedScriptText = model.render()
                    shouldPresentSheet = true
                }
                .ignoresSafeArea()

                SieveScriptView(viewModel: $model)
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
    }
}

private struct Toolbar: View {
    var onRender: (() -> Void)
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                onRender()
            } label: {
                Image(systemName: "note.text")
                    .resizable()
                    .frame(width: 18, height: 18)
            }
            .buttonStyle(.plain)

        }
        .padding(.trailing, 24)
        .frame(height: 50)
    }
}

#Preview {
    SieveScriptBuilderView(model: SieveScriptViewModel())
        .frame(width: 1120, height: 720)
}
