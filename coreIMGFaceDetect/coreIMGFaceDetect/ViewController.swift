//
//  ViewController.swift
//  coreIMGFaceDetect
//
//  Created by Krishna Kushwaha on 12/12/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func detect(_ sender: UIButton) {
        
        detectFaces()

        }
    
    func detectFaces() {
        let faceImage = CIImage(image: imageView.image!)
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let faces = faceDetector?.features(in: faceImage!) as! [CIFaceFeature]
        print("Number of faces: \(faces.count)")
        let transformScale = CGAffineTransform(scaleX: 1, y: -1)
            let transform = transformScale.translatedBy(x: 0, y: -faceImage!.extent.height)
        
        for face in faces {
                var faceBounds = face.bounds.applying(transform)
                let imageViewSize = imageView.bounds.size
                let scale = min(imageViewSize.width / faceImage!.extent.width,
                                imageViewSize.height / faceImage!.extent.height)
                
                let dx = (imageViewSize.width - faceImage!.extent.width * scale) / 2
                let dy = (imageViewSize.height - faceImage!.extent.height * scale) / 2
                
                faceBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
                faceBounds.origin.x += dx
                faceBounds.origin.y += dy
                
                let box = UIView(frame: faceBounds)
                box.layer.borderColor = UIColor.red.cgColor
                box.layer.borderWidth = 2
                box.backgroundColor = UIColor.clear
                imageView.addSubview(box)
            }
    }

}

