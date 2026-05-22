import SwiftUI

struct ShapeGrid<Item: Identifiable & Hashable, Cell: View>: View {
    let items: [Item]
    @Binding var selectedID: Item.ID
    let columns: Int
    @ViewBuilder var cell: (Item) -> Cell

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 8) {
            ForEach(items) { item in
                let isSelected = item.id == selectedID
                Button {
                    selectedID = item.id
                } label: {
                    cell(item)
                        .frame(width: 52, height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isSelected ? Color.accentColor.opacity(0.18) : Color(nsColor: .windowBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSelected ? Color.accentColor : Color(nsColor: .separatorColor).opacity(0.4),
                                        lineWidth: isSelected ? 2 : 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
