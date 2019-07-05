//
//  ViewController.swift
//  SeeFood
//
//  Created by Michael Arakilian on 7/4/19.
//  Copyright © 2019 Michael Arakilian. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let apiKey = "your-ibm-watson-visual-recognition-api-key"
    let version = "2019-07-04"
    var classificationResults : [String] = []
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topBarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            // call watson
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            let imageData = image.jpegData(compressionQuality: 0.01)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("tmpImage.jpg")
            try? imageData?.write(to: fileURL, options: [])

            visualRecognition.classify(imagesFile: imageData) { response, error in
                if let error = error {
                    print(error)
                }
                if let response = response {
                    let classes = response.result!.images.first!.classifiers.first!.classes
                    self.classificationResults = []
                    for index in 0..<classes.count {
                        self.classificationResults.append(classes[index].className)
                    }
                    DispatchQueue.main.async {
                        self.cameraButton.isEnabled = true
                        SVProgressHUD.dismiss()
                    }
                    
                    if(self.classificationResults.contains("food")) {
                        for index in 0..<classes.count {
                            if(classes[index].className == "food") {
                                if(classes[index].score >= 0.8) {
                                    DispatchQueue.main.sync {
                                        self.navigationItem.title = "Consume!"
                                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                                        self.navigationController?.navigationBar.isTranslucent = false
                                    }
                                }
                                else {
                                    DispatchQueue.main.sync {
                                        self.navigationItem.title = "Risky!?"
                                        self.navigationController?.navigationBar.barTintColor = UIColor.orange
                                        self.navigationController?.navigationBar.isTranslucent = false
                                    }
                                }
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.sync {
                            self.navigationItem.title = "Dont Consume!"
                            self.navigationController?.navigationBar.barTintColor = UIColor.red
                            self.navigationController?.navigationBar.isTranslucent = false
                        }
                    }
                    
                    
                }
            }
        } else {
            print("There was an error picking the image")
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

}

