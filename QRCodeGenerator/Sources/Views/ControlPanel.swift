import SwiftUI

struct ControlPanel: View {
    @ObservedObject var design: QRDesign

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                URLSection(design: design)
                LogoSection(design: design)
                MarkersSection(design: design)
                FrameSection(design: design)
                DotsSection(design: design)
            }
            .padding(20)
        }
        .frame(minWidth: 460, idealWidth: 520)
    }
}
