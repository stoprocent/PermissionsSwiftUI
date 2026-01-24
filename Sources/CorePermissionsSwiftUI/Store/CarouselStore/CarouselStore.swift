//
//  CarouselStore.swift
//
//
//  Created by Claude Code on 1/24/26.
//

import Foundation
import SwiftUI

/// The state of the carousel permission flow
@available(iOS 13.0, tvOS 13.0, *)
public enum CarouselState: Equatable {
    /// Carousel is idle, waiting for user to tap Continue
    case idle
    /// Carousel is actively requesting permissions
    case processing
    /// Carousel has completed all permission requests
    case completed
    /// All permissions were already determined before carousel started
    case allDetermined
    /// View has been dismissed
    case dismissed
}

/// Manages the carousel permission flow state and progression
@available(iOS 13.0, tvOS 13.0, *)
public class CarouselStore: ObservableObject {

    // MARK: - Published State

    /// The current state of the carousel
    @Published public var state: CarouselState = .idle

    /// The index of the currently processing permission (nil when not processing)
    @Published public var currentPermissionIndex: Int?

    /// Set of permission types that have been processed in this carousel session
    @Published public var processedPermissions: Set<PermissionType> = []

    // MARK: - Dependencies

    /// Reference to the main permission store
    public weak var permissionStore: PermissionStore?

    /// Reference to the schema store
    public weak var schemaStore: PermissionSchemaStore?

    /// Binding to control view dismissal
    public var showingBinding: Binding<Bool>?

    // MARK: - Configuration

    /// Whether the carousel flow is enabled in the config
    public var isCarouselEnabled: Bool {
        permissionStore?.configStore.enableCarouselFlow ?? false
    }

    /// The delay before auto-dismissing after carousel completes
    private var autoDismissDelay: TimeInterval {
        permissionStore?.configStore.autoDismissDelay ?? 0.8
    }

    /// Whether auto-dismiss is enabled for the current view style
    private var shouldAutoDismiss: Bool {
        guard let configStore = permissionStore?.configStore,
              let schemaStore = schemaStore,
              let permissionStore = permissionStore else { return false }

        // Check if autoDismiss is enabled globally and for current style
        return configStore.autoDismiss &&
               ((schemaStore.permissionViewStyle == .alert && permissionStore.autoDismissAlert) ||
                (schemaStore.permissionViewStyle == .modal && permissionStore.autoDismissModal))
    }

    // MARK: - Initialization

    public init() {}

    /// Initialize the carousel store with dependencies
    public func initialize(
        permissionStore: PermissionStore,
        schemaStore: PermissionSchemaStore,
        showing: Binding<Bool>
    ) {
        self.permissionStore = permissionStore
        self.schemaStore = schemaStore
        self.showingBinding = showing

        // Determine initial state
        let undetermined = getUndeterminedPermissions()
        if undetermined.isEmpty {
            state = .allDetermined
        } else {
            state = .idle
        }
    }

    // MARK: - Public Interface

    /// Start the carousel flow
    public func startCarousel() {
        guard isCarouselEnabled else { return }

        let undeterminedPermissions = getUndeterminedPermissions()

        // If all permissions are already determined, just dismiss
        if undeterminedPermissions.isEmpty {
            state = .allDetermined
            dismissView()
            return
        }

        // Reset processed permissions for this session
        processedPermissions.removeAll()

        // Start processing
        state = .processing
        requestNextPermission(from: undeterminedPermissions, index: 0)
    }

    /// Check if a specific permission is currently being processed
    public func isProcessingPermission(_ permissionType: PermissionType) -> Bool {
        guard let index = currentPermissionIndex,
              let permissions = permissionStore?.permissions else {
            return false
        }

        guard index < permissions.count else { return false }
        return permissions[index].permissionType == permissionType
    }

    /// Dismiss the view (called when user taps Done or auto-dismiss triggers)
    public func dismissView() {
        state = .dismissed
        showingBinding?.wrappedValue = false

        // Call completion handlers
        if let handler = permissionStore?.configStore.onDisappearHandler {
            handler(
                schemaStore?.successfulPermissions,
                schemaStore?.erroneousPermissions
            )
        }

        permissionStore?.configStore.onDisappear?()
    }

    // MARK: - Private Helpers

    /// Get all permissions that are currently in notDetermined state
    private func getUndeterminedPermissions() -> [PermissionManager] {
        guard let permissions = permissionStore?.permissions else { return [] }

        return permissions.filter { manager in
            manager.authorizationStatus == .notDetermined
        }
    }

    /// Request the next permission in the sequence
    private func requestNextPermission(from permissions: [PermissionManager], index: Int) {
        // Base case: all permissions processed
        guard index < permissions.count else {
            completeCarousel()
            return
        }

        currentPermissionIndex = index
        let permission = permissions[index]

        // Request the permission
        permission.requestPermission { [weak self] authorized, error in
            DispatchQueue.main.async {
                guard let self = self else { return }

                // Handle the result
                self.handlePermissionResult(
                    permission: permission,
                    authorized: authorized,
                    error: error
                )

                // Continue to next permission REGARDLESS of result
                self.requestNextPermission(from: permissions, index: index + 1)
            }
        }
    }

    /// Handle the result of a permission request
    private func handlePermissionResult(
        permission: PermissionManager,
        authorized: Bool,
        error: Error?
    ) {
        // Mark as processed
        processedPermissions.insert(permission.permissionType)

        // Update the schema store (following existing pattern)
        updateSchemaStore(for: permission, authorized: authorized, error: error)

        // Notify observers of state change
        schemaStore?.objectWillChange.send()
    }

    /// Update the schema store with permission result (follows existing pattern from PermissionSectionCell)
    private func updateSchemaStore(
        for permissionManager: PermissionManager,
        authorized: Bool,
        error: Error?
    ) {
        guard let schemaStore = schemaStore else { return }

        let result = JMResult(
            permissionType: permissionManager.permissionType,
            authorizationStatus: permissionManager.authorizationStatus,
            error: error
        )

        schemaStore.permissionComponentsStore.getPermissionComponent(for: permissionManager.permissionType) { permissionComponent in
            permissionComponent.interacted = true

            if authorized {
                permissionComponent.authorized = true

                // Add to successful permissions
                if schemaStore.successfulPermissions == nil {
                    schemaStore.successfulPermissions = [result]
                } else {
                    schemaStore.successfulPermissions?.append(result)
                }
            } else {
                permissionComponent.authorized = false

                // Add to erroneous permissions
                if schemaStore.erroneousPermissions == nil {
                    schemaStore.erroneousPermissions = [result]
                } else {
                    schemaStore.erroneousPermissions?.append(result)
                }
            }
        }
    }

    /// Complete the carousel flow
    private func completeCarousel() {
        state = .completed
        currentPermissionIndex = nil

        // Handle auto-dismiss if enabled
        if shouldAutoDismiss {
            handleAutoDismiss()
        }
    }

    /// Handle auto-dismiss after carousel completion
    private func handleAutoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissDelay) { [weak self] in
            guard let self = self,
                  self.state == .completed else { return }

            self.dismissView()
        }
    }
}
