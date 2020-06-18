//
//  ViewController.swift
//  meme_V1
//
//  Created by Sarah Al-Matawah on 03/06/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    
    var tableVC = MemeTableViewController()
    var collectionVC = MemeCollectionViewController()
    
    //AppDelegate to access shared properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //components properties
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    //nab and tool bar properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //boolean properties
    var isTopEditied = false
    var isBottonEditied = false
    
    //final meme properties
    var memedImage = UIImage()
    
    //text field attributes properties
    let memeTextFieldAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor:UIColor.black,
        .foregroundColor:UIColor.white,
        .font:UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth:-4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting textfield attribues and values
        setInitalTextfields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Disable share button and text fields
        enableComponent(false)
        shareBtn.isEnabled = false
        topTextField.isEnabled = false
        bottomTextField.isEnabled = false
        //Disable camera button if resource is unavaliable
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    //MARK: Enable Buttons and Testfield
    
    func enableComponent(_ isEnable: Bool){
        shareBtn.isEnabled = isEnable
        topTextField.isEnabled = isEnable
        bottomTextField.isEnabled = isEnable
    }
    
    //MARK: Text Field Delegates
    
    //Setting values and attribues for top and bottom text fields
    func setInitalTextfields(){
        memeTextFieldAttributeSetter(topTextField, "TOP")
        memeTextFieldAttributeSetter(bottomTextField, "BOTTOM")
    }
    
    //Text field attributes setter
    func memeTextFieldAttributeSetter(_ textField: UITextField,_ defaultTitle: String){
        textField.defaultTextAttributes = memeTextFieldAttributes
        textField.delegate = self
        textField.text = defaultTitle
        textField.textAlignment = .center
    }
    
    //When return is tapped on keyboard, keyboard is closed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //when beginning to edit textfields, the inital text is cleared
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == topTextField && !isTopEditied{
            textField.text = ""
            isTopEditied = true
        } else if textField == bottomTextField{
            //Subscription to keyboard observation when bottom textfield is selected
            keyboardNotificationSubscription()
            if !isBottonEditied {
                textField.text = ""
                isBottonEditied = true
            }
        }
    }
    
    //when ending edit textfields, the inital text is re-added if it is empty
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == topTextField && textField.text == ""{
            textField.text = "TOP"
            isTopEditied = false
        } else if textField == bottomTextField{
            //Unsubscription to keyboard observation when ending edit on bottom textfield
            keyboardNotificationUnsubscription()
            if textField.text == "" {
                textField.text = "BOTTOM"
                isBottonEditied = false
            }
        }
    }
    
    //MARK: Selecting and Retriving an Image to be Memed
    
    //Taking a picture with camera or selecting picture from photo library
    @IBAction func takeOrSelectPicture(_ sender: Any){
        let senderBtn = sender as? UIBarButtonItem
        let selectImage = UIImagePickerController()
        selectImage.delegate = self
        //Checks which toolbar itemBtn was clicked
        if senderBtn?.tag == 0{
            selectImage.sourceType = .camera
        } else if senderBtn?.tag == 1{
            selectImage.sourceType = .photoLibrary
        }
        
        present(selectImage, animated: true, completion: nil)
    }
    
    //setting the selected/taken image to the imageView and closing the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        memeImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        //Enable share button
        enableComponent(true)
    }
    
    //MARK: Sharing and canceling Meme
    
    //Sharing the Memed image using activity view controller
    @IBAction func shareMemeAction(_ sender: Any) {
        memedImage = generateMemedImage()
        let shareActivity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareActivity.completionWithItemsHandler = { (activity, completed, _, error) in
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error.debugDescription)
            }
        }
        present(shareActivity, animated: true, completion: nil)
    }
    
    //Canceling current meme and returning to sent meme view
    @IBAction func cancelResetMeme(_ sender: Any) {
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    //MARK: Generating and Saving Memed Image
    
    //Saving memed image in-app
    func saveMeme(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImage.image!, memedImage: memedImage)
        //save Meme to shared meme property
        appDelegate.sharedMeme.append(meme)
    }
    
    //Creating the memed image
    func generateMemedImage() -> UIImage {
        //Hide toolbar and navbar
        self.toolBar.isHidden = true
        self.navigationBar.isHidden = true

        // Creating memed image from view elements
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let createdMemedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //Show toolbar and navbar
        self.toolBar.isHidden = false
        self.navigationBar.isHidden = false

        return createdMemedImage
    }
    
    
    //MARK: Keyboard Show/Hide function
    
    //move view above keyboard when is is shown
    @objc func keyboardWillShow(_ notification: Notification){
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    //return view to original position when keyboard is hidden
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    //retrieve keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    //setting keyboard observers for showing and hiding keyboard
    func keyboardNotificationSubscription(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //removing keyboard observation
    func keyboardNotificationUnsubscription(){
        NotificationCenter.default.removeObserver(self)
    }

}

//MARK: Structure (Meme)

struct Meme{
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}



