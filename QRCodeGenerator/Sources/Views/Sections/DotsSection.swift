import SwiftUI
import QRCode

struct DotsSection: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        SectionCard(title: "Color & Shape", systemImage: "circle.grid.2x2") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Dots")
                    .font(.callout.weight(.semibold))
                ShapeGrid(items: DotsPresets.all,
                          selectedID: $design.dotsPresetID,
                          columns: 8) { preset in
                    DotsCell(preset: preset)
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 16) {
                        HexColorField(label: "Background color", color: $design.backgroundColor)
                        HexColorField(label: "Dots color", color: $design.dotsColor)
                    }

                    HStack(spacing: 16) {
                        Toggle("Transparent background", isOn: $design.transparentBackground)
                            .toggleStyle(.switch)
                            .tint(.green)

                        Toggle("Gradient", isOn: $design.useGradient)
                            .toggleStyle(.switch)
                            .tint(.green)
                    }

                    if design.useGradient {
                        HexColorField(label: "Gradient end color", color: $design.gradientEndColor)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(nsColor: .windowBackgroundColor).opacity(0.5))
                )
            }
        }
    }
}

private struct DotsCell: View {
    let preset: DotsPreset

    var body: some View {
        if let cg = try? QRCodePixelShapeFactory.shared.image(
            pixelGenerator: preset.make(),
            dimension: 88,
            foregroundColor: NSColor.labelColor.cgColor
        ) {
            Image(nsImage: NSImage(cgImage: cg, size: NSSize(width: 44, height: 44)))
                .resizable()
                .scaledToFit()
                .padding(4)
        } else {
            Color.clear
        }
    }
}
