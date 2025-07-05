
import SwiftUI
import AVFoundation

// MARK: - ViewModel for OTP
class OTPViewModel: ObservableObject {
    @Published var otp: [String] = Array(repeating: "", count: 5)
    @Published var timeRemaining = 30
    @Published var isResendEnabled = false
    @Published var showError = false
    @Published var success = false
    @Published var isVerified = false
    @Published var showCheckmark = false
    var onError: ((String) -> Void)?
    var onSuccess: ((String) -> Void)?

    private var timer: Timer?

    init() {
        startResendTimer()
    }

    private func getUserEmail() -> String {
        return UserDefaults.standard.string(forKey: "email") ?? ""
    }

    func handleInputChange(index: Int, value: String, focusedIndex: inout Int) {
        if value.count > 1 {
            otp[index] = String(value.last!)
        }

        if !value.isEmpty && index < 4 {
            focusedIndex = index + 1
        } else if value.isEmpty && index > 0 {
            focusedIndex = index - 1
        }
    }

    func verifyOTP() {
        let enteredOTP = otp.joined()
        print("Entered OTP: \(enteredOTP)")
        
        let otpRequest = Otp(email: getUserEmail(), otpCode: enteredOTP)

        APIService.shared.postData(to: Apis.otpCode, body: otpRequest) {  [weak self] (result: Result<otpResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("Server Response: \(response)")
                        self?.onSuccess?(response.message)
                        self?.showError = false
                        self?.success = true

                        withAnimation(.easeInOut(duration: 0.5)) {
                            self?.isVerified = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5)) {
                                self?.showCheckmark = true
                            }
                            self?.playSuccessSound()
                        }

                    case .failure(let error):
                        print("Error verifying OTP: \(error.localizedDescription)")
                        self?.onError?(error.localizedDescription)

                        self?.showError = true
                        self?.success = false
                    }
                }
            }
    }

    func resendOTP() {
        otp = Array(repeating: "", count: 5)
        timeRemaining = 30
        isResendEnabled = false
        startResendTimer()

        let resend = reSendOtp(email: getUserEmail())
        APIService.shared.postData(to: Apis.resendOtpCode, body: resend) {  [weak self] (result: Result<otpResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("Server Response: \(response)")

                    case .failure(let error):
                        print("Error verifying OTP: \(error.localizedDescription)")
                        self?.showError = true
                        self?.success = false
                    }
                }
            }
    }

    private func startResendTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.isResendEnabled = true
                    timer.invalidate()
                }
            }
        }
    }

    private func playSuccessSound() {
        AudioServicesPlaySystemSound(1407)
    }
}
