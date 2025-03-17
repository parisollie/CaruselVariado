import SwiftUI

struct Home: View {
    @State private var currentIndex: Int = 0
    @State private var posts: [Post] = []
    @State private var currentTab = "Slide Show"
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    
                } label: {
                    Label {
                        Text("Back")
                            .fontWeight(.semibold)
                    } icon: {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.primary)
                }
                
                Text("My Wishes")
                    .font(.title)
                    .fontWeight(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            // Segment Control
            HStack(spacing: 0) {
                TabButton(title: "Slide Show", animation: animation, currentTab: $currentTab)
                TabButton(title: "List", animation: animation, currentTab: $currentTab)
            }
            .background(.gray.opacity(0.1), in: .rect(cornerRadius: 10))
            .padding(.horizontal)
            
            // Snap Carousel
            SnapCarousel(index: $currentIndex, items: posts) {post in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .cornerRadius(12)
                }
            }
            .padding(.vertical,40)
            
            // Indicator
            HStack(spacing: 10) {
                ForEach(posts.indices, id: \.self){ index in
                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding(.bottom,40)
        }
        .frame(maxHeight: .infinity,alignment: .top)
        .onAppear {
            for index in 1...7 { posts.append(Post(postImage: "post\(index)")) }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// TabButton
struct TabButton: View {
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Button {
            withAnimation(.spring()) {
                currentTab = title
            }
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(currentTab == title ? (scheme == .dark ? .black : .white) : Color.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background {
                    ZStack{
                        if currentTab == title {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.primary)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                }
        }
    }
}
