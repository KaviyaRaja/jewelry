//
//  OTPVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class OTPVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mFirstTF: CustomFontTextField!
    @IBOutlet weak var mSecondTF: CustomFontTextField!
    @IBOutlet weak var mThirdTF: CustomFontTextField!
    @IBOutlet weak var mFouthTF: CustomFontTextField!
    @IBOutlet weak var mSubmitbtn: UIButton!
    var otp : String! = ""
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
        
        self.mSubmitbtn.layer.cornerRadius = 5.0

        self.mFirstTF.delegate = self
        self.mSecondTF.delegate = self
        self.mThirdTF.delegate = self
        self.mFouthTF.delegate = self
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        //self.mFirstTF.addBorder()
        //self.mSecondTF.addBorder()
        //elf.mThirdTF.addBorder()
        //self.mFouthTF.addBorder()
        //getOTP()
        
        // Do any additional setup after loading the view.
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - API
    func getOTP()
    {
        
        SKActivityIndicator.show("Loading...")
        let parameters  =
            [
                "email_or_mobile" :self.email ?? ""
                
                
        ]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/forgetpassword/forgotpassword", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "error"){
                    
                    self.view.makeToast( response["message"] as? String)
                    
                }
                else{
                    
                    if  (response["status"] as? String == "success"){
                        self.view.makeToast(response["message"] as? String)

                    }
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }
        
       

        
    }
    
    func verifyOTP()
    {
        
        let otpStr = self.otp

        SKActivityIndicator.show("Loading...")
         let parameters : Parameters =
            [
                "email_or_mobile" : self.email ?? "",
                "otp" : otpStr ?? ""
        ]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/forgetpassword/verifyotp", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "error"){
                    
                    self.view.makeToast( response["message"] as? String)
                    
                }
                else{
                    
                    if  (response["status"] as? String == "success"){
                        
                        self.next()
                        
                    }
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }
    }
      // MARK:- Btn Action
    @IBAction func verifyBtnAction(_ sender: Any)
    {
        self.mFirstTF.resignFirstResponder()
        self.mSecondTF.resignFirstResponder()
        self.mThirdTF.resignFirstResponder()
        self.mFouthTF.resignFirstResponder()
        let totalStr = String(format : "%@%@%@%@",self.mFirstTF.text!,self.mSecondTF.text!,self.mThirdTF.text!,self.mFouthTF.text!)
        self.otp = totalStr
        if(totalStr == "")
        {
            self.view .makeToast("Please enter OTP")
            return
        }
//        else if(totalStr != self.otp)
//        {
//            self.view .makeToast("Please enter correct OTP")
//            return
//        }
        else
        {
            verifyOTP()
        }
    }
    
   
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func resendBtnAction(_ sender: Any)
    {
        getOTP()
    }
    func next()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        vc.email = self.email
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK:- Textfield
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            // This allows numeric text only, but also backspace for deletes
            if string.count > 0 && !Scanner(string: string).scanInt32(nil) {
                return false
            }
            if Int(range.location) > 0 {
                return false
            }
            if (textField.text?.count ?? 0) == 0 {
                // perform(Selector(changeTextFieldFocus:), with: textField, afterDelay: 0)
                perform(#selector(changeTextFieldFocus), with: textField, afterDelay: 0)
            }
            
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                perform(#selector(keyboardInputShouldDelete), with: textField, afterDelay: 0)
                print("Backspace was pressed")
            }
            //perform(Selector(("secureTextField:")), with: textField, afterDelay: 0)
            //        NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
            //        return !(proposedNewString.length>1);
            return true
        }
    }
    @objc func changeTextFieldFocus(toNextTextField textField: UITextField?) {
        let tagValue: Int = (textField?.tag ?? 0) + 1
        let txtField = view.viewWithTag(tagValue) as? UITextField
        //let value = textField?.text
        if textField?.tag == 101 {
            
        } else if textField?.tag == 102 {
            
        } else if textField?.tag == 103 {
            
        } else if textField?.tag == 104 {
            
        }
        
        txtField?.becomeFirstResponder()
    }
    
    
    
    @objc func keyboardInputShouldDelete(_ textField: UITextField?) -> Bool {
        let shouldDelete = true
        if (textField?.text?.count ?? 0) == 0 && (textField?.text == "") {
            let tagValue: Int = (textField?.tag ?? 0) - 1
            let txtField = view.viewWithTag(tagValue) as? UITextField
            if textField?.tag == 101 {
                
            } else if textField?.tag == 102 {
                
            } else if textField?.tag == 103 {
                
            } else if textField?.tag == 104 {
                
            }
            txtField?.becomeFirstResponder()
        }
        return shouldDelete
    }
    
    func secureTextField(_ txtView: UITextField?) {
        txtView?.isSecureTextEntry = true
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
