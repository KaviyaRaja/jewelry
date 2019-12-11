//
//  MyOrderVC.swift
//  ECommerce
//
//  Created by Apple on 25/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView
class MyOrderVC:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var orderSegmentControl: UISegmentedControl!
    @IBOutlet weak var myOrdertableview: UITableView!
    @IBOutlet weak var reOrderPopUpView : UIView!
    @IBOutlet var cancelPopUpView: UIView!
    @IBOutlet weak var mcartCountLabel : UILabel!
    @IBOutlet weak var noOrderView : UIView!
    var orderArray : NSArray = []
    @IBOutlet weak var mCancelBtn : CustomFontButton!
    @IBOutlet weak var mCancel2Btn : CustomFontButton!
    @IBOutlet weak var mReorderCancelBtn : CustomFontButton!
    var cancelIndex : Int?
    var mOrderID : String!
    var ProductID : String!
    var refreshControl = UIRefreshControl()
    var selectedOrder = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        if #available(iOS 13, *){
                     let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                     statusBar.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
                     UIApplication.shared.keyWindow?.addSubview(statusBar)
                 }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
        }
        
        myOrdertableview.register(UINib(nibName: "MyOrderTableViewCell", bundle: .main), forCellReuseIdentifier: "MyOrderTableViewCell")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.myOrdertableview.addSubview(refreshControl)
//        self.mcartCountLabel.layer.cornerRadius = self.mcartCountLabel.frame.size.width/2
//        self.mcartCountLabel.layer.masksToBounds = true
        self.myOrdertableview.isHidden = true
        
        (orderSegmentControl.subviews[0] as UIView).tintColor = UIColor .blue
        getMyOrders()
        //getCartCount()
        
    }
    // MARK: - API
    @IBAction func orderSegmentControlOnSelect(_ sender: Any) {
        
        selectedOrder =  orderSegmentControl.selectedSegmentIndex
        
        switch  orderSegmentControl.selectedSegmentIndex{
        case 0:
            getMyOrders()
        case 1:
            getCustomOrder()
            default:
            print("default")
        }
        
        
    }
