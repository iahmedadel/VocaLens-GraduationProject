import SwiftUI

struct SecondOnBoarding: View {
    
    // property
    
    // Navigation using paging
    @AppStorage("paging") var paging: Int = 0
    
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.white, .color1]), startPoint: .top, endPoint: .bottom)
            
            VStack{
                
                Button {
                    paging = 4
                } label: {
                    Text("Skip").font(.title3)
                        .foregroundStyle(.color)
                }.padding(.top, -50).padding(.leading, 300)
                
                Image("onBoardingCartoon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 344 , height: 300, alignment: .center)
                    .padding(.bottom)
                
                Image("PagingControl2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60 , height: 50, alignment: .center)
                    .padding(.bottom)
                
                Text("Words in the air, now on display, Smart glasses light up what you say.")
                    .font(.custom("Al Nile Bold",size: 19))
                    .multilineTextAlignment(.center)
                    .frame(width: 343, height: 52, alignment: .center)
                    .padding(.bottom,10)
                
                Text("What you say becomes a line, On these lenses, clear and fine.")
                    .multilineTextAlignment(.center)
                    .frame(width: 343, height: 49.33, alignment: .center)
                    .padding(.bottom,30)
                
                Button {
                    paging = 3
                } label: {
                    Text("Next")
                        .foregroundStyle(Color.white)
                        .frame(width: 343, height: 51, alignment: .center)
                        .background(Color.color)
                        .cornerRadius(12)
                }
            }
        }.ignoresSafeArea(.all)
    }
}

#Preview {
    SecondOnBoarding()
}
