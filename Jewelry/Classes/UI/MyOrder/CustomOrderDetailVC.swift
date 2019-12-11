//
//  CustomOrderDetailVC.swift
//  Jewelry
//
//  Created by Febin Puthalath on 10/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire



class CustomOrderDetailVC: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var discountedPriceLbl: UILabel!
    @IBOutlet weak var confirmorderBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var diclaimerLabel: UILabel!
    @IBOutlet weak var discText: UITextView!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var sizeTF: UITextField!
    
    @IBOutlet weak var polishTF: UITextField!
    @IBOutlet weak var QtyTF: UITextField!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var categoryIdLbl: UILabel!
    var ProductID  : String!
    
    var slideCount : Int?
    var customProductId = String()
    var imageArray = [[String:String]]()
    var tempArray : NSArray = []
    var polishArray : NSArray = []
    var sizeArray : NSArray = []
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
        
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.productCollectionView.register(UINib(nibName: "customOrderCell", bundle: nil), forCellWithReuseIdentifier: "customOrderCell")
        categoryTF.layer.borderColor = UIColor.lightGray.cgColor
        categoryTF.layer.borderWidth = 1.0
        categoryTF.setLeftPaddingPoints(10)
        categoryTF.isUserInteractionEnabled = false
        
        polishTF.layer.borderColor = UIColor.lightGray.cgColor
        polishTF.layer.borderWidth = 1.0
        polishTF.setLeftPaddingPoints(10)
        polishTF.isUserInteractionEnabled = false
        
        sizeTF.layer.borderColor = UIColor.lightGray.cgColor
        sizeTF.layer.borderWidth = 1.0
        sizeTF.setLeftPaddingPoints(10)
        sizeTF.isUserInteractionEnabled = false
        
        weightTF.layer.borderColor = UIColor.lightGray.cgColor
        weightTF.layer.borderWidth = 1.0
        weightTF.setLeftPaddingPoints(10)
        weightTF.isUserInteractionEnabled = false
        
        discText.layer.borderColor = UIColor.lightGray.cgColor
        discText.layer.borderWidth = 1.0
        discText.isUserInteractionEnabled = false
        
        callForProductdetail()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func cancelBtnClk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmBtnClk(_ sender: Any) {
        if(self.QtyTF.text == "")
        {
            self.view.makeToast("Please Enter Quantity")
            return
        }
        //self.tempArray = response["result"] as? NSArray
        let tempDict = self.tempArray[0] as? NSDictionary
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        var PolishID : String!
        var PolishValueID : String!
        var isPolishValueAvailable : Bool = false
        
        let polish = (tempDict!["polish"] as? [[String:AnyObject]])
        let size =  (tempDict!["admin_size"] as? [[String:AnyObject]])
        if(polish as? String == "null" && size as? String == "null")
        {
        }
        else{
            var polishArray = tempDict!["polish"] as? NSArray
            if((polishArray?.count)! > 0)
            {
                var polishDict = self.polishArray[0] as? NSDictionary
                PolishID = polishDict!["product_option_id"] as? String
                PolishValueID = polishDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
            }
        }
        if(size as? String == "null" && size as? String == "null")
        {
        }
        else{
            var SizeArray = tempDict!["admin_size"] as? NSArray
            if((SizeArray?.count)! > 0)
            {
                var sizeDict = SizeArray![0] as? NSDictionary
                optionID = sizeDict!["product_option_id"] as? String
                optionValueID = sizeDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
            }
        }
    SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/add&api_token=api/cart/products&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : customProductId ?? "",
                "quantity" : self.QtyTF.text ?? "",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? "",
                "product_option_id_polish" : PolishID ?? "",
                "product_option_value_id_polish" : PolishValueID ?? "",
                "buy_now_flag" :"0"
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : self.ProductID ?? "",
                "quantity" : "1",
            ]
        }
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
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let myVC = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as? MyCartVC
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell: customOrderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customOrderCell", for: indexPath) as! customOrderCell
        //cell.selectionStyle = .none
        cell.bgView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.bgView.layer.shadowOpacity = 0.6
        cell.bgView.layer.shadowRadius = 3.0
        cell.bgView.layer.cornerRadius = 5.0
        
        
        let dict = self.imageArray[indexPath.row]
        
        var image = dict["image"] 
        if(image != nil){
            image = image?.replacingOccurrences(of: " ", with: "%20")
            cell.productImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "defaultImage"))
        }
        
        return cell
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == self.productCollectionView)
        {
            for cell in self.productCollectionView.visibleCells  as! [customOrderCell]    {
                let indexPath = self.productCollectionView.indexPath(for: cell as UICollectionViewCell)
                self.slideCount = (indexPath?.item)!
                self.pageController.currentPage = self.slideCount!
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CustomOrderDetailVC{
    func callForProductdetail(){
        SKActivityIndicator.show("Loading...")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters =
            [
                "customer_id" : userID ?? "",
                //"customer_id" : "1",
                "product_id" : customProductId
                ] as [String : Any]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl:"product/productdetails/customProductDetails", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "success"){
                    self.tempArray = (response["result"] as? NSArray)!
                    let tempDict = self.tempArray[0] as? NSDictionary
                    self.imageArray = (tempDict!["image"] as? [[String:String]])!
                    self.categoryIdLbl.text = tempDict!["name"] as? String
                    self.categoryTF.text = tempDict!["category"] as? String
                    self.polishArray = (tempDict!["polish"] as? NSArray)!
                    //let polishDict = self.tempDict!["polish"] as? NSArray
                    self.polishTF.text = tempDict!["customer_given_polish"] as? String
                    self.sizeArray = (tempDict!["admin_size"] as? NSArray)!
                    
                    let size = (tempDict!["customer_given_size"] as? NSString)?.doubleValue
                    self.sizeTF.text =   String(format:"%.2f",size!)
                    //self.sizeTF.text = String(format : "%@.2f",tempDict!["customer_given_size"] as? String ?? "")
                    let weight = (tempDict!["customer_given_weight"] as? NSString)?.doubleValue
                    
                    self.weightTF.text =   String(format:"%.2f","gm%@",weight!)
                    //self.weightTF.text = tempDict!["customer_given_weight"] as? String
                    //self.weightTF.text = String(format: "%dgm", tempDict!["weight"] as!Int)
                    self.priceLbl.text = String(format : "%@",tempDict!["admin_price"] as? String ?? "")
//
                    self.discText.text = tempDict!["description"] as? String
                    
                    // self.polishTF.text = tempDict![
                    self.pageController.numberOfPages = self.imageArray.count
                    self.productCollectionView.reloadData()
                    
                    
//                    let discountSting = String(format : "%@",sizedict!["discount_price"] as? String ?? "")
//                    let discountDouble =  Double (discountSting)
//                    var attributeString = NSMutableAttributedString()
//                    if((discountDouble) != nil)
//                    {
//                        let discount = String(format : "₹%.2f",discountDouble!)
//                         attributeString = NSMutableAttributedString(string: discount)
//                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                        self.priceLbl.attributedText = attributeString
//
//                    }
                
                    
                   
                    
                   
                }
                else{
                    self.view.makeToast(response["message"]as?String)
                   
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }
        
    }
    
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
}
