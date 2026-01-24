//
//  PermissionStatusIcon.swift
//
//
//  Created by Claude Code on 1/24/26.
//

import SwiftUI

/// The status of a permission in carousel flow
@available(iOS 13.0, tvOS 13.0, *)
public enum PermissionStatus {
    /// Permission has not been determined yet
    case notDetermined
    /// Permission was allowed/granted
    case allowed
    /// Permission was denied
    case denied
    /// Permission is currently being requested (carousel in progress)
    case inProgress
}

/// A view that displays the current status of a permission using an icon
@available(iOS 13.0, tvOS 13.0, *)
struct PermissionStatusIcon: View {

    /// The current status of the permission
    let status: PermissionStatus

    /// Whether this permission is currently being processed in the carousel
    let isProcessing: Bool

    @EnvironmentObject var store: PermissionStore

    /// The SF Symbol name for the current status
    private var iconName: String {
        switch status {
        case .notDetermined:
            return "questionmark.circle.fill"  // Empty circle outline
        case .allowed:
            return "checkmark.circle.fill"  // Green checkmark in filled badge (more prominent)
        case .denied:
            return "xmark.circle.fill"  // Red X in filled badge (more prominent)
        case .inProgress:
            return "clock.fill"  // Circular loading indicator
        }
    }

    /// The color for the current status (uses existing AllButtonColors configuration)
    private var iconColor: Color {
        let buttonColors = store.configStore.allButtonColors
        switch status {
        case .notDetermined:
            return buttonColors.buttonIdle.backgroundColor
        case .allowed:
            return buttonColors.buttonAllowed.backgroundColor
        case .denied:
            return buttonColors.buttonDenied.backgroundColor
        case .inProgress:
            return buttonColors.primaryColor
        }
    }

    /// The accessibility label for the current status
    private var accessibilityLabel: String {
        switch status {
        case .notDetermined:
            return "status_not_determined"
        case .allowed:
            return "status_allowed"
        case .denied:
            return "status_denied"
        case .inProgress:
            return "status_in_progress"
        }
    }

    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: 24, weight: .semibold))  // Make symbols bolder
            .foregroundColor(iconColor)
            .frame(width: 40, height: 40)
            .accessibilityLabel(Text(LocalizedStringKey(accessibilityLabel), bundle: .module))
    }
}

// MARK: - Preview
@available(iOS 13.0, *)
struct PermissionStatusIcon_Previews: PreviewProvider {
    static var previews: some View {
        let store = PermissionStore()

        VStack(spacing: 20) {
            HStack {
                Text("Not Determined")
                Spacer()
                PermissionStatusIcon(status: .notDetermined, isProcessing: false)
            }

            HStack {
                Text("Allowed")
                Spacer()
                PermissionStatusIcon(status: .allowed, isProcessing: false)
            }

            HStack {
                Text("Denied")
                Spacer()
                PermissionStatusIcon(status: .denied, isProcessing: false)
            }

            HStack {
                Text("In Progress")
                Spacer()
                PermissionStatusIcon(status: .inProgress, isProcessing: true)
            }
        }
        .padding()
        .environmentObject(store)
    }
}
