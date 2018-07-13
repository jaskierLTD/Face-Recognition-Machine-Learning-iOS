//
//  CaptureController.swift
//  Social H.
//
//  Created by Oleksandr Zheliezniak on 08/04/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreML
import CoreImage
import AVFoundation

class CaptureController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //let mlModel = PersonalityTypeClassifierTest()
    let mlModel = MoneyClassifier_3_0()
    
    var importButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Import", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
        btn.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.90)
        btn.layer.cornerRadius = btn.bounds.height/2
        btn.tag = 0
        return btn
    }()
    
    var previewImg:UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        img.contentMode = .scaleAspectFit
        img.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
        return img
    }()
    
    var descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.text = "No Image Content"
        lbl.frame = CGRect(x: 0, y: 0, width: 350, height: 200)
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 5
        lbl.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
        return lbl
    }()

    var imageChanged = false

    @IBOutlet weak var CaptureView: UIImageView!
    @IBAction func cancelButton(_ sender: Any)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "PersonDetailNav") as UIViewController
        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func saveButton(_ sender: Any)
    {
        // There is no image
        if imageChanged == false
        {
            let alertController = UIAlertController(title: "NO photo/NOT recognized", message: "Please SELECT or CREATE a new photo", preferredStyle: UIAlertControllerStyle.alert)
            
            let ConfirmAction = UIAlertAction(title: "FIX IT!", style: UIAlertActionStyle.destructive)
            {
                (result : UIAlertAction) -> Void in
            }
            
            alertController.addAction(ConfirmAction)
            self.present(alertController, animated: true, completion: nil)
        }
            
        else
        {
            // image filled - all is okay!
            let alertController = UIAlertController(title: "Success!", message: "Your photo has been successfuly recognized", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "CONTINUE", style: UIAlertActionStyle.default)
            {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            
            let prevVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as! DetailedViewController
            prevVC.transferedImage = CaptureView.image
            navigationController?.pushViewController(prevVC, animated: true)
            
            self.present(alertController, animated: true, completion: nil)
            
            imageChanged = false
        }
        //testing , delete after
        //let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        //let compressedJPGImage = UIImage(data: imageData!)
        //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imageChanged = false
        importButton.addTarget(self, action: #selector(importFromCameraRoll), for: .touchUpInside)
        self.view.addSubview(previewImg)
        self.view.addSubview(descriptionLbl)
        self.view.addSubview(importButton)
    }
    
    @objc func importFromCameraRoll()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            previewImg.image = image
            if let buffer = image.buffer(with: CGSize(width:227, height:227))
            {
                guard let prediction = try? mlModel.prediction(image: buffer) else {fatalError("Unexpected runtime error")}
                descriptionLbl.text = prediction.moneyType
                /*descriptionLbl.text = prediction.personalityType

                switch descriptionLbl.text
                {
                case "Entp":
                    descriptionLbl.text = descriptionLbl.text! + ": Intuitive-Logical Extratim - (The Inventor)"
                case "Isfp":
                    descriptionLbl.text = descriptionLbl.text! + ": Sensory-Ethical Intratim -  (The Peacemaker)"
                case "Esfj":
                    descriptionLbl.text = descriptionLbl.text! + " Ethical-Sensory Extratim -  (The Enthusiast)"
                case "Intj":
                    descriptionLbl.text = descriptionLbl.text! + " Logical-Intuitive Intratim -  (The Analyst)"
                case "Enfj":
                    descriptionLbl.text = descriptionLbl.text! + " Ethical-Intuitive Extratim -  (The Actor)"
                case "Istj":
                    descriptionLbl.text = descriptionLbl.text! + " Logical-Sensory Intratim -  (The Pragmatist)"
                case "Estp":
                    descriptionLbl.text = descriptionLbl.text! + " Sensory-Logical Extratim -  (The Conqueror)"
                case "Infp":
                    descriptionLbl.text = descriptionLbl.text! + " Intuitive-Ethical Intratim -  (The Romantic)"
                case "Esfp":
                    descriptionLbl.text = descriptionLbl.text! + " Sensory-Ethical Extratim - ESFp (The Ambassador)"
                case "Intp":
                    descriptionLbl.text = descriptionLbl.text! + " Intuitive-Logical Intratim -  (The Observer)"
                case "Entj":
                    descriptionLbl.text = descriptionLbl.text! + " Logical-Intuitive Extratim -  (The Pioneer)"
                case "Isfj":
                    descriptionLbl.text = descriptionLbl.text! + " Ethical-Sensory Intratim -  (The Guardian)"
                case "Estj":
                    descriptionLbl.text = descriptionLbl.text! + " Logical-Sensory Extratim -  (The Director)"
                case "Infj":
                    descriptionLbl.text = descriptionLbl.text! + " Ethical-Intuitive Intratim -  (The Empath)"
                case "Enfp":
                    descriptionLbl.text = descriptionLbl.text! + " Intuitive-Ethical Extratim -  (The Reporter)"
                case "Istp":
                    descriptionLbl.text = descriptionLbl.text! + " Sensory-Logical Intratim -  (The Artisan)"
                default:
                    print("There is not type, please contact: jaskierLTD@gmail.com")
                }
                print(prediction.personalityTypeProbability)
                descriptionLbl.text = descriptionLbl.text! + "."*/
                print(prediction.moneyTypeProbability)
            }else
            {
                print("failed buffer")
            }
        }
        dismiss(animated:true, completion: nil)
    }
}
