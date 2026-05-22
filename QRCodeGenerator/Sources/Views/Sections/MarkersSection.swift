import SwiftUI
import QRCode

struct MarkersSection: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        SectionCard(title: "Markers", systemImage: "qrcode.viewfinder") {
            VStack(alignment: .leading, spacing: 18) {
                Text("Marker border")
                    .font(.callout.weight(.semibold))
                ShapeGrid(items: EyeBorderPresets.all,
                          selectedID: $design.eyeBorderPresetID,
                          columns: 8) { preset in
                    EyeBorderCell(preset: preset)
                }
                HexColorField(label: "Marker border color", color: $design.eyeBorderColor)

                Text("Marker center")
                    .font(.callout.weight(.semibold))
                    .padding(.top, 8)
                ShapeGrid(items: EyeCenterPresets.all,
                          selectedID: $design.eyeCenterPresetID,
                          columns: 8) { preset in
                    EyeCenterCell(preset: preset)
                }
                HexColorField(label: "Marker center color", color: $design.eyeCenterColor)
            }
        }
    }
}

private struct EyeBorderCell: View {
    let preset: EyeBorderPreset

    var body: some View {
        Canvas { context, size in
            let shape = preset.make()
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 4, dy: 4)
            let scale = rect.width / 90
            var t = CGAffineTransform.identity
                .translatedBy(x: rect.minX, y: rect.minY)
                .scaledBy(x: scale, y: scale)
            let path = Path(shape.eyePath().copy(using: &t) ?? CGMutablePath())
            context.stroke(path, with: .color(.primary), lineWidth: 2)
        }
    }
}

private struct EyeCenterCell: View {
    let preset: EyeCenterPreset

    var body: some View {
        Canvas { context, size in
            let shape = preset.make()
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 8, dy: 8)
            let scale = rect.width / 30
            // Pupil paths use 90x90 coordinate space and occupy (30..60, 30..60).
            // Translate to remove that offset, then scale to fit the cell.
            var t = CGAffineTransform.identity
                .translatedBy(x: rect.minX, y: rect.minY)
                .scaledBy(x: scale, y: scale)
                .translatedBy(x: -30, y: -30)
            let path = Path(shape.pupilPath().copy(using: &t) ?? CGMutablePath())
            context.fill(path, with: .color(.primary))
        }
    }
}
