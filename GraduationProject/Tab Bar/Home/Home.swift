//
//  Home.swift
//  GraduationProject
//
//  Created by MacBook Pro on 12/02/2025.
//

import SwiftUI


struct CustomizationItem: View {
    let title: String
    @Binding var value: Int
    var onValueChange: (Int) -> Void // Add closure to handle value changes

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.color)
                .padding(.leading, 5)

            HStack {
                Button(action: {
                    if value > 1 {
                        value -= 1
                        onValueChange(value) // Call closure on change
                    }
                }) {
                    Image(systemName: "minus")
                        .frame(width: 40, height: 40)
                        .background(Color.color1)
                        .foregroundColor(.color)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(value <= 1)

                Text("\(value)")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.color1)
                    .frame(minWidth: 60)
                    .padding(.leading, 55)

                Spacer()

                Button(action: {
                    if value < 9 {
                        value += 1
                        onValueChange(value) // Call closure on change
                    }
                }) {
                    Image(systemName: "plus")
                        .frame(width: 40, height: 40)
                        .background(Color.color1)
                        .foregroundColor(.color)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(value >= 9)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.color)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
struct Home: View {
    @AppStorage("appearance") private var selectedAppearance: String = "System"
    @AppStorage("language") private var selectedLanguage: String = "System"
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("transLanguage") private var transLanguage: String = "Arabic"
    @AppStorage("isTranslationOn") private var isTranslationOn: Bool = false
    @State private var textFontSize: Int = 5
    @State private var voiceLevel: Int = 5
    @State private var selectedColor: Color = .black
    @State private var showLanguagePicker = false

    let colors: [(String, Color)] = [
        ("Black", .black),
        ("White", .white),
        ("Red", .red),
        ("Blue", .blue),
        ("Green", .green)
    ]
    let language = ["Translation", "English"]

    var body: some View {
        ZStack {
            Color(.color1).ignoresSafeArea(.all)
            content
        }
        .onAppear {
            applyTheme(selectedAppearance)
            viewModel.makeFontRequest(body: textFontSize)
        }
        .animation(.easeInOut(duration: 0.2), value: showLanguagePicker)
    }

    // Main content extracted
    private var content: some View {
        VStack(alignment: .leading) {
            welcomeHeader
            customizeTitle
            translationToggle
           // languagePicker
            fontSizeCustomization
        }
        .padding()
    }

    private var welcomeHeader: some View {
        HStack {
            Circle()
                .fill(Color.color)
                .frame(width: 50, height: 50)
                .overlay(Text("\(firstName.prefix(1))\(lastName.prefix(1))").font(.title3))
                .foregroundColor(.color1)

            Text("Welcome Back".localized + ",\n\(firstName) \(lastName)")
                .font(.title3)
                .bold()
                .foregroundColor(.color)
        }
        .padding()
        .padding(.top, -100)
    }

    private var customizeTitle: some View {
        Text("You Can Now Customize Your Vocalens!".localized)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.color)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
    }

    private var translationToggle: some View {
        HStack {
            Text("Speach to Text Arabic".localized)
                .font(.title3)
                .bold()
                .foregroundColor(.color)
                .padding(.leading, 30)

            Toggle("", isOn: $isTranslationOn)
                .labelsHidden()
                .tint(.color)
                .padding(.trailing, -30)
        }
        .padding(.top, 10)
    }

    private var languagePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Language of Text".localized)
                .font(.title3)
                .bold()
                .foregroundColor(.color)
                .padding(.leading, 10)

            Button(action: {
                showLanguagePicker.toggle()
            }) {
                HStack {
                    Text(transLanguage.localized)
                        .foregroundColor(.color)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.color)
                        .rotationEffect(.degrees(showLanguagePicker ? 180 : 0))
                }
                .padding()
                .background(Color.color.opacity(0.1))
                .cornerRadius(12)
            }

            if showLanguagePicker {
                VStack(spacing: 0) {
                    ForEach(language, id: \.self) { lang in
                        Button(action: {
                            transLanguage = lang
                            showLanguagePicker = false
                        }) {
                            HStack {
                                Text(lang.localized)
                                    .foregroundColor(transLanguage == lang ? .color : .gray)
                                    .font(.headline)
                                Spacer()
                                if transLanguage == lang {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.color)
                                }
                            }
                            .padding()
                            .background(Color.color.opacity(0.05))
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }

    private var fontSizeCustomization: some View {
        CustomizationItem(
            title: "Font Size of Text".localized,
            value: $textFontSize,
            onValueChange: { newValue in
                viewModel.makeFontRequest(body: newValue)
            }
        )
        .padding()
        .padding(.top, 10)
    }
}

#Preview {
    Home()
}
