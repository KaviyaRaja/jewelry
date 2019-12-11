//
//  CheckOutVC.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

class CheckOutVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var mDeliveyDayLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryInstructionLabel: CustomFontLabel!
    @IBOutlet weak var mAddressLabel: CustomFontLabel!
    @IBOutlet weak var mApartmentLabel: CustomFontLabel!
    @IBOutlet weak var mNumberLabel: CustomFontLabel!
    @IBOutlet weak var mNameLabel: CustomFontLabel!
    @IBOutlet weak var mApproximateLabel: CustomFontLabel!
    @IBOutlet weak var mTotalSavingsLabel: CustomFontLabel!
    @IBOutlet weak var mCartValueLabel: CustomFontLabel!
    @IBOutlet weak var mDeliveryValueLabel: CustomFontLabel!
    @IBOutlet weak var mTotalSaving: CustomFontLabel!
    @IBOutlet weak var mFullPayRadioBtn: CustomFontButton!
    @IBOutlet weak var mAdvancePayRadioBtn: CustomFontButton!
    @IBOutlet weak var mCheckoutTableView: UITableView!
    @IBOutlet weak var mBalancePayableView: UIView!
    @IBOutlet weak var mfullapaymentView: UIView!
    @IBOutlet weak var mAdvanceapaymentView: UIView!
    @IBOutlet weak var mBalancePayableLbl: CustomFontLabel!
    @IBOutlet weak var mAdvancePayLbl: CustomFontLabel!
    @IBOutlet weak var mFullPaymentLbl: CustomFontLabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
//    var shipping_firstname = ""
//    var shipping_lastname = ""
//    var total : String = ""
//    var shipping_city : String = ""
//    var shipping_zone : String = ""
//    var shipping_country : String = ""
    var telephone = ""
    var data_total : String = ""
    var result : String = ""
    var address : String = ""
    var totalpayable = String()
    var totalArray : NSArray!
    var full_payment : String = ""
    var advance_payment : String = ""
    var shipping_address_1 : String = ""
    var ShippingArray : NSArray!
    var resultArray : NSArray!
    var StateIDArray : NSArray!
    let itemsArray : NSArray = []
    var selectedpaymenttype = Int()
    var paymenttype = Int()
    var amountPayable = String()
    var firstname = String()
    var lastname = String()
    var emailid =  String()
    var number = String()
    var type : String!
    var shopnow : String!
    var OrderID : String!
     @IBOutlet weak var tableHeight: NSLayoutConstraint!
    //let cellReuseIdentifier = "cell"
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
   // self.mCheckoutTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    mCheckoutTableView.register(UINib(nibName: "CheckoutCell", bundle: .main), forCellReuseIdentifier: "CheckoutCell")
    mCheckoutTableView.delegate = self
    mCheckoutTableView.dataSource = self
    
    
    self.tableHeight.constant = CGFloat(self.ShippingArray.count * 44)
     self.mCheckoutTableView.reloadData()
    
    
    let dict = self.resultArray[0] as? NSDictionary
    //let statedict = self.StateIDArray[0] as? NSDictionary
    print("array:",resultArray)
    

    self.mNameLabel.text = String(format:"%@%@",(dict!["shipping_firstname"] as? String)!,(dict!["shipping_lastname"] as? String)!)
        self.mNumberLabel.text = String(format:"%@",(dict!["telephone"] as? String)!)
    self.mAddressLabel.text = String(format:"%@,%@,%@,%@,%@",(dict!["shipping_address_1"] as? String)!,(dict!["shipping_city"] as? String)!,(dict!["shipping_zone"] as? String)!,(dict!["shipping_country"] as? String)!,(dict!["shipping_postcode"] as? String)!)
    let rupee = "\u{20B9}"
//    let price = String(format: "%.2f",  Double(dict!["full_payment"] as! String)!)
//    cell.priceLabel.text = rupee + String(price)
    if let fullPayment = (dict?["full_payment"] as? NSString)?.doubleValue {
        // here, totalfup is a Double
        
        
        
        self.mFullPaymentLbl.text = rupee + String(format:"%.2f",fullPayment)
        
    }
    if let advance = (dict?["advance_payment"] as? NSString)?.doubleValue {
        // here, totalfup is a Double
        
        self.mAdvancePayLbl.text =  rupee + String(format:"%.2f",advance)
        
    }
    let fullPayment = (dict?["full_payment"] as? NSString)?.doubleValue
    let advance = (dict?["advance_payment"] as? NSString)?.doubleValue
    var full_payment = String(format:"%.2f",fullPayment!).floatValue
    var advance_payment = String(format:"%.2f",advance!).floatValue
    
    
    self.mBalancePayableLbl.text = rupee + String(format:"%.2f",full_payment - advance_payment)
    
