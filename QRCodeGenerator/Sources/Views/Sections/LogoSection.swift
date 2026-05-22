import SwiftUI
import UniformTypeIdentifiers

struct LogoSection: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        SectionCard(title: "Logo", systemImage: "photo") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Upload Logo")
                    .font(.callout.weight(.semibold))

                HStack(spacing: 0) {
                    Text(design.customLogoData == nil ? "Choose file" : "Custom logo loaded")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                    Divider()
                    Button("Browse") { pickFile() }
                        .buttonStyle(.borderless)
                        .padding(.horizontal, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(nsColor: .separatorColor).opacity(0.5), lineWidth: 1)
                )

                if design.customLogoData != nil {
                    Button("Remove custom logo") {
                        design.customLogoData = nil
                    }
                    .buttonStyle(.borderless)
                }

                Text("Or choose from here")
                    .font(.callout.weight(.semibold))

                ShapeGrid(items: LogoPresets.all,
                          selectedID: Binding(
                            get: { design.customLogoData == nil ? design.logoPresetID : "none" },
                            set: { newID in
                                design.customLogoData = nil
                                design.logoPresetID = newID
                            }
                          ),
                          columns: 8) { preset in
                    LogoCell(preset: preset)
                }

                Toggle("Remove background behind Logo", isOn: $design.removeBackgroundBehindLogo)
                    .toggleStyle(.switch)
                    .tint(Color.green)
            }
        }
    }

    private func pickFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg, .image, .heic]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url, let data = try? Data(contentsOf: url) {
            design.customLogoData = data
        }
    }
}

private struct LogoCell: View {
    let preset: LogoPreset

    var body: some View {
        Group {
            if case .none = preset.kind {
                Image(systemName: "xmark")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.primary)
            } else if let image = LogoImageRenderer.image(for: preset, size: 96) {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(4)
            } else {
                Color.clear
            }
        }
    }
}
