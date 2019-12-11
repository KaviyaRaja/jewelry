//
//  CompletePaymentVC.swift
//  Nisagra
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CompletePaymentVC: UIViewController {

    @IBOutlet weak var mCardNumberLabel: CustomFontLabel!
    @IBOutlet weak var mOTPTF: CustomFontTextField!
    @IBOutlet weak var mNameLabel : CustomFontLabel!
    @IBOutlet weak var mDateLabel : CustomFontLabel!
    @IBOutlet weak var mTotalLabel : CustomFontLabel!
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
        self.mOTPTF.addBorder()
        self.mOTPTF.setLeftPaddingPoints(10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.screenType = "FAQ"
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        
    }

    @IBAction func resendBtnAction(_ sender: Any) {
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
