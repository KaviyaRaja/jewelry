//
//  File.swift
//  Jewelry
//
//  Created by Febin Puthalath on 02/10/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import Alamofire

//let kAPIHost = "http://3.213.33.73/APIT/public/api/"

class NetworkClass{
    static var shared = NetworkClass()
    
    func postDetailsToServer(withUrl strURL: String,withParam postParam: Dictionary<String, Any>,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        
        let url = Constants.BASEURL+strURL
        
        Alamofire.request(url, method: .post, parameters: postParam, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                
                
                print(response)
                print(response.result.value as Any)
                let json = response.result.value as? NSDictionary
                completion(true,json!);
                
                break
            case .failure:
                completion(false,[:])
                print(Error.self)
                
                
            }
            
            
        }
        
    }
    func getDetailsFromServer(withUrl strURL: String,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        
        let url = Constants.BASEURL+strURL
        
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                
                
                print(response)
                print(response.result.value as Any)
                let json = response.result.value as? NSDictionary
                completion(true,json!);
                
                break
            case .failure:
                
                completion(false,[:]);
                
                print(Error.self)
                
            }
            
            
            
            // Do any additional setup after loading the view.
        }
        
    }
    
    func getPinCodeDetail(withUrl strURL: String,completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void)
    {
        
        
        
        
        
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                
                
                print(response)
                print(response.result.value as Any)
                let json = response.result.value as? NSDictionary
                completion(true,json!);
                
                break
            case .failure:
                
                completion(false,[:]);
                
                print(Error.self)
                
            }
            
            
            
            // Do any additional setup after loading the view.
        }
        
    }
    
    func uploadImagesAsArray(withUrl strURL: String,withImages imageArray:[UIImage],completion:@escaping (_ isSuccess: Bool, _ response:NSDictionary) -> Void){
        let url = Constants.BASEURL+strURL
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
//            for image in imageArray {
//                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
//                    multipartFormData.append(imageData, withName:"file[]", fileName: "pictures", mimeType: "image/jpeg")
//                }
//            }
            
            for i in 0...imageArray.count-1{
                let image = imageArray[i]
                let imageName = String(format: "pictures%d", i)
                if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                    multipartFormData.append(imageData, withName:"file[]", fileName: imageName, mimeType: "image/jpeg")
                
            }
            }
            
            
        }, to: url) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                upload.responseJSON { (response) in
                    
                    print(response)
                    let json = response.result.value as? NSDictionary
                    completion(true,json!);
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                completion(false,[:]);            }
        }
    }
}

