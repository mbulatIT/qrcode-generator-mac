import SwiftUI
import QRCode

struct URLSection: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        SectionCard(title: "Content", systemImage: "link") {
            VStack(alignment: .leading, spacing: 12) {
                Text("URL or text to encode")
                    .font(.callout.weight(.semibold))
                TextField("https://example.com", text: $design.content, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)

                HStack(spacing: 8) {
                    Text("Error correction")
                        .font(.callout)
                    Picker("", selection: $design.errorCorrection) {
                        Text("Low").tag(QRCode.ErrorCorrection.low)
                        Text("Medium").tag(QRCode.ErrorCorrection.medium)
                        Text("Quantize").tag(QRCode.ErrorCorrection.quantize)
                        Text("High").tag(QRCode.ErrorCorrection.high)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}
