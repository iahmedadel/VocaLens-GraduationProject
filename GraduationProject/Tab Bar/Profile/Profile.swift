//
//  Profile.swift
//  GraduationProject
//
//  Created by MacBook Pro on 12/02/2025.
//

import SwiftUI

struct Profile: View {
    @AppStorage("appearance") private var selectedAppearance: String = "System"
    @AppStorage("language") private var selectedLanguage: String = "System"
    @AppStorage("firstName") private var firstName: String = ""
    @AppStorage("lastName") private var lastName: String = ""
    @AppStorage("dateOfBirth") private var dateOfBirth: String = ""
    @AppStorage("country") private var country: String = ""
    @AppStorage("address") private var address: String = ""
    @AppStorage("phoneNumber") private var phoneNumber: String = ""
    @AppStorage("email") private var email: String = ""
    
    @State private var isEditing = false
    @State private var tempDateOfBirth: String = ""
    @State private var tempCountry: String = ""
    @State private var tempAddress: String = ""
    @State private var tempPhoneNumber: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color(.color1).ignoresSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Circle()
                        .fill(Color.color)
                        .frame(width: 60, height: 60)
                        .overlay(Text("\(firstName.prefix(1))\(lastName.prefix(1))").font(.title3))
                        .foregroundColor(.color1)
                    
                    Text("\(firstName) \(lastName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.color)
                }
                .padding(.bottom)
                
                if isEditing {
                    EditableProfileRow(title: "Date Of Birth".localized, value: $tempDateOfBirth)
                    EditableProfileRow(title: "Country".localized, value: $tempCountry)
                    EditableProfileRow(title: "Address".localized, value: $tempAddress)
                    EditableProfileRow(title: "Phone Number".localized, value: $tempPhoneNumber)
                } else {
                    ProfileRow(title: "Date Of Birth".localized, value: dateOfBirth)
                    ProfileRow(title: "Country".localized, value: country)
                    ProfileRow(title: "Address".localized, value: address)
                    ProfileRow(title: "Phone Number".localized, value: phoneNumber)
                }
                
                // Non-editable fields
                ProfileRow(title: "Email".localized, value: email)
                
                Spacer()
                
                Button(action: {
                    if isEditing {
                        // Save changes
                        dateOfBirth = tempDateOfBirth
                        country = tempCountry
                        address = tempAddress
                        phoneNumber = tempPhoneNumber
                        alertMessage = "Profile updated successfully!".localized
                        showAlert = true
                    }
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Save".localized : "Edit".localized)
                        .font(.headline)
                        .foregroundColor(.color1)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.color))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            applyTheme(selectedAppearance)
            // Initialize temporary values
            tempDateOfBirth = dateOfBirth
            tempCountry = country
            tempAddress = address
            tempPhoneNumber = phoneNumber
        }
        .alert("Profile Update".localized, isPresented: $showAlert) {
            Button("OK".localized, role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct ProfileRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.color)

            Text(value)
                .font(.body)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()
        }
    }
}

struct EditableProfileRow: View {
    let title: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.color)

            TextField("\(NSLocalizedString("Enter", comment: "")) \(title)", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
                .foregroundColor(.color)

            Divider()
        }
    }
}

#Preview {
    Profile()
}
