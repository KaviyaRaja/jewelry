//
//  MyCartVC.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class MyCartVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
   
    @IBOutlet weak var relatedTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mRelatedTableView: UITableView!
    @IBOutlet weak var mRelatedView: UIView!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cartTableview: UITableView!
    @IBOutlet weak var mCartEmptyView : UIView!
    @IBOutlet weak var mtotalView : UIView!
    @IBOutlet weak var RelatedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mCountLabel : CustomFontLabel!
    @IBOutlet weak var msaveCountLabel : CustomFontLabel!
    @IBOutlet weak var mNameLabel : CustomFontLabel!
    @IBOutlet weak var mTotalLabel : CustomFontLabel!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    @IBOutlet weak var QuantityPopUpView : UIView!
    @IBOutlet weak var quantitypopLbl: CustomFontLabel!
    
    @IBOutlet weak var mDateTF: IQDropDownTextField!
    @IBOutlet var mPopupView: UIView!
    var saveforlaterArray : NSArray = []
    var cartArray : NSArray = []
    var totalArray : NSArray = []
    var removeArray : NSArray = []
    var refreshControl = UIRefreshControl()
    var orderID : String!
    var CartID : String!
    var totaldict = NSDictionary()
    
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
        cartTableview.register(UINib(nibName: "CartTableViewCell", bundle: .main), forCellReuseIdentifier: "CartTableViewCell")
        mRelatedTableView.register(UINib(nibName: "CartTableViewCell", bundle: .main), forCellReuseIdentifier: "CartTableViewCell")
        mCartEmptyView.isHidden = true
//        self.mDateTF.addBorder()
//        self.mDateTF.setLeftPaddingPoints(10)
        
        
     self.mRelatedView.isHidden = true
     self.RelatedViewHeight.constant = 0
    self.mRelatedTableView.isHidden = true
        self.relatedTableViewHeight.constant = 0
        self.totalHeight.constant = 0
        self.mtotalView.isHidden = true
        self.cartTableview.delegate = self
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getCart()
        getSaveForLaterCartlist()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.cartTableview.addSubview(refreshControl)
        
        
    }
// MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func checkOutBtnAction(_ sender: UIButton)
    {
        self.mPopupView.frame = self.view.frame
        self.view.addSubview(self.mPopupView)
        
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: NSDate() as Date)
        var arrDates = [String]()
        for i in 1 ... 3 {
            
            date = cal.date(byAdding: .day, value: 1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        self.mDateTF.itemList = arrDates
        
    }
//    @IBAction func deliveryBtnAction(_ sender: UIButton)
//    {
//        self.mPopupView.frame = self.view.frame
//        self.view.addSubview(self.mPopupView)
//
//        let cal = NSCalendar.current
//        var date = cal.startOfDay(for: NSDate() as Date)
//        var arrDates = [String]()
//        for i in 1 ... 3 {
//
//            date = cal.date(byAdding: .day, value: 1, to: date)!
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEEE"
//            let dateString = dateFormatter.string(from: date)
//            arrDates.append(dateString)
//        }
//        print(arrDates)
//        self.mDateTF.itemList = arrDates
//    }
    @IBAction func shopNowBtnAction(_ sender: UIButton)
    {
        Constants.appDelegate?.goToHome()
    }
  
    @IBAction func closeBtnAction(_ sender: Any)
    {
        self.mPopupView.removeFromSuperview()
    }
    @IBAction func CheckoutBtnAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
       for i in 0..<cartArray.count{
            let dict = self.cartArray[i] as! NSDictionary
            let indexpath = IndexPath(row: i, section: 0)
            let cell = cartTableview.cellForRow(at: indexpath) as! CartTableViewCell
        let quantity = dict["stock_quantity"] as? String
            if(cell.mQuantityTF.text == ""){
                self.view.makeToast("Please Enter Quantity for all the items")
                return
            }
            
            else if cell.mQuantityTF.text!  < quantity!
           {
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let myVC = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as? ShippingVC
               self.navigationController?.pushViewController(myVC!, animated: true)
           }
        


           // print(cell.mQuantityTF.text ?? "Not Available")
        }
    
    }
    //@IBAction func scheduleBtnAction(_ sender: Any)
