//
//  HomeVC.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

extension String {
    var isInteger: Bool { return Int(self) != nil }
    var isFloat: Bool { return Float(self) != nil }
    var isDouble: Bool { return Double(self) != nil }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UISegmentedControl {
    
    func removeBorder(){
        
        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor :UIColor(red: 229/255.0, green: 66/255.0, blue: 153/255.0, alpha: 1)], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        
    }
    

    
   
}

class HomeVC: UIViewController,IQDropDownTextFieldDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mCategoryCollectionView: UICollectionView!
    @IBOutlet weak var mDealCollectionView: UICollectionView!
    @IBOutlet weak var mRecommendedCollectionView: UICollectionView!
   // @IBOutlet weak var mDealsView: UIView!
   // @IBOutlet weak var ProductsView: UIView!
   // @IBOutlet weak var mRecommendedView: UIView!
    @IBOutlet weak var profileImage : UIImageView!
   // @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var mPageCtrl : UIPageControl!
    @IBOutlet var mRateView: UIView!
    @IBOutlet var mRateLikeView: UIView!
    @IBOutlet var mRateUnLikeView: UIView!
    @IBOutlet weak var mRateLikeImage : UIImageView!
    @IBOutlet weak var mRateUnLikeImage : UIImageView!
    @IBOutlet weak var mRateLikeBtn : UIButton!
    @IBOutlet weak var mRateUnLikeBtn : UIButton!
    @IBOutlet weak var mCartCountLabel : CustomFontLabel!
   // @IBOutlet weak var mlayout1TableView : UITableView!
   // @IBOutlet weak var mlayout1CollectionView: UICollectionView!
    //@IBOutlet weak var mlayoutHeaderLabel : CustomFontLabel!
   // @IBOutlet weak var layoutHeight: NSLayoutConstraint!
    //@IBOutlet weak var layout2Height: NSLayoutConstraint!
    // @IBOutlet var moffer2View: UIView!
   // @IBOutlet var mOfferLabelView: UIView!
   // @IBOutlet var mOffer1View: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var slideCount : Int?
    var bannerArray : NSArray = []
    var productsArray : NSArray = []
    var categoryArray : NSArray = []
    var recommendedArray : NSArray = []
    var whishlistArray : NSArray = []
    var mProductID : String!
   
    var layout1Array : NSArray = []
    var layout2Array : NSArray = []
    var collectionType : NSString = ""
    
    
    let segmentBottomBorder = CALayer()
    var imageDataArray = [UIImage]()
    var bannerImageArray=[[String:Any]]()
    var defaultTitle = "   "
    var selectedCateroy = 1
    var selectedview = ""
    var timer:Timer = Timer()

    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    override func viewDidLoad()
    {
        
        
        if #available(iOS 13, *){
                     let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                     statusBar.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
                     UIApplication.shared.keyWindow?.addSubview(statusBar)
                 }
        else {
            UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.98, green:0.17, blue:0.61, alpha:1.0)
        }
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        segmentControl.removeBorder()
        setBorder(sender: segmentControl)
        
       // scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height-120)

         self.bannerCollectionView.delegate = self
        self.bannerCollectionView.dataSource = self
        self.bannerCollectionView.register(UINib(nibName: "SliderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
       self.mDealCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
        self.mCategoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        self.mRecommendedCollectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionViewCell")
//        self.mlayout1TableView.register(UINib(nibName: "layout1TableViewCell", bundle: .main), forCellReuseIdentifier: "layout1TableViewCell")
//        self.mlayout1CollectionView.register(UINib(nibName: "layout2CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "layout2CollectionViewCell")
//        self.contentHeight.constant = 780
//
//
//
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2;       self.mCartCountLabel.layer.masksToBounds = true
//
//        let myColor = UIColor.lightGray
        
//        self.mOffer1View.layer.shadowColor = UIColor.lightGray.cgColor
//        self.mOffer1View.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mOffer1View.layer.shadowOpacity = 0.6
//        self.mOffer1View.layer.shadowRadius = 3.0
//        self.mOffer1View.layer.cornerRadius = 5.0
//        mOffer1View.layer.borderColor = UIColor.lightGray.cgColor
//        mOffer1View.layer.borderWidth = 1.0
        
//
//        mOfferLabelView.layer.borderColor = myColor.cgColor
//        mOfferLabelView.layer.borderWidth = 1.0
//
//
//        self.moffer2View.layer.shadowColor = UIColor.lightGray.cgColor
//        self.moffer2View.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.moffer2View.layer.shadowOpacity = 0.6
//        self.moffer2View.layer.shadowRadius = 3.0
//        self.moffer2View.layer.cornerRadius = 5.0
//        self.moffer2View.layer.borderColor = UIColor.lightGray.cgColor
//        self.moffer2View.layer.borderWidth = 1.0
//
//        self.mlayout1TableView.layer.shadowColor = UIColor.lightGray.cgColor
//        self.mlayout1TableView.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mlayout1TableView.layer.shadowOpacity = 0.6
//        self.mlayout1TableView.layer.shadowRadius = 3.0
//        self.mlayout1TableView.layer.cornerRadius = 5.0
      
        

       
    }
    @IBAction func mUploadBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "uploadPicVC") as? uploadPicVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         getData()
        getCartCount()
        
        
        
        
        
        
        
