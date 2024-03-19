//
//  YXBDocumentPickerPresenter.swift
//  TempTest
//
//  Created by yangxiaobin on 2024/2/7.
//

import UIKit
import MobileCoreServices

@objc public protocol YXBDocumentPickerPresenterDelegate {
    func documentPickerPresenter(_ presenter: YXBDocumentPickerPresenter, didPickDocumentsAt url: URL)
    func documentPickerPresenterWasCancelled(_ presenter: YXBDocumentPickerPresenter)
}

/// YXBDocumentPickerPresenter presents a controller that provides access to documents or destinations outside the app’s sandbox.
/// Internally presents a UIDocumentPickerViewController in UIDocumentPickerMode.import.
/// Note: You must turn on the iCloud Documents capabilities in Xcode
/// (see https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/DocumentPickerProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40014451)
@objcMembers
public class YXBDocumentPickerPresenter: NSObject {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private weak var presentingViewController: UIViewController?
    
    // MARK: Public
    
    public weak var delegate: YXBDocumentPickerPresenterDelegate?
    
    public var isPresenting: Bool {
        return self.presentingViewController?.parent != nil
    }
    
    // MARK: - Public
    
    /// Presents a document picker view controller modally.
    ///
    /// - Parameters:
    ///   - allowedUTIs: Allowed pickable file UTIs.
    ///   - viewController: The view controller on which to present the document picker.
    ///   - animated: Indicate true to animate.
    ///   - completion: Animation completion.
    public func presentDocumentPicker(with allowedUTIs: [YXBUTI], from viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let documentTypes = allowedUTIs.map { return $0.rawValue }
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: animated, completion: completion)
        self.presentingViewController = viewController
    }
}

// MARK - UIDocumentPickerDelegate
extension YXBDocumentPickerPresenter: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        self.delegate?.documentPickerPresenter(self, didPickDocumentsAt: url)
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.delegate?.documentPickerPresenterWasCancelled(self)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.delegate?.documentPickerPresenter(self, didPickDocumentsAt: url)
    }
}
