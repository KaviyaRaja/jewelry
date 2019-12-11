//
//  ShippingVC.swift
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

class ShippingVC: UIViewController,IQDropDownTextFieldDelegate, IQDropDownTextFieldDataSource {

    @IBOutlet weak var mCityTF: CustomFontTextField!
    @IBOutlet weak var mInstructionTF: CustomFontTextField!
    @IBOutlet weak var mNumberTF: CustomFontTextField!
    @IBOutlet weak var mNameTF: CustomFontTextField!
    @IBOutlet weak var AddressTF: CustomFontTextField!
    @IBOutlet weak var mCountryTF: CustomFontTextField!
    @IBOutlet weak var mPincodeTF: CustomFontTextField!
    @IBOutlet weak var mStateTF: IQDropDownTextField!
    
    
    
    var deliveryDate : String!
    var addressDict : NSDictionary!
    var count = 0
    var total : String!
    var StateIDArray : NSArray = []
    var ShippingArray : NSArray = []
    var resultArray : NSArray = []
    var addressArray : NSArray = []
    var responseDict : NSDictionary!
    var StateArray = [String]()
    var total_savings : String!
    var total_payable : String!
    var delivery_charge : String = ""
    var address : String = ""
    var type : String!
    var shopnow : String!
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
        
        
        
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            addressDict = dataDict
            //self.mApartmentLabel.text =  String(format:"%@",(dataDict["company"] as? String)!)
////            self.mNameTF.text =  String(format:"%@,%@",(dataDict["firstname"] as? String)!,(dataDict["lastname"] as? String)!)
////           self.mNumberTF.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
////            self.AddressTF.text =  String(format:"%@,%@,%@,%@,%@,%@",(dataDict["block"] as? String)!,(dataDict["floor"] as? String)!,(dataDict["door"] as? String)!,(dataDict["address_1"] as? String)!,(dataDict["city"] as? String)!,(dataDict["postcode"] as? String)!)
//            self.mNameTF.text = String(format:"%@ %@",(dict!["shipping_firstname"] as? String)!,(dict!["shipping_lastname"] as? String)!)
//            self.mNumberTF.text = String(format:"%@",(dict!["telephone"] as? String)!)
//            self.AddressTF.text = String(format:"%@ %@ %@",(dict!["shipping_city"] as? String)!,(dict!["shipping_zone"] as? String)!,(dict!["shipping_country"] as? String)!,(dict!["shipping_postcode"] as? String)!)

        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setData), name: NSNotification.Name("RefreshshippingAddress"), object: nil)
       // count = 0
       previousAddress()
       //editshipping()
        getstate()
        setData()
    }
    @objc func setData()
    {
        var dataDict : NSDictionary = [:]
        var data = UserDefaults.standard.object(forKey: "ShippingAddress") as? Data
        if let aData = data {
            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
            print(dataDict)
            addressDict = dataDict
            self.mNameTF.text =  String(format:"%@%@",(dataDict["shipping_firstname"] as? String)!,(dataDict["shipping_lastname"] as? String)!)
            self.mNumberTF.text =  String(format:"%@",(dataDict["telephone"] as? String)!)
            self.AddressTF.text = String(format:"%@",(dataDict["shipping_address_1"] as? String)!)
            self.mCityTF.text = String(format:"%@",(dataDict["shipping_city"] as? String)!)
            self.mCountryTF.text = String(format:"%@",(dataDict["shipping_country"] as? String)!)
            self.mPincodeTF.text = String(format:"%@",(dataDict["shipping_postcode"] as? String)!)
            self.mStateTF.selectedItem = String(format:"%@",(dataDict["name"] as? String)!)

        }
   }
    // MARK: - Btn Action
    @IBAction func backActionBtn(_ sender: UIButton) {
        
        
        
        if(self.type == "shopnow")
        {
        buybackbutton()
       // self.navigationController?.popViewController(animated: true)
        }
        else{
          self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.screenType = "FAQ"
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func editBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NewAddressVC") as? NewAddressVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func SubmitBtnAction(_ sender: Any)
    {
        if(self.mNameTF.text == "")
        {
            self.view.makeToast("Please Enter First Name")
            return
        }
        if(self.mCityTF.text == "")
        {
            self.view.makeToast("Please Enter City")
            return
        }
        if(self.mNumberTF.text == "")
        {
            self.view.makeToast("Please Enter Number")
            return
        }
        if((self.mNumberTF.text?.count)! != 10)
        {
            self.view.makeToast("Please Enter valid Mobile Number")
            return
        }
        if(self.mCountryTF.text == "")
       {
           self.view.makeToast("Please Enter Country")
           return
        }
        if(self.mStateTF.selectedItem == "" || self.mStateTF.selectedItem == nil)
        {
            self.view.makeToast("Please Choose State")
            return
        }
        
        if(self.mPincodeTF.text == "")
        {
            self.view.makeToast("Please Enter Pincode")
            return
        }
        else if((self.mPincodeTF.text?.count)! != 6)
        {
            self.view.makeToast("Please Enter valid Pincode")
            return
        }
        if(self.AddressTF.text == "")
        {
            self.view.makeToast("Please Enter Address")
            return
        }
        
        UserDefaults.standard.setValue(self.mInstructionTF.text, forKey: "DeliveryInstruction")
        shippingAPI()
    }
    //MARK:- API
    func shippingAPI()
    {
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@checkout/shipping_addressbuynow/save&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        let selectedRow = self.mStateTF.selectedRow
        let idDict = self.StateIDArray[selectedRow] as? NSDictionary
        var zoneID : String!
        zoneID = idDict!["zone_id"] as? String
        
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "firstname":self.mNameTF.text ?? "",
                "lastname":"",
                "address_1":self.AddressTF.text ?? "",
                "city":self.mCityTF.text ?? "",
                "country":"IN",
                "zone": zoneID ?? "",
                "pincode":self.mPincodeTF.text ?? "",
                "email" : "",
                //"pincode":self.addressDict["postcode"] ?? "",
                "telephone":self.mNumberTF.text ?? "",
                "comment":self.mInstructionTF.text ?? "",
                "session_id" : sessionID ?? ""
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
                            self.ShippingArray = (JSON["data_total"] as? NSArray)! as! NSArray
                            self.resultArray = (JSON["result"] as? NSArray)!
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutVC") as? CheckOutVC
                            myVC?.ShippingArray = self.ShippingArray as NSArray
                            myVC?.resultArray = self.resultArray
                            
//                            for i in 0...(self.ShippingArray.count){
//                                var shippingdict = self.ShippingArray[i]  as! [[String : Any]]
//                                if  case let shippingdict[title : "Bag Value"]
//                                {
//                                var BagValue =  UserDefaults.standard.set("value",forKey: "BagValue")
//                                }
//                                else{
//                                    
//                                }
//                                
//                                
//                            }
                            myVC?.address = self.address
                            self.navigationController?.pushViewController(myVC!, animated: true)
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
    func editshipping()
    {
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@checkout/editshipping_address/editshipping&api_token=%@",Constants.BASEURL)
        print(Url)
       // let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let OrderID =  UserDefaults.standard.string(forKey: "order_id")
        let ShippingCountryID = UserDefaults.standard.string(forKey: "shipping_country_id")
        let ShippingZoneID = UserDefaults.standard.string(forKey: "shipping_zone_id")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        
        let parameters: Parameters =
            [
                "order_id" : OrderID ?? "",
                "customer_id" : userID ?? "",
                "firstname":self.mNameTF.text ?? "",
                "lastname":"",
                "address_1":self.AddressTF.text ?? "",
                "city":self.mCityTF.text ?? "",
                "country":"IN",
                "zone":"1484",
                //"shipping_country_id" : ShippingCountryID ?? "",
                //"shipping_zone_id" : ShippingZoneID ?? "",
                "shipping_postcode":self.mPincodeTF.text ?? "",
                "email" : "",
                //"pincode":self.addressDict["postcode"] ?? "",
                "telephone":self.mNumberTF.text ?? "",
                "comment":self.mInstructionTF.text ?? "",
                "session_id" : sessionID ?? ""
               
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
                            self.ShippingArray = (JSON["data_total"] as? NSArray)!
                            self.resultArray = (JSON["result"] as? NSArray)!
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutVC") as? CheckOutVC
                            myVC?.ShippingArray = self.ShippingArray
                            myVC?.resultArray = self.resultArray
                            //                            myVC?.delivery_charge = self.delivery_charge
                            //                            myVC?.total_payable = self.total_payable
                            //                            myVC?.address = self.address
                            self.navigationController?.pushViewController(myVC!, animated: true)
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
    func previousAddress()
    {
    
    SKActivityIndicator.show("Loading...")
    let Url = String(format: "%@checkout/editshipping_address/previousshippingDeatils",Constants.BASEURL)
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
     self.addressArray = (JSON["result"] as? NSArray)!
        let Dict = self.addressArray[0] as? NSDictionary
        self.mNameTF.text =  String(format:"%@%@",(Dict!["shipping_firstname"] as? String)!,(Dict!["shipping_lastname"] as? String)!)
        self.mNumberTF.text =  String(format:"%@",(Dict!["telephone"] as? String)!)
        self.AddressTF.text = String(format:"%@",(Dict!["shipping_address_1"] as? String)!)
        self.mCityTF.text = String(format:"%@",(Dict!["shipping_city"] as? String)!)
        self.mStateTF.selectedItem = String(format:"%@",(Dict!["shipping_zone"] as? String)!)
        self.mPincodeTF.text = String(format:"%@",(Dict!["shipping_postcode"] as? String)!)
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
    
    
    func getstate()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@checkout/shipping_addressbuynow/stateList",Constants.BASEURL)
        
        print(Url)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
                            let responseArray =  JSON["result"] as? NSArray
                            self.StateIDArray = (JSON["result"] as? NSArray)!
                            for dict in responseArray! {
                                let name = (dict as AnyObject).object(forKey: "name") as? String
                                self.StateArray.append(name!)
                                self.mStateTF.itemList = self.StateArray
                                // self.imageUploading()
                            }
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
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
                            self.navigationController?.popViewController(animated: true)
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
