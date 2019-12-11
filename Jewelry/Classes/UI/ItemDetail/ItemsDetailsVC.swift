//
//  ItemsDetailsVC.swift
//  ECommerce
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class ItemsDetailsVC: UIViewController{
    
    @IBOutlet weak var orderItemsTableview: UITableView!
    var OrderItemsArray : NSArray = []
    @IBOutlet weak var mOrderIdLbl : CustomFontLabel!
    @IBOutlet weak var mDateLbl : CustomFontLabel!
    @IBOutlet weak var mNameLbl : CustomFontLabel!
    @IBOutlet weak var mpriceLbl : CustomFontLabel!
    @IBOutlet weak var mDiscountLbl : CustomFontLabel!
    @IBOutlet weak var mQtyLbl : CustomFontLabel!
    @IBOutlet weak var mBagValueLbl : CustomFontLabel!
    @IBOutlet weak var mMakingChargesLbl : CustomFontLabel!
    @IBOutlet weak var mShippingChargesLbl : CustomFontLabel!
    @IBOutlet weak var mCgstLbl : CustomFontLabel!
    @IBOutlet weak var mSgstLbl : CustomFontLabel!
    @IBOutlet weak var mIgstLbl : CustomFontLabel!
    @IBOutlet weak var mTotalAmountLbl : CustomFontLabel!
    @IBOutlet weak var mTotalSavingsLbl : CustomFontLabel!
    @IBOutlet weak var mAddressNameLbl : CustomFontLabel!
    @IBOutlet weak var mAddressNumberLbl : CustomFontLabel!
    @IBOutlet weak var mAddressLbl : CustomFontLabel!
    @IBOutlet weak var mDeliveryInstructionLbl : CustomFontLabel!
    @IBOutlet weak var mProductImage : UIImageView!
    @IBOutlet weak var mDetailsView : UIView!
    @IBOutlet weak var ReturnPopUpView : UIView!
    @IBOutlet weak var mreturnDateLbl : CustomFontLabel!
    @IBOutlet weak var mreturnOrderIdLbl : CustomFontLabel!
    @IBOutlet weak var mreasonTF: IQDropDownTextField!
    @IBOutlet weak var mreturnActionTF: IQDropDownTextField!
    @IBOutlet weak var mcountTF: IQDropDownTextField!
    @IBOutlet weak var mCommentTF: UITextView!
    @IBOutlet weak var returnbtn : CustomFontButton!
    @IBOutlet weak var writereviewbtn : CustomFontButton!
    
    
    
    var orderID : String!
    var status : String!
    var FirstName : NSString!
    
    var LastName : String!
    var EmailID : String!
    var TelephoneNo : String!
    var reasonID : NSArray = []
    var reasonAction = [String]()
    var ProductName : NSArray = []
    //var CustomerArray : NSArray = []
    var CustomerArray = [[String: Any]]()
    var resultArray = [[String: Any]]()
    var reasondict = [String: Any]()
    var Actiondict = [String: Any]()
   // var  : String!
    var returnreasonArray = [[String: Any]]()
    var returnActionArray = [[String: Any]]()
    var CountArray = ["1","2"]
    var ModelID : String!
    var OrderedDate : String!
    var resultdict = [String: Any]()
    
    var returnreasonID : String!
    var isOPtionsAvailable : Bool = false
    
    var returnActionID : String!
    //var isPolishValueAvailable : Bool = false
    
    
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
        
        self.writereviewbtn.isHidden = true
        
        self.writereviewbtn.layer.cornerRadius = 5
        self.writereviewbtn.layer.borderColor = UIColor.lightGray.cgColor
        self.writereviewbtn.layer.borderWidth = 1
               self.mDetailsView.layer.shadowColor = UIColor.lightGray.cgColor
                self.mDetailsView.layer.shadowOffset = CGSize(width: 1, height:3)
                self.mDetailsView.layer.shadowOpacity = 0.6
                self.mDetailsView.layer.shadowRadius = 3.0
                self.mDetailsView.layer.cornerRadius = 5.0
     ReturnPopUpView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        self.ReturnPopUpView.frame = self.view.frame
//        self.view .addSubview(self.ReturnPopUpView)
        mcountTF.itemList = ["1", "2", "3"]
        
        
        
        
        getDetail()
        getReturnReason()
        getReturnAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if ( self.status  == "Complete")
    {
            self.writereviewbtn.isHidden = false
            
    }
        else
    {
            self.writereviewbtn.isHidden = true
            
    }
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.ReturnPopUpView.removeFromSuperview()
        self.ReturnPopUpView.removeFromSuperview()
    }
    @IBAction func ReturnBtnAction(_ sender: Any)
    {
        self.ReturnPopUpView.frame = self.view.frame
        self.view .addSubview(self.ReturnPopUpView)
    }
    @IBAction func ReturnOrderBtnAction(_ sender: Any)
    {
        getreturnOrder()
    }
    @IBAction func writereviewBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "Rate_ReviewVC") as? Rate_ReviewVC
        let dict = self.resultArray[0]
        //let dict = self.orderArray [sender.tag] as? NSDictionary
        let ProductID = dict[ "product_id"] as? String
        myVC?.ProductId = ProductID!
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    func getDetail()
    {
        
        SKActivityIndicator.show("Loading...")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "order_id" : self.orderID ?? ""
        ]
        
        print (parameters)
        let Url = String(format: "%@api/order/MyorderProductList",Constants.BASEURL)
        print(Url)
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
                        let rupee = "\u{20B9}"
