//
//  JMFaceIDPermissionManager.swift
//
//
//  Created by Nevio Hirani on 20.01.24.
//  Github: N3v1  -
//

#if os(iOS)
import Foundation
import LocalAuthentication
import CorePermissionsSwiftUI

/// A permission manager for handling Face ID authentication requests.
@available(iOS 13.0, *)
public extension PermissionManager {
    /// Shared instance for managing Face ID permissions.
    static let faceID = JMFaceIDPermissionManager()
}

/// A permission manager specifically designed for handling Face ID authentication requests.
///
/// `JMFaceIDPermissionManager` checks for Face ID availability and requests authentication using Face ID.
/// It is part of the `CorePermissionsSwiftUI` framework and aligns with the standardized `PermissionManager` protocol.
@available(iOS 13.0, *)
public final class JMFaceIDPermissionManager: PermissionManager {
    
    public override var permissionType: PermissionType {
        .faceID
    }
    
    public override var authorizationStatus: AuthorizationStatus {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            switch error?.code {
            case LAError.Code.biometryLockout.rawValue,
                 LAError.Code.biometryNotAvailable.rawValue,
                 LAError.Code.biometryNotEnrolled.rawValue:
                return .denied
            default:
                return .notDetermined
            }
        }
        
        return context.biometryType == .faceID ? .authorized : .denied
    }
    
    public override func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async {
                completion(false, error)
            }
            return
        }
        
        guard context.biometryType == .faceID else {
            let notSupportedError = NSError(
                domain: LAError.errorDomain,
                code: LAError.biometryNotAvailable.rawValue,
                userInfo: [NSLocalizedDescriptionKey: "Face ID is not available on this device."]
            )
            DispatchQueue.main.async {
                completion(false, notSupportedError)
            }
            return
        }
        
        let localizedReason = "Authenticate with Face ID to access secure items"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
#endif
