//
//  ListVC.swift
//  ECommerce
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
import WARangeSlider
class ListVC:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,IQDropDownTextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var mProductfoundlbl: CustomFontLabel!
    @IBOutlet weak var closetnWidthCnst: NSLayoutConstraint!
    @IBOutlet weak var closeFilterBtn: UIButton!
    @IBOutlet weak var filterViewWidthCnst: NSLayoutConstraint!
    @IBOutlet weak var filterContainerLeadingCnst: NSLayoutConstraint!
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var mGridImageView: UIImageView!
    @IBOutlet weak var listcollectionview: UICollectionView!
    @IBOutlet weak var mProductsCountLabel : UILabel!
    @IBOutlet weak var profileImage : UIImageView!
    var itemsArray : NSArray = []
    var categorylistArray : NSArray = []
    var isGrid : Bool = true
    var isFilterData : Bool = false
     @IBOutlet weak var mCartCountLabel : CustomFontLabel!
    var selectedCateroy : String!
    var selectedCategory : String!
    var selectedview : String!
    var type : String!
    var productID : String!
    var categoryID : String!
    var bannerArray : NSArray = []
    var offerArray : NSArray = []
    
    
    let segmentBottomBorder = CALayer()
    var slideCount : Int?
    var selectedofferCategory = 1
    
    var mExpandArray : NSMutableArray = []
    var namesArray : NSMutableArray = ["Green Leaves","Sprouts","English Item","Other Veggies"]
    var imagesArray : NSMutableArray = ["greenLeaves","sprouts","EnglishItem","OtherVeggiez"]
    var categoryArray :  NSMutableArray = ["Sort By","Price","Category","Ratting","Offer"]
    var sortArray : NSMutableArray = ["Popularity","Price-Low to High","Price-High to Low","Newest First"]
    var ratingArray : NSMutableArray = ["5 * * * * *","4 * * * * *","3 * * * * *","2 * * * * *","1 * * * * *"]

    var selectedSection0 = -1
    var selectedSection2 = -1
    var selectedSection3 = -1
    var selectedSection4 = -1

    
    var categoryDetail = [[String:Any]]()
    var categoryNameArray = [String]()
    var offerDetail = [[String:Any]]()
    var offerNameArray = [String]()
    
    var filterViewShow = false
    var maximumPrice = String()
    var minimumPrice = String()
    var priceSubTitle = String()
    
    
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
        
        self.mCartCountLabel.layer.cornerRadius = self.mCartCountLabel.frame.size.width/2
       self.mCartCountLabel.layer.masksToBounds = true

//        profileImage.layer.masksToBounds = true
//        profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
        listcollectionview.register(UINib(nibName: "ProductListCell", bundle: .main), forCellWithReuseIdentifier: "ProductListCell")
        
        filterContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
       
        callForGetCategoryApi()
        callForOfferApi()
        
        filterContainerLeadingCnst.constant += self.view.frame.width
        filterViewWidthCnst.constant = 0
        closetnWidthCnst.constant = 0
        
        minimumPrice = "500"
        maximumPrice = "500000"
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        if (self.type == "Category" )
        {
            getCategory()
            getCartCount()
            return
        }
        else if( self.type == "offer" )
        {
            callForOfferListApi()
            getCartCount()
            return
        }
        getData()
        getCartCount()
        
        
        
        
        
