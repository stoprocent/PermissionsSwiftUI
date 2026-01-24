//
//  ContinueButtonSection.swift
//
//
//  Created by Claude Code on 1/24/26.
//

import SwiftUI

/// A view that displays the continue button for carousel flow
@available(iOS 13.0, tvOS 13.0, *)
struct ContinueButtonSection: View {

    /// Binding to control view visibility
    @Binding var showing: Bool

    @EnvironmentObject var store: PermissionStore
    @EnvironmentObject var schemaStore: PermissionSchemaStore
    @EnvironmentObject var carouselStore: CarouselStore

    /// The text to display on the button based on carousel state
    private var buttonText: String {
        switch carouselStore.state {
        case .idle:
            return store.configStore.continueButtonTexts.continueText
        case .processing:
            return store.configStore.continueButtonTexts.processingText
        case .completed:
            return store.configStore.continueButtonTexts.doneText
        case .allDetermined:
            return store.configStore.continueButtonTexts.continueText
        case .dismissed:
            return store.configStore.continueButtonTexts.doneText
        }
    }

    /// Whether the button should be disabled
    private var isDisabled: Bool {
        carouselStore.state == .processing
    }

    /// Button colors from the existing AllButtonColors configuration
    private var buttonColors: ButtonColor {
        store.configStore.allButtonColors.continueButton
    }

    var body: some View {
        Button(action: handleTap) {
            Text(LocalizedStringKey(buttonText), bundle: .module)
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundColor(buttonColors.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Capsule()
                        .fill(buttonColors.backgroundColor)
                )
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
        .id(carouselStore.state)  // Force re-render on state change
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: buttonText)
        .accessibilityLabel(Text(LocalizedStringKey(buttonText), bundle: .module))
        .accessibilityHint(Text(LocalizedStringKey(accessibilityHint), bundle: .module))
    }

    /// The accessibility hint for the current state
    private var accessibilityHint: String {
        switch carouselStore.state {
        case .idle:
            return "hint_continue_start"
        case .processing:
            return "hint_continue_processing"
        case .completed:
            return "hint_continue_done"
        case .allDetermined:
            return "hint_continue_dismiss"
        case .dismissed:
            return ""
        }
    }

    /// Handle button tap based on current state
    private func handleTap() {
        switch carouselStore.state {
        case .idle:
            // Start the carousel flow
            carouselStore.startCarousel()

        case .allDetermined:
            // All permissions already determined, just dismiss
            carouselStore.dismissView()

        case .completed:
            // Carousel completed, dismiss the view
            carouselStore.dismissView()

        case .processing:
            // Button is disabled, should not reach here
            break

        case .dismissed:
            // Already dismissed, should not reach here
            break
        }
    }
}

// MARK: - Preview
@available(iOS 13.0, *)
struct ContinueButtonSection_Previews: PreviewProvider {
    static var previews: some View {
        let store = PermissionStore()
        let schemaStore = PermissionSchemaStore(store: store, permissionViewStyle: .modal)
        let carouselStore = CarouselStore()

        VStack(spacing: 20) {
            // Idle state
            ContinueButtonSection(showing: .constant(true))
                .environmentObject(store)
                .environmentObject(schemaStore)
                .environmentObject(carouselStore)
                .onAppear { carouselStore.state = .idle }

            // Processing state
            ContinueButtonSection(showing: .constant(true))
                .environmentObject(store)
                .environmentObject(schemaStore)
                .environmentObject(carouselStore)
                .onAppear { carouselStore.state = .processing }

            // Completed state
            ContinueButtonSection(showing: .constant(true))
                .environmentObject(store)
                .environmentObject(schemaStore)
                .environmentObject(carouselStore)
                .onAppear { carouselStore.state = .completed }
        }
        .padding()
    }
}
