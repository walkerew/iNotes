//
//  NoteViewController.swift
//  iNotes
//
//  Created by Emily Walker on 12/4/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import UIKit
import FirebaseMLVision

class NoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note!
    var imagePicker = UIImagePickerController()
    var imageToConvert: UIImage!
    var textRecognizer: VisionTextRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if note == nil {
            note = Note()
        }
        updateUserInterface()
        
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        
    }
    
    func updateUserInterface() {
        // update attributes of detailVC with data pulled from segue
        if note.title != nil {
            titleTextField.text = note.title
        }
        if note.body != "" {
            noteTextView.text = note.body
        }
    }
    
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { (features, error) in
            self.processResult(from: features, error: error)
        }
    }
    
    func processResult(from text: VisionText?, error: Error?) {
        
    }
    
    func convertImageToText() {
        runTextRecognition(with: imageToConvert)
    }
    
    func cameraOrLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessLibrary()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        alertController.addAction(photoLibraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
        cameraOrLibraryAlert()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            print("******* cancel from add mode")
            dismiss(animated: true, completion: nil)
        } else {
            print("&&&&&&&& cancel from show")
            navigationController!.popViewController(animated: true)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromNoteSave" {
            print("preparing for unwind")
            note.title = titleTextField.text
        }
    }
}

extension NoteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageToConvert = selectedImage
        // Now that we've got the image we can close the UIImagePicker using the dismiss method
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera available on this device.")
        }
    }
}

