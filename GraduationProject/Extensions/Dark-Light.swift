//
//  Dark:Light.swift
//  GraduationProject
//
//  Created by Khalid Gad on 26/02/2025.
//

import SwiftUI

public func applyTheme(_ appearance: String) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        windowScene.windows.first?.overrideUserInterfaceStyle = {
            switch appearance {
            case "Light": return .light
            case "Dark": return .dark
            default: return .unspecified
            }
        }()
    }
}
