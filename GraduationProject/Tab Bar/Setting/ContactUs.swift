import SwiftUI

struct ContactUs: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismissSheet()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.color)
                        .font(.title)
                }
            }
            .padding()
            
            HStack(spacing: 20) {
                ContactCard(icon: "envelope", title: "Send Email", value: "vocalens.sup@gmail.com")
                ContactCard(icon: "phone.arrow.up.right", title: "Call Us", value: "+201150801065")
            }
            .padding()
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private func dismissSheet() {
        if let topVC = UIApplication.shared.windows.first?.rootViewController?.presentedViewController {
            topVC.dismiss(animated: true)
        }
    }
}

struct ContactCard: View {
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        Button(action: {
            if title == "Call Us" {
                callNumber(value)
            } else if title == "Send Email" {
                sendEmail()
            }
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .padding()
                    .background(Color(.color))
                    .cornerRadius(10)
                    .foregroundColor(.color1)
                
                Text(title)
                    .font(.headline).foregroundStyle(.color)
                
                // Uncomment this if you want to display the value
                // Text(value)
                //     .font(.subheadline)
                //     .foregroundColor(.color)
            }
            .frame(width: 150, height: 150)
            .background(Color.color1)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
    
    /// Open the phone app with the given number
    private func callNumber(_ number: String) {
        let formattedNumber = "tel://\(number)".replacingOccurrences(of: " ", with: "")
        if let url = URL(string: formattedNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open email app with pre-filled recipient
    private func sendEmail() {
        let email = "vocalens.sup@gmail.com"
        if let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "mailto:\(encodedEmail)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ContactUs()
}
