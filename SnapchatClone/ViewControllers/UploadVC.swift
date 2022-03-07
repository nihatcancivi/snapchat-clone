//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Nihat on 4.03.2022.
//

import UIKit
import Firebase

class UploadVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadImageView.isUserInteractionEnabled = true
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadImageView.addGestureRecognizer(imageRecognizer)
    }
    

    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            //database
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else
                                if snapshot?.isEmpty == false && snapshot != nil{//daha önce snapi varsa
                                    for document in snapshot!.documents {
                                        let documentId = document.documentID
                                        if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                            imageUrlArray.append(imageUrl!)
                                            let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                            firestore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { error in
                                                if error == nil {
                                                    self.tabBarController?.selectedIndex = 0
                                                    self.uploadImageView.image = UIImage(named: "selectPhoto")
                                                }
                                            }
                                        }
                                    }
                                    
                                }else{
                                    //daha önce bir snapi yoksa
                                    let snapDictionary = ["imageUrlArray" : [imageUrl!],"snapOwner" : UserSingleton.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String : Any]
                                    firestore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                        if error != nil {
                                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                        }else{
                                            self.tabBarController?.selectedIndex = 0
                                            self.uploadImageView.image = UIImage(named: "selectPhoto")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @objc func chooseImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    func makeAlert(titleInput : String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
