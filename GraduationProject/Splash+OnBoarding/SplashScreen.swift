//
//import SwiftUI
//
//struct SplashScreen: View {
//    @State var isActive: Bool = false
//    @State var isActiveAnimation: Bool = false
//    @State private var size = 0.8
//    @State private var opacity = 0.2
//    
//    // Navigation using paging
//    @AppStorage("paging") var paging: Int = 0
//    
//    var body: some View {
//              
//        if isActive{
//            FirstOnBoarding()
//        } else {
//            ZStack{
//          //      Color.mainColorScreen.ignoresSafeArea()
//
//                // Mesh Gradient background animation
//                
//                TimelineView(.animation) { context in
//                    let s = context.date.timeIntervalSince1970
//                    let v = Float(sin(s)) / 4
//                    
//                    MeshGradient(
//                        width: 3,
//                        height: 3,
//                        points: [
//                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
//                            [0.0, 0.5], [0.5 + v, 0.5 - v], [1.0, 0.3 - v],
//                            [0.0, 1.0], [0.7 - v, 1.0], [1.0, 1.0],
//                        ],
//                        
//                        colors: [
//                            .color0, .color2, isActive ? .color9 : .color3,
//                            .color4, .color5, .color6,
//                            isActive ? .color5 : .color7, .color8, .color9
//                        ]
//                    )
//                }
//                .ignoresSafeArea()
//                .onAppear {
//                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
//                        isActiveAnimation = true
//                    }
//                }
//                
//                
//                VStack{
// 
//                    Text("VocaLens")
//                        .foregroundStyle(Color(hex: "CCF3FF").opacity(0.80))
//                        .frame(width: 285, height: 80, alignment: .center)
//                        .font(.custom("Rockwell Bold", size: 45.0))
//                        .padding(.bottom,-500.0)
//                    
//                    Image("logo")
//                        .resizable()
//                        .scaledToFit()
//                        .padding(.top,-100)
//                        .padding(.leading, 20)
//                        .padding(.trailing, 20)
//                    
//                    Text("Communication made crystal clear, With VocaLens, connection is here.")
//                        .foregroundStyle(Color(hex: "CCF3FF").opacity(0.80))
//                        .frame(width: 337.67, height: 47, alignment: .center)
//                        .font(.custom("Futura Bold", size: 18.0))
//                        .padding(.top,-100)
//                      
//                    
//                }.scaledToFit()
//                    .opacity(opacity)
//                    .onAppear{
//                        withAnimation(.easeIn(duration: 1.5)) {
//                            self.size = 0.9
//                            self.opacity = 1.0
//                        }
//                    }
//            }
//            .onAppear{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
//                    withAnimation {
//                        self.isActive = true
//                    }
//                }
//            }
//        }
//    }
//}
//
//    
////    extension Color {
////        static let color0 = Color(red: 137/255, green: 207/255, blue: 204/255)
////        static let color2 = Color(red: 124/255, green: 224/255, blue: 224/255)
////        static let color3 = Color(red: 158/255, green: 255/255, blue: 226/255)
////        static let color4 = Color(red: 64/255, green: 224/255, blue: 208/255)
////        static let color5 = Color(red: 49/255, green: 186/255, blue: 190/255)
////        static let color6 = Color(red: 64/255, green: 181/255, blue: 173/255)
////        static let color7 = Color(red: 125/255, green: 249/255, blue: 255/255)
////        static let color8 = Color(red: 137/255, green: 240/255, blue: 222/255)
////        static let color9 = Color(red: 64/255, green: 224/255, blue: 208/255)
////    }
//
//
//extension Color {
//    static let color0 = Color(red: 137/255, green: 207/255, blue: 240/255) // Light Sky Blue
//    static let color2 = Color(red: 102/255, green: 204/255, blue: 204/255) // Soft Cyan
//    static let color3 = Color(red: 158/255, green: 255/255, blue: 226/255) // Aquamarine
//    static let color4 = Color(red: 70/255, green: 191/255, blue: 189/255)  // Sea Green
//    static let color5 = Color(red: 49/255, green: 186/255, blue: 190/255)  // Turquoise
//    static let color6 = Color(red: 44/255, green: 170/255, blue: 173/255)  // Deep Teal
//    static let color7 = Color(red: 123/255, green: 225/255, blue: 255/255) // Sky Blue
//    static let color8 = Color(red: 120/255, green: 220/255, blue: 210/255) // Mint Blue
//    static let color9 = Color(red: 82/255, green: 210/255, blue: 255/255)  // Ocean Blue
//}
//
//   
//#Preview {
//    SplashScreen()
//}


import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false
    @State var isActiveAnimation: Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.2
    
    // Navigation using paging
    @AppStorage("paging") var paging: Int = 0
    
    var body: some View {
        if isActive {
            FirstOnBoarding()
        } else {
            ZStack {
                // Mesh Gradient background animation
                TimelineView(.animation) { context in
                    let s = context.date.timeIntervalSince1970
                    let v = Float(sin(s)) / 4
                    
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                            [0.0, 0.5], [0.5 + v, 0.5 - v], [1.0, 0.3 - v],
                            [0.0, 1.0], [0.7 - v, 1.0], [1.0, 1.0],
                        ],
                        colors: [
                            .color0, .color2, isActive ? .color9 : .color3,
                            .color4, .color5, .color6,
                            isActive ? .color5 : .color7, .color8, .color9
                        ]
                    )
                }
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isActiveAnimation = true
                    }
                }
                
                VStack {
                    Text("VocaLens")
                        .foregroundStyle(Color(hex: "CCF3FF").opacity(0.80))
                        .frame(width: 285, height: 80, alignment: .center)
                        .font(.custom("Rockwell Bold", size: 45.0))
                        .padding(.bottom, -500.0)
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, -100)
                        .padding(.horizontal, 20)
                    
                    Text("Communication made crystal clear, With VocaLens, connection is here.")
                        .foregroundStyle(Color(hex: "CCF3FF").opacity(0.80))
                        .frame(width: 337.67, height: 47, alignment: .center)
                        .font(.custom("Futura Bold", size: 18.0))
                        .padding(.top, -100)
                }
                .scaledToFit()
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                    if isLoggedIn {
                        paging = -1 // Navigate to Home Screen
                    } else {
                        withAnimation {
                            self.isActive = true // Navigate to onboarding
                        }
                    }
                }
            }
        }
    }
}

extension Color {
    static let color0 = Color(red: 137/255, green: 207/255, blue: 240/255)
    static let color2 = Color(red: 102/255, green: 204/255, blue: 204/255)
    static let color3 = Color(red: 158/255, green: 255/255, blue: 226/255)
    static let color4 = Color(red: 70/255, green: 191/255, blue: 189/255)
    static let color5 = Color(red: 49/255, green: 186/255, blue: 190/255)
    static let color6 = Color(red: 44/255, green: 170/255, blue: 173/255)
    static let color7 = Color(red: 123/255, green: 225/255, blue: 255/255)
    static let color8 = Color(red: 120/255, green: 220/255, blue: 210/255)
    static let color9 = Color(red: 82/255, green: 210/255, blue: 255/255)
}

#Preview {
    SplashScreen()
}

