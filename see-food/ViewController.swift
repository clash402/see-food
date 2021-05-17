//
//  ViewController.swift
//  see-food
//
//  Created by Josh Courtney on 5/17/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePickerVC = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .camera
        imagePickerVC.allowsEditing = false
    }

    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        do {
            let model = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError()
                }
                
                if let firstResult = results.first {
                    if firstResult.identifier.contains("hotdog") {
                        self.navigationItem.title = "Hotdog!"
                    } else {
                        self.navigationItem.title = "Not hotdog :("
                    }
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
}

extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError()
            }
            
            detect(image: ciImage)
        }
        
        imagePickerVC.dismiss(animated: true, completion: nil)
    }
}
