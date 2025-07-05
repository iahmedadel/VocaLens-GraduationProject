import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            
            // Home Button
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: "sunglasses")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30) // Adjusted size
                    Text("Home".localized)
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(selectedTab == 0 ? .color : .gray)
            }
            
            Spacer()
            
            // Chat Button
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Chat".localized)
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(selectedTab == 1 ? .color : .gray)
            }
            
            Spacer()
            
            // Favorites Button
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Favorites".localized)
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(selectedTab == 2 ? .color : .gray)
            }
            
            Spacer()
            
            // Settings Button
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("Settings".localized)
                        .font(.system(size: 10, weight: .bold))
                }
                .foregroundColor(selectedTab == 3 ? .color : .gray)
            }
            
            Spacer()
        }.background(Color(.color1).ignoresSafeArea(.all)) // Background color

        .padding()
        .frame(height: 80) // Increased height
       // .background(Color.white.shadow(radius: 5))
      //  .background(Color(.color1).ignoresSafeArea(.all))
        .cornerRadius(2)

    }
}
#Preview {
    CustomTabBarView(selectedTab:.constant(0) )
}