//        let profileTapped =  UserDefaults.standard.string(forKey: "isProfileTapped")
//        if(profileTapped == "1")
//        {
//            UserDefaults.standard.setValue("0", forKey: "isProfileTapped")
//        }
//        else
//        {
////            getData()
////            getCartCount()
//        }
//
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showRateView), name: NSNotification.Name("ShowRate"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.RefreshPic), name: NSNotification.Name("RefreshPic"), object: nil)
//
//        var image = UserDefaults.standard.string(forKey: "ProfilePic")
//        if(image != nil){
//            if(image == "0")
//            {
//                image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
//            }
//            else
//            {
//                image = image?.replacingOccurrences(of: " ", with: "%20")
//            }
//            self.profileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
//            self.profileImage.layer.masksToBounds = true
//        }
//
    }
    
    @IBAction func menuSegmentSelected(_ sender: Any) {
        segmentBottomBorder.removeFromSuperlayer()
        selectedCateroy = segmentControl.selectedSegmentIndex+1
        timer.invalidate()
        getData()
        setBorder(sender: segmentControl)
    }
    
    
    func setBorder(sender:UISegmentedControl){
        
        let underlineWidth: CGFloat = sender.bounds.size.width / CGFloat(sender.numberOfSegments)
        let underlineHeight: CGFloat = 2
        let underlineXPosition = CGFloat(sender.selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = sender.bounds.size.height - underlineHeight
       segmentBottomBorder.frame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        //let underline = UIView(frame: underlineFrame)
        segmentBottomBorder.backgroundColor = UIColor(red: 229/255.0, green: 66/255.0, blue: 153/255.0, alpha: 1).cgColor
        sender.layer.addSublayer(segmentBottomBorder)
        
    }
    
    func startTimer() {
        
        timer =  Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)

                if ((indexPath?.row)! < bannerArray.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    self.mPageCtrl.currentPage = indexPath1!.row

                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    self.mPageCtrl.currentPage = indexPath1!.row


                }

            }
        }
    }
    
    
    
    
    
    
    
