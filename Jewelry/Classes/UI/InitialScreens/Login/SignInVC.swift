//
//  SignInVC.swift
//  Nisarga
//
//  Created by Hari Krish on 18/09/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView


class SignInVC: UIViewController {
    @IBOutlet var mSignInView: UIView!
    @IBOutlet var mPasswordView: UIView!
    @IBOutlet var mUserIdTF: CustomFontTextField!
    @IBOutlet var mPasswordTF: CustomFontTextField!
    @IBOutlet var mForgetPasswordBtn: CustomFontTextField!
    @IBOutlet var mSignInBtn: CustomFontButton!
    @IBOutlet var mSignUpBtn: CustomFontButton!
    @IBOutlet var mRememberBtn: CustomFontButton!

    var isLogin: Bool = true
    //var isEmail : Bool = true
    //var imagePicker = UIImagePickerController()
    
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
         mSignInView.layer.borderColor = UIColor.lightGray.cgColor
         mSignInView.layer.borderWidth = 1.0
        
        mPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        mPasswordView.layer.borderWidth = 1.0
        
        self.mSignInBtn.layer.cornerRadius = 5.0
        
        //loginNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isRememberMe =  UserDefaults.standard.string(forKey: "isRememberMe")
        if(isRememberMe == "1"){

            self.mRememberBtn.isSelected = true
            mRememberBtn.setBackgroundImage(UIImage(named: "CheckBox"), for: UIControlState.normal)
            self.mUserIdTF.text = UserDefaults.standard.string(forKey: "user")


        }

    }
    
//    func rememberme()
//    {
//        if(self.isLogin)
//        {
//            //self.mSignInBtn.text = "Log In to Continue"
//            self.mRememberBtn.isSelected = false
//            self.mRememberBtn.setImage(UIImage(named: "UncheckboxGray"), for: .normal)
//            let isRememberMe =  UserDefaults.standard.string(forKey: "isRememberMe")
//            if(isRememberMe == "1")
//            {
//                self.mRememberBtn.isSelected = true
//                self.mRememberBtn .setImage(UIImage(named: "CheckBox"), for: .normal)
//                self.mUserIdTF.text = UserDefaults.standard.string(forKey: "user")
//                self.mPasswordTF.text = UserDefaults.standard.string(forKey: "password")
//            }
//            
//            if(mRememberBtn.isSelected == true)
//            {
//                UserDefaults.standard.setValue("1", forKey: "isRememberMe")
//                UserDefaults.standard.setValue(self.mUserIdTF.text, forKey: "user")
//                UserDefaults.standard.setValue(self.mPasswordTF.text, forKey: "password")
//            }
//        }
//    }

    
    @IBAction func mSignInBtnAction(_ sender: UIButton)
    {
        
        if(self.mUserIdTF.text == "")
        {
            self.view.makeToast("Please Enter User Id")
            return
        }
        
        if(self.mPasswordTF.text == "")
        {
            self.view.makeToast("Please Enter Password")
            return
        }
      
        loginApi()
        
        
      
    }
    @IBAction func mRememberBtnAction(_ sender: Any) {
        
        if (mRememberBtn.isSelected == true)
        {
            mRememberBtn.setBackgroundImage(UIImage(named: "UncheckboxGray"), for: UIControlState.normal)
            
            //  self.mRememberBtn .setImage(UIImage(named: "CheckBox"), for: .n"ormal)
            self.mUserIdTF.text = ""
            self.mPasswordTF.text = ""
            
            
            mRememberBtn.isSelected = false
        }
        else
        {
            mRememberBtn.setBackgroundImage(UIImage(named: "CheckBox"), for: UIControlState.normal)
            
            let isRememberMe =  UserDefaults.standard.string(forKey: "isRememberMe")
            if(isRememberMe == "1")
            {
                self.mRememberBtn.isSelected = true
                //  self.mRememberBtn .setImage(UIImage(named: "CheckBox"), for: .normal)
                self.mUserIdTF.text = UserDefaults.standard.string(forKey: "user")
                
            }
            
            mRememberBtn.isSelected = true
        }
        self.isLogin = true
       // rememberme()
    }
    @IBAction func mSignUpBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func mForgetPasswordBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func loginNavigation()
    {
        if(mRememberBtn.isSelected == true)
        {
            //UserDefaults.standard.setValue("1", forKey: "isRememberMe") ?? ""
             self.mUserIdTF.text =  UserDefaults.standard.string(forKey: "user") ?? ""
//            self.mPasswordTF.text =  UserDefaults.standard.string(forKey: "password") ?? ""
            
        }
        
    }
    func loginApi()
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
                "user" : self.mUserIdTF.text ?? "",
                "password" : self.mPasswordTF.text ?? "",
                
            ]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/login", withParam: parameters) { (isSuccess, response) in
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
                        
//                        self.isLogin = true
//                        self.mUserIdTF.text = ""
//                        self.mPasswordTF.text = ""
//                        self.mRememberBtn.isSelected = true
//                        self.mRememberBtn .setImage(UIImage(named: "mRememberBtn"), for: .normal)
//                        self.rememberme()
//
                       /* "customer_id": "70",
                        "firstname": "jewelry",
                        "lastname": "user",
                        "email": "jewelry@gmail.com",
                        "cart": null,
                        "wishlist": null,
                        "telephone": "1234512345",
                        "api_token": "ba2726dcefa17ccbb49810eacd"
                        */
                        
                        
                        
                        self.view.makeToast("Succesfully Created The Account")
                        
                        let responseArray =  response["data"] as? NSArray
                        let dict = responseArray![0] as! NSDictionary
                        UserDefaults.standard.setValue(dict["customer_id"] as? String, forKey: "customer_id")
                        UserDefaults.standard.setValue(dict["api_token"] as? String, forKey: "api_token")
                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: dict), forKey: "UserData")
                        NotificationCenter.default.post(name: NSNotification.Name("REFRESHSIDEMENU"), object: nil)
                        
                        UserDefaults.standard.setValue("1", forKey: "isLoggedin")
                        UserDefaults.standard.setValue("1", forKey: "isLoggedin")
                        if(self.mRememberBtn.isSelected == true)
                        {
                            UserDefaults.standard.setValue("1", forKey: "isRememberMe")
                            UserDefaults.standard.setValue(self.mUserIdTF.text, forKey: "user")
//                            UserDefaults.standard.setValue(self.mPasswordTF.text, forKey: "password")
                        }
                        if(self.mRememberBtn.isSelected == false)
                        {
                            UserDefaults.standard.setValue("0", forKey: "isRememberMe")
                            UserDefaults.standard.setValue("", forKey: "user")
                           // UserDefaults.standard.setValue("", forKey: "password")
                        }
                        self.mUserIdTF.text = ""
                        self.mPasswordTF.text = ""
                        self.mRememberBtn.isSelected = true
                        self.mRememberBtn.setBackgroundImage(UIImage(named: "UncheckboxGray"), for: UIControlState.normal)

                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
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
