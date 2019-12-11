//
//  ForgotPasswordVC.swift
//  Nisarga
//
//  Created by Hari Krish on 03/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var mBackImageView: UIImageView!
    @IBOutlet weak var mEmailTF : CustomFontTextField!
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

        // Do any additional setup after loading the view.
        mBackImageView.image = mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        mBackImageView.tintColor = UIColor.black
        
        self.mEmailTF.addBorder()
        self.mEmailTF.setLeftPaddingPoints(10)
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
        if(self.mEmailTF.text == "")
        {
            self.view.makeToast("Please Enter Mobile Number/Email Id")
            return
        }
        getOTP()
    }
    @IBAction func resendBtnAction(_ sender: Any)
    {
        self.getOTP()
        
    }
    
    @IBAction func mSignUpBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    // MARK: - API
    func getOTP()
    {
        
        SKActivityIndicator.show("Loading...")
        let parameters  =
            [
                "email_or_mobile" :self.mEmailTF.text ?? ""

                
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
                     
                        self.view.makeToast(response["message"] as? String)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let myVC = storyboard.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC
                        myVC?.email = self.mEmailTF.text
                        self.navigationController?.pushViewController(myVC!, animated: false)
                        
                        
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
