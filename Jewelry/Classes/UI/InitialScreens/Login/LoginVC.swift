 //  LoginVC.swift
//  Nisagra
//
//  Created by Suganya on 7/31/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import Foundation

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func addBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
}
extension String {
    var isDigits: Bool {
        guard !self.isEmpty else { return false }
        return !self.contains { Int(String($0)) == nil }
    }
}
class LoginVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IQDropDownTextFieldDelegate {


    
    @IBOutlet weak var mSelectBtn: UIButton!
    @IBOutlet weak var mFirstnameTF: CustomFontTextField!
     @IBOutlet weak var mLastnameTF: CustomFontTextField!
     @IBOutlet weak var mEmailTF: CustomFontTextField!
     @IBOutlet weak var mMobileTF: CustomFontTextField!
     @IBOutlet weak var mPasswordTF: CustomFontTextField!
    @IBOutlet weak var mSignUpbtn : CustomFontButton!
    @IBOutlet weak var mReferralCheckBox: CustomFontButton!
    @IBOutlet weak var mSignInbtn : CustomFontButton!
    @IBOutlet weak var mReferralTF: CustomFontTextField!
    @IBOutlet weak var mLastnameView: UIView!
    @IBOutlet weak var mFirstnameView: UIView!
    @IBOutlet weak var mEmailView: UIView!
    @IBOutlet weak var mMobileView: UIView!
    @IBOutlet weak var mPasswordView: UIView!
   
    var isLogin: Bool = true
    var isEmail : Bool = true
    var imagePicker = UIImagePickerController()
    var imageUrl : String = "0"
    

    var area : String = ""

    var apartmentArray = [String]()
    var apartmentIdArray : NSArray = []
    var count = 0

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
        
        mFirstnameView.layer.borderColor = UIColor.lightGray.cgColor
        mFirstnameView.layer.borderWidth = 1.0
        
        mLastnameView.layer.borderColor = UIColor.lightGray.cgColor
        mLastnameView.layer.borderWidth = 1.0
        
        mEmailView.layer.borderColor = UIColor.lightGray.cgColor
        mEmailView.layer.borderWidth = 1.0
        
        mMobileView.layer.borderColor = UIColor.lightGray.cgColor
        mMobileView.layer.borderWidth = 1.0
        
        mPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        mPasswordView.layer.borderWidth = 1.0
        
        
        self.mSignUpbtn.layer.cornerRadius = 5.0
        self.mReferralCheckBox.setImage(UIImage(named: "UncheckboxGray"), for: .normal)
        mReferralCheckBox.isSelected = false
        self.mReferralTF.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setUI()
    }
    func setUI()
    {
        
    }
//    func rememberme()
//    {
//        if(self.isLogin)
//        {
//            //self.mSignInBtn.text = "Log In to Continue"
//            self.mReferralCheckBox.isSelected = false
//            self.mReferralCheckBox.setImage(UIImage(named: "UncheckboxGray"), for: .normal)
//            self.mReferralTF.isHidden = true
//            let isReferralCheckBox =  UserDefaults.standard.string(forKey: "isReferralCheckBox")
//            if(isReferralCheckBox == "1")
//            {
//                self.mReferralCheckBox.isSelected = true
//                self.mReferralCheckBox .setImage(UIImage(named: "CheckBox"), for: .normal)
//
//            }
//
//            if(mReferralCheckBox.isSelected == true)
//            {
//                UserDefaults.standard.setValue("1", forKey: "isReferralCheckBox")
//                self.mReferralTF.isHidden = true
//
//            }
//        }
//    }
 //MARK: - Button Actions
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        signupValidations()
        
        
    }
    
    @IBAction func ReferralBtnAction(_ sender: Any) {
        if(self.mReferralCheckBox.isSelected == true)
        {
            self.mReferralCheckBox.setImage(UIImage(named: "UncheckboxGray"), for: .normal)
            mReferralCheckBox.isSelected = false
            self.mReferralTF.isHidden = true
           //self.mReferralCheckBox.isSelected == false
        }
        else

        {
            
            self.mReferralCheckBox.setImage(UIImage(named: "CheckBox"), for: .normal)
            
            self.mReferralTF.isHidden = false
             mReferralCheckBox.isSelected = true
        }
        }
        
    
    
    @IBAction func mSignInBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
   //@IBAction func loginBtnAction(_ sender: Any)
   //{
       // self.isLogin = true
       //setUI()
  //}
//  @IBAction func signupBtnAction(_ sender: Any)
//   {      self.ismSignIn = false
//      setUI()
//    }
//    
    
   //