//                let path = IndexPath(row: tag, section: 0)
//                let cell = self.mCategoryCollectionView.cellForItem(at: path) as! HomeCell?
        
       
//        if(sender.tag == 1)
//        {
//            myVC.selectedCategory  = "1"
//        }
//        else if(sender.tag == 2)
//        {
//            myVC.selectedCategory  = "2"
//        }
//
//        self.navigationController?.pushViewController(myVC!, animated: true)
//
//       getviewAll()
       
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
//        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name("FilteredData"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func refreshData()
    {
        var dataArray : NSArray = []
        var data = UserDefaults.standard.object(forKey: "FilterData") as? Data
        if let aData = data {
            dataArray = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSArray
            print(dataArray)
            self.isFilterData = true
            self.itemsArray = dataArray
           
            self.listcollectionview.reloadData()
        }
    }
    @objc func wishListBtnAction(_ sender: UIButton)
    {
        let dict = self.itemsArray[sender.tag] as? NSDictionary
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
                            //self.view.makeToast(JSON["message"] as? String)
                            
                            if (self.type == "Category" )
                            {
                                self.getCategory()
                               
                                
                            }
                            else if( self.type == "offer" )
                            {
                                self.callForOfferListApi()
                                
                                
                            }
                            else{
                                self.getData()
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
    
    // MARK: - API
    
    @IBAction func filterBtnClk(_ sender: Any) {
        
        if filterViewShow{
            filterViewShow = false
            filterContainerLeadingCnst.constant += self.view.frame.width
            filterViewWidthCnst.constant = 0
            closetnWidthCnst.constant = 0

           
           
        }
        if !filterViewShow{
            filterViewShow = true
            filterContainerLeadingCnst.constant = 0
            filterViewWidthCnst.constant = 240
            closetnWidthCnst.constant = 30


        }
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations:{
            self.filterContainerView.isHidden = false
            
            self.view.layoutIfNeeded()
            
            
            
        })
        
       
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.categoryArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mExpandArray.contains(section)
        {
//            let dict = self.categoryArray[section] as? NSDictionary
//            var subCategoryArray : NSArray = []
//            if (dict!["product_data"] != nil) {
//                subCategoryArray = (dict!["product_data"] as? NSArray)!
//                return subCategoryArray.count
//            }
//            else{
//                return 0
//            }
            
            if section == 0{
                return sortArray.count
            }
            if section == 1{
                return 1
            }
            if section == 2{
                return categoryNameArray.count
            }
            if section == 3{
                return ratingArray.count
            }
            if section == 4{
                return offerNameArray.count
            }
             return 0
            
            
            
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSortCell", for: indexPath) as! FilterSortCell
            cell.selectionStyle = .none
            cell.titleLabel.text = sortArray[indexPath.row] as? String
            if selectedSection0 == indexPath.row{
                cell.checkBoxImage?.image = UIImage(named: "CheckboxGray")
            }
            else{
                cell.checkBoxImage?.image = UIImage(named: "UncheckboxGray")

            }
//            let lineView = UIView(frame:CGRect (x: 0, y: cell.contentView.frame.height-1, width:tableView.frame.size.width , height:1))
//            lineView.backgroundColor = UIColor.darkGray
//            lineView.removeFromSuperview()
            if indexPath.row == sortArray.count-1{
             cell.lineView.isHidden = false
            }
            else{
               cell.lineView.isHidden = true
            }
            
            
            return cell
        }
        
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSliderCell", for: indexPath) as! FilterSliderCell
            cell.selectionStyle = .none
         
            let lineView = UIView(frame:CGRect (x: 0, y: cell.contentView.frame.height-1, width:tableView.frame.size.width , height:1))
            lineView.backgroundColor = UIColor.darkGray
            cell.addSubview(lineView)

             cell.rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
            
            
            return cell
        }
        if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSortCell", for: indexPath) as! FilterSortCell
            cell.selectionStyle = .none
            cell.titleLabel.text = categoryDetail[indexPath.row]["category_name"] as? String
            if selectedSection2 == indexPath.row{
                cell.checkBoxImage?.image = UIImage(named: "CheckboxGray")
            }
            else{
                cell.checkBoxImage?.image = UIImage(named: "UncheckboxGray")
                
            }
           

            if indexPath.row == categoryDetail.count-1{
                cell.lineView.isHidden = false
            }
            else{
                cell.lineView.isHidden = true
            }
            
            
            return cell
        }
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSortCell", for: indexPath) as! FilterSortCell
            cell.selectionStyle = .none
            cell.titleLabel.text = ratingArray[indexPath.row] as? String
            if selectedSection3 == indexPath.row{
                cell.checkBoxImage?.image = UIImage(named: "CheckboxGray")
            }
            else{
                cell.checkBoxImage?.image = UIImage(named: "UncheckboxGray")
                
            }
            
          
            if indexPath.row == ratingArray.count-1{
                cell.lineView.isHidden = false
            }
            else{
                cell.lineView.isHidden = true
            }
            
            
            return cell
        }
            
        if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSortCell", for: indexPath) as! FilterSortCell
            cell.selectionStyle = .none
            cell.titleLabel.text = offerNameArray[indexPath.row] as? String
            if selectedSection4 == indexPath.row{
                cell.checkBoxImage?.image = UIImage(named: "CheckboxGray")
            }
            else{
                cell.checkBoxImage?.image = UIImage(named: "UncheckboxGray")
                
            }
            //            let lineView = UIView(frame:CGRect (x: 0, y: cell.contentView.frame.height-1, width:tableView.frame.size.width , height:1))
            //            lineView.backgroundColor = UIColor.darkGray
            //            lineView.removeFromSuperview()
            if indexPath.row == offerNameArray.count-1{
                cell.lineView.isHidden = false
            }
            else{
                cell.lineView.isHidden = true
            }
            
            
            return cell
        }
       
        else{
        
        
        let pcell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        pcell.selectionStyle = .none
        return pcell;
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame:CGRect (x: 0, y: 15, width:tableView.frame.size.width , height:50))
        headerView.backgroundColor = UIColor.clear
    
        let lineView = UIView(frame:CGRect (x: 0, y: 49, width:tableView.frame.size.width , height:1))
        lineView.backgroundColor = UIColor.darkGray
        
        //headerView.addSubview(lineView)
        
        if mExpandArray.contains(section)
        {
            lineView.removeFromSuperview()
        }
        else{
            headerView.addSubview(lineView)

        }
        
        
      
        
        let Label = CustomFontLabel(frame : CGRect (x: 5, y: 3, width:tableView.frame.size.width - 20, height:25))
        Label.text = categoryArray[section]as? String
        Label.font = UIFont (name: "Roboto", size: 15)
        headerView.addSubview(Label)
        
        let subTitle = CustomFontLabel(frame : CGRect (x: 5, y: 30, width:tableView.frame.size.width - 20, height:15))
//        subTitle.text = categoryArray[section]as? String
          subTitle.font = UIFont (name: "Roboto", size: 10)