//    func getCartCount()
//    {
//        let Url = String(format: "%@api/cart/cartcount&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        print(Url)
//        let headers: HTTPHeaders =
//            [
//                "Content-Type": "application/json"
//        ]
//        Alamofire.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
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
//                            self.mcartCountLabel.text = JSON["data"] as? String
//                            if(self.mcartCountLabel.text == "0")
//                            {
//                                self.mcartCountLabel.isHidden = true
//                            }
//                            else
//                            {
//                                self.mcartCountLabel.isHidden = false
//                            }
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
func getMyOrders()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        let parameters: Parameters =
//        [
//            "customer_id" : userID ?? ""
//            //"customer_id" : "1"
//        ]
        let parameters: Parameters =
            [
                "customer_id" : userID ?? ""
                //"customer_id" : "1"
        ]
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        let Url = String(format: "%@api/order/cusOrder",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                        self.orderArray = (JSON["result"] as? NSArray)!
                        self.myOrdertableview.reloadData()
                        self.noOrderView.isHidden = true
                        self.myOrdertableview.isHidden = false
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            self.noOrderView.isHidden = false
                            self.myOrdertableview.isHidden = true
                        }
                        
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func getCustomOrder()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? ""
                //"customer_id" : "1"
        ]
        print (parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        let Url = String(format: "%@product/productdetails/customProductList",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                            self.orderArray = (JSON["result"] as? NSArray)!
                           self.myOrdertableview.reloadData()
                            self.noOrderView.isHidden = true
                            self.myOrdertableview.isHidden = false
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            self.noOrderView.isHidden = false
                            self.myOrdertableview.isHidden = true
                        }
                        
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return orderArray.count
    }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyOrderTableViewCell =  myOrdertableview.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as!MyOrderTableViewCell
        cell.selectionStyle = .none
        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        
    if selectedOrder == 1{
        cell.mCancelBtn.isHidden = true
        cell.mReorderBtn.isHidden = true
        cell.trackBtn.isHidden = true
        cell.mCancel2Btn.isHidden = true
    }
        else{
        cell.mCancelBtn.isHidden = false
        cell.mReorderBtn.isHidden = false
        cell.trackBtn.isHidden = false
        cell.mCancel2Btn.isHidden = true
        }
        let dict = self.orderArray [indexPath.row] as? NSDictionary
      
        if selectedOrder == 0{
        
            cell.OrderNumberlabel.text = String(format : "Order Id : %@",(dict![ "order_id"] as? String)!)
            cell.OrderDatelabel.text = String(format : "Order Date : %@",(dict![ "date_added"] as? String)!)
        
            cell.OrderStatuslabel.text = dict!["status"] as? String
        let todayDate = Date()
            let deliveryDateString = dict!["delivery_date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let deliveryDate = dateFormatter.date(from:deliveryDateString!)
        
            let cancel =  dict!["cancel"] as? String
        if(cancel == "0")
        {
            cell.mCancelBtn.isHidden = true
        }
        else{
            cell.mCancelBtn.isHidden = false
        //    let calendar = Calendar.current
//            if(calendar.isDateInTomorrow(deliveryDate!))
//            {
//                NSLog("Yes Tomorrow")
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "hh:mm"
//                let currentTime: String = dateFormatter.string(from: todayDate)
//                print("My Current Time is \(currentTime)")
//                if(currentTime >= "04:00")
//                {
//                    cell.mCancelBtn.isHidden = true
//                }
//            }
    }
      //  let cancel =  dict!["cancel"] as? String
        if(cancel == "0")
        {
            cell.mCancelBtn.isHidden = true
        }
        else{
            cell.mCancelBtn.isHidden = false
        }
//        let paynow =  dict!["payment_status"] as? String
//        if(paynow == "0")
//        {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            let DateInFormat = dateFormatter.string(from: todayDate)
//            let convertedTodayDate = dateFormatter.date(from:DateInFormat)
//            if(convertedTodayDate == deliveryDate)
//            {
//                cell.mPayNowBtn.isHidden = false
//            }
//            else
//            {
//                cell.mPayNowBtn.isHidden = true
//            }
//        }
//        else{
//            cell.mPayNowBtn.isHidden = true
//        }
            if(dict!["status"] as? String == "Pending")
        {
            cell.OrderStatuslabel.textColor = UIColor(red:0.99, green:0.47, blue:0.21, alpha:1.0)
            cell.mReorderBtn.isHidden = true
            cell.mCancelBtn.isHidden = false
        }
            else if(dict!["status"] as? String == "Canceled" || dict!["status"] as? String == "Canceled Reversal")
        {
            cell.OrderStatuslabel.textColor = UIColor.red
        }
            else if(dict!["status"] as? String == "Complete")
        {
            cell.OrderStatuslabel.text = "Delivered"
            cell.OrderStatuslabel.textColor = UIColor(red:0.00, green:1.0, blue:0.00, alpha:1.0)
            cell.mReorderBtn.isHidden = false
            cell.mCancelBtn.isHidden = true
            cell.trackBtn.isHidden = true
        }
            else if(dict!["status"] as? String == "Shipped")
            {
                cell.OrderStatuslabel.textColor = UIColor(red:0.92, green:0.203, blue:0.207, alpha:1.0)
                cell.mReorderBtn.isHidden = false
                cell.mCancelBtn.isHidden = true
                cell.trackBtn.isHidden = false
            }
            
            
            cell.mReorderBtn.isHidden = false
            
            
            
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd"
//
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "EEE,MMM d,yy"
//
//        let date: NSDate? = dateFormatterGet.date(from: (dict![ "delivery_date"] as? String ?? "2019-09-18 09:10:17"))! as NSDate
//
//
//        print(dateFormatterPrint.string(from: date! as Date))
//        cell.OrderDatelabel.text = String(format :"Delivered on %@",dateFormatterPrint.string(from: date! as Date))
//            if(dict!["status"] as? String == "Canceled")
//        {
//            cell.OrderDatelabel.text = "Order Canceled"
//        }
//        print(dateFormatterPrint.string(from: date! as Date))
            
        cell.mCancelBtn.tag = indexPath.row
        cell.mCancelBtn.addTarget(self, action:#selector(cancelBtnAction(_:)), for: UIControlEvents.touchUpInside)
       cell.mReorderBtn.tag = indexPath.row
       cell.mReorderBtn.addTarget(self, action:#selector(reOrderBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mDetailsBtn.tag = indexPath.row
        cell.mDetailsBtn.addTarget(self, action:#selector(detailsBtnAction(_:)), for: UIControlEvents.touchUpInside)
            cell.trackBtn.addTarget(self, action:#selector(trackOrderBTnAction(_:)), for: UIControlEvents.touchUpInside)
            
//        cell.mPayNowBtn.tag = indexPath.row
//        cell.mPayNowBtn.addTarget(self, action:#selector(payNowBtnAction(_:)), for: UIControlEvents.touchUpInside)
           
        }
        else{
            switch (dict!["approve_status"] as! NSString).integerValue{
            case 0:
                
                cell.OrderStatuslabel.text = "Pending"
                cell.OrderStatuslabel.textColor = UIColor(red:193/255.0, green:152/255.0, blue:80/255.0, alpha:1.0)
                
                break
            case 1:
                
                cell.OrderStatuslabel.text = "Confirm Order"
                cell.OrderStatuslabel.textColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0)

                
                break
            case 2:
                
                cell.OrderStatuslabel.text = "Rejected"
                cell.OrderStatuslabel.textColor = UIColor.red
                break
                
            default:
                print("default")
            }
            cell.OrderNumberlabel.text = String(format : "Order Id : %@",(dict![ "product_id"] as? String)!)
            cell.OrderDatelabel.text = String(format : "Order Date : %@",(dict![ "date_added"] as? String)!)
//            let dateFormatterGet = DateFormatter()
//            dateFormatterGet.dateFormat = "yyyy-MM-dd"
//
//            let dateFormatterPrint = DateFormatter();            dateFormatterPrint.dateFormat = "EEE,MMM d,yy"
//
//          let date: NSDate? = dateFormatterGet.date(from: (dict![ "date_added"] as? String)!)! as NSDate
//          print(dateFormatterPrint.string(from: date! as Date))
//            cell.OrderDatelabel.text = String(format :"Order Date %@",dateFormatterPrint.string(from: date! as Date))
 //           let dateFormatterGet = DateFormatter()            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

//let dateFormatterPrint = DateFormatter()
 //           dateFormatterPrint.dateFormat = "MMM dd,yyyy"

  //          if let date = dateFormatterGet.date(from: dict![ "date_added"] as? //String ?? "  ") {
  //              print(dateFormatterPrint.string(from: date))/                cell.OrderDatelabel.text = String(format :"Order Placed on %@",dateFormatterPrint.string(from: date))

        
//        else
//         {
//                print("There was an error decoding the string")
//           }
        }


            if((dict!["approve_status"] as? NSString)?.integerValue == 2)
            {
                cell.OrderDatelabel.text = "Order Rejected"
            }
//            cell.mCancelBtn.tag = indexPath.row
//            cell.mCancelBtn.addTarget(self, action:#selector(cancelBtnAction(_:)), for: UIControlEvents.touchUpInside)
//            cell.mDetailsBtn.tag = indexPath.row
            cell.mDetailsBtn.addTarget(self, action:#selector(detailsBtnAction(_:)), for: UIControlEvents.touchUpInside)
           // cell.mReorderBtn.isHidden = true
            
            
        
        
        return cell
        
    }

    
    func removeNullFromDict (dict : NSMutableDictionary) -> NSMutableDictionary
    {
        let dic = dict;
        
        for (key, value) in dict {
            
            let val : NSObject = value as! NSObject;
            if(val.isEqual(NSNull()))
            {
                dic.setValue("", forKey: (key as? String)!)
            }
            else
            {
                dic.setValue(value, forKey: key as! String)
            }
            
        }
        
        return dic;
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @IBAction func cartBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @objc func cancelBtnAction (_ sender: UIButton)
    {
        cancelIndex = sender.tag
        self.mCancelBtn.layer.cornerRadius = 5
        self.mCancelBtn.layer.borderWidth = 1
        self.mCancelBtn.layer.borderColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0).cgColor
        self.cancelPopUpView.frame = self.view.frame
        self.view .addSubview(self.cancelPopUpView)
    }
    @objc func reOrderBtnAction (_ sender: UIButton)
    {
//        let dict = self.orderArray [sender.tag] as? NSDictionary
//       // let orderID = dict![ "order_id"] as? String
//        let productID = dict![ "product_id"] as? String
//         let orderID = String(format : "orderID : %@",(dict![ "product_id"] as? String)!)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductOneVC") as? ProductOneVC
//        myVC?.orderID = orderID
//        self.navigationController?.pushViewController(myVC!, animated: false)

        let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        mOrderID = orderID
        self.mReorderCancelBtn.layer.cornerRadius = 5
        self.mReorderCancelBtn.layer.borderWidth = 1
        self.mReorderCancelBtn.layer.borderColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0).cgColor
        self.reOrderPopUpView.frame = self.view.frame
        self.view .addSubview(self.reOrderPopUpView)
    }
    @objc func detailsBtnAction (_ sender: UIButton)
    {
        if (selectedOrder == 0){
        
        let dict = self.orderArray [sender.tag] as? NSDictionary
        
        let orderID = dict![ "order_id"] as? String
        let status = dict!["status"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ItemsDetailsVC") as? ItemsDetailsVC
        myVC?.orderID = orderID
        myVC?.status = status
        self.navigationController?.pushViewController(myVC!, animated: false)
            
        }
        else{
            
            let dict = self.orderArray [sender.tag] as? NSDictionary
            let orderID = dict![ "product_id"] as? String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "CustomOrderDetailVC") as? CustomOrderDetailVC
            myVC?.customProductId = orderID!
            self.navigationController?.pushViewController(myVC!, animated: false)
            //CustomOrderDetailVC
        }
    }
    //trackOrderBTnAction
    @objc func trackOrderBTnAction (_ sender: UIButton){
        
       let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "TrackOrderVC") as? TrackOrderVC
        myVC?.orderId = orderID!
        self.navigationController?.pushViewController(myVC!, animated: false)
        
        
    }
    @objc func payNowBtnAction (_ sender: UIButton)
    {
        let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutPayNowVC") as? CheckOutPayNowVC
        myVC?.orderID = orderID
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.reOrderPopUpView.removeFromSuperview()
        self.cancelPopUpView.removeFromSuperview()
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        if(selectedOrder == 0 )
        {
        getMyOrders()
        }
        else if(selectedOrder == 1 )
        {
         getCustomOrder()
        }
        self.refreshControl.endRefreshing()
    }
    @IBAction func confirmBtnAction(_ sender: UIButton)
    {
        self.cancelPopUpView.removeFromSuperview()
        let dict = self.orderArray [cancelIndex!] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let Url = String(format: "%@api/custom/CancelOrder",Constants.BASEURL)
        print(Url)
        let parameters: Parameters =
        [
            "order_id" : orderID ?? "",
            "customer_id" : userID ?? ""
        ]
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        SKActivityIndicator.show("Loading...")
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
                            self.getMyOrders()
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
    @IBAction func checkBtnAction(_ sender: UIButton)
    {
        self.reOrderPopUpView.removeFromSuperview()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // var id : String = ""
        let myVC = storyboard.instantiateViewController(withIdentifier: "OrderItemsVC") as? OrderItemsVC
        myVC?.orderID = mOrderID
//        myVC?.ProductID = id
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