//    let mBalancePayableLbl = (dict!["full_payment"] as? AnyObject)-(dict!["advance_payment"] as? AnyObject)
//    self.mBalancePayableLbl = String(format:"%@",((dict!["full_payment"] as? AnyObject)- (dict!["advance_payment"] as? AnyObject)
   
    
         self.contentHeight.constant = 550 + self.tableHeight.constant
    self.mfullapaymentView.layer.shadowColor = UIColor.darkGray.cgColor
    self.mfullapaymentView.layer.shadowOffset = CGSize(width: 1, height:3)
    self.mfullapaymentView.layer.shadowOpacity = 0.6
    self.mfullapaymentView.layer.shadowRadius = 3.0
    self.mfullapaymentView.layer.cornerRadius = 5.0
    
    self.mAdvanceapaymentView.layer.shadowColor = UIColor.darkGray.cgColor
    self.mAdvanceapaymentView.layer.shadowOffset = CGSize(width: 1, height:3)
    self.mAdvanceapaymentView.layer.shadowOpacity = 0.6
    self.mAdvanceapaymentView.layer.shadowRadius = 3.0
    self.mAdvanceapaymentView.layer.cornerRadius = 5.0
    self.mBalancePayableView.isHidden = true
//        setData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
               self.mFullPayRadioBtn.setImage(UIImage(named: "RadioButton_gold"), for: .normal)
               mFullPayRadioBtn.isSelected = true
               mAdvancePayRadioBtn.isSelected = false
               self.mAdvancePayRadioBtn.setImage(UIImage(named: "UncheckRadioButton_gold"), for: .normal)
               self.mBalancePayableView.isHidden = true
               selectedpaymenttype = 2
               let dict = self.resultArray[0] as? NSDictionary
               //amountPayable = (mFullPaymentLbl.text! as NSString) as String
               let fullPayment = (dict?["full_payment"] as? NSString)?.doubleValue
               let advance = (dict?["advance_payment"] as? NSString)?.doubleValue
               var full_payment = String(format:"%.2f",fullPayment!).floatValue
               var advance_payment = String(format:"%.2f",advance!).floatValue
               
               amountPayable = String(format:"%.2f",full_payment)
               //String(format:"₹%@",(self.dataDict["delivery_charges"] as? String)!)
           }
    
        
        func setData()
   {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            self.mNameLabel.text =  String(format:"%@",(dataDict["shipping_firstname"] as? String)!,(dataDict["shipping_lastname"] as? String)!)
            self.mNumberLabel.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
           // self.mAddressLabel.text = dataDict["shipping_address_1"] as? String
            self.mAddressLabel.text = String(format:"%@,%@,%@,%@,%@",(dataDict["shipping_address_1"] as? String)!,(dataDict["shipping_city"] as? String)!,(dataDict["shipping_zone"] as? String)!,(dataDict["shipping_country"] as? String)!,
                (dataDict["shipping_postcode"] as? String)!,
                (dataDict["name"] as? String)!)
            self.mFullPaymentLbl.text =  String(format:"₹%@",(dataDict["full_payment"] as? String)!)
            self.mAdvancePayLbl.text =  String(format:"₹%@",(dataDict["advance_payment"] as? String)!)
        }
            //(dataDict["address_1"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
                //self.mAddressLabel.text = self.address
         //   self.mDeliveyDayLabel.text = UserDefaults.standard.string(forKey: "DeliveryDate")

          //  self.mDeliveryInstructionLabel.text = UserDefaults.standard.string(forKey: "DeliveryInstruction")
        
        }
    @objc func setShippingData()
    {
         //setData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mFullBtnAction(_ sender: Any) {
        
        if(self.mFullPayRadioBtn.isSelected == true)
        {
        self.mFullPayRadioBtn.setImage(UIImage(named: "UncheckRadioButton_gold"), for: .normal)
            mFullPayRadioBtn.isSelected = false
            self.mBalancePayableView.isHidden = true
            
        }
       else
        
        {
            self.mFullPayRadioBtn.setImage(UIImage(named: "RadioButton_gold"), for: .normal)
            mFullPayRadioBtn.isSelected = true
            mAdvancePayRadioBtn.isSelected = false
            self.mAdvancePayRadioBtn.setImage(UIImage(named: "UncheckRadioButton_gold"), for: .normal)
            self.mBalancePayableView.isHidden = true
            selectedpaymenttype = 2
            let dict = self.resultArray[0] as? NSDictionary
            //amountPayable = (mFullPaymentLbl.text! as NSString) as String
            let fullPayment = (dict?["full_payment"] as? NSString)?.doubleValue
            let advance = (dict?["advance_payment"] as? NSString)?.doubleValue
            var full_payment = String(format:"%.2f",fullPayment!).floatValue
            var advance_payment = String(format:"%.2f",advance!).floatValue
            
            amountPayable = String(format:"%.2f",full_payment)
            //String(format:"₹%@",(self.dataDict["delivery_charges"] as? String)!)
        }
    }
    @IBAction func mAdvanceBtnAction(_ sender: Any) {
        if(self.mAdvancePayRadioBtn.isSelected == true)
        {
            self.mAdvancePayRadioBtn.setImage(UIImage(named: "UncheckRadioButton_gold"), for: .normal)
            mAdvancePayRadioBtn.isSelected = false
            self.mBalancePayableView.isHidden = true
            
        }
        else
            
        {
            self.mAdvancePayRadioBtn.setImage(UIImage(named: "RadioButton_gold"), for: .normal)
            mAdvancePayRadioBtn.isSelected = true
            mFullPayRadioBtn.isSelected = false
            self.mFullPayRadioBtn.setImage(UIImage(named: "UncheckRadioButton_gold"), for: .normal)
            self.mBalancePayableView.isHidden = false
            selectedpaymenttype = 1
            let dict = self.resultArray[0] as? NSDictionary
            
            let fullPayment = (dict?["full_payment"] as? NSString)?.doubleValue
            let advance = (dict?["advance_payment"] as? NSString)?.doubleValue
            var full_payment = String(format:"%.2f",fullPayment!).floatValue
            var advance_payment = String(format:"%.2f",advance!).floatValue
          
           amountPayable =  String(format:"%.2f",advance_payment)
        }
    }
    // MARK: - Navigation
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.screenType = "FAQ"
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        if(self.type == "shopnow")  
        {
            buybackbutton()
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func PayNowBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutPayNowVC") as! CheckOutPayNowVC
//       myVC.paymenttype = selectedpaymenttype
        //let dict = resultArray[0] as! [String:Any]
        
        firstname = (mNameLabel.text! as NSString) as String
        number = (mNumberLabel.text! as NSString) as String
        
        //emailid = String(format:"%@",(dict["email"] as? String)!)
        
        myVC.totalPriceAmount = amountPayable
        
        //myVC.totalPayableAmount = totalpayable
        
        //myVC.orderID = dict["order_id"] as? String
        myVC.shippingfirstname = firstname
        myVC.email = emailid
        myVC.telephone = number
        myVC.resultArray = self.resultArray
        self.navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func editBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as? ShippingVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    
    //func orderAddApi()
//    {
//
//        SKActivityIndicator.show("Loading...")
//        let Url = String(format: "%@checkout/shipping_addressbuynow/checkoutDetail",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        print(Url)
//        let date =  UserDefaults.standard.string(forKey: "DeliveryDay")
//        let parameters: Parameters =
//            [
//                "delivery_date" : date ?? "",
//                ]
//        print(parameters)
//        let headers: HTTPHeaders =
//            [
//                "Content-Type": "application/json"
//        ]
//        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseJSON { response in
//                print(response)
//                SKActivityIndicator.dismiss()
//                switch(response.result) {
//
//                case .success:
//                    if let json = response.result.value
//                    {
//                        let JSON = json as! NSDictionary
//                        print(JSON)
//                        if(JSON["status"] as? String == "success")
//                        {
//                            let responseArray =  JSON["data"] as? NSArray
//                            let dict = responseArray![0] as! NSDictionary
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let myVC = storyboard.instantiateViewController(withIdentifier: "ConfirmationVC") as? ConfirmationVC
//                            myVC?.dataDict = dict
//                            self.navigationController?.pushViewController(myVC!, animated: true)
//                        }
//                        else
//                        {
//                            self.view.makeToast(JSON["message"] as? String)
//                        }
//                    }
//                    break
//
//                case .failure(let error):
//                    print(error)
//                    break
//
//                }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.ShippingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CheckoutCell =  mCheckoutTableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
     // self.itemsArray = (JSON["data_total"] as? NSArray)!
        var dict = self.ShippingArray[indexPath.row] as? NSDictionary
       let rupee = "\u{20B9}"
        cell.mpriceTitleLabel.text = dict!["title"] as? String
        let amountlabel = (dict!["value"] as? NSString)?.doubleValue
        cell.mpriceAmountLabel.text =  rupee + String(format:"%.2f",amountlabel!)
        //cell.mpriceAmountLabel.text = String(format : "₹%@",(dict!["value"] as? String)!)
        for i in 0..<ShippingArray.count {
            var dict = self.ShippingArray[i] as! [String:Any]
            if (dict["title"] as! String == "Bag Value")
            {
            //UserDefaults.standard.setValue(dict["value"] as? String, forKey: "value")
                
                let myFloat = (dict["value"] as! NSString).floatValue

               UserDefaults.standard.set(myFloat, forKey: "value")
            }
        //let ShippingArray = JSON!["data_total"] as? [[String:Any]]
        //var dict = self.ShippingArray[indexPath.row] as? NSDictionary
        
    
}
        return cell
    }
    func buybackbutton()
    {
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/updateBuyNowStatustInCart",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //    let OrderID =  UserDefaults.standard.string(forKey: "order_id")
        //    let ShippingCountryID = UserDefaults.standard.string(forKey: "shipping_country_id")
        //    let ShippingZoneID = UserDefaults.standard.string(forKey: "shipping_zone_id")
        //    let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //    let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        
        let parameters: Parameters =
            [
                
                "customer_id" : userID ?? "",
                ]
        print(parameters)
        let headers: HTTPHeaders =
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
                        }
                        else
                        {
                            
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
    }


}
