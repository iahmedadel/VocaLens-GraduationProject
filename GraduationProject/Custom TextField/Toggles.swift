import SwiftUI

struct InputField: View {
    var label: String
    var placeHolder:String
    @Binding var text: String
    var fieldType: FieldType  // Field type (password, email, phone number)
    var iconName: String?  // Optional image name for toggle (for email/phone)
    
    @State private var showPassword: Bool = false  // For password visibility toggle
    
    // Enum to define different field types
    enum FieldType {
        case password
        case email
        case phoneNumber
        case firstName
        case lastName
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            // .foregroundColor(Color(hex: "CCF3FF"))
                .foregroundColor(Color(hex: "555555"))
                .padding(.leading, 20)
            
            ZStack {
                // Conditionally render the correct field type
                switch fieldType {
                case .password:
                    if showPassword {
                        TextField(placeHolder, text: $text)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                    } else {
                        SecureField(placeHolder, text: $text)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                    }
                    
                case .email, .phoneNumber, .firstName, .lastName:
                    TextField(placeHolder, text: $text)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    
                    
//                case .firstName:
//                    TextField(placeHolder, text: $text)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .padding(.horizontal, 16).padding(.vertical)
//                        .frame(width: 200, height: 50)
//                    
//                case .lastName:
//                    TextField(placeHolder, text: $text)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .padding(.trailing, 16).padding(.vertical)
//                        .frame(width: 200, height: 50)
//
//                    
                }
                
                // Eye icon for password visibility toggle
                if fieldType == .password {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showPassword.toggle()
                        }
                        .padding(.leading, 320)
                        .padding(.top, -5)
                }
                
//                if fieldType == .firstName {
//                    Image(systemName: "person")
//                        .foregroundColor(.gray)
//                        
//                        .padding(.leading, 70)
//                        .padding(.top, -8)
//                }
//                
//                if fieldType == .lastName {
//                    Image(systemName: "person")
//                        .foregroundColor(.gray)
//                       
//                        .padding(.leading, 70)
//                        .padding(.top, -8)
//                }
                
                // Icon for email or phone number (if provided)
                if let icon = iconName {
                    Image(icon)
                        .foregroundColor(.gray)
                        .padding(.leading, 320)
                        .padding(.top, -5)
                }
            }
            .padding(.bottom, 10)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputField(label: "Password", placeHolder: "", text: .constant(""), fieldType: .password, iconName: nil)
    }
}
