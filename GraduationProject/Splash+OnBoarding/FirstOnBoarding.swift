import SwiftUI

struct FirstOnBoarding: View {
    
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
                
                Image("Glasses1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 344 , height: 300, alignment: .center)
                    .padding(.bottom)
                
                Image("PagingControl1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60 , height: 50, alignment: .center)
                    .padding(.bottom)
                
                Text("No words are lost, no signs unseen, VocaLens keeps the pathway clean.")
                    .font(.custom("Al Nile Bold",size: 20))
                    .frame(width: 343, height: 54.67, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,10)
                
                Text("You express, we translate, VocaLens makes communication seamless and great.")
                    .frame(width: 343, height: 46.67, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.bottom,30)
                
                Button {
                    paging = 2
                } label: {
                    Text("Next")
                        .foregroundStyle(Color.white)
                        .frame(width: 343, height: 51, alignment: .center)
                        .background(Color.color)
                        .cornerRadius(12)
                }
            }
        }.edgesIgnoringSafeArea(.all)
        
    }
}

#Preview {
    FirstOnBoarding()
}