//    @objc func RefreshPic()
//    {
//        var image = UserDefaults.standard.string(forKey: "ProfilePic")
//        if(image != nil){
//            if(image == "0")
//            {
//                image = "http://3.213.33.73/Ecommerce/upload/image/backend/profile.png"
//            }
//            else
//            {
//                image = image?.replacingOccurrences(of: " ", with: "%20")
//            }
//            self.profileImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "Rectangle"))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
//            self.profileImage.layer.masksToBounds = true
//        }
//    }
//    @objc func showRateView()
//    {
//        self.mRateView.frame = self.view.frame
//        self.view.addSubview(self.mRateView)
//
//        self.mRateLikeView.layer.shadowColor = UIColor.darkGray.cgColor
//        self.mRateLikeView.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mRateLikeView.layer.shadowOpacity = 0.6
//        self.mRateLikeView.layer.shadowRadius = 3.0
//        self.mRateLikeView.layer.cornerRadius = 5.0
//        self.mRateLikeBtn.isSelected = false
//
//        self.mRateUnLikeView.layer.shadowColor = UIColor.darkGray.cgColor
//        self.mRateUnLikeView.layer.shadowOffset = CGSize(width: 1, height:3)
//        self.mRateUnLikeView.layer.shadowOpacity = 0.6
//        self.mRateUnLikeView.layer.shadowRadius = 3.0
//        self.mRateUnLikeView.layer.cornerRadius = 5.0
//        self.mRateUnLikeBtn.isSelected = false
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @objc func wishListBtnAction(_ sender: UIButton)
    {
        let dict = self.recommendedArray[sender.tag] as? NSDictionary
       // let dict = self.productsArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
       SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(dict!["wishlist_status"] as? String == "1")
        {
            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        }
        else
        {
            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
        }
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
                            self.getData()
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
    @objc func dealwishListBtnAction(_ sender: UIButton)
    {
        let dict = self.productsArray[sender.tag] as? NSDictionary
        // let dict = self.productsArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(dict!["wishlist_status"] as? String == "1")
        {
            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        }
        else
        {
            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
        }
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
                            self.getData()
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
    
    @IBAction func myCart(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func searchBtnAction(_ sender: UIButton)
    {
        UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    @IBAction func ViewAllBtn(_ sender: UIButton) {
        
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
        myVC!.selectedCategory = String(sender.tag)
        if(sender.tag == 1)
                {
                    myVC?.selectedview  = "2"
                }
                else if(sender.tag == 2)
                {
                   myVC?.selectedview  = "3"
                }
        myVC?.type = "ViewAll"
        self.navigationController?.pushViewController(myVC!, animated: true)
       
    }
    
    func getviewAll()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/homepageViewAll",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "view_all_id" : selectedview,
                "category_type_id" : selectedCateroy
        ]
        //as [String : Any]
        
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
                            let result = JSON["result"] as? AnyObject
                            UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
                           
                            //                                if(result == nil || result as? String == "null")
                            //                                {
                            //                                }
                            //                                else
                            //                                {
                            //                                    self.itemsArray = (JSON["result"] as? NSArray)!
                            //                                    //                        self.mProductsCountLabel.text = String(format: "%d Products found",self.itemsArray.count)
                            //                                    self.listcollectionview.reloadData()
                            
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
//    @IBAction func viewAllBtnAction(_ sender: UIButton)
//    {
//        UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
//        if(sender.tag == 1)
//        {
//            myVC?.selectedCategory  = "1"
//        }
//        else if(sender.tag == 2)
//        {
//            myVC?.selectedCategory  = "2"
//        }
//
//        self.navigationController?.pushViewController(myVC!, animated: true)
//    }
    @IBAction func removeBtnAction(_ sender: Any)
    {
        self.mRateView.removeFromSuperview()
    }
    @IBAction func rateLikeBtnAction(_ sender: Any)
    {
        if(self.mRateLikeBtn.isSelected)
        {
            self.mRateLikeBtn.isSelected = false
            self.mRateLikeImage.image = UIImage(named: "Ratelike")
            
        }
        else
        {
            self.mRateLikeBtn.isSelected = true
            self.mRateLikeImage.image = UIImage(named: "Like-pink")
            self.mRateUnLikeBtn.isSelected = false
            self.mRateUnLikeImage.image = UIImage(named: "Rateunlike")
            
        }
    }
    @IBAction func rateUnLikeBtnAction(_ sender: Any)
    {
        if(self.mRateUnLikeBtn.isSelected)
        {
            self.mRateUnLikeBtn.isSelected = false
            self.mRateUnLikeImage.image = UIImage(named: "Rateunlike")
        }
        else
        {
            self.mRateUnLikeBtn.isSelected = true
            self.mRateUnLikeImage.image = UIImage(named: "Like-pink")
            self.mRateLikeBtn.isSelected = false
            self.mRateLikeImage.image = UIImage(named: "Ratelike")
            
        }
    }
    @IBAction func submitBtnAction(_ sender: Any)
    {
        if(self.mRateLikeBtn.isSelected == false && self.mRateUnLikeBtn.isSelected == false)
        {
            self.view.makeToast("Please choose your feeback")
            return
        }
        submitRate()
    }

    
    // MARK: - API
    
    func getData()
    {
        
        SKActivityIndicator.show("Loading...")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters =
                    [
                        "customer_id" : userID ?? "",
                        //"customer_id" : "1",
                        "category_parent_id" : selectedCateroy
                        ] as [String : Any]
        
        SKActivityIndicator.dismiss()
        
        print (parameters)
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/custom/homepageForAndroid", withParam: parameters) { (isSuccess, response) in
            // Your Will Get Response here
            
            SKActivityIndicator.dismiss()
            
            print(response)
            
            
            if  isSuccess{
                
                
                print("details:",response)
                
                
                if  (response["status"] as? String == "error"){
                    
                    self.view.makeToast( response["message"] as? String)
                    
                }
                    
                    
                    
                    
                else{
                    
                    if  (response["status"] as? String == "success"){
                        self.startTimer()
                        self.bannerArray = (response["banner"] as? NSArray)!
                        self.bannerCollectionView.reloadData()
                        self.mPageCtrl.numberOfPages = self.bannerArray.count
                        self.categoryArray = (response["categorylist"] as? NSArray)!
                        self.mCategoryCollectionView.reloadData()
//                        var dealofday = (response["dealoftheday"] as? AnyObject)
//                        if(dealofday! as! String == "null")
//                        {
////                            self.SimilarHeightConstraint.constant = 0
////                            self.SimilarHeight.constant = 0
////                            self.ViewAllHeight.constant = 0
//                            self.mDealCollectionView.isHidden = true
//                            self.mDealCollectionView.reloadData()
//                        }
//                        else
//                        {
//                            self.mDealCollectionView.isHidden = false
//                           self.productsArray = (response["dealoftheday"] as? NSArray)!
//                            self.mDealCollectionView.reloadData()
//                        }
                        self.productsArray = (response["dealoftheday"] as? NSArray)!
                        self.mDealCollectionView.reloadData()
                        
                       self.recommendedArray = (response["recommended"] as? NSArray)!
                        self.mRecommendedCollectionView.reloadData()
                        
                    }
                }
            }
            else{
                self.view.makeToast("Issue with connecting to server")
                
            }
            
        }
        
        
        
        
        
        
        
        
//        SKActivityIndicator.show("Loading...")
//        let Url = String(format: "%@api/custom/homepageForAndroid",Constants.BASEURL)
//        print(Url)
//        let userID =  UserDefaults.standard.string(forKey: "customer_id")
//        let parameters: Parameters =
//        [
//            "customer_id" : userID ?? "",
//            //"customer_id" : "1",
//            "id" : "1"
//        ]
//        print(parameters)
//        let headers: HTTPHeaders =
//        [
//            "Content-Type": "application/json"
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
//                          self.bannerArray = (JSON["banner"] as? NSArray)!
//                          self.bannerCollectionView.reloadData()
////                        self.categoryArray = (JSON["dealoftheday"] as? NSArray)!
////                        self.mCategoryCollectionView.reloadData()
////                        self.productsArray = (JSON["products"] as? NSArray)!
////                        self.mDealCollectionView.reloadData()
////                        self.recommendedArray = (JSON["recommended"] as? NSArray)!
////                        self.mRecommendedCollectionView.reloadData()
//                       self.mPageCtrl.numberOfPages = self.bannerArray.count
////
////                        self.layout1Array = (JSON["layout1"] as? NSArray)!
////                        self.mlayout1TableView.reloadData()
////                        self.layout2Array = (JSON["layout2"] as? NSArray)!
////                        self.mlayout1CollectionView.reloadData()
////                        self.layoutHeight.constant = CGFloat(self.layout1Array.count * 100)
////                            self.layout2Height.constant = CGFloat(self.layout2Array.count/2 * 140 + 35)
////                        self.mlayoutHeaderLabel.text = JSON["layout2_title"] as? String
////                            self.contentHeight.constant = 780  +  self.layoutHeight.constant + self.layout2Height.constant
//                        }
//                        else
//                        {
//                               //self.view.makeToast(JSON["message"] as? String)
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

    }
    
    

//    func callWishListApi(parameter:[String:Any], url:String)  {
//
//        SKActivityIndicator.show("Loading...")
//
//
//        SKActivityIndicator.dismiss()
//
//        print (parameter)
//
//        NetworkClass.shared.postDetailsToServer(withUrl: url, withParam: parameter) { (isSuccess, response) in
//            // Your Will Get Response here
//
//            SKActivityIndicator.dismiss()
//
//            print(response)
//
//
//            if  isSuccess{
//
//
//                print("details:",response)
//
//
//                if  (response["status"] as? String == "error"){
//
//                    self.view.makeToast( response["message"] as? String)
//
//                }
//
//
//
//
//                else{
//
//                    if  (response["status"] as? String == "success"){
//
//                        self.getData()
//                    }
//                }
//            }
//            else{
//                self.view.makeToast("Issue with connecting to server")
//
//            }
//
//
//
//        //statements
//    }
//    }
    
    
    
    func submitRate()
    {
        var rateVlaue = ""
        if(self.mRateLikeBtn.isSelected)
        {
            rateVlaue = "1"
        }
        else{
            rateVlaue = "0"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/rateus/giveRateUs",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "rate" : rateVlaue
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
                            self.view.makeToast("Thanks for your Valuable Feedback!")
                            self.mRateView.removeFromSuperview()
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
}


extension HomeVC{


    
    // MARK: - CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(collectionView == self.bannerCollectionView)
        {
            return self.bannerArray.count
        }
        else if(collectionView == self.mCategoryCollectionView)
        {
            return self.categoryArray.count
        }
        else if(collectionView == self.mDealCollectionView)
        {
            return self.productsArray.count
        }
        else if(collectionView == self.mRecommendedCollectionView)
        {
            return self.recommendedArray.count
        }
//        else if(collectionView == self.mlayout1CollectionView)
//        {
//            return self.layout2Array.count
//        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var defaultCell : UICollectionViewCell!
        if(collectionView == self.bannerCollectionView)
        {
            let cell: SliderCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as! SliderCollectionViewCell
            let dict = self.bannerArray[indexPath.row] as? NSDictionary
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.imageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
                
            }
            return cell
        }
        
        else if(collectionView == self.mCategoryCollectionView)
        {
            let cell: CategoryCollectionViewCell     = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            
            let dict = self.categoryArray[indexPath.row] as? NSDictionary

            var image = dict!["category_image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.categoryImage.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            
            cell.titleLabel.text = dict!["category_name"] as? String
            return cell
        }
            
        else if(collectionView == self.mDealCollectionView)
{
            
           
            
            let cell: ProductCollectionViewCell     = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            
            cell.productContainerView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.productContainerView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.productContainerView.layer.shadowOpacity = 0.6
            cell.productContainerView.layer.shadowRadius = 3.0
            cell.productContainerView.layer.cornerRadius = 5.0
            
            
            let dict = self.productsArray[indexPath.row] as? NSDictionary
            
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.productImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.productTitleLabel.text = dict!["name"] as? String
            let rupee = "\u{20B9}"
            
            let price = String(format: "%.2f",  Double(dict!["price"] as! String)!)
             cell.offerPriceText.text = rupee + String(price)
          let offer = dict!["offer"]
         if offer as? String == "null" || offer as? String == "0"
             {
              cell.offerlbl.isHidden = true
             }
         else
             {
              cell.offerlbl.isHidden = false
               cell.offerlbl.text = dict!["offer"] as? String
           cell.offerlbl.text = String(format : "%@ %%off",dict!["offer"] as! String)
       }
    
            let discountPrice = String(format: "%.2f",  Double(dict!["discount_price"] as! String)!)

            
            let actualPrice = rupee + String(discountPrice) 
            cell.actualPriceText.attributedText = self.makeAttributedString(text: actualPrice, linkTextWithColor: rupee + String(discountPrice))
            cell.rating.text = String(dict!["rating"] as! String)+" ⃰"
            cell.userRating.text = dict!["users_rating"] as? String
            
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.setTitle(defaultTitle, for: .normal)
            cell.likeBtn.titleLabel?.isHidden = true
                 if(dict!["wishlist_status"] as? String == "1")
                  {
                 cell.likeBtn.setBackgroundImage(UIImage(named: "LikeWhite"), for: .normal)
                   }
                 else
                  {
                cell.likeBtn.setBackgroundImage(UIImage(named: "Like-pink"), for: .normal)
                 }
            if(Int(dict!["wishlist_status"] as! String)! == 0){
            cell.likeBtn.setBackgroundImage(UIImage(named: "LikeWhite"), for: .normal)
            }
            else{
            cell.likeBtn.setBackgroundImage(UIImage(named: "Like-pink"), for: .normal)

            }
            cell.likeBtn.addTarget(self, action:#selector(dealwishListBtnAction(_:)), for: UIControlEvents.touchUpInside)

           
            return cell
        }
        else if(collectionView == self.mRecommendedCollectionView)

        {
            let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            
            cell.productContainerView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.productContainerView.layer.shadowOffset = CGSize(width: 1, height:3)
            cell.productContainerView.layer.shadowOpacity = 0.6
            cell.productContainerView.layer.shadowRadius = 3.0
            cell.productContainerView.layer.cornerRadius = 5.0
            
            
            let dict = self.recommendedArray[indexPath.row] as? NSDictionary
            
            var image = dict!["image"] as? String
            if(image != nil){
                image = image?.replacingOccurrences(of: " ", with: "%20")
                cell.productImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
            }
            cell.productTitleLabel.text = dict!["name"] as? String
            let rupee = "\u{20B9}"
            
            let price = String(format: "%.2f",  Double(dict!["price"] as! String)!)
            cell.offerPriceText.text = rupee + String(price)
                   let offer = dict!["offer"]
            if offer as? String == "null" || offer as? String == "0"
            {
                cell.offerlbl.isHidden = true
            }
            else
            {
                cell.offerlbl.isHidden = false
                cell.offerlbl.text = dict!["offer"] as? String
                cell.offerlbl.text = String(format : "%@ %%off",dict!["offer"] as! String)
            }
            
            let discountPrice = dict!["discount_price"]
            
            if (discountPrice as? String  == "0" || discountPrice  as? String == "null")
            {
                cell.actualPriceText.isHidden = true
            }
            else
            {
                cell.actualPriceText.isHidden = false
                let discountPrice = String(format: "%.2f",  Double(dict!["discount_price"] as! String)!)
               let actualPrice = rupee + String(discountPrice)
              cell.actualPriceText.attributedText = self.makeAttributedString(text: actualPrice, linkTextWithColor: rupee + String(discountPrice))
            }
            cell.rating.text = String(dict!["rating"] as! String)+" ⃰"
            cell.userRating.text = dict!["users_rating"] as? String
            
            cell.likeBtn.tag = indexPath.row
            if(Int(dict!["wishlist_status"] as! String)! == 0){
                cell.likeBtn.setBackgroundImage(UIImage(named: "LikeWhite"), for: .normal)
            }
            else{
                cell.likeBtn.setBackgroundImage(UIImage(named: "Like-pink"), for: .normal)
            }
            cell.likeBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)
            
            
            
            return cell
        }

            
            
            
            
//        else if(collectionView == self.mlayout1CollectionView)
//        {
//            let cell: layout2CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "layout2CollectionViewCell", for: indexPath) as! layout2CollectionViewCell
//
//            cell.mlayout2View .layer.shadowColor = UIColor.darkGray.cgColor
//            cell.mlayout2View.layer.shadowOffset = CGSize(width: 1, height:3)
//            cell.mlayout2View.layer.shadowOpacity = 0.6
//            cell.mlayout2View.layer.shadowRadius = 1.0
//            //cell.mlayout2View.layer.cornerRadius = 5.0
//            if (indexPath.row % 3 == 0)
//            {
//                cell.mlayout2View.backgroundColor = UIColor.white
//            }
//            else
//            {
//                cell.mlayout2View.backgroundColor = UIColor.groupTableViewBackground
//            }
//            let dict = self.layout2Array[indexPath.row] as? NSDictionary
//            cell.mlayout2Label.text = dict!["title"] as? String
//            var image = dict!["image"] as? String
//            if(image != nil){
//                image = image?.replacingOccurrences(of: " ", with: "%20")
//                cell.mlayout2ImageView.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
//            }
//            return cell
//        }
        
     
        return defaultCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if(collectionView == self.bannerCollectionView)
        {
            return CGSize(width: Constants.SCREEN_WIDTH, height: collectionView.bounds.size.height)
        }
        if(collectionView == self.mCategoryCollectionView)
        {
            return CGSize(width: 125, height: 150)
        }
        if(collectionView == self.mDealCollectionView || collectionView == self.mRecommendedCollectionView )
        {
            return CGSize(width: 160, height: 180)
        }
        
        
        
//        else if(collectionView == self.mDealCollectionView || collectionView == self.mCategoryCollectionView || collectionView == self.mRecommendedCollectionView)
//        {
//           return CGSize(width: 140, height: 150)
//        }
//        else if(collectionView == self.mlayout1CollectionView)
//        {
//             return CGSize(width: self.view.frame.size.width/2 - 10, height: 140)
//        }
         return CGSize(width: 0, height: 0)
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        if(collectionView == self.bannerCollectionView)
//        {
//            return
//        }
//        if(collectionView == self.mCategoryCollectionView)
//        {
//            let dict = self.categoryArray[indexPath.row] as? NSDictionary
//            self.mProductID = dict![ "product_id"] as? String
//        }
//        else if(collectionView == self.mDealCollectionView)
//        {
//            let dict = self.productsArray[indexPath.row] as? NSDictionary
//            self.mProductID = dict![ "product_id"] as? String
//        }
//        else if(collectionView == self.mRecommendedCollectionView)
//        {
//            let dict = self.recommendedArray[indexPath.row] as? NSDictionary
//            self.mProductID = dict![ "product_id"] as? String
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
//        myVC?.productID = self.mProductID! as NSString
//        self.navigationController?.pushViewController(myVC!, animated: false)
//
//    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if(scrollView == self.bannerCollectionView)
        {
            for cell in self.bannerCollectionView.visibleCells  as! [SliderCollectionViewCell]    {
                let indexPath = self.bannerCollectionView.indexPath(for: cell as UICollectionViewCell)
                self.slideCount = (indexPath?.item)!
                self.mPageCtrl.currentPage = self.slideCount!
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
    
    
//    @objc func cartBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.categoryArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        cell?.mCartCountLabel.text = "1"
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
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
//        parameters = [
//           "customer_id" : userID ?? "",
//            "product_id" : productID,
//            "quantity" : "1",
//        ]
//        }
//
//        print (parameters)
//        let headers: HTTPHeaders =
//        [
//            "Content-Type": "application/json"
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
//                            self.getCartCount()
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
//
//    }
//    @objc func plusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.categoryArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count + 1
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
//         var parameters: Parameters = [:]
//        if(isOPtionsAvailable)
//        {
//        parameters =
//         [
//         "customer_id" : userID ?? "",
//         "product_id" : productID,
//         "quantity" : count,
//         "product_option_id" : optionID ?? "",
//         "product_option_value_id" : optionValueID ?? ""
//         ]
//        }
//        else{
//            parameters =
//            [ "customer_id" : userID ?? "",
//            "product_id" : productID,
//            "quantity" : count,
//            ]
//        }
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
//         self.getCartCount()
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
//        let dict = self.categoryArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count - 1
//        if(count == 0)
//        {
//            cell?.mAddView.isHidden = true
//            cell?.mCartBtn.isHidden = false
//        }
//
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//        var Url =  ""
//        if(count == 0)
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//        else
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
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
//         self.getCartCount()
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
//    @objc func productsCartBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.productsArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mDealCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        cell?.mCartCountLabel.text = "1"
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
//         var parameters: Parameters = [:]
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
//            self.view.makeToast(JSON["message"] as? String)
//            self.getCartCount()
//         }
//         else
//         {
//            //self.view.makeToast(JSON["message"] as? String)
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
//    @objc func productsPlusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.productsArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mDealCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count + 1
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
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
//         self.getCartCount()
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
//    @objc func productsMinusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.productsArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mDealCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count - 1
//        if(count == 0)
//        {
//            cell?.mAddView.isHidden = true
//            cell?.mCartBtn.isHidden = false
//        }
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//        var Url =  ""
//        if(count == 0)
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//        else
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
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
//         self.getCartCount()
//         }
//         else
//         {
//            //self.view.makeToast(JSON["message"] as? String)
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
//    @objc func recCartBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.recommendedArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        cell?.mCartCountLabel.text = "1"
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
//         var parameters: Parameters = [:]
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
//         self.getCartCount()
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
//    @objc func recPlusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.recommendedArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count + 1
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
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
//         self.getCartCount()
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
//    @objc func recMinusBtnAction(_ sender: UIButton)
//    {
//        let tag = sender.tag
//        let dict = self.recommendedArray[tag] as? NSDictionary
//        let productID = dict!["product_id"] as! String
//        let path = IndexPath(row: tag, section: 0)
//        let cell = self.mRecommendedCollectionView.cellForItem(at: path) as! HomeCell?
//        cell?.mAddView.isHidden = false
//        //cell?.mCartCountLabel.text = "1"
//        let countStr = cell?.mCartCountLabel.text
//        var count : Int = 0
//        count = Int(countStr!)!
//        count = count - 1
//        if(count == 0)
//        {
//            cell?.mAddView.isHidden = true
//            cell?.mCartBtn.isHidden = false
//        }
//        cell?.mCartCountLabel.text = String(format:"%d",count)
//
//        let selectedRow = cell?.mGramTF.selectedRow
//        var optionID : String!
//        var optionValueID : String!
//        var isOPtionsAvailable : Bool = false
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow!] as? NSDictionary
//                        optionID = optDict!["product_option_id"] as? String
//                        optionValueID = optDict!["product_option_value_id"] as? String
//                        isOPtionsAvailable = true
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow!] as? NSDictionary
//                    optionID = weighDict!["product_option_id"] as? String
//                    optionValueID = weighDict!["product_option_value_id"] as? String
//                    isOPtionsAvailable = true
//                }
//            }
//        }
//
//         SKActivityIndicator.show("Loading...")
//        var Url =  ""
//        if(count == 0)
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//        else
//        {
//            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
//        }
//         print(Url)
//         let userID =  UserDefaults.standard.string(forKey: "customer_id")
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
//         self.getCartCount()
//         }
//         else
//         {
//            //self.view.makeToast(JSON["message"] as? String)
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
//    //MARK: IQDropdown delegate
//    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
//
//        print ("Tag=\(textField.tag)")
//
//        if(textField.tag >= 300)
//        {
//            collectionType = "Recommended"
//            textField.tag = textField.tag - 300
//        }
//        else if(textField.tag >= 200 && textField.tag < 300)
//        {
//            collectionType = "Products"
//            textField.tag = textField.tag - 200
//        }
//        else if(textField.tag >= 100 && textField.tag < 200)
//        {
//            collectionType = "Deals"
//            textField.tag = textField.tag - 100
//        }
//        else{
//            textField.tag = textField.tag
//        }
//        print ("textFieldTag=\(textField.tag)")
//
//        print ("item=\(textField.selectedRow)")
//        if (textField.selectedRow == -1) {
//            textField.selectedRow = 1
//        }
//        let selectedRow = textField.selectedRow
//        let path = IndexPath(row: textField.tag, section: 0)
//        let tag = textField.tag
//        var finalPrice : String!
//        var finalDiscount : String!
//        var cartValue : String!
//        var dict : NSDictionary!
//        if(collectionType == "Deals")
//        {
//            dict = self.categoryArray[tag] as? NSDictionary
//        }
//        else if(collectionType == "Products")
//        {
//             dict = self.productsArray[tag] as? NSDictionary
//        }
//        else if(collectionType == "Recommended")
//        {
//             dict = self.recommendedArray[tag] as? NSDictionary
//        }
//
//        let weights = dict!["weight_classes"] as? AnyObject
//        let options = dict!["options"] as? AnyObject
//        if(weights as? String == "null" && options as? String == "null")
//        {
//
//        }
//        else{
//            if(weights == nil || weights as? String == "null")
//            {
//
//
//                if(options == nil || options as? String == "null")
//                {
//                }
//                else
//                {
//                    var optArray = dict!["options"] as? NSArray
//                    if((optArray?.count)! > 0)
//                    {
//                        var optDict = optArray![selectedRow] as? NSDictionary
//                        let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
//                        finalPrice = String(format : "₹%@",priceSting)
//
//                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
//                        finalDiscount = String(format : "₹%@",doubleSting)
//                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
//                        {
//                            cartValue = "0"
//                        }
//                        else{
//                            cartValue = String(format : "%@",(optDict!["cart_count"] as? String)!)
//                        }
//
//                    }
//                }
//            }
//            else //if((weights?.count)! > 0)
//            {
//                var weighArray = dict!["weight_classes"] as? NSArray
//                if((weighArray?.count)! > 0)
//                {
//                    var weighDict = weighArray![selectedRow] as? NSDictionary
//                    let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
//                    finalPrice = String(format : "₹%@",priceSting)
//
//                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
//                    finalDiscount = String(format : "₹%@",doubleSting)
//                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
//                    {
//                        cartValue = "0"
//                    }
//                    else{
//                        cartValue = String(format : "%@",(weighDict!["cart_count"] as? String)!)
//                    }
//
//
//                }
//            }
//
//        }
//        if(collectionType == "Deals")
//        {
//            let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
//            cell?.mPriceLabel.text = finalPrice
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            cell?.mDicountLabel.attributedText = attributeString
//            if(cartValue == "0")
//            {
//                cell?.mCartBtn.isHidden = false
//                cell?.mAddView.isHidden = true
//            }
//            else
//            {
//                cell?.mCartBtn.isHidden = true
//                cell?.mAddView.isHidden = false
//                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
//            }
//        }
//        else if(collectionType == "Products")
//        {
//            let cell = self.mDealCollectionView.cellForItem(at: path) as! HomeCell?
//            cell?.mPriceLabel.text = finalPrice
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            cell?.mDicountLabel.attributedText = attributeString
//            if(cartValue == "0")
//            {
//                cell?.mCartBtn.isHidden = false
//                cell?.mAddView.isHidden = true
//            }
//            else
//            {
//                cell?.mCartBtn.isHidden = true
//                cell?.mAddView.isHidden = false
//                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
//            }
//
//        }
//        else if(collectionType == "Recommended")
//        {
//            let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
//            cell?.mPriceLabel.text = finalPrice
//            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            cell?.mDicountLabel.attributedText = attributeString
//            if(cartValue == "0")
//            {
//                cell?.mCartBtn.isHidden = false
//                cell?.mAddView.isHidden = true
//            }
//            else
//            {
//                cell?.mCartBtn.isHidden = true
//                cell?.mAddView.isHidden = false
//                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
//            }
//        }
//
//
//    }
//    //MARK: TableView delegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.layout1Array.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell:layout1TableViewCell =  mlayout1TableView.dequeueReusableCell(withIdentifier: "layout1TableViewCell", for: indexPath) as!layout1TableViewCell
//
//        cell.mLayout1View.layer.shadowColor = UIColor.darkGray.cgColor
//        cell.mLayout1View.layer.shadowOffset = CGSize(width: 1, height:3)
//        cell.mLayout1View.layer.shadowOpacity = 0.6
//        cell.mLayout1View.layer.shadowRadius = 3.0
//        cell.mLayout1View.layer.cornerRadius = 5.0
//
//
//        let dict = self.layout1Array[indexPath.row] as? NSDictionary
//        var image = dict!["image"] as? String
//        if(image != nil){
//            image = image?.replacingOccurrences(of: " ", with: "%20")
//            cell.mLayout1ImageView?.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "placeholder"))
//        }
//        return cell;
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         if(collectionView == self.mCategoryCollectionView)
         {
            UserDefaults.standard.setValue("HomeList", forKey: "SelectedTab")
            let dict = self.categoryArray[indexPath.row] as? NSDictionary
            let productID = dict!["category_id"] as? String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as? ListVC
            myVC?.selectedCategory = productID
            myVC?.type = "Category";
            self.navigationController?.pushViewController(myVC!, animated: true)
            return
        } else
         {
            var  dict = NSDictionary()
            if(collectionView == self.mRecommendedCollectionView)
            {
                dict = (self.recommendedArray[indexPath.row] as? NSDictionary)!
            }
            else{
                dict = (self.productsArray[indexPath.row] as? NSDictionary)!
            }
            let productID = dict[ "product_id"] as? String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myVC = storyboard.instantiateViewController(withIdentifier: "ProductOneVC") as? ProductOneVC
            myVC?.ProductID = productID!  as String;
            self.navigationController?.pushViewController(myVC!, animated: false)
        }
   }

    /*
     // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
     }
 
    
}


     */
 }
