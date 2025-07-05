import SwiftUI
import SwiftData

@main
struct VocaLensApp: App {
    let container: ModelContainer
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @AppStorage("paging") var paging: Int = 0
    
    init() {
        do {
            container = try ModelContainer(
                for: ChatMessage.self, FavoriteChat.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        paging = 0
        
        // Initialize localization
        if let language = UserDefaults.standard.string(forKey: "language") {
            LocalizationManager.shared.currentLanguage = language
        }
    }
    
    var body: some Scene {
        WindowGroup {
            switch paging {
            case 0:
                SplashScreen()
            case 1:
                FirstOnBoarding()
            case 2:
                SecondOnBoarding()
            case 3:
                ThirdOnBoarding()
            case 4:
                LoginScreen()
            case 5:
                SignUpScreen()
            case 6:
                LoadingView()
            case 7:
                ForgetPasswordView()
            case 8:
                NewPasswordScreen()
            default:
                MainTabBar()
            }
        }
        .modelContainer(container)
        .environmentObject(userViewModel)
        .environmentObject(localizationManager)
        .environment(\.layoutDirection, localizationManager.isRTL ? .rightToLeft : .leftToRight)
    }
} 
