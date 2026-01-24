//
//  PermissionCustomizeModifiers.swift
//
//
//  Created by Jevon Mao on 1/31/21.
//

import SwiftUI

//MARK: Customize Permission Components
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Customizes the image view, title (optional), and description (optional) of any permission component

     Use this modifier on your existing view to set all the available customizations–the symbol image , and title (optional) and description (optional).

     For example,
     ```
     YourTopLevelView()
     .setPermissionComponents(for: .camera,
                              image: AnyView(Image(systemName: "camera.fill")),
                              title: "Camera",
                              description: "Camera description")
     ```
     will override the default image, title , and description for the `camera` permission. It will result in a camera image symbol, and the custom title and description
     - Parameters:
        - for: `PermissonType` specifying the permission component
        - image: The color to render the symbol image
        - title: The title text (optional)
        - description: The description text (optional)
     */
    
    @inlinable func setPermissionComponent(for permission: PermissionType, image:AnyView, title: String?=nil, description: String?=nil) -> some CustomizableView {
        store.permissionComponentsStore.getPermissionComponent(for: permission){permissionComponent in
            permissionComponent.title = title ?? permissionComponent.title
            permissionComponent.imageIcon = image
            permissionComponent.description = description ?? permissionComponent.description
        }
        return self
    }
    
    /**
     Customizes only the title of any permission component

     Use this modifier on your existing view to set the title customization.

     For example,
     ```
     YourTopLevelView()
     .setPermissionComponents(for: .camera,
                              title: "Camera")
     ```
     will override the default title for the `camera` permission. It will result in a custom title.
     - Parameters:
        - for: `PermissonType` specifying the permission component
        - title: The title text
     */
    
    @inlinable func setPermissionComponent(for permission: PermissionType, title: String) -> some CustomizableView {
        store.permissionComponentsStore.getPermissionComponent(for: permission){permissionComponent in
            permissionComponent.title = title
        }
        return self
    }
    
    /**
     Customizes only the description of any permission component

     Use this modifier on your existing view to set the description customization.

     For example,
     ```
     YourTopLevelView()
     .setPermissionComponents(for: .camera,
                              description: "Camera description")
     ```
     will override the default title for the `camera` permission. It will result in a custom description.
     - Parameters:
        - for: `PermissonType` specifying the permission component
        - description: The description text
     */
    
    @inlinable func setPermissionComponent(for permission: PermissionType, description: String) -> some CustomizableView {
        store.permissionComponentsStore.getPermissionComponent(for: permission){$0.description = description}
        return self
    }
}

//MARK: Configure Allow Button Colors
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Customizes the color of allow buttons for all status states

     The customization of button colors with this modifier applies to both `JMAlert` and `JMModal` views
     
     To customize button colors:
     1. Define a new instance of the `AllButtonColors` struct
     2. Add the `setAllowButtonColor(to colors:AllButtonColors)` modifier to your view
     3. Pass in the `AllButtonColors` struct previously into the proper parameter
     
     - Parameters:
        - for: `PermissonType` specifying the permission component
        - description: The description text
     */
    
    @inlinable func setAllowButtonColor(to colors:AllButtonColors) -> some CustomizableView {
        store.configStore.allButtonColors = colors
        return self
    }
    
    /**
     Customizes the close/exit button color.

     The customization of the close button color with this modifier applies to both `JMAlert` and `JMModal` views.

     - Parameters:
        - to: The new customized close button color configuration
     */

    @inlinable func setCloseButtonColor(to closeButtonColor: ButtonColor) -> some CustomizableView {
        store.configStore.allButtonColors.closeButton = closeButtonColor
        return self
    }

    /**
     Customizes the continue button color (carousel flow).

     The customization of the continue button color applies when carousel flow is enabled.

     - Parameters:
        - to: The new customized continue button color configuration
     */

    @inlinable func setContinueButtonColor(to continueButtonColor: ButtonColor) -> some CustomizableView {
        store.configStore.allButtonColors.continueButton = continueButtonColor
        return self
    }
}


//MARK: Set Overall Accent Color
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Customizes the overall accent color of PermissionsSwiftUI views.

     The customization of accent color with this modifier applies to both `JMAlert` and `JMModal` views. The new accent color will replace the default Apple system blue color for image icons, as well as button foreground and background colors.
     
     - Parameters:
        - to: The new customized accent color
     */
    
    @inlinable func setAccentColor(to color: Color) -> some CustomizableView {
        store.configStore.allButtonColors.primaryColor = color
        return self
    }
    
    /**
     Customizes the primary and tertiary color of PermissionsSwiftUI views.

     The customization of colors with this modifier applies to both `JMAlert` and `JMModal` views.
     * The new primary color will replace the default Apple system blue color for image icons, as well as button foreground and background colors.
     * The new tertiary color will replace the default Apple system red color for the `Denied` state of buttons.
     
     - Parameters:
        - toPrimary: The new customized primary color
        - toTertiary: The new customized tertiary color
        
     */
    
    @inlinable func setAccentColor(toPrimary primaryColor: Color, toTertiary tertiaryColor: Color) -> some CustomizableView {
        let buttonColors = AllButtonColors(primaryColor: primaryColor,
                                           tertiaryColor: tertiaryColor)
        store.configStore.allButtonColors = buttonColors
        return self
    }
    
    /**
     Customizes the primary, tertiary, and close button colors of PermissionsSwiftUI views.

     The customization of colors with this modifier applies to both `JMAlert` and `JMModal` views.
     * The new primary color will replace the default Apple system blue color for image icons, as well as button foreground and background colors.
     * The new tertiary color will replace the default Apple system red color for the `Denied` state of buttons.
     * The new close button color will replace the default gray color for the close/exit button icon.
     
     - Parameters:
        - toPrimary: The new customized primary color
        - toTertiary: The new customized tertiary color
        - toCloseButton: The new customized close button icon color
        
     */
    
    @inlinable func setAccentColor(toPrimary primaryColor: Color, toTertiary tertiaryColor: Color, toCloseButton closeButtonColor: Color) -> some CustomizableView {
        let buttonColors = AllButtonColors(primaryColor: primaryColor,
                                           tertiaryColor: tertiaryColor,
                                           closeButtonColor: closeButtonColor)
        store.configStore.allButtonColors = buttonColors
        return self
    }

    /**
     Customizes the text foreground style for all the permission descriptions.

     - Parameters:
        - foreground: The new customized color

     */

    @inlinable func setPermissionDescription(foreground color: any ShapeStyle) -> some CustomizableView {
        store.configStore.permissionDescriptionForeground = color
        return self
    }
}