//        headerView.addSubview(subTitle)
        
        print("section:",section)
        print("selected:",selectedSection0)
        
        if (section == 0 && selectedSection0 != -1){
            subTitle.text = sortArray[selectedSection0] as? String
        }
        if (section == 1){
            subTitle.text = priceSubTitle
        }
        if (section == 2 && selectedSection2 != -1){
            subTitle.text = categoryNameArray[selectedSection2]
        }
        if (section == 3 && selectedSection3 != -1){
            subTitle.text = ratingArray[selectedSection3] as? String
        }
        if (section == 4 && selectedSection4 != -1){
            subTitle.text = offerNameArray[selectedSection4]
        }
       
         headerView.addSubview(subTitle)
        
        
        
        
        let categoriesDropdownImages = UIImageView(frame : CGRect (x: headerView.frame.size.width - 40, y: 8, width:15, height:15))
        categoriesDropdownImages.image = UIImage(named: "Dropdown")
        headerView.addSubview(categoriesDropdownImages)
        categoriesDropdownImages.contentMode = .scaleAspectFit
//        if mExpandArray.contains(section)
//        {
//            categoriesDropdownImages.image = UIImage(named : "up-arrow")
//        }
        let button = UIButton(frame : CGRect (x: 0, y: 0, width:tableView.frame.size.width, height:50))
        
        button.setTitle("", for: [])
        button.tag = section
        button.addTarget(self, action:#selector(expandBtnAction(_:)), for: UIControlEvents.touchUpInside)
        headerView.addSubview(button)
        
        return headerView;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return 30.0//Choose your custom row height
        }
        if indexPath.section == 1{
            return 55.0//Choose your custom row height
        }
        if indexPath.section == 2{
            return 30.0//Choose your custom row height
        }
        if indexPath.section == 3{
            return 30.0//Choose your custom row height
        }
        if indexPath.section == 4{
            return 30.0//Choose your custom row height
        }
        else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 0{
            
            selectedSection0 = indexPath.row
            
        }
        if indexPath.section == 2{
            
            selectedSection2 = indexPath.row
            
        }
        if indexPath.section == 3{
            
            selectedSection3 = indexPath.row
            
        }
        if indexPath.section == 4{
            
            selectedSection4 = indexPath.row
            
        }
        
        filterTableView.reloadData()
       
    }
    
    
   
    
    @objc func expandBtnAction (_ sender: UIButton)
    {
        let tag : Int = sender.tag
        
        self.mExpandArray.removeAllObjects()
        self.mExpandArray.add(tag)
//        if self.mExpandArray .contains(tag)
//        {
//            self.mExpandArray .remove(tag)
//        }
//        else
//        {
//            self.mExpandArray.add(tag)
//        }
        let range = NSRange(location: tag, length: 1)
        let section = NSIndexSet(indexesIn: range)
        //self.filterTableView.reloadSections(section as IndexSet, with: .fade)
        
        UIView.transition(with: filterTableView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.filterTableView.reloadData()}, completion: nil)
    }
    
    
    
    
    
    
    
    
    func getData()
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
                            if(result == nil || result as? String == "null")
                            {
                            }
                            else
                            {
                                self.itemsArray = (JSON["result"] as? NSArray)!
                                self.mProductfoundlbl.text = String(format: "%d Products found",self.itemsArray.count)
                                self.listcollectionview.reloadData()
                                //self.listcollectionview.reloadData()
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
        
    }
    func callForGetCategoryApi(){
        SKActivityIndicator.show("Loading...")

        
        
        NetworkClass.shared.getDetailsFromServer(withUrl: "api/custom/categoryListForUpload") { (isSuccess, response) in
            SKActivityIndicator.dismiss()
            print(response)
            
            
            if  isSuccess{
                if (response["status"] as? String == "success"){
                    
                    self.categoryDetail = response["result"] as! [[String : Any]]
                    for category in self.categoryDetail{
                        self.categoryNameArray.append(category["category_name"]! as! String)
                    }
                   
                }
                else{
                    self.view.makeToast(response["message"]as? String)
                }
            }
        }
        
        
        
        
    }
   
    
    func callForOfferApi(){
        SKActivityIndicator.show("Loading...")
        NetworkClass.shared.getDetailsFromServer(withUrl: "api/filterproduct/offerListForFilter") { (isSuccess, response) in
            SKActivityIndicator.dismiss()
            print(response)
            
            
            if  isSuccess{
                if (response["status"] as? String == "success"){
                    
                    self.offerDetail = response["result"] as! [[String : Any]]
                    for offer in self.offerDetail{
                        self.offerNameArray.append(offer["title"]! as! String)
                    }
                    self.listcollectionview.reloadData()
                }
                else{
                    self.view.makeToast(response["message"]as? String)
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
    func getCategory()
    
        {
            SKActivityIndicator.show("Loading...")
            let Url = String(format: "%@api/custom/productListBasedOnCategoryId",Constants.BASEURL)
            print(Url)
            let userID =  UserDefaults.standard.string(forKey: "customer_id")
            let parameters: Parameters =
                [
                    "customer_id" : userID ?? "",
                    "category_id" : selectedCategory
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
                                self.categorylistArray = (JSON["result"] as? NSArray)! 
                                self.mProductfoundlbl.text = String(format: "%d Products found",self.categorylistArray.count)
                                //self.mProductfoundlbl.text = String(format: "%d Products found",self.categoryArray.count)
                                if(result == nil || result as? String == "null")
                                {
                                }
                                else
                                {
                                    self.itemsArray = (JSON["result"] as? NSArray)!
                                    //                        self.mProductsCountLabel.text = String(format: "%d Products found",self.itemsArray.count)
                                    self.listcollectionview.reloadData()
                                    
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
            
        }
    @IBAction func myCart(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func cancelBtn(_ sender: Any) {
        
        
        
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations:{
            
            self.filterViewShow = false
            self.filterContainerLeadingCnst.constant += self.view.frame.width
            self.filterViewWidthCnst.constant = 0
            self.closetnWidthCnst.constant = 0
            self.filterContainerView.isHidden = true
            
            self.view.layoutIfNeeded()
            
            
            
        })
        
    }
    
   @objc func rangeSliderValueChanged(_ sender: RangeSlider){
    
    
    let lowerInt = Int(sender.lowerValue.rounded())
    let upperInt = Int(sender.upperValue.rounded())
    
    minimumPrice = String(lowerInt)
    maximumPrice = String(upperInt)
    priceSubTitle = minimumPrice + "-" + maximumPrice
    
    }
        
    
    @IBAction func clearBtnClk(_ sender: Any) {
        
        selectedSection0 = -1
        selectedSection2 = -1
        selectedSection3 = -1
        selectedSection4 = -1
        priceSubTitle = " "
        mExpandArray.removeAllObjects()

        filterTableView.reloadData()
        
        getData()
        
        
    }
    
    
    @IBAction func applyBtnClk(_ sender: Any) {
        
        callForFilter() 
        
        
    }
    
    func callForFilter(){
      /*  "customer_id" : "4",
        "popularity" : "1",
        "filter_low_to_high" : "",
        "filter_high_to_low" : "",
        "newest_first" : "",
        "min_price" : "",
        "max_price" : "",
        "category_id" : "98",
        "rating" : "",
        "offer_id" : "1"*/
        
       var ratingStr = "0"
        switch selectedSection4 {
        case 0:
            ratingStr = "5"
        case 1:
            ratingStr = "4"
        case 2:
            ratingStr = "3"
        case 3:
            ratingStr = "2"
        case 4:
            ratingStr = "1"
        default:
            ratingStr = "0"
        }
        var categoryID = " "
        if selectedSection0 != -1{
            categoryID = categoryDetail[selectedSection0]["category_id"] as! String
        }
        var offerID = " "
        if selectedSection4 != -1{
            offerID = offerDetail[selectedSection4]["id"] as! String
        }
       
        
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters = [String: Any]()
        parameters = [
            "customer_id":userID!,
            "min_price":minimumPrice,
            "max_price":maximumPrice,
            "category_id":categoryID,
            "rating":ratingStr,
            "offer_id":offerID
        ]
        
        if selectedSection0 != -1{
        
        switch sortArray[selectedSection0] as! String{
        case "Popularity":
          
            parameters["popularity"] = "1"
            parameters["filter_low_to_high"] = "0"
            parameters["filter_high_to_low"] = "0"
            parameters["newest_first"] = "0"
        case "Price-Low to High":
            parameters["popularity"] = "0"
            parameters["filter_low_to_high"] = "1"
            parameters["filter_high_to_low"] = "0"
            parameters["newest_first"] = "0"
        case "Price-High to Low":
            parameters["popularity"] = "0"
            parameters["filter_low_to_high"] = "0"
            parameters["filter_high_to_low"] = "1"
            parameters["newest_first"] = "0"
        case "Newest First":
            parameters["popularity"] = "0"
            parameters["filter_low_to_high"] = "0"
            parameters["filter_high_to_low"] = "0"
            parameters["newest_first"] = "1"
        default:
            print("error")
        }
        }
        else{
            parameters["popularity"] = "0"
            parameters["filter_low_to_high"] = "0"
            parameters["filter_high_to_low"] = "0"
            parameters["newest_first"] = "0"
        }
 
        
//        var parameters = [String: Any]()
//        parameters = [
//            "customer_id" : "4",
//            "popularity" : "1",
//            "filter_low_to_high" : "",
//            "filter_high_to_low" : "",
//            "newest_first" : "",
//            "min_price" : "",
//            "max_price" : "",
//            "category_id" : "98",
//            "rating" : "",
//            "offer_id" : "1"
//        ]
        
        SKActivityIndicator.show("Loading...")
        
        print("parameters",parameters)

        NetworkClass.shared.postDetailsToServer(withUrl: "api/filterproduct/FilterProduct", withParam: parameters) { (isSuccess, response) in
            
            SKActivityIndicator.dismiss()

            print(response)
            
            
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations:{
                
                self.filterViewShow = false
                self.filterContainerLeadingCnst.constant += self.view.frame.width
                self.filterViewWidthCnst.constant = 0
                self.closetnWidthCnst.constant = 0
                self.filterContainerView.isHidden = true
                
                self.view.layoutIfNeeded()
                
                
                
            })
            
            
            if  isSuccess{
                if response["status"] as? String == "success"{
                    self.itemsArray = (response["result"] as? NSArray)!
                    
                    self.listcollectionview.reloadData()
                    
                   
                }
                else{
                    self.getData()
                    self.view.makeToast(response["message"]as? String)
                    return
                    
                }
                
            }
            else{
                self.view.makeToast(response["Issue with connecting to server"]as? String)
                return
            }
            
            // Your Will Get Response here
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
    func callForOfferListApi(){
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/custom/offerProductList",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "offer_id" : selectedCategory
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
                            self.offerArray = (JSON["result"] as? NSArray)!
                            self.mProductfoundlbl.text = String(format: "%d Products found",self.offerArray.count)
                            //self.mProductfoundlbl.text = String(format: "%d Products found",self.categoryArray.count)
                            if(result == nil || result as? String == "null")
                            {
                            }
                            else
                            {
                                self.itemsArray = (JSON["result"] as? NSArray)!
                                //                        self.mProductsCountLabel.text = String(format: "%d Products found",self.itemsArray.count)
                                self.listcollectionview.reloadData()
                                
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
        
    }

    // MARK: - Colletion View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductListCell


        cell.mListView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.mListView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.mListView.layer.shadowOpacity = 0.6
        cell.mListView.layer.shadowRadius = 3.0
        cell.mListView.layer.cornerRadius = 5.0

        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.listviewImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        cell.listNameLabel.text = dict!["name"] as? String
        let rupee = "\u{20B9}"

        let price = String(format: "%.2f",  Double(dict!["price"] as! String)!)
        cell.priceLabel.text = rupee + String(price)
        let discountPrice = dict!["discount_price"]
        
        if (discountPrice as? String  == "0" || discountPrice  as? String == "null")
        {
            cell.attributePriceLabel.isHidden = true
        }
        else
        {
            cell.attributePriceLabel.isHidden = false
            let discountPrice = String(format: "%.2f",  Double(dict!["discount_price"] as! String)!)
            let actualPrice = rupee + String(discountPrice)
            cell.attributePriceLabel.attributedText = self.makeAttributedString(text: actualPrice, linkTextWithColor: rupee + String(discountPrice))
        }
        
                //cell.attributePriceLabel.text = dict!["discount_price"] as? String
        

       // let actualPrice = rupee + String(discountPrice) + " " + String(dict!["discount_price"] as! String) + " % off"
//        cell.attributePriceLabel.attributedText = self.makeAttributedString(text: actualPrice, linkTextWithColor: rupee + String(discountPrice))

        cell.priceLabel.text = dict!["price"] as? String
        let offer = dict!["offer"]
        if offer as? String == "null" || offer as? String == "0"
        {
            cell.offerlabel.isHidden = true
        }
        else
        {
            cell.offerlabel.isHidden = false
            cell.offerlabel.text = dict!["offer"] as? String
            cell.offerlabel.text = String(format : "%@ %%off",dict!["offer"] as! String)
        }
        
        cell.ratingLabel.text = dict!["rating"] as? String
        cell.userRating.text = dict!["users_rating"] as? String




    cell.mWishListBtn.tag = indexPath.row
    if(Int(dict!["wishlist_status"] as! String)! == 0){
    cell.mWishListBtn.setBackgroundImage(UIImage(named: "LikeWhite"), for: .normal)
    }
    else{
    cell.mWishListBtn.setBackgroundImage(UIImage(named: "Like-pink"), for: .normal)
    }
    cell.mWishListBtn.tag = indexPath.row
    cell.mWishListBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)



        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            if(collectionView == self.listcollectionview)
        {
            return CGSize(width: 160, height: 200)
        }
        return CGSize(width: 0, height: 0)
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




        return attributedString
    }
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
////    {
////        let dict = self.itemsArray[indexPath.row] as? NSDictionary
////       let productID = dict![ "product_id"] as? String/        let storyboard = UIStoryboard(name: "Main", bundle: nil)        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC        myVC?.productID = productID! as NSString
////       self.navigationController?.pushViewController(myVC!, animated: false)
////  }
//    // MARK: - TableView View
//
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
////    {
////        return itemsArray.count
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell:ListViewTableViewCell =  mTableView.dequeueReusableCell(withIdentifier: "ListViewTableViewCell", for: indexPath) as! ListViewTableViewCell
////        cell.selectionStyle = .none
////        let dict = self.itemsArray[indexPath.row] as? NSDictionary
////        var image = dict!["image"] as? String
////        image = image?.replacingOccurrences(of: " ", with: "%20")
////        cell.listviewImage.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
////        cell.listNameLabel.text = dict!["name"] as? String
////
////        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
////        let priceDouble =  Double (priceSting)
////        if((priceDouble) != nil)
////        {
////            cell.priceLabel.text = String(format : "₹%.2f",priceDouble!)
////        }
////
////        var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
////        if(discount == "null")
////        {
////
////        }
////        else
////        {
////            let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
////            let discountDouble =  Double (discountSting)
////            if((discountDouble) != nil)
////            {
////                discount = String(format : "₹%.2f",discountDouble!)
////                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
////                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
////                cell.listattributeLabel.attributedText = attributeString
////            }
////
////        }
////
////        if(dict!["wishlist_status"] as? Int == 1)
////        {
////            cell.wishListImage.image = UIImage(named: "Like")
////        }
////        else
////        {
////            cell.wishListImage.image = UIImage(named: "AddWishlist")
////        }
////        if(dict!["Add_product_quantity_in_cart"] as? Int == 0 || dict!["Add_product_quantity_in_cart"] as? String == "0")
////        {
////            cell.mAddView.isHidden = false
////            cell.mCartView.isHidden = true
////        }
////        else
////        {
////            cell.mAddView.isHidden = true
////            cell.mCartView.isHidden = false
////            cell.mCartCountLabel.text = String(format : "%@",(dict!["Add_product_quantity_in_cart"] as? String)!)
////        }
////
////        cell.mGramTF.delegate = self as? IQDropDownTextFieldDelegate
////        cell.mGramTF.tag = indexPath.row
////        cell.mGramTF.itemList = ["1 Piece"]
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////            cell.mGramTF.selectedItem = "1 Piece"
////            cell.mArrowImageView.isHidden = true
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////
////
////                if(options == nil || options as? String == "null")
////                {
////                    cell.mGramTF.selectedItem = "1 Piece"
////                    cell.mGramTF.isUserInteractionEnabled = false
////                    cell.mArrowImageView.isHidden = true
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optionsArray = [String]()
////                        for optionsDict in optArray! {
////                            let size = (optionsDict as AnyObject).object(forKey: "name") as? String
////                            optionsArray.append(size!)
////                        }
////                        print("weightArray=\(optionsArray)")
////
////                        cell.mGramTF.itemList = optionsArray
////                        cell.mGramTF.selectedRow = 1
////                        cell.mArrowImageView.isHidden = false
////                        var optDict = optArray![0] as? NSDictionary
////                        let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
////                        cell.priceLabel.text = String(format : "₹%@",priceSting)
////                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
////                        let discount = String(format : "₹%@",doubleSting)
////                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
////                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
////                        cell.listattributeLabel.attributedText = attributeString
////
////                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
////                        {
////                            cell.mAddView.isHidden = false
////                            cell.mCartView.isHidden = true
////                        }
////                        else
////                        {
////                            cell.mAddView.isHidden = true
////                            cell.mCartView.isHidden = false
////                            cell.mCartCountLabel.text = String(format : "%@",(optDict!["cart_count"] as? String)!)
////                        }
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weightsArray = [String]()
////                    for weightsDict in weighArray! {
////                        let size = (weightsDict as AnyObject).object(forKey: "name") as? String
////                        weightsArray.append(size!)
////                    }
////                    print("weightArray=\(weightsArray)")
////
////                    cell.mGramTF.itemList = weightsArray
////                    cell.mGramTF.selectedRow = 1
////                    cell.mArrowImageView.isHidden = false
////                    var weighDict = weighArray![0] as? NSDictionary
////                    let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
////                    cell.priceLabel.text = String(format : "₹%@",priceSting)
////                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
////                    let discount = String(format : "₹%@",doubleSting)
////                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
////                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
////                    cell.listattributeLabel.attributedText = attributeString
////
////                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
////                    {
////                        cell.mAddView.isHidden = false
////                        cell.mCartView.isHidden = true
////                    }
////                    else
////                    {
////                        cell.mAddView.isHidden = true
////                        cell.mCartView.isHidden = false
////                        cell.mCartCountLabel.text = String(format : "%@",(weighDict!["cart_count"] as? String)!)
////                    }
////                }
////            }
////        }
////        cell.mWishListBtn.tag = indexPath.row
////        cell.mWishListBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)
////        cell.mAddBtn.tag = indexPath.row
////        cell.mAddBtn.addTarget(self, action:#selector(listAddBtnAction(_:)), for: UIControlEvents.touchUpInside)
////        cell.mPlusBtn.tag = indexPath.row
////        cell.mPlusBtn.addTarget(self, action:#selector(listPlusBtnAction(_:)), for: UIControlEvents.touchUpInside)
////        cell.mMinusBtn.tag = indexPath.row
////        cell.mMinusBtn.addTarget(self, action:#selector(listMinusBtnAction(_:)), for: UIControlEvents.touchUpInside)
////        return cell;
////    }
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
////{
//////        let dict = self.itemsArray[indexPath.row] as? NSDictionary
//////        let productID = dict![ "product_id"] as? String
//////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//////        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
//////        myVC?.productID = productID! as NSString
//////        self.navigationController?.pushViewController(myVC!, animated: false)
////    }
////
////    // MARK: - Btn Actions
////
//    @IBAction func mLeftBtnAction(_ sender: Any) {
//    }
//    @IBAction func mUPloadBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "uploadPicVC") as? uploadPicVC
//        self.navigationController?.pushViewController(myVC!, animated: true)
//
//    }
//    @IBAction func notificationBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
//        self.navigationController?.pushViewController(myVC!, animated: true)
//    }
//    @IBAction func mSearchBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    @IBAction func myBagBtn(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    //    @objc func wishListBtnAction(_ sender: UIButton)
////    {
////        let dict = self.itemsArray[sender.tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        SKActivityIndicator.show("Loading...")
////        var Url =  ""
////        if(dict!["wishlist_status"] as? Int == 1)
////        {
////            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
////        }
////        else
////        {
////            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
////        }
////        print(Url)
////        let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        let parameters: Parameters =
////        [
////            "customer_id" : userID ?? "",
////            "product_id" : productID
////        ]
////
////        print (parameters)
////        let headers: HTTPHeaders =
////        [
////            "Content-Type": "application/json"
////        ]
////        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////            .responseJSON { response in
////                print(response)
////                SKActivityIndicator.dismiss()
////                switch(response.result) {
////
////                case .success:
////                    if let json = response.result.value
////                    {
////                        let JSON = json as! NSDictionary
////                        print(JSON)
////                        if(JSON["status"] as? String == "success")
////                        {
////                        self.view.makeToast(JSON["message"] as? String)
////                        self.getData()
////                        }
////                        else
////                        {
////                            self.view.makeToast(JSON["message"] as? String)
////                        }
////                    }
////                    break
////
////                case .failure(let error):
////                    print(error)
////                    break
////
////                }
////        }
////    }
////    @IBAction func listviewBtnAction(_ sender: UIButton)
////    {
////        if(isGrid == true)
////        {
////            isGrid = false
////            listcollectionview.isHidden = true
////            mTableView.isHidden = false
////            self.mGridImageView.image = UIImage(named: "gridView")
////        }
////        else
////        {
////            isGrid = true
////            listcollectionview.isHidden = false
////            mTableView.isHidden = true
////            self.mGridImageView.image = UIImage(named: "Listview")
////        }
////        if(isFilterData == false)
////        {
////            getData()
////        }
////    }
////    @IBAction func cartBtnAction(_ sender: UIButton)
////    {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let vc = storyboard.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
////        self.navigationController?.pushViewController(vc, animated: true)
////    }
////    @IBAction func notificationBtnAction(_ sender: UIButton)
////    {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
////        self.navigationController?.pushViewController(myVC!, animated: true)
////    }
//
////    @IBAction func searchBtnAction(_ sender: UIButton)
////    {
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
////        self.navigationController?.pushViewController(vc, animated: true)
////    }
////
////    @objc func addBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
////        cell?.mCartView.isHidden = false
////        cell?.mCartCountLabel.text = "1"
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters = [
////                "customer_id" : userID ?? "",
////                "product_id" : productID,
////                "quantity" : "1",
////                "product_option_id" : optionID ?? "",
////                "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters = [
////                "customer_id" : userID ?? "",
////                "product_id" : productID,
////                "quantity" : "1",
////            ]
////        }
////
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    @objc func plusBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
////        cell?.mCartView.isHidden = false
////
////        //cell?.mCartCountLabel.text = "1"
////        let countStr = cell?.mCartCountLabel.text
////        var count : Int = 0
////        count = Int(countStr!)!
////        count = count + 1
////        cell?.mCartCountLabel.text = String(format:"%d",count)
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters =
////                [
////                    "customer_id" : userID ?? "",
////                    "product_id" : productID,
////                    "quantity" : count,
////                    "product_option_id" : optionID ?? "",
////                    "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters =
////                [ "customer_id" : userID ?? "",
////                  "product_id" : productID,
////                  "quantity" : count,
////            ]
////        }
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            //self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    @objc func minusBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
////        cell?.mCartView.isHidden = false
////        //cell?.mCartCountLabel.text = "1"
////        let countStr = cell?.mCartCountLabel.text
////        var count : Int = 0
////        count = Int(countStr!)!
////        count = count - 1
////        if(count == 0)
////        {
////            cell?.mCartView.isHidden = true
////            cell?.mCartBtn.isHidden = false
////        }
////        cell?.mCartCountLabel.text = String(format:"%d",count)
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////        var Url =  ""
////        if(count == 0)
////        {
////             Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////        }
////        else
////        {
////            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////        }
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters =
////                [
////                    "customer_id" : userID ?? "",
////                    "product_id" : productID,
////                    "quantity" : count,
////                    "product_option_id" : optionID ?? "",
////                    "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters =
////                [ "customer_id" : userID ?? "",
////                  "product_id" : productID,
////                  "quantity" : count,
////            ]
////        }
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            //self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    @objc func listAddBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
////        cell?.mCartView.isHidden = false
////        cell?.mCartCountLabel.text = "1"
////        cell?.mAddView.isHidden = true
////
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////         let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters = [
////                "customer_id" : userID ?? "",
////                "product_id" : productID,
////                "quantity" : "1",
////                "product_option_id" : optionID ?? "",
////                "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters = [
////                "customer_id" : userID ?? "",
////                "product_id" : productID,
////                "quantity" : "1",
////            ]
////        }
////
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    @objc func listPlusBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
////        cell?.mCartView.isHidden = false
////        cell?.mAddView.isHidden = true
////        //cell?.mCartCountLabel.text = "1"
////        let countStr = cell?.mCartCountLabel.text
////        var count : Int = 0
////        count = Int(countStr!)!
////        count = count + 1
////        cell?.mCartCountLabel.text = String(format:"%d",count)
////
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters =
////                [
////                    "customer_id" : userID ?? "",
////                    "product_id" : productID,
////                    "quantity" : count,
////                    "product_option_id" : optionID ?? "",
////                    "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters =
////                [ "customer_id" : userID ?? "",
////                  "product_id" : productID,
////                  "quantity" : count,
////            ]
////        }
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            //self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    @objc func listMinusBtnAction(_ sender: UIButton)
////    {
////        let tag = sender.tag
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let productID = dict!["product_id"] as! String
////        let path = IndexPath(row: tag, section: 0)
////        let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
////        cell?.mCartView.isHidden = false
////        cell?.mAddView.isHidden = true
////        //cell?.mCartCountLabel.text = "1"
////        let countStr = cell?.mCartCountLabel.text
////        var count : Int = 0
////        count = Int(countStr!)!
////        count = count - 1
////        if(count == 0)
////        {
////            cell?.mCartView.isHidden = true
////            cell?.mAddView.isHidden = false
////        }
////
////        cell?.mCartCountLabel.text = String(format:"%d",count)
////
////        let selectedRow = cell?.mGramTF.selectedRow
////        var optionID : String!
////        var optionValueID : String!
////        var isOPtionsAvailable : Bool = false
////
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow!] as? NSDictionary
////                        optionID = optDict!["product_option_id"] as? String
////                        optionValueID = optDict!["product_option_value_id"] as? String
////                        isOPtionsAvailable = true
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow!] as? NSDictionary
////                    optionID = weighDict!["product_option_id"] as? String
////                    optionValueID = weighDict!["product_option_value_id"] as? String
////                    isOPtionsAvailable = true
////                }
////            }
////        }
////
////         SKActivityIndicator.show("Loading...")
////         let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
////         print(Url)
////         let userID =  UserDefaults.standard.string(forKey: "customer_id")
////        var parameters: Parameters = [:]
////        if(isOPtionsAvailable)
////        {
////            parameters =
////                [
////                    "customer_id" : userID ?? "",
////                    "product_id" : productID,
////                    "quantity" : count,
////                    "product_option_id" : optionID ?? "",
////                    "product_option_value_id" : optionValueID ?? ""
////            ]
////        }
////        else{
////            parameters =
////                [ "customer_id" : userID ?? "",
////                  "product_id" : productID,
////                  "quantity" : count,
////            ]
////        }
////
////         print (parameters)
////         let headers: HTTPHeaders =
////         [
////         "Content-Type": "application/json"
////         ]
////         Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
////         .responseJSON { response in
////         print(response)
////         SKActivityIndicator.dismiss()
////         switch(response.result) {
////
////         case .success:
////         if let json = response.result.value
////         {
////         let JSON = json as! NSDictionary
////         print(JSON)
////         if(JSON["status"] as? String == "success")
////         {
////         self.view.makeToast(JSON["message"] as? String)
////         self.getCartCount()
////         }
////         else
////         {
////            //self.view.makeToast(JSON["message"] as? String)
////            }
////         }
////         break
////
////         case .failure(let error):
////         print(error)
////         break
////
////         }
////         }
////
////    }
////    //MARK: IQDropdown delegate
////    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
////        print ("textFieldTag=\(textField.tag)")
////        print ("item=\(textField.selectedRow)")
////        if (textField.selectedRow == -1) {
////            textField.selectedRow = 1
////        }
////        let selectedRow = textField.selectedRow
////        let path = IndexPath(row: textField.tag, section: 0)
////        let tag = textField.tag
////        var finalPrice : String!
////        var finalDiscount : String!
////        var cartValue : String!
////        let dict = self.itemsArray[tag] as? NSDictionary
////        let weights = dict!["weight_classes"] as? AnyObject
////        let options = dict!["options"] as? AnyObject
////        if(weights as? String == "null" && options as? String == "null")
////        {
////
////        }
////        else{
////            if(weights == nil || weights as? String == "null")
////            {
////
////
////                if(options == nil || options as? String == "null")
////                {
////                }
////                else
////                {
////                    var optArray = dict!["options"] as? NSArray
////                    if((optArray?.count)! > 0)
////                    {
////                        var optDict = optArray![selectedRow] as? NSDictionary
////                        let priceSting = String(format : "%d",optDict!["price"] as? Int ?? "")
////                        finalPrice = String(format : "₹%@",priceSting)
////
////                        let doubleSting = String(format : "%d",optDict!["discount_price"] as? Int ?? "")
////                        finalDiscount = String(format : "₹%@",doubleSting)
////                        if(optDict!["cart_count"] as? Int == 0 || optDict!["cart_count"] as? String == "0")
////                        {
////                            cartValue = "0"
////                        }
////                        else{
////                            cartValue = String(format : "%@",(optDict!["cart_count"] as? String)!)
////                        }
////
////                    }
////                }
////            }
////            else //if((weights?.count)! > 0)
////            {
////                var weighArray = dict!["weight_classes"] as? NSArray
////                if((weighArray?.count)! > 0)
////                {
////                    var weighDict = weighArray![selectedRow] as? NSDictionary
////                    let priceSting = String(format : "%d",weighDict!["price"] as? Int ?? "")
////                    finalPrice = String(format : "₹%@",priceSting)
////
////                    let doubleSting = String(format : "%d",weighDict!["discount_price"] as? Int ?? "")
////                    finalDiscount = String(format : "₹%@",doubleSting)
////                    if(weighDict!["cart_count"] as? Int == 0 || weighDict!["cart_count"] as? String == "0")
////                    {
////                        cartValue = "0"
////                    }
////                    else{
////                        cartValue = String(format : "%@",(weighDict!["cart_count"] as? String)!)
////                    }
////
////
////                }
////            }
////
////        }
////        if(isGrid == true)
////        {
////            let cell = self.listcollectionview.cellForItem(at: path) as! ProductListCell?
////             cell?.productCostLabel.text = finalPrice
////            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
////            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
////            cell?.attributeLabel.attributedText = attributeString
////
////            if(cartValue == "0" )
////            {
////                cell?.mCartBtn.isHidden = false
////                cell?.mCartView.isHidden = true
////            }
////            else
////            {
////                cell?.mCartBtn.isHidden = true
////                cell?.mCartView.isHidden = false
////                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
////            }
////        }
////        else{
////            let cell = self.mTableView.cellForRow(at: path) as! ListViewTableViewCell?
////            cell?.priceLabel.text = finalPrice
////            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: finalDiscount)
////            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
////            cell?.listattributeLabel.attributedText = attributeString
////
////            if(cartValue == "0" )
////            {
////                cell?.mAddView.isHidden = false
////                cell?.mCartView.isHidden = true
////            }
////            else
////            {
////                cell?.mAddView.isHidden = true
////                cell?.mCartView.isHidden = false
////                cell?.mCartCountLabel.text = String(format : "%@",cartValue)
////            }
////        }
////
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        let productID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductOneVC") as? ProductOneVC
        myVC?.ProductID = productID! as NSString as String;
        self.navigationController?.pushViewController(myVC!, animated: false)
    }








}
