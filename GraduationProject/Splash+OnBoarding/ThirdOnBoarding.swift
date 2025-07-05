import SwiftUI

struct ThirdOnBoarding: View {
    
    // property
    
    // Navigation using paging
    @AppStorage("paging") var paging: Int = 0
    
    
    var body: some View {
 
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.white, .color1]), startPoint: .top, endPoint: .bottom)
            
            VStack{
                
//                Button {
//                    paging = 4
//                } label: {
//                    Text("Skip").font(.title3)
//                        .foregroundStyle(.color)
//                }.padding(.top, -50).padding(.leading, 300)
//
             
                
                Image("onBoardingCartoon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 344 , height: 300, alignment: .center)
                    .padding(.bottom)
                    .padding(.top, 15)
                
                Image("PagingControl3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60 , height: 50, alignment: .center)
                    .padding(.bottom)
                
                Text("VocaLens – Hear the world, speak with ease, silent voices find their peace.")
                    .font(.custom("Al Nile Bold",size: 19))
                    .multilineTextAlignment(.center)
                    .frame(width: 343, height: 52, alignment: .center)
                    .padding(.bottom,10)
                
                Text("Sign in the air, hear it loud, Smart gloves speak your message proud.")
                    .multilineTextAlignment(.center)
                    .frame(width: 343, height: 46.67, alignment: .center)
                    .padding(.bottom,30)
                
                Button {
                    paging = 4
                } label: {
                    Text("Next")
                        .foregroundStyle(Color.white)
                        .frame(width: 343, height: 51, alignment: .center)
                        .background(Color.color)
                        .cornerRadius(10)
                }.padding(.top, 5)
            }
        }.ignoresSafeArea(.all)
    }
}

#Preview {
    ThirdOnBoarding()
}