//                        let Value = UserDefaults.standard.float(forKey: "value")
//                        print("value",Value)
//
//           // self.mBagValueLbl.text = UserDefaults.standard.string(forKey: "value")
//                        self.mBagValueLbl.text = String(format: "%@%0.2f", rupee,Value)
                        
                        let cgst = (JSON["cgst"] as? NSString)?.doubleValue
                        self.mCgstLbl.text =  rupee + String(format:"%.2f",cgst!)
                        let sgst = (JSON["sgst"] as? NSString)?.doubleValue
                        self.mSgstLbl.text =  rupee + String(format:"%.2f",sgst!)
                        let igst = (JSON["igst"] as? NSString)?.doubleValue
                        self.mIgstLbl.text =  rupee + String(format:"%.2f",igst!)
                        
                        
                         let shippingcharge = (JSON["delivery_charges"] as? NSString)?.doubleValue
                        self.mShippingChargesLbl.text =  rupee + String(format:"%.2f",shippingcharge!)
                        let makingcharge = (JSON["making_charge"] as? NSString)?.doubleValue
                        self.mMakingChargesLbl.text =  rupee + String(format:"%.2f",makingcharge!)
                        let bagvalue = (JSON["sub_total"] as? NSString)?.doubleValue
                        self.mBagValueLbl.text = rupee + String(format:"%.2f",bagvalue!)
                            
                      let totalsaving = (JSON["total_saving"] as? NSString)?.doubleValue

                        self.mTotalSavingsLbl.text =  rupee + String(format:"%.2f",totalsaving!)
                        let totalamount = (JSON["totalMoney"] as? NSString)?.doubleValue
                        self.mTotalAmountLbl.text = rupee + String(format:"%.2f",totalamount!)
                        self.resultArray = JSON["result"] as! [[String: Any]]
                        let dict = self.resultArray[0]
                        let image = dict["image"] as? String
                        self.mProductImage.sd_setImage(with: URL(string: image ?? ""), placeholderImage:nil)
                        self.mNameLbl.text = dict["name"] as? String
                        self.mQtyLbl.text = dict["quantity"] as? String
                        //self.mpriceLbl.text = dict["price"] as? String
                        //var full_payment = (mFullPaymentLbl.text! as NSString).floatValue
                        let priceSting = String(format : "%@",dict["price"] as? String ?? "")
                        let priceDouble =  Double (priceSting)
                        self.mpriceLbl.text = String(format : "₹%.2f",priceDouble!)
                        var discount = String(format : "%@",dict["discount_price"] as? String ?? "")
                        if(discount == "null" || discount == "0")
                        {
                            
                        }
                        else
                        {
                            let discountSting = String(format : "%@",dict["discount_price"] as? String ?? "")
                            let discountDouble =  Double (discountSting)
                            if((discountDouble) != nil)
                            {
                                discount = String(format : "₹%.2f",discountDouble!)
                                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                                self.mDiscountLbl.attributedText = attributeString
                            }
                            
                        }

                        self.mOrderIdLbl.text = dict["order_id"] as? String
                        self.mreturnOrderIdLbl.text = dict["order_id"] as? String
                        self.CustomerArray = JSON["customer_details"] as! [[String: Any]]
                        let dict1 = self.CustomerArray[0]
                        self.mDateLbl.text = dict1["date_added"] as? String
                        self.mreturnDateLbl.text = dict1["date_added"] as? String
                        //self.mAddressNameLbl.text = String(format:"%@ %@",(dict1["firstname"] as? String)!(dict1["lastname"] as? String)!)
                        
                         self.mAddressNameLbl.text = String(format:"%@",(dict1["firstname"] as? String)!)
