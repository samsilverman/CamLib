//
//  ViewController.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/18/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import UIKit
import TesseractOCR

class MainMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraButtonLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var generateButtonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disables camera button if device does not have a camera.
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            cameraButton.isEnabled = false
            cameraButton.alpha = 0.25
            cameraButtonLabel.alpha = 0.25
        }
        
        // Disables generate button at startup since no image is selected.
        generateButton.isEnabled = false
        generateButton.alpha = 0.25
        generateButtonLabel.alpha = 0.25
    }
    
    // Checks if generate button should be enabled everytime UI is refreshed.
    override func viewDidAppear(_ animated: Bool) {
        if imageView.image == nil {
            generateButton.isEnabled = false
            generateButton.alpha = 0.25
            generateButtonLabel.alpha = 0.25
        }
        else {
            generateButton.isEnabled = true
            generateButton.alpha = 1.0
            generateButtonLabel.alpha = 1.0
        }
    }
    
    // Opens camera if camera button is selected.
    @IBAction func openCamera(_ sender: UIButton) {
        pickMediaFromSource(UIImagePickerController.SourceType.camera)
    }
    
    // Opens photo library if library button is selected.
    @IBAction func openLibrary(_ sender: UIButton) {
        pickMediaFromSource(UIImagePickerController.SourceType.photoLibrary)
    }
    
    // Creates and presents UIImagePickerController for desired type (camera or photo library).
    @objc func pickMediaFromSource(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // Dismisses current UIIMagePickerController if cancel is selected and returns to root viewController.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Extract chosen image.
        let chosenImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // Remove previous paths & image
        imageView.image = nil
        
        // Place photo inside imageView.
        imageView.image = chosenImage
        
        // Dismiss the picker to return to original view controller.
        dismiss(animated: true, completion: nil)
    }
    
    func scaleAndOrient(image: UIImage) -> UIImage {
        
        // Set a default value for limiting image size.
        let maxResolution: CGFloat = 640
        
        guard let cgImage = image.cgImage else {
            print("UIImage has no CGImage backing it!")
            return image
        }
        
        // Compute parameters for transform.
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        var transform = CGAffineTransform.identity
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if width > maxResolution ||
            height > maxResolution {
            let ratio = width / height
            if width > height {
                bounds.size.width = maxResolution
                bounds.size.height = round(maxResolution / ratio)
            } else {
                bounds.size.width = round(maxResolution * ratio)
                bounds.size.height = maxResolution
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let orientation = image.imageOrientation
        switch orientation {
        case .up:
            transform = .identity
        case .down:
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
        case .left:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
        case .upMirrored:
            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
        case .leftMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
        }
        
        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
            let context = rendererContext.cgContext
            
            if orientation == .right || orientation == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            context.concatenate(transform)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    }
    
    func generateInformation() -> String {
        var output = ""
        print("----Start of text recognition----")
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.image = scaleAndOrient(image: imageView.image!).g8_blackAndWhite()
            tesseract.recognize()
            if let text = tesseract.recognizedText, !text.isEmpty {
                output = text
            }
        }
        print(output)
        print("----End of text recognition----")
        return output
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress)%")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Generate Info" {
            let foundText = generateInformation().trimmingCharacters(in: .whitespacesAndNewlines)
            let searcher = OpenLibrarySearcher()
            if let vc = segue.destination as? BookTableViewController {
                vc.books = searcher.searchForBookDataa(query: foundText)
            }
        }
    }
}