//    {
//        self.mPopupView.removeFromSuperview()
//        if(self.mDateTF.selectedItem == "" || self.mDateTF.selectedItem == nil)
//        {
//            self.view.makeToast("Please Choose Delivery Date")
//            return
//        }
//
//        let selectedRow = self.mDateTF.selectedRow
//        let cal = NSCalendar.current
//        var date = cal.startOfDay(for: NSDate() as Date)
//        var arrDates = [String]()
//        for i in 1 ... 3 {
//
//            date = cal.date(byAdding: .day, value: 1, to: date)!
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd-MM-YYYY"
//            let dateString = dateFormatter.string(from: date)
//            arrDates.append(dateString)
//        }
//        print(arrDates)
//        UserDefaults.standard.setValue(arrDates[selectedRow] as? String, forKey: "DeliveryDay")
//        UserDefaults.standard.setValue(self.mDateTF.selectedItem, forKey: "DeliveryDate")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as! ShippingVC
//        vc.deliveryDate = self.mDateTF.selectedItem
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        vc.screenType = "FAQ"
        Constants.kNavigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func UploadBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "uploadPicVC") as? uploadPicVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getCart()
        self.refreshControl.endRefreshing()
    }
    @IBAction func okBtnAction(_ sender: UIButton)
    {
        self.QuantityPopUpView.removeFromSuperview()
        
        
    }
    
    @objc func SaveForLaterbtnAction(_ sender: AnyObject) {
        // Code to refresh table view
        let dict =  self.cartArray[sender.tag] as? NSDictionary
        CartID = dict!["cart_id"] as! String
        getSaveForLater()
        //self.refreshControl.endRefreshing()
    }
    @objc func removeBtnAction(_ sender: AnyObject) {
        // Code to refresh table view
        let dict =  self.cartArray[sender.tag] as? NSDictionary
        CartID = dict!["cart_id"] as! String
        getremove()
        
        //getSaveForLaterCartlist()
        //self.refreshControl.endRefreshing()
    }
    @objc func removeSaveLaterBtnAction(_ sender: AnyObject) {
        // Code to refresh table view
        let dict =  self.saveforlaterArray[sender.tag] as? NSDictionary
        CartID = dict!["cart_id"] as! String
        getremove()
        
        //getSaveForLaterCartlist()
        //self.refreshControl.endRefreshing()
    }
    @objc func MoveToCartBtnAction(_ sender: AnyObject) {
        // Code to refresh table view
        let dict =  self.saveforlaterArray[sender.tag] as? NSDictionary
        CartID = dict!["cart_id"] as! String
        getmovetocart()
       // getCart()
        //getSaveForLaterCartlist()
        //self.refreshControl.endRefreshing()
    }
    
    // MARK: - API
    func getCart()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/products&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            //"customer_id" :  "4"
            "customer_id" : userID ?? "",
           // "order_id" : orderID ?? ""
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
                            self.cartTableview.isHidden = false
                            //self.view.makeToast(JSON["message"] as? String)
                           // let Array = self.cartArray[0] as! NSArray
                            self.cartArray = (JSON["result"] as? NSArray)!
                            self.TableViewHeight.constant = CGFloat(self.cartArray.count * 220)
                            self.contentHeight.constant = self.TableViewHeight.constant + self.RelatedViewHeight.constant + self.relatedTableViewHeight.constant
                            self.cartTableview.reloadData()
                        if(self.cartArray.count > 0)
                        {
                            self.mCartEmptyView.isHidden = true
                            self.mtotalView.isHidden = false
                            self.totalHeight.constant = 60
                            self.mtotalView.isHidden = false
                            
                        }
                        else
                        {
                            self.mCartEmptyView.isHidden = false
                            self.mtotalView.isHidden = true
                            self.totalHeight.constant = 0
                            self.mtotalView.isHidden = true
                            
                        }
                            
                           self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            
                            let totalArray = JSON["total_cart_price"] as? NSArray
                            //let totalDict = totalArray![0] as? NSDictionary
                            self.mTotalLabel.text = String(format : "₹%@",JSON["total_cart_price"] as? AnyObject as! CVarArg)
                           // self.cartArray = (JSON["total_cart_price"] as? NSArray)!
                           // let totalDict = self.cartArray[0]
