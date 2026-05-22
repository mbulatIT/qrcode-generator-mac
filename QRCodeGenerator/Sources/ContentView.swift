import SwiftUI
import UniformTypeIdentifiers

public struct ContentView: View {
    @StateObject private var design = QRDesign()

    public init() {}

    public var body: some View {
        HSplitView {
            QRPreviewView(design: design)
                .frame(minWidth: 360, idealWidth: 520)
            ControlPanel(design: design)
        }
        .frame(minWidth: 960, minHeight: 720)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    exportPNG()
                } label: {
                    Label("Export PNG", systemImage: "square.and.arrow.down")
                }
            }
        }
        .navigationTitle("QR Code Generator")
    }

    private func exportPNG() {
        guard let image = QRRenderer.render(design: design, pixelSize: 2048) else { return }
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "qrcode.png"
        guard panel.runModal() == .OK, let url = panel.url else { return }

        guard let tiff = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiff),
              let data = rep.representation(using: .png, properties: [:]) else { return }
        try? data.write(to: url)
    }
}
