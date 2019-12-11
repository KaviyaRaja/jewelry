//
//  WishListVC.swift
//  ECommerce
//
//  Created by Apple on 11/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class WishListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var wishlistTableview: UITableView!
    @IBOutlet weak var mProductsCountLabel : UILabel!
    @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    
    var wishlistArray : NSArray = []
    var refreshControl = UIRefreshControl()
    
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

     wishlistTableview.register(UINib(nibName: "WishListCell", bundle: .main), forCellReuseIdentifier: "WishListCell")
        
         getWishList()
        getCartCount()
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
        self.mCartCountLabel.layer.masksToBounds = true
        
       refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
         
        self.wishlistTableview.addSubview(refreshControl)
    }
    
    @IBAction func cartBtnClk(_ sender: Any) {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
            self.navigationController?.pushViewController(myVC!, animated: true)
        
        
    }
    
    
    @IBAction func uploadImageBtnClk(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "uploadPicVC") as? uploadPicVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    
    @IBAction func menuBtnClk(_ sender: Any) {
    }
    
    
    
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getWishList()
        self.refreshControl.endRefreshing()
    }
    func getCartCount()
    {
        let Url = String(format: "%@api/cart/cartcount&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
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
                            self.mCartCountLabel.text = JSON["data"] as? String
                            if(self.mCartCountLabel.text == "0")
                            {
                                self.mCartCountLabel.isHidden = true
                            }
                            else
                            {
                                self.mCartCountLabel.isHidden = false
                            }
                        }
                        else
                        {
                            //self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    func getWishList()
    {
        
        SKActivityIndicator.show("Loading...")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")

        let parameters  =
            [
                "customer_id" : userID ?? ""

                
                ]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "account/wishlist/wishListProducts", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "failure"){
                    
                    self.wishlistArray = []
                    self.wishlistTableview.reloadData()
                    self.view.makeToast(response["message"] as? String)
                }
                    
                    
                    
                    
                else{if  (response["status"] as? String == "success"){
                        
                        
                    let result = response["result"] as? AnyObject
                    if(result as? String == "null")
                    {
                        return
                    }
                    self.wishlistArray = (response["result"] as? NSArray)!
                    
                    self.mCartCountLabel.text = String(format: "%d Products found",self.wishlistArray.count)
                    self.wishlistTableview.reloadData()
                    //self.mProductsCountLabel.text = String(format: "%d items",self.wishlistArray.count)
                        
                        
                    }
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }
        
        
      
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return wishlistArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WishListCell =  wishlistTableview.dequeueReusableCell(withIdentifier: "WishListCell", for: indexPath) as! WishListCell
        cell.selectionStyle = .none
        cell.mBgView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        let dict = self.wishlistArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.wishProductLabel.text = dict![ "name"] as? String
        //cell.wishkgLabel.text = dict![ "quantity"] as? String
        cell.wishlistImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        cell.wishPriceLable.text = String(format : "₹%.2f",priceDouble!)
        var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
        if(discount == "null" || discount == "0" )
        {
            cell.wishattributeLabel.isHidden = true
        }
        else
        {
            
            let discountPrice = String(format: "₹%.2f",  Double(dict!["discount_price"] as! String)!)
            cell.wishattributeLabel.attributedText = self.makeAttributedString(text: discountPrice, linkTextWithColor:String(discountPrice))
        }
         let offerPrice = dict!["offer"]
            if(offerPrice as? String == "null" || offerPrice as? String == "0" )
            {
                cell.wishofferLabel.isHidden = true
            }
            else{
                 let offerPrice =  String(dict!["offer"] as! String) + " %%off"
            
             cell.wishofferLabel.text = String(format : offerPrice)
        }
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action:#selector(removeBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.moveCartBtn.tag = indexPath.row
        cell.moveCartBtn.addTarget(self, action:#selector(moveBtnAction(_:)), for: UIControlEvents.touchUpInside)
      
        cell.rateLabel.text = String(dict!["rating"] as! String)+" ⃰"
        cell.userRateLabel.text = dict!["users_rating"] as? String

        return cell
        
    }
    
//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        let dict = self.wishlistArray[indexPath.row] as? NSDictionary
//        let productID = dict![ "product_id"] as? String
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "SingleProductVC") as? SingleProductVC
//        //myVC?.productID = productID! as NSString
//        self.navigationController?.pushViewController(myVC!, animated: false)
//}
    
    func makeAttributedString(text:String , linkTextWithColor:String) ->NSMutableAttributedString {
        // let text =  "Emi per month: RS" + String(format: "%.2f", Emi!)
        
        // let linkTextWithColor = "RS" + String(format: "%.2f", Emi!)
        
        let range = (text as NSString).range(of: linkTextWithColor)
        
        //        let attributedString = NSMutableAttributedString(string:text)
        //        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range)
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: range)
        attributedString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.gray, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray , range: range)
        
        //NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length)
        // emiLabel.attributedText = attributedString
        
        
        
        return attributedString
    }
    @objc func removeBtnAction (_ sender: UIButton)
    {
        let dict = self.wishlistArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "product_id" : productID
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
                            self.getWishList()
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
    @objc func moveBtnAction (_ sender: UIButton)
    {
        let dict = self.wishlistArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@account/wishlist/insertWishListToCart",Constants.BASEURL)
        
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let sessionID =  UserDefaults.standard.string(forKey: "api_token")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "session_id" : sessionID ?? ""
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
                            self.getWishList()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}