//                            self.mTotalLabel.text = String(format : "₹%@,JSON["total_cart_price"] as? String)
                            
                            
                           // totalData = (jsonDict["totalfup"] as! NSString).doubleValue
                            }
                    
                        else
                        {
                            self.TableViewHeight.constant = 150
                            self.contentHeight.constant = self.TableViewHeight.constant + self.RelatedViewHeight.constant + self.relatedTableViewHeight.constant
                            self.cartTableview.isHidden = true
                            self.mCartEmptyView.isHidden = false
                            self.totalHeight.constant = 0
                            self.mtotalView.isHidden = true
                            self.cartArray = []
                            self.cartTableview.reloadData()
                        }
                    
                    break
                    }
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    
    func getSaveForLater()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/saveforlater&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
       // let CartID =  UserDefaults.standard.string(forKey: "cart_id")
        let parameters: Parameters =
            [
                "cart_id" :  CartID ?? "",
                //"customer_id" : userID ?? "",
                // "order_id" : orderID ?? ""
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
                            //self.view.makeToast(JSON["message"] as? String)
                            self.getSaveForLaterCartlist()
                            self.getCart()
                            
                            // let Array = self.cartArray[0] as! NSArray
//                            self.cartArray = (JSON["result"] as? NSArray)!
//                            self.TableViewHeight.constant = CGFloat(self.cartArray.count * 100)
                           // self.mRelatedTableView.reloadData()
                            
                            
                           
//                            self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
//
//                            //                            let totalDict = self.cartArray[0] as? NSDictionary
//                            //                            self.mTotalLabel.text = String(format : "₹%@",totalDict!["text"] as? AnyObject as! CVarArg)
                                //let cartArray = JSON["total_product_count"] as? NSArray
//                            self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            
                        }
                        else
                        {
                            self.mCartEmptyView.isHidden = false
                        }
                        
                        break
                    }
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func getSaveForLaterCartlist()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/saveforlaterproductslist&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                //"customer_id" :  "4"
                "customer_id" : userID ?? "",
                // "order_id" : orderID ?? ""
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
                            //self.view.makeToast(JSON["message"] as? String)
                            // let Array = self.cartArray[0] as! NSArray
                            self.saveforlaterArray = (JSON["result"] as? NSArray)!
                            self.relatedTableViewHeight.constant = CGFloat(self.saveforlaterArray.count * 100)
                            
                            self.mRelatedTableView.reloadData()
                           
                            if(self.saveforlaterArray.count > 0){
                            self.mRelatedView.isHidden = false
                            self.RelatedViewHeight.constant = 32
                            self.mRelatedTableView.isHidden = false
                            self.relatedTableViewHeight.constant = CGFloat(self.saveforlaterArray.count * 200)
                                
                            }
