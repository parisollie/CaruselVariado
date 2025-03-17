import SwiftUI

// To for Accepting Collections
struct SnapCarousel<Content: View,T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    // Properties
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    init(
        spacing: CGFloat = 15,
        trailingSpace: CGFloat = 100,
        index: Binding<Int>,
        items: [T],
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    @GestureState private var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    var body: some View {
        GeometryReader { proxy in
            // Setting correct Width for snap Carousel
            // One Sided Snap Caorusel
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            // Spacing will be horizontal padding
            .padding(.horizontal,spacing)
            // setting only after 0th index
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onEnded { value in
                        currentIndex = max(min(currentIndex, list.count - 1), 0)
                        /// Updating Index
                        currentIndex = index
                    }
                    .onChanged { value in
                        let offsetX = value.translation.width + (value.velocity.width / 5)
                        let progress = -offsetX / width
                        
                        /// Limiting Update to only update two card for each swipe
                        let roundIndex = min(max(Int(progress.rounded()), -2), 2)
                        index = max(min(currentIndex + roundIndex, list.count - 1), 0)
                    }
            )
        }
        // Animatiing when offset = 0
        .animation(.snappy, value: offset == 0)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
