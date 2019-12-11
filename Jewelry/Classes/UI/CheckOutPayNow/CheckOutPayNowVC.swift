//
//  CheckOutPayNowVC.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView

class CheckOutPayNowVC: UIViewController {

    
    @IBOutlet weak var memailLabel: CustomFontLabel!
    
    
    @IBOutlet weak var mNumberLabel: CustomFontLabel!
    
    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mTotalLabel: CustomFontLabel!
    @IBOutlet weak var paynowview : UIView!
    var orderID : String!
    var resultArray : NSArray!
    var isNisargaSelected : String = ""
    var transactionId : String = ""
    var status : String = ""
    var selectedpaymenttype = Int()
    var amountPayable = String()
    var shippingfirstname = String()
    var shippinglastname = Int()
    var email = String()
    var telephone = String()
    var totalPriceAmount = String()
    var totalPayableAmount = String()
    var totalpayable = String()
    var paymenttype = Int()
    
    
    
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
        
        self.paynowview.layer.shadowColor = UIColor.lightGray.cgColor
        self.paynowview.layer.shadowOffset = CGSize(width: 1, height:3)
        self.paynowview.layer.shadowOpacity = 0.6
        self.paynowview.layer.shadowRadius = 3.0
        self.paynowview.layer.cornerRadius = 5.0
        //self.paynowview.layer.borderColor = UIColor.lightGray.cgColor
        self.paynowview.layer.borderWidth = 1.0
       
        self.mNameLabel.text = shippingfirstname
        self.memailLabel.text = email
        self.mNumberLabel.text = telephone
        let rupee = "\u{20B9}"
        self.mTotalLabel.text = rupee + totalPriceAmount  
        //totalPriceAmount = String(format:"₹%@",(mTotalLabel.text! as NSString))
        
        
         let dict = self.resultArray[0] as? NSDictionary
        // Do any additional setup after loading the view.
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            self.memailLabel.text =  String(format:"%@",(dataDict["email"] as? String)!)
        }
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - API
    
    
    
// MARK: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.screenType = "FAQ"
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func payNowBtnAction(_ sender: Any)
    {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "PayUVC") as? PayUVC
        
        
        
        myVC?.paymenttype = selectedpaymenttype
        myVC?.amountPayable = totalPriceAmount
        let dict = resultArray[0] as! [String:Any]
        myVC?.orderid = dict["order_id"] as? String
        //let Dict = self.addressArray[0] as? NSDictionary
        // UserDefaults.standard.setValue(Dict["order_id"] as? String, forKey: "order_id")
        self.navigationController?.pushViewController(myVC!, animated: true)
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
