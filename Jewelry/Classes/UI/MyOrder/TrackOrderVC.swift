//
//  TrackOrderVC.swift
//  Jewelry
//
//  Created by Febin Puthalath on 12/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class TrackOrderVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    

    @IBOutlet weak var trackTableView: UITableView!
    var orderId = String()
    var trackArray : NSArray = []

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
        
        trackTableView.delegate = self
        trackTableView.dataSource = self
        trackTableView.estimatedRowHeight = 241
        
         trackTableView.register(UINib(nibName: "TrackOrderTableCell", bundle: .main), forCellReuseIdentifier: "TrackOrderTableCell")
        
        callForTrackDetails()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClk(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackOrderTableCell", for: indexPath)as!TrackOrderTableCell
        
        cell.bgView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.bgView.layer.shadowOffset = CGSize(width: 1, height:3)
        cell.bgView.layer.shadowOpacity = 0.6
        cell.bgView.layer.shadowRadius = 3.0
        cell.bgView.layer.cornerRadius = 5.0
        
        
        
        let dict = self.trackArray[indexPath.row] as? NSDictionary
        
        cell.orderIdLabel.text = String(format: "Order Id : %@", dict!["order_id"] as! String)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: dict!["delivery_date"] as! String) {
            print(dateFormatterPrint.string(from: date))
            
            cell.deiveryDateLabel.text = String(format: "Delivery expected by %@",dateFormatterPrint.string(from: date))
            
            
        } else {
            print("There was an error decoding the string")
        }

     
        
        var firstName = String()
        var lastName = String()
        var shippingAddress = String()
        var shipping_city = String()
        var shipping_postcode = String()
        var shipping_country = String()
        var shipping_zone = String()
        
        if let value = dict!["shipping_firstname"] as? String{
            if value == "null"{
                firstName = ""
            }
            else{
            firstName = value
            }
        }
        else{
            firstName = ""
        }
        if let value = dict!["shipping_lastname"] as? String{
            if value == "null"{
                lastName = ""
            }
            else{
                lastName = value
            }        }
        else{
            lastName = ""
        }
        if let value = dict!["shipping_address_1"] as? String{
            if value == "null"{
                shippingAddress = ""
            }
            else{
                shippingAddress = value
            }
            
            
        }
        else{
            shippingAddress = ""
        }
        if let value = dict!["shipping_city"] as? String{
            if value == "null"{
                shipping_city = ""
            }
            else{
                shipping_city = value
            }
            
        }
        else{
            shipping_city = ""
        }
        if let value = dict!["shipping_postcode"] as? String{
            if value == "null"{
                shipping_postcode = ""
            }
            else{
                shipping_postcode = value
            }
            
        }
        else{
            shipping_postcode = ""
        }
        if let value = dict!["shipping_country"] as? String{
            if value == "null"{
                shipping_country = ""
            }
            else{
                shipping_country = value
            }
            
        }
        else{
            shipping_country = ""
        }
        if let value = dict!["shipping_zone"] as? String{
            if value == "null"{
                shipping_zone = ""
            }
            else{
                shipping_zone = value
            }
            
        }
        else{
            shipping_zone = ""
        }
     
     
        cell.addressLabel.text = String(format: "%@ %@\n%@\n%@\n%@\n%@\n%@", firstName,lastName,shippingAddress,shipping_city,shipping_zone,shipping_country,shipping_postcode)
        
      
            for item in cell.trackTipView{
                if item.tag <= NSInteger(dict!["order_status_id"] as! String )!{
                    
                    item.backgroundColor = UIColor(red: 78/255.0, green: 138/255.0, blue: 78/255.0, alpha: 1.0)
                }
        }
        for item in cell.trackView{
            if item.tag < NSInteger(dict!["order_status_id"] as! String )!{
                
                item.backgroundColor = UIColor(red: 78/255.0, green: 138/255.0, blue: 78/255.0, alpha: 1.0)
            }
        }
        for item in cell.orderLabelCollection{
            if item.tag <= NSInteger(dict!["order_status_id"] as! String )!{
                
                item.textColor = UIColor(red: 78/255.0, green: 138/255.0, blue: 78/255.0, alpha: 1.0)
            }
        }
      
        return cell
    }
    private func tableView(tableView: UITableView,
                   heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        
        return 241
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func callForTrackDetails(){
        
        
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters = [String: Any]()
       parameters =
        [
            "order_id" : orderId ,
        "customer_id" : userID ?? ""
       ]
//parameters =
//        [
//            "order_id" : "4" ,
//            "customer_id" : "3"
//        ]
        
        
        NetworkClass.shared.postDetailsToServer(withUrl: "api/order/trackOrder", withParam: parameters) { (isSuccess, response) in
            
            
            print(response)
            
            
            if  isSuccess{
                if response["status"] as? String == "success"{
                   
                    
                    self.trackArray = (response["result"] as? NSArray)!
                    self.trackTableView.reloadData()
                    
                }
                else{
                    
                    
                    UserDefaults.standard.set(false , forKey: "login")
                    self.view.makeToast(response["message"]as? String)
                    return
                    
                }
                
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "issue with connecting to server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    @unknown default:
                        print("error")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            
            // Your Will Get Response here
        }
        
    }
    
    
}
