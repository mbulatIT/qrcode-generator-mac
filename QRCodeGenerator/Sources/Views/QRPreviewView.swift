import SwiftUI

struct QRPreviewView: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        VStack {
            if let image = QRRenderer.render(design: design, pixelSize: 768) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(nsColor: .underPageBackgroundColor))
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                    .padding(24)
            } else {
                Text("Enter content to generate")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
