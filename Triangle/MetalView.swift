import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var renderer: Renderer?
    @State private var metalView = MTKView()
    
    var body: some View {
        //MARK: Renderer is initialized when the metal view first appears.
        MetalViewRepresentable(metalView: $metalView)
            .onAppear {
                renderer = Renderer(metalView: metalView)
            }
    }
}

typealias ViewRepresentable = NSViewRepresentable

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var metalView: MTKView
    
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    func updateNSView(_ uiView: NSViewType, context: Context) {
        updateMetalView()
    }
    
    func updateMetalView() {
    }
}

#Preview {
    VStack {
        MetalView()
        Text("Metal View")
    }
}