//MARK: Configure Background Colors
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Customizes the background colors for modal and dialog views.

     The customization of background colors with this modifier applies to both `JMAlert` and `JMModal` views.
     
     To customize background colors:
     1. Define a new instance of the `BackgroundColors` struct
     2. Add the `setBackgroundColors(to colors:BackgroundColors)` modifier to your view
     3. Pass in the `BackgroundColors` struct previously into the proper parameter
     
     - Parameters:
        - to: The `BackgroundColors` struct containing all background color configurations
     */
    
    @inlinable func setBackgroundColors(to colors: BackgroundColors) -> some CustomizableView {
        store.configStore.backgroundColors = colors
        return self
    }
    
    /**
     Customizes the modal background colors.

     The customization applies to the `JMModal` view background colors.
     
     - Parameters:
        - modalBackground: The background color for the modal view's main background
        - modalCardBackground: The background color for the permission card in modal view
     */
    
    @inlinable func setModalBackgroundColors(modalBackground: Color? = nil, modalCardBackground: Color? = nil) -> some CustomizableView {
        store.configStore.backgroundColors.modalBackground = modalBackground ?? store.configStore.backgroundColors.modalBackground
        store.configStore.backgroundColors.modalCardBackground = modalCardBackground ?? store.configStore.backgroundColors.modalCardBackground
        return self
    }
    
    /**
     Customizes the dialog background colors.

     The customization applies to the `JMAlert` view background colors.
     
     - Parameters:
        - dialogBackground: The background color for the dialog view
        - dialogBlurStyle: The blur style for the dialog overlay background
     */
    
    @inlinable func setDialogBackgroundColors(dialogBackground: Color? = nil, dialogBlurStyle: UIBlurEffect.Style? = nil) -> some CustomizableView {
        store.configStore.backgroundColors.dialogBackground = dialogBackground ?? store.configStore.backgroundColors.dialogBackground
        store.configStore.backgroundColors.dialogBlurStyle = dialogBlurStyle ?? store.configStore.backgroundColors.dialogBlurStyle
        return self
    }
}

//MARK: Configure Carousel Flow
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Enables or disables the carousel permission flow.

     The carousel flow replaces individual "Allow" buttons with status icons and a single "Continue" button.
     When enabled, tapping Continue will sequentially request all undetermined permissions.

     This is an opt-in feature that defaults to false for backward compatibility.

     - Parameters:
        - enabled: Whether to enable the carousel flow (default: false)
     */

    @inlinable func setCarouselFlow(enabled: Bool) -> some CustomizableView {
        store.configStore.enableCarouselFlow = enabled
        return self
    }

    /**
     Customizes the text displayed on the continue button in different states.

     The continue button text changes based on the carousel state:
     * Before carousel: "Continue" (or custom text)
     * During carousel: "Processing..." (or custom text)
     * After carousel: "Done" (or custom text)

     - Parameters:
        - to: The `ContinueButtonTexts` struct containing custom text for each state
     */

    @inlinable func setContinueButtonTexts(to texts: ContinueButtonTexts) -> some CustomizableView {
        store.configStore.continueButtonTexts = texts
        return self
    }

    /**
     Customizes the colors of permission status icons in carousel flow.

     Status icons are displayed when carousel flow is enabled, showing the current state of each permission:
     * Not determined: Circle icon (gray by default)
     * Allowed: Checkmark icon (green by default)
     * Denied: X mark icon (red by default)
     * In progress: Animated circle (blue by default)

     - Parameters:
        - to: The `StatusIconColors` struct containing custom colors for each status
     */

    @inlinable func setStatusIconColors(to colors: StatusIconColors) -> some CustomizableView {
        store.configStore.statusIconColors = colors
        return self
    }

    /**
     Sets the delay before auto-dismissing the view after carousel completion.

     This delay only applies when `autoDismiss` is enabled. After the carousel completes,
     the view will wait for this duration before automatically dismissing.

     - Parameters:
        - delay: The delay in seconds (default: 0.8)
     */

    @inlinable func setAutoDismissDelay(_ delay: TimeInterval) -> some CustomizableView {
        store.configStore.autoDismissDelay = delay
        return self
    }
}

//MARK: Configure Color Scheme
@available(iOS 13.0, tvOS 13.0, *)
public extension CustomizableView {
    /**
     Forces a specific color scheme for the permissions view, overriding the system setting.

     Use this to display the permission view in dark mode or light mode regardless of the user's
     device settings.

     - Parameters:
        - colorScheme: The color scheme to use (.dark or .light). Pass nil to use system setting.

     Example:
     ```swift
     .JMModal(showModal: $showModal, for: [.camera])
         .setColorScheme(.dark)  // Always show in dark mode
     ```
     */

    @inlinable func setColorScheme(_ colorScheme: ColorScheme?) -> some CustomizableView {
        store.configStore.colorSchemeOverride = colorScheme
        return self
    }
}

