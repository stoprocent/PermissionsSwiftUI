//
//  ContinueButtonTexts.swift
//
//
//  Created by Claude Code on 1/24/26.
//

import Foundation

/// Text configuration for continue button states in carousel flow
@available(iOS 13.0, tvOS 13.0, *)
public struct ContinueButtonTexts: Equatable {

    /// Text shown before carousel starts (default: "Continue")
    public var continueText: String

    /// Text shown during carousel processing (default: "Processing...")
    public var processingText: String

    /// Text shown after carousel completes (default: "Done")
    public var doneText: String

    /// Creates continue button texts with default localized values
    public init() {
        self.continueText = "button_continue"
        self.processingText = "button_processing"
        self.doneText = "button_done"
    }

    /// Creates continue button texts with custom values
    ///
    /// - Parameters:
    ///   - continueText: Text for initial state
    ///   - processingText: Text during carousel
    ///   - doneText: Text after carousel completes
    public init(
        continueText: String,
        processingText: String,
        doneText: String
    ) {
        self.continueText = continueText
        self.processingText = processingText
        self.doneText = doneText
    }
}