//
                        self.mAddressLbl.text = String(format:"%@ %@ %@ %@",(dict1["shipping_address_1"] as? String)!,(dict1["shipping_city"] as? String)!,(dict1["shipping_zone"] as? String)!,(dict1["shipping_postcode"] as? String)!)
                        self.mDeliveryInstructionLbl.text = dict1["delivery_instruction"] as? String
                        self.mAddressNumberLbl.text = dict1["telephone"] as? String
                        let countdict = self.CountArray[0]
                        self.mcountTF.selectedItem = dict1["date_added"] as? String
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
    func getReturnReason()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/return/returnReasons",Constants.BASEURL)
        
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
                            self.returnreasonArray =  JSON["result"] as! [[String: Any]]
                            //let reasondict = returnreasonArray[0]
                            //self.reasonID = (JSON["result"] as? NSArray)!
                            var reasonnames = [String]()
                            for dict in self.returnreasonArray {
                                let name = (dict as AnyObject).object(forKey: "name") as? String
                                reasonnames.append(name!)
                               
                                // self.imageUploading()00
                            }
                             self.mreasonTF.itemList = reasonnames
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
        func getReturnAction()
        {
            SKActivityIndicator.show("Loading...")
            let Url = String(format: "%@account/return/returnActions",Constants.BASEURL)
            
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
                                self.returnActionArray =  JSON["result"] as! [[String: Any]]
                                //self.reasonID = (JSON["result"] as? NSArray)!
                                var Actionnames = [String]()
                                for dict in self.returnActionArray {
                                    let name = (dict as AnyObject).object(forKey: "name") as? String
                                    Actionnames.append(name!)
                                   
                                    // self.imageUploading()
                                }
                                self.mreturnActionTF.itemList = Actionnames
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
    
    func getreturnOrder()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        //let FirstName =  UserDefaults.standard.string(forKey: "firstname")
        
        let dict1 = self.CustomerArray[0]
        let dict = self.resultArray[0]
        
        let reasondict = self.returnreasonArray[0]
        let reasonselectedRow = self.mreasonTF.selectedRow
        self.reasondict = (returnreasonArray[reasonselectedRow] as?  [String : String])!
         returnreasonID = reasondict["return_reason_id"] as? String
        isOPtionsAvailable = true
        
        let Actiondict = self.returnActionArray[0]
        let ActionselectedRow = self.mreturnActionTF.selectedRow
        self.Actiondict = (returnActionArray[ActionselectedRow] as?  [String : String])!
        returnActionID = Actiondict["return_action_id"] as? String
        isOPtionsAvailable = true
        
        
       
      SKActivityIndicator.show("Loading...")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "order_id" : self.orderID ?? "",
                "firstname" : dict1["firstname"] as! String,
                "lastname": dict1["lastname"] as! String,
                "email": dict1["email"] as! String,
                "telephone": dict1["telephone"] as! String,
                "return_reason_id": reasondict["return_reason_id"] as! String,
                "comment": self.mCommentTF.text ?? "",
                "return_action_id": self.returnActionID ?? "",
                "product_name": dict["name"] as! String,
                "model": dict["model"] as! String,
                "date_ordered": dict1["date_added"] as! String,
                "quantity": dict["quantity"] as! String,
                "order_product_id" : dict["order_product_id"] as! String,
                
        ]
        
        print (parameters)
        let Url = String(format: "%@account/return/AddReturns",Constants.BASEURL)
        print(Url)
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
                       self.view.makeToast(JSON["message"] as? String)
                        self.ReturnPopUpView.removeFromSuperview()
                        //self.returnbtn.isEnabled = false;
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
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return OrderItemsArray.count;
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell:OrderDetailsCell =  orderItemsTableview.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
//
//        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
//        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
//        cell.mBgView.layer.shadowOpacity = 0.6
//        cell.mBgView.layer.shadowRadius = 3.0
//        cell.mBgView.layer.cornerRadius = 5.0
//        let dict = self.OrderItemsArray[indexPath.row] as? NSDictionary
//        var image = dict!["image"] as? String
//        image = image?.replacingOccurrences(of: " ", with: "%20")
//        cell.OrderDetailsImage.sd_setImage(with: URL(string: image ?? ""), placeholderImage:nil)
//        cell.detailsname.text = dict![ "name"] as? String
//        cell.Orderdetailkg.text = dict![ "quantity"] as? String
//        cell.orderDetailsQuantiy.text = String(format:"Quantity : %@",(dict!["quantity"] as? String)!)
//        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
//        let priceDouble =  Double (priceSting)
//        cell.orderdetailsPrice.text = String(format : "₹%.2f",priceDouble!)
//        var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
//        if(discount == "null")
//        {
//
//        }
//        else
//        {
//            let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
//            let discountDouble =  Double (discountSting)
//            if((discountDouble) != nil)
//            {
//                discount = String(format : "₹%.2f",discountDouble!)
//                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
//                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                cell.orderattributePrice.attributedText = attributeString
//            }
//
//        }
//        return cell
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
