import SwiftUI

struct FrameSection: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        SectionCard(title: "Frames", systemImage: "crop") {
            VStack(alignment: .leading, spacing: 16) {
                ShapeGrid(items: FramePresets.all,
                          selectedID: $design.framePresetID,
                          columns: 7) { preset in
                    FrameCell(preset: preset, phrase: design.framePhrase)
                }

                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Frame Phrase")
                            .font(.callout.weight(.semibold))
                        TextField("SCAN ME", text: $design.framePhrase)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phrase Font")
                            .font(.callout.weight(.semibold))
                        Picker("", selection: $design.framePhraseFont) {
                            ForEach(PhraseFont.allCases) { font in
                                Text(font.rawValue).tag(font)
                            }
                        }
                        .labelsHidden()
                    }
                }

                HexColorField(label: "Frame Color", color: $design.frameColor)
            }
        }
    }
}

private struct FrameCell: View {
    let preset: FramePreset
    let phrase: String

    var body: some View {
        Group {
            if preset.style == .none {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
            } else {
                FrameThumbnail(style: preset.style, phrase: phrase)
                    .padding(6)
            }
        }
    }
}

private struct FrameThumbnail: View {
    let style: FrameStyle
    let phrase: String

    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            // QR placeholder
            let qrRect = qrThumbRect(in: rect)
            context.fill(Path(qrRect), with: .color(Color.primary.opacity(0.85)))

            // frame overlay (simplified)
            switch style {
            case .none: break
            case .barBelow:
                let bar = CGRect(x: 0, y: rect.maxY - rect.height * 0.18,
                                 width: rect.width, height: rect.height * 0.18)
                context.fill(Path(bar), with: .color(.primary))
            case .barBelowRounded:
                let bar = CGRect(x: rect.width * 0.1, y: rect.maxY - rect.height * 0.18,
                                 width: rect.width * 0.8, height: rect.height * 0.16)
                context.fill(Path(roundedRect: bar, cornerRadius: bar.height / 2),
                             with: .color(.primary))
            case .outlinedBar:
                let outline = rect.insetBy(dx: 3, dy: 3)
                context.stroke(Path(roundedRect: outline, cornerRadius: 6),
                               with: .color(.primary), lineWidth: 1.5)
                let bar = CGRect(x: outline.minX, y: outline.maxY - outline.height * 0.22,
                                 width: outline.width, height: outline.height * 0.22)
                context.fill(Path(roundedRect: bar, cornerRadius: 4), with: .color(.primary))
            case .circle:
                context.stroke(Path(ellipseIn: rect.insetBy(dx: 2, dy: 2)),
                               with: .color(.primary), lineWidth: 1.5)
            case .phone:
                let phone = rect.insetBy(dx: 6, dy: 2)
                context.stroke(Path(roundedRect: phone, cornerRadius: 6),
                               with: .color(.primary), lineWidth: 1.5)
            case .speech:
                let frame = rect.insetBy(dx: 3, dy: 3)
                context.stroke(Path(roundedRect: frame, cornerRadius: 6),
                               with: .color(.primary), lineWidth: 1.5)
                let bar = CGRect(x: frame.minX, y: frame.maxY - frame.height * 0.22,
                                 width: frame.width, height: frame.height * 0.22)
                context.fill(Path(roundedRect: bar, cornerRadius: 4), with: .color(.primary))
            }
        }
    }

    private func qrThumbRect(in rect: CGRect) -> CGRect {
        switch style {
        case .circle:
            let side = rect.width * 0.5
            return CGRect(x: (rect.width - side) / 2, y: (rect.height - side) / 2, width: side, height: side)
        case .phone:
            let side = rect.width * 0.55
            return CGRect(x: (rect.width - side) / 2, y: 6, width: side, height: side)
        default:
            let side = rect.width * 0.65
            return CGRect(x: (rect.width - side) / 2, y: 2, width: side, height: side)
        }
    }
}

extension Path {
    init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(CGPath(roundedRect: roundedRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil))
    }
}
