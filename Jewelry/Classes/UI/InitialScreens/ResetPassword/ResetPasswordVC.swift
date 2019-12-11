//
//  ResetPasswordVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mNewPasswordTF: CustomFontTextField!
    @IBOutlet weak var mConfirmPasswordTF: CustomFontTextField!
    @IBOutlet weak var mSubmitbtn: UIButton!
    @IBOutlet weak var mEyeButton: UIButton!
    @IBOutlet weak var mEyeButton1: UIButton!
     @IBOutlet weak var mEyeImageView: UIImageView!
    @IBOutlet weak var mEye1ImageView: UIImageView!
    var email : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *){
                     let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                     statusBar.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
                     UIApplication.shared.keyWindow?.addSubview(statusBar)
                 }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
        }
        
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        
       
        mNewPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        mNewPasswordTF.layer.borderWidth = 1.0
        
        mConfirmPasswordTF.layer.borderColor = UIColor.lightGray.cgColor
        mConfirmPasswordTF.layer.borderWidth = 1.0
        
        self.mSubmitbtn.layer.cornerRadius = 5.0
        
//        self.mNewPasswordTF.addBorder()
//        self.mNewPasswordTF.setLeftPaddingPoints(10)
//        self.mConfirmPasswordTF.addBorder()
//        self.mConfirmPasswordTF.setLeftPaddingPoints(10)
        
       // self.mEyeButton.isSelected = true
        self.mNewPasswordTF.isSecureTextEntry = true
        
       // self.mEyeButton1.isSelected = true
        self.mConfirmPasswordTF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if(self.mNewPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter New Password")
            return
        }
        if(self.mConfirmPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Confirm Password")
            return
        }
        if(self.mNewPasswordTF.text != self.mConfirmPasswordTF.text)
        {
            self.view.makeToast("New Password and Confirm Password should be same")
            return
        }
        resetPassword()
    }
    
    @IBAction func showPasswordBtnAction(_ sender: Any)
    {
        if((sender as AnyObject).tag == 100)
        {
            if(self.mEyeButton.isSelected)
            {
                self.mEyeButton.isSelected = false
                self.mNewPasswordTF.isSecureTextEntry = false
                self.mEyeImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mEyeButton.isSelected = true
                self.mNewPasswordTF.isSecureTextEntry = true
                self.mEyeImageView.image = UIImage(named: "HidePass")
            }
        }
        else
        {
            if(self.mEyeButton1.isSelected)
            {
                self.mEyeButton1.isSelected = false
                self.mConfirmPasswordTF.isSecureTextEntry = false
                self.mEye1ImageView.image = UIImage(named: "Showpass")
            }
            else{
                self.mEyeButton1.isSelected = true
                self.mConfirmPasswordTF.isSecureTextEntry = true
                self.mEye1ImageView.image = UIImage(named: "HidePass")
            }
        }
    }
    // MARK: - API
    func resetPassword()
    {
        
        SKActivityIndicator.show("Loading...")
        let parameters  =
            [
                "email_or_mobile" : self.email ?? "",
                "new_password" : self.mNewPasswordTF.text ?? "",
                "confirm_password" : self.mConfirmPasswordTF.text ?? ""
                
        ]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/forgetpassword/forgotpassword", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "failure"){
                    
                    self.view.makeToast( response["message"] as? String)
                    
                }
                    
                else  if  (response["status"] as? String == "error"){
                    
                    self.view.makeToast( response["message"] as? String)
                    
                }
                    
                    
                else{
                    
                    if  (response["status"] as? String == "success"){
                        
                        for controller: UIViewController in (self.navigationController?.viewControllers)! {
                            if (controller is SignInVC) {
                                self.navigationController?.popToViewController(controller, animated: false)
                                break
                            }
                        }
                        
                    }
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }

        
    }
  
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
