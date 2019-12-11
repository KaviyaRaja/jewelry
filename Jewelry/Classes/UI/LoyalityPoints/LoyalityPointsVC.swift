//
//  LoyalityPointsVC.swift
//  Nisagra
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class LoyalityPointsVC: UIViewController {
    
    
    @IBOutlet weak var mTableView: UITableView!

    @IBOutlet weak var mPointsTF: CustomFontLabel!
    @IBOutlet weak var mAmountTF: CustomFontTextField!
    @IBOutlet weak var mamount: CustomFontLabel!
    @IBOutlet weak var mnote: CustomFontLabel!
    @IBOutlet weak var loyalitynoteHeight: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    
   var dataArray : NSArray = []
    var dict = [String:Any]()
    
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
        
         getLoyalityPoints()
        
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
//    @IBAction func proceedBtnAction(_ sender: Any)
//    {
//        if(self.mAmountTF.text == "")
//        {
//            self.view.makeToast("Please Enter Redeem Amount")
//            return
//        }
//        reedeemPoints()
//    }
    // MARK: - TableView
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
//        if cell == nil {
//            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
//        }
//        cell?.textLabel?.text = "Lorem Ipsum is simply dummy text of the printing  and typesetting industry"
//        cell?.textLabel?.font = UIFont(name: Constants.FONTNAME as String, size: 14)!
//        cell?.textLabel?.textColor = UIColor.darkGray
//        cell?.textLabel?.numberOfLines = 0
//        return cell!
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        
//    }
//    
    // MARK:- API
    func getLoyalityPoints()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/reward/mywallet",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? ""
        ]
        print (parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SKActivityIndicator.dismiss()
            print(response)
            switch(response.result) {
                
            case .success:
                if let json = response.result.value
                {
                    let JSON = json as! NSDictionary
                    print(JSON)
                    
                    if(JSON["status"] as? String == "success")
                    {
                        let dataArray = JSON["data1"] as! [[String:Any]]
                        print("dataArray",dataArray)
                        self.dict = dataArray[0]
                        let rupee = "\u{20B9}"
                        self.mPointsTF.text = (self.dict["loyalitypoints"] as? String)! + " points"
                        self.mamount.text =  rupee + (self.dict["loyalitypoints"] as? String)!
                        self.mnote.text = """
                        1.  Loyality points awarded on purchase of any product can be redeemed in next order
                        
                        2.Loyality points will be  automatically redeemed if it is equal to or more than 100.
                        
                        3.  Maximum  20%  of the total amount can br redeemed using the loyalty points.
                        """
//                      if(balance == "0")
//                {
//                self.mPointsTF.text = "0 points"
//                }
//                else
//               {
//                self.mPointsTF.text = String(format:"₹%@", balance!)
//               }
                        
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
    }
//    func reedeemPoints()
//    {
//        SKActivityIndicator.show("Loading...")
//        let Url = String(format: "%@api/customer/redeemLoyaltyPoints",Constants.BASEURL)
//        print(Url)
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        let parameters: Parameters =
//        [
//            "customer_id" : userID ?? "",
//            "points" : self.mAmountTF.text ?? ""
//        ]
//        print (parameters)
//        let headers: HTTPHeaders =
//            [
//                "Content-Type": "application/json"
//        ]
//        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            SKActivityIndicator.dismiss()
//            print(response)
//            switch(response.result) {
//
//            case .success:
//                if let json = response.result.value
//                {
//                    let JSON = json as! NSDictionary
//                    print(JSON)
//                    if(JSON["status"] as? String == "success")
//                    {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let myVC = storyboard.instantiateViewController(withIdentifier: "RedemptionSuccessfullVC") as? RedemptionSuccessfullVC
//                        self.navigationController?.pushViewController(myVC!, animated: true)
//                    }
//                    else
//                    {
//                        self.view.makeToast(JSON["message"] as? String)
//                    }
//                }
//                break
//
//            case .failure(let error):
//                print(error)
//                break
//
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
