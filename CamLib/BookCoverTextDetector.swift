//
//  BookCoverTextDetector.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/19/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import Foundation
import UIKit
import Vision

class BookCoverTextDetector {
    
//    var bookCover: UIImage
//
//    init(bookCover: UIImage) {
//        self.bookCover = bookCover
//    }
//
//    /// - Tag: PreprocessImage to make orientation upright for Vision algorithms (from Apple)
//    private func scaleAndOrient(image: UIImage) -> UIImage {
//        // Set a default value for limiting image size.
//        let maxResolution: CGFloat = 640
//
//        guard let cgImage = image.cgImage else {
//            print("UIImage has no CGImage backing it!")
//            return image
//        }
//
//        // Compute parameters for transform.
//        let width = CGFloat(cgImage.width)
//        let height = CGFloat(cgImage.height)
//        var transform = CGAffineTransform.identity
//
//        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
//
//        if width > maxResolution ||
//            height > maxResolution {
//            let ratio = width / height
//            if width > height {
//                bounds.size.width = maxResolution
//                bounds.size.height = round(maxResolution / ratio)
//            } else {
//                bounds.size.width = round(maxResolution * ratio)
//                bounds.size.height = maxResolution
//            }
//        }
//
//        let scaleRatio = bounds.size.width / width
//        let orientation = image.imageOrientation
//        switch orientation {
//        case .up:
//            transform = .identity
//        case .down:
//            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
//        case .left:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
//        case .right:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
//        case .upMirrored:
//            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
//        case .downMirrored:
//            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
//        case .leftMirrored:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
//        case .rightMirrored:
//            let boundsHeight = bounds.size.height
//            bounds.size.height = bounds.size.width
//            bounds.size.width = boundsHeight
//            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
//        }
//
//        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
//            let context = rendererContext.cgContext
//
//            if orientation == .right || orientation == .left {
//                context.scaleBy(x: -scaleRatio, y: scaleRatio)
//                context.translateBy(x: -height, y: 0)
//            } else {
//                context.scaleBy(x: scaleRatio, y: -scaleRatio)
//                context.translateBy(x: 0, y: -height)
//            }
//            context.concatenate(transform)
//            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//        }
//    }
//
//    private func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
//        let requests = createVisionRequests()
//        let imageRequestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try imageRequestHandler.perform(requests)
//            } catch let error as NSError {
//                print("Failed to perform image request: \(error)")
//                self.presentAlert("Image Request Failed", error: error)
//                return
//            }
//        }
//    }
//
//    fileprivate func createVisionRequests() -> [VNRequest] {
//        // Create an array to collect all desired requests.
//        var requests: [VNRequest] = []
//        requests.append(self.textDetectionRequest)
//        // Return grouped requests as a single array.
//        return requests
//    }
//
//    fileprivate func handleDetectedText(request: VNRequest?, error: Error?) {
//        if let nsError = error as NSError? {
//            self.presentAlert("Text Detection Error", error: nsError)
//            return
//        }
//        // Perform drawing on the main thread.
//        DispatchQueue.main.async {
//            guard let drawLayer = self.pathLayer,
//                let results = request?.results as? [VNTextObservation] else {
//                    return
//            }
//            self.draw(text: results, onImageWithBounds: drawLayer.bounds)
//            drawLayer.setNeedsDisplay()
//        }
//    }
//
//    lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
//        let textDetectRequest = VNDetectTextRectanglesRequest(completionHandler: self.handleDetectedText)
//        // Tell Vision to report bounding box around each character.
//        textDetectRequest.reportCharacterBoxes = true
//        return textDetectRequest
//    }()
//
//}
//
//// Converst UIImageOrientation to CGImageOrientation for use in Vision analysis (from Apple)
//extension CGImagePropertyOrientation {
//    init(_ uiImageOrientation: UIImage.Orientation) {
//        switch uiImageOrientation {
//        case .up: self = .up
//        case .down: self = .down
//        case .left: self = .left
//        case .right: self = .right
//        case .upMirrored: self = .upMirrored
//        case .downMirrored: self = .downMirrored
//        case .leftMirrored: self = .leftMirrored
//        case .rightMirrored: self = .rightMirrored
//        }
//    }
}
