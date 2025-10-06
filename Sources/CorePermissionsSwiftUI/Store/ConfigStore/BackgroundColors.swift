//
//  BackgroundColors.swift
//  
//
//  Created by Jevon Mao on 3/18/21.
//

import SwiftUI

// MARK: - Customize the background colors
/**
 `BackgroundColors` encapsulates the background color configuration for modal and dialog views
    
 To customize background colors:
 1. Define a new instance of the `BackgroundColors` struct
 2. Add the appropriate modifier to your view
 3. Pass in the `BackgroundColors` struct previously into the proper parameter
 */
@available(iOS 13.0, tvOS 13.0, *)
public struct BackgroundColors: Equatable {
    var contentChanged: Bool {
        let defaultBackgroundColors = BackgroundColors()
        if self == defaultBackgroundColors {return false}
        return true
    }
    
    //MARK: Creating New Background Color Configs
    /**
     - parameters:
        - modalBackground: The background color for the modal view's main background
        - modalCardBackground: The background color for the permission card in modal view
        - dialogBackground: The background color for the dialog view
        - dialogBlurStyle: The blur style for the dialog overlay background
     */
    public init(modalBackground: Color? = nil, modalCardBackground: Color? = nil, dialogBackground: Color? = nil, dialogBlurStyle: UIBlurEffect.Style? = nil){
        self.modalBackground = modalBackground ?? Color(.secondarySystemBackground)
        self.modalCardBackground = modalCardBackground ?? Color(.systemBackground)
        self.dialogBackground = dialogBackground ?? Color(.systemBackground)
        self.dialogBlurStyle = dialogBlurStyle ?? .systemUltraThinMaterialDark
    }
    
    //MARK: Background Color Properties
    
    ///The background color for the modal view's main background
    public var modalBackground: Color
    
    ///The background color for the permission card in modal view
    public var modalCardBackground: Color
    
    ///The background color for the dialog view
    public var dialogBackground: Color
    
    ///The blur style for the dialog overlay background
    public var dialogBlurStyle: UIBlurEffect.Style
}
