//
//  StatusIconColors.swift
//
//
//  Created by Claude Code on 1/24/26.
//

import Foundation
import SwiftUI

/// Color configuration for permission status icons in carousel flow
@available(iOS 13.0, tvOS 13.0, *)
public struct StatusIconColors: Equatable {

    /// Color for notDetermined status icon
    public var notDeterminedColor: Color

    /// Color for allowed status icon
    public var allowedColor: Color

    /// Color for denied status icon
    public var deniedColor: Color

    /// Color for in-progress status icon (during carousel)
    public var progressColor: Color

    /// Creates status icon colors with default values
    public init() {
        self.notDeterminedColor = Color(.systemGray3)
        self.allowedColor = Color(.systemGreen)
        self.deniedColor = Color(.systemRed)
        self.progressColor = Color(.systemBlue)
    }

    /// Creates status icon colors with custom values
    ///
    /// - Parameters:
    ///   - notDetermined: Color for notDetermined status
    ///   - allowed: Color for allowed status
    ///   - denied: Color for denied status
    ///   - progress: Color for in-progress status
    public init(
        notDetermined: Color,
        allowed: Color,
        denied: Color,
        progress: Color
    ) {
        self.notDeterminedColor = notDetermined
        self.allowedColor = allowed
        self.deniedColor = denied
        self.progressColor = progress
    }
}