//                            if(self.saveforlaterArray.count > 0)
//                            {
//                                self.mCartEmptyView.isHidden = true
//                            }
                            else
                          {
                            self.mRelatedView.isHidden = true
                            self.RelatedViewHeight.constant = 0
                            self.mRelatedTableView.isHidden = true
                            self.relatedTableViewHeight.constant = 0
                           }
                            self.contentHeight.constant = self.TableViewHeight.constant + self.RelatedViewHeight.constant + self.relatedTableViewHeight.constant
                            let saveforlaterArray = JSON["total_cart_price"] as? NSArray
                            self.msaveCountLabel.text = String(format: "%d items",self.saveforlaterArray.count)
                           
                            
                            //                            let totalDict = self.cartArray[0] as? NSDictionary
                            //                            self.mTotalLabel.text = String(format : "₹%@",totalDict!["text"] as? AnyObject as! CVarArg)
                      //  let cartArray = JSON["total_cart_price"] as? NSArray
                            //self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            
                        }
                        else
                        {
                            //self.mCartEmptyView.isHidden = false
                            self.mRelatedView.isHidden = true
                            self.RelatedViewHeight.constant = 0
                            self.mRelatedTableView.isHidden = true
                            self.relatedTableViewHeight.constant = 0
                            self.saveforlaterArray = []
                            self.mRelatedTableView.reloadData()
                        }
                        
                        break
                    }
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func quantityupdate(cart_id:String,quantity:String)
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
         //let CartID =  UserDefaults.standard.string(forKey: "cart_id")
        let parameters: Parameters =
            [
                "cart_id" :  cart_id,
                "quantity" : quantity,
                // "order_id" : orderID ?? ""
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
                            //self.view.makeToast(JSON["message"] as? String)
                            self.getSaveForLaterCartlist()
                            self.getCart()
                            
                            // let Array = self.cartArray[0] as! NSArray
                            //                            self.cartArray = (JSON["result"] as? NSArray)!
                            //                            self.TableViewHeight.constant = CGFloat(self.cartArray.count * 100)
                            // self.mRelatedTableView.reloadData()
                            
                            
                            
                            //                            self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            //
                            //                            //                            let totalDict = self.cartArray[0] as? NSDictionary
                            //                            //                            self.mTotalLabel.text = String(format : "₹%@",totalDict!["text"] as? AnyObject as! CVarArg)
                            //let cartArray = JSON["total_product_count"] as? NSArray
                            //                            self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            
                        }
                        else
                        {
                            self.mCartEmptyView.isHidden = false
                        }
                        
                        break
                    }
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      if(tableView == self.cartTableview)
    {
        return cartArray.count
    }
    else if(tableView == self.mRelatedTableView)
      {
        return saveforlaterArray.count
     }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        var defaultCell : UITableViewCell!
        if(tableView == self.cartTableview)
        {
        
        let cell:CartTableViewCell =   cartTableview.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.selectionStyle = .none
            cell.mSaveForLaterLbl.text = "SaveForLater"
            
        let dict = self.cartArray[indexPath.row] as? NSDictionary
            
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.cartImageView.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        cell.cartnameLabel.text = dict!["name"] as? String
            let offer = dict!["offer"]
            if offer as? String == "null" || offer as? String == "0" 
//            let offer = String(format : "%@ %%off",dict!["offer"] as! String)
//            if(offer == "null" || offer == "0")
            {
               cell.cartOfferLabel.isHidden = true
            }
            else
            {
                cell.cartOfferLabel.isHidden = false
                cell.cartOfferLabel.text = dict!["offer"] as? String
                cell.cartOfferLabel.text = String(format : "%@ %%off",dict!["offer"] as! String)
            }
            cell.mPolishTF.text = (dict!["polish"] as! String)
            if let weight = dict!["weight"] as? Int {
                cell.mWeightTF.text = String(format: "%dgm", dict!["weight"] as!Int)
            }
            else if let weight = dict!["weight"] as? Double {
                cell.mWeightTF.text = String(format: "%dgm", dict!["weight"] as!Double)
            }
            cell.msizeTF.text = (dict!["size"]  as! String)
           cell.mQuantityTF.text = dict!["quantity"] as? String
           cell.mQuantityTF.delegate = self
            cell.mQuantityTF.tag = indexPath.row
            cell.mQuantityTF.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
       // cell.mCartCountLabel.text = String(format : "%d",(dict!["total_product_count"] as? Int)!)
       
        let priceSting = dict!["discount_price"]
        if (priceSting as? String  == "0" || priceSting  as? String == "null")
            {
                cell.cartAttributeLabel.isHidden = true
            }
            else
            {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceSting as! String)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.cartAttributeLabel.attributedText = attributeString
       let priceSting = String(format : "₹%@",dict!["discount_price"] as? String ?? "")
        cell.cartAttributeLabel.text = priceSting
            }
        
      
       // let discountSting = String(format : "%d",dict!["discount_price"] as? Int ?? "")
     
        let discount = String(format : "₹%@",dict!["price"] as? String ?? "")
            if (discount as? String  == "0" || discount  as? String == "null")
            {
                cell.cartprice.isHidden = true
            }
            else
            {
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
//        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
       cell.cartprice.text = discount
            }
        
            cell.mRemoveBtn.tag = indexPath.row
            cell.mRemoveBtn.addTarget(self, action:#selector(removeBtnAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell.mMoveToCartBtn.tag = indexPath.row
            cell.mMoveToCartBtn.addTarget(self, action:#selector(SaveForLaterbtnAction(_:)), for: UIControlEvents.touchUpInside)
            
//
        return cell;
    }
        if(tableView == self.mRelatedTableView)
        {
            
            let cell:CartTableViewCell =   mRelatedTableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.mSaveForLaterLbl.text = "Move To Cart"
            cell.selectionStyle = .none
            let dict = self.saveforlaterArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            image = image?.replacingOccurrences(of: " ", with: "%20")
            cell.cartImageView.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
            cell.cartnameLabel.text = dict!["name"] as? String
            let offer = dict!["offer"]
            if offer as? String == "null" || offer as? String == "0"
                //            let offer = String(format : "%@ %%off",dict!["offer"] as! String)
                //            if(offer == "null" || offer == "0")
            {
                cell.cartOfferLabel.isHidden = true
            }
            else
            {
                cell.cartOfferLabel.isHidden = false
                cell.cartOfferLabel.text = dict!["offer"] as? String
                cell.cartOfferLabel.text = String(format : "%@ %%off",dict!["offer"] as! String)
            }
            cell.mPolishTF.text = dict!["polish"] as? String
            cell.mWeightTF.text = String(format: "%dgm", dict!["weight"] as!Int)
            cell.msizeTF.text = dict!["size"] as? String
            cell.mQuantityTF.text = dict!["quantity"] as? String
            // cell.mCartCountLabel.text = String(format : "%d",(dict!["total_product_count"] as? Int)!)
            
            let priceSting = String(format : "₹%@",dict!["discount_price"] as? String ?? "")
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceSting)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.cartAttributeLabel.attributedText = attributeString
            
            cell.cartprice.text = priceSting
            
            
            // let discountSting = String(format : "%d",dict!["discount_price"] as? Int ?? "")
            
            let discount = String(format : "₹%@",dict!["price"] as? String ?? "")
            //        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
            //        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.cartprice.text = discount
            cell.mRemoveBtn.tag = indexPath.row
            cell.mRemoveBtn.addTarget(self, action:#selector(removeSaveLaterBtnAction(_:)), for: UIControlEvents.touchUpInside)
            
            cell.mMoveToCartBtn.tag = indexPath.row
            cell.mMoveToCartBtn.addTarget(self, action:#selector(MoveToCartBtnAction(_:)), for: UIControlEvents.touchUpInside)
            return cell;
        }
        return defaultCell!
    }
//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let dict = self.cartArray[indexPath.row] as? NSDictionary
//        let productID = dict![ "product_id"] as? String
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
//        myVC?.productID = productID! as NSString
//        self.navigationController?.pushViewController(myVC!, animated: false)
//    }
     func textFieldDidEndEditing(_ textField: UITextField!)
    {
        
        
        
        
//        let storyboard = UIStoryboard(name: "MyCartVC", bundle: nil)
//        let cell = cartTableview.register(UINib(nibName: "CartTableViewCell", bundle: .main), forCellReuseIdentifier: "CartTableViewCell")
//        let indexPath = cartTableview.indexPath(for: cell)
        let dict = self.cartArray[textField.tag] as? NSDictionary
       
        
        let quantity = dict!["stock_quantity"] as?  String
        let cartid =  dict!["cart_id"] as?  String
        let quantityid = textField.text ?? ""
        
        if(textField.text == "")
        {
            self.view.makeToast("Please Enter Quantity")
            return
            
        }
        
        let textfieldInt: Int? = Int(textField.text!)
        
        let quantityInt: Int? = Int(quantity!)

             print("self.quantityTF.text",textfieldInt)
        if (textfieldInt! > quantityInt!)
        {
            self.QuantityPopUpView.frame = self.view.frame
            self.view .addSubview(self.QuantityPopUpView)
            self.quantitypopLbl.text = String(format : "%@ Pieces only available. please choose the quantity accordingly.",dict!["stock_quantity"] as! String)
            return
        }
        else
        {
            quantityupdate(cart_id: cartid!, quantity: quantityid)
        }
        
    }
//        func ShopNowBtnAction(_ sender: Any) {
//
//
//    }
//        func cartBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.cartArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
//        cell?.mAddView.isHidden = true
//        //cell?.mCartView.isHidden = false
//        cell?.mCartCountLabel.text = "1"
//        let selectedRow = 0
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let options = dict!["option"] as? AnyObject
//        if(options == nil || options as? String == "null")
//        {
//        }
//        else
//        {
//            var optArray = dict!["option"] as? NSArray
//            if((optArray?.count)! > 0)
//            {
//                var optDict = optArray![selectedRow] as? NSDictionary
//                optionID = optDict!["product_option_id"] as? String
//                optionValueID = optDict!["product_option_value_id"] as? String
//                isOPtionsAvailable = true
//            }
//        }
//
//
//        SKActivityIndicator.show("Loading...")
//        let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        print(Url)
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        var parameters: Parameters = [:]
//        if(isOPtionsAvailable)
//        {
//            parameters = [
//                "customer_id" : userID ?? "",
//                "product_id" : productID,
//                "quantity" : "1",
//                "product_option_id" : optionID ?? "",
//                "product_option_value_id" : optionValueID ?? ""
//            ]
//        }
//        else{
//            parameters = [
//                "customer_id" : userID ?? "",
//                "product_id" : productID,
//                "quantity" : "1",
//            ]
//        }
//        print (parameters)
//         let headers: HTTPHeaders =
//         [
//         "Content-Type": "application/json"
//         ]
//         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//         .responseJSON { response in
//         print(response)
//         SKActivityIndicator.dismiss()
//         switch(response.result) {
//
//         case .success:
//         if let json = response.result.value
//         {
//         let JSON = json as! NSDictionary
//         print(JSON)
//         if(JSON["status"] as? String == "success")
//         {
//         self.view.makeToast(JSON["message"] as? String)
//         self.getCart()
//         }
//         else
//         {
//            self.view.makeToast(JSON["message"] as? String)
//            }
//         }
//         break
//
//         case .failure(let error):
//         print(error)
//         break
//
//         }
//         }
//
//    }
//    @objc func plusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.cartArray[tag] as? NSDictionary
//        let cartID = dict!["cart_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
//        cell?.mAddView.isHidden = true
//        //cell?.mCartView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count + 1
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//        let selectedRow = 0 //cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        let productID = dict!["product_id"] as! String
//        var isOPtionsAvailable : Bool = false
//
//        let options = dict!["option"] as? AnyObject
//        if(options == nil || options as? String == "null")
//        {
//        }
//        else
//        {
//            var optArray = dict!["option"] as? NSArray
//            if((optArray?.count)! > 0)
//            {
//                var optDict = optArray![selectedRow] as? NSDictionary
//                optionID = optDict!["product_option_id"] as? String
//                optionValueID = optDict!["product_option_value_id"] as? String
//                isOPtionsAvailable = true
//            }
//        }
//        SKActivityIndicator.show("Loading...")
//        let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        print(Url)
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        var parameters: Parameters = [:]
//        if(isOPtionsAvailable)
//        {
//            parameters =
//                [
//                    "customer_id" : userID ?? "",
//                    "product_id" : productID,
//                    "quantity" : count,
//                    "product_option_id" : optionID ?? "",
//                    "product_option_value_id" : optionValueID ?? ""
//            ]
//        }
//        else{
//            parameters =
//                [ "customer_id" : userID ?? "",
//                  "product_id" : productID,
//                  "quantity" : count,
//            ]
//        }
//
//
//
//         print (parameters)
//         let headers: HTTPHeaders =
//         [
//         "Content-Type": "application/json"
//         ]
//         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//         .responseJSON { response in
//         print(response)
//         SKActivityIndicator.dismiss()
//         switch(response.result) {
//
//         case .success:
//         if let json = response.result.value
//         {
//         let JSON = json as! NSDictionary
//         print(JSON)
//         if(JSON["status"] as? String == "success")
//         {
//         self.view.makeToast(JSON["message"] as? String)
//         self.getCart()
//         }
//         else
//         {
//           // self.view.makeToast(JSON["message"] as? String)
//            }
//         }
//         break
//
//         case .failure(let error):
//         print(error)
//         break
//
//         }
//         }
//
//    }
//    @objc func minusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.cartArray[tag] as? NSDictionary
//        let cartID = dict!["cart_id"] as! String
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count - 1
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//        var Url = ""
//        if(count == 1)
//        {
//            cell?.mAddView.isHidden = true
//            //return
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//        else
//        {
//        Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//        print(Url)
//
//        let selectedRow = 0 //cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let options = dict!["option"] as? AnyObject
//        if(options == nil || options as? String == "null")
//        {
//        }
//        else
//        {
//            var optArray = dict!["option"] as? NSArray
//            if((optArray?.count)! > 0)
//            {
//                var optDict = optArray![selectedRow] as? NSDictionary
//                optionID = optDict!["product_option_id"] as? String
//                optionValueID = optDict!["product_option_value_id"] as? String
//                isOPtionsAvailable = true
//            }
//        }
//
//        SKActivityIndicator.show("Loading...")
//
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        var parameters: Parameters = [:]
//        if(isOPtionsAvailable)
//        {
//            parameters =
//                [
//                    //"customer_id" : userID ?? "",
//                    "product_id" : productID,
//                    "quantity" : count,
//                    "product_option_id" : optionID ?? "",
//                    "product_option_value_id" : optionValueID ?? ""
//            ]
//        }
//        else{
//            parameters =
//                [ //"customer_id" : userID ?? "",
//                  "product_id" : productID,
//                  "quantity" : count,
//            ]
//        }
//    print (parameters)
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
//                            self.view.makeToast(JSON["message"] as? String)
//                            self.getCart()
//                        }
//                        else
//                        {
//                            //self.view.makeToast(JSON["message"] as? String)
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
//
//    }
//
//
   
        func getremove()
        {
        
        //let productID = dict!["product_id"] as! String
        //let dict =  self.cartArray[sender.tag] as? NSDictionary
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/remove&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)

        print(Url)
        //let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                //"customer_id" : userID ?? "",
                "cart_id" :  CartID ?? "",
        ]

        print (parameters)
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
                            self.getSaveForLaterCartlist()
                            self.getCart()
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
    func getmovetocart()
    {
        
        //let productID = dict!["product_id"] as! String
        //let dict =  self.cartArray[sender.tag] as? NSDictionary
        
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/addtocartfromsaveforlater&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        
        print(Url)
        //let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                //"customer_id" : userID ?? "",
                "cart_id" :  CartID ?? "",
                ]
        
        print (parameters)
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
                           // self.view.makeToast(JSON["message"] as? String)
                            self.getCart()
                            self.getSaveForLaterCartlist()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var  dict = NSDictionary()
        if(tableView == self.cartTableview)
        {
            dict = (self.cartArray[indexPath.row] as? NSDictionary)!
        }
        else
       // if(tableView == self.mRelatedTableView)
        {
            dict = (self.saveforlaterArray[indexPath.row] as? NSDictionary)!
        }
        let productID = dict[ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductOneVC") as? ProductOneVC
        myVC?.ProductID = productID!  as String;
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