//
//    @IBAction func goBtnAction(_ sender: Any)
//    {
//
//        if(self.isLogin)
//        {
//            self.loginValidations()
//        }
//        else
//        {
//            self.signupValidations()
//        }
//
//       // self.next()
//    }
//    func loginValidations()
//    {
//        if(self.mEmailIdTF.text == "")
//        {
//            self.view.makeToast("Please Enter Mobile Number/Email Id")
//            return
//        }
//        else if((self.mEmailIdTF.text?.count)! > 0)
//        {
//            let letters = CharacterSet.letters
//            let phrase = self.mEmailIdTF.text
//            let range = phrase?.rangeOfCharacter(from: letters)
//            // range will be nil if no letters is found
//            if let test = range {
//                print("letters found")
//                self.isEmail = self.isValidEmail(emailStr: self.mEmailIdTF.text!)
//                if(self.isEmail == false)
//                {
//                    self.view.makeToast("Please Enter valid EmailID")
//                    return
//                }
//            }
//            else {
//                print("letters not found")
//                self.isEmail = false
//                if((self.mEmailIdTF.text?.count)! < 10)
//                {
//                    self.view.makeToast("Please Enter valid Mobile Number")
//                    return
//                }
//            }
//        }
//        if(self.mPasswordTF.text == "")
//        {
//            self.view.makeToast("Please Enter Password")
//            return
//        }
//        self.mEmailIdTF.resignFirstResponder()
//        self.mPasswordTF.resignFirstResponder()
//        self.loginAPI()
//    }
    func signupValidations()
    {
        if(self.mFirstnameTF.text == "")
        {
            self.view.makeToast("Please Enter First Name")
            return
        }

        if(self.mLastnameTF.text == "")
        {
            self.view.makeToast("Please Enter Last Name")
            return
        }
        else if((self.mMobileTF.text?.count)! != 10)
        {
            self.view.makeToast("Please Enter valid Mobile Number")
            return
        }
        if(self.mEmailTF.text == "")
        {
            self.view.makeToast("Please Enter EmailID")
            return
        }
        else if (self.isValidEmail(emailStr: self.mEmailTF.text!) == false)
        {
            self.view.makeToast("Please Enter valid EmailID")
            return
        }
        if(self.mPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Password")
            return
        }
       
        self.signupAPI()
    }
//    func next()
//    {
//        UserDefaults.standard.setValue("1", forKey: "isLoggedin")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    func loginNavigation()
//    {
//        if(mSelectBtn.isSelected == true)
//        {
//            UserDefaults.standard.setValue("1", forKey: "isRememberMe")
//            UserDefaults.standard.setValue(self.mEmailIdTF.text, forKey: "LoginEmail")
//            UserDefaults.standard.setValue(self.mPasswordTF.text, forKey: "LoginPassword")
//        }
//        self.next()
//    }
//    // MARK: - Textfield Delegates
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        if(textField == self.mMobileNoTF)
//        {
//            if(range.location > 9)
//            {
//                return false
//            }
//        }
//        return true
//    }
//
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
//     // MARK: - API
    
 
    
    
    
    
    
    

    func signupAPI()
    {
        
       /*
        "firstname" : "Rithin",
        "lastname" : "Kp",
        "email" : "rithin@gmail.com",
        "mobile" : "9535980054",
        "password" : "123456"
    */
        
        SKActivityIndicator.show("Loading...")
        let parameters  =
        [
            "firstname" : self.mFirstnameTF.text ?? "",
            "lastname" : self.mLastnameTF.text ?? "",
            "mobile" : self.mMobileTF.text ?? "",
            "email" : self.mEmailTF.text ?? "",
            "password" : self.mPasswordTF.text ?? "",
            "referal_code" : ""
            
        ]
        
        SKActivityIndicator.dismiss()

        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/customer/register", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()

            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                if  (response["status"] as? String == "success"){
                    
                    
                    self.view.makeToast("Succesfully Created The Account")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                
               
                    
                    
                    
                    
                else {
                    
                   
                        
                        self.view.makeToast( response["message"] as? String)
                        
                    
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")

            }
            
        }
        
        
        
        
        
        
        
        
 /*      let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {

                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                             self.view.makeToast(JSON["message"] as? String)
                            self.isLogin = true
                            self.mEmailIdTF.text = ""
                            self.mPasswordTF.text = ""
                            self.mSelectBtn.isSelected = false
                            self.mSelectBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
                            self.setUI()
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break

                case .failure(let error):
                    print(error)
                    break

                }
        }
    }*/


 }
 }
