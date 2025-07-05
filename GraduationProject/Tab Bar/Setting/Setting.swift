//
//  Setting.swift
//  GraduationProject
//
//  Created by Khalid Gad on 18/02/2025.
//

import SwiftUI
import FittedSheets

struct Setting: View {
    
    @AppStorage("appearance") private var selectedAppearance: String = "System"
    @AppStorage("language") private var selectedLanguage: String = "System"
    @AppStorage("paging") var paging: Int = 0
    
    @StateObject private var localizationManager = LocalizationManager.shared
    
    let appearances = ["System", "Light", "Dark"]
    let language = ["System", "Arabic", "English"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.color1).ignoresSafeArea(.all)
                
                VStack {
                    Form {
                        Section {
                            HStack {
                                Text("VocaLens")
                                    .foregroundStyle(.color)
                                    .font(.title3)
                                Spacer()
                            }
                            
                            appearancePicker
                            languagePicker
                        }
                        
                        Section {
                            NavigationLink(destination: Profile()) {
                                HStack {
                                    Image(systemName: "person").foregroundStyle(.color)
                                    Text("Profile".localized).foregroundStyle(.color)
                                }
                            }
                            
                            Button(action: {
                                showHelpSheet()
                            }) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle").foregroundStyle(.color)
                                    Text("Contact Us".localized).foregroundStyle(.color)
                                }
                            }
                            
                            Button(action: {
                                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                paging = 4
                            }) {
                                HStack {
                                    Image(systemName: "arrow.backward").foregroundStyle(.red)
                                    Text("Log Out".localized).foregroundStyle(.red)
                                }
                            }
                        }
                        
                        Section {
                            HStack {
                                Text("Version".localized)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("Powered by".localized)
                                    .foregroundColor(.gray)
                                Text("VocaLens")
                                    .foregroundColor(.color)
                            }
                        }
                    }
                    .background(Color(.color1))
                    .scrollContentBackground(.hidden)
                    .background(Color(UIColor.systemGroupedBackground))
                }
            }
            .navigationTitle("Settings".localized)
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            applyTheme(selectedAppearance)
        }
    }
    
    // MARK: - Custom Pickers
    
    private var appearancePicker: some View {
        Picker("Appearance".localized, selection: $selectedAppearance) {
            ForEach(appearances, id: \.self) {
                Text($0.localized)
            }
        }
        .foregroundColor(.color)
        .tint(.blue)
        .pickerStyle(MenuPickerStyle())
        .onChange(of: selectedAppearance) { newValue in
            applyTheme(newValue)
        }
    }

    private var languagePicker: some View {
        Picker("Language".localized, selection: $localizationManager.currentLanguage) {
            ForEach(language, id: \.self) {
                Text($0.localized)
            }
        }
        .foregroundColor(.color)
        .tint(.blue)
        .pickerStyle(MenuPickerStyle())
        .onChange(of: localizationManager.currentLanguage) { newValue in
            selectedLanguage = newValue
        }
    }
    
    // MARK: - Sheet Presentation
    
    private func showHelpSheet() {
        let helpVC = UIHostingController(rootView: ContactUs())
        let sheetController = SheetViewController(controller: helpVC, sizes: [.fixed(300), .fullscreen])
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(sheetController, animated: true)
        }
    }
}

#Preview {
    Setting()
}
