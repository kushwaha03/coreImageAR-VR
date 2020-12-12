//
//  ImageViewController.swift
//  visionTotalFace
//
//  Created by Krishna Kushwaha on 12/12/20.
//

import UIKit
import Vision
class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var ShowImg: UIImageView!
    lazy var faceDetectionRequest =
      VNDetectFaceRectanglesRequest(completionHandler: self.onFacesDetected)
    
    let resultsLayer = CALayer()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowImg.layer.addSublayer(resultsLayer)

 
        
        
    }
    func onFacesDetected(request: VNRequest, error: Error?) {
      guard let results = request.results as? [VNFaceObservation] else {
        return
      }
      
      for result in results {
        print("Found face at \(result.boundingBox)")
      }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photolibrary", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        
        guard let image = info[.originalImage] as? UIImage else {
             return
           }
           
            ShowImg.image = image
        detectFaces(on: image)

           dismiss(animated: true)


        
        
    }
    func detectFaces(on image: UIImage) {
      let handler = VNImageRequestHandler(
        cgImage: image.cgImage!,
        options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
          do {
            try handler.perform([self.faceDetectionRequest])
          } catch {
            print(error)
          }
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIImageView {
  var contentClippingRect: CGRect {
    guard let image = image else { return bounds }
    guard contentMode == .scaleAspectFit else { return bounds }
    guard image.size.width > 0 && image.size.height > 0 else { return bounds }
    
    let scale: CGFloat
    if image.size.width > image.size.height {
      scale = bounds.width / image.size.width
    } else {
      scale = bounds.height / image.size.height
    }
    
    let size = CGSize(
      width: image.size.width * scale,
      height: image.size.height * scale)
    let x = (bounds.width - size.width) / 2.0
    let y = (bounds.height - size.height) / 2.0
    
    return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
}
