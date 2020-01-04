//
//  ImageService.swift
//  Hyped Books
//
//  Created by Азизбек on 04.01.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit
class ImageService {
    static let cashe = NSCache<NSString, UIImage>()
    
    static func dowloadImage(withURL url: URL, complition: @escaping (_ image: UIImage?)->()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            var dowloadedImage:UIImage?
             guard let data = data else{return}
            dowloadedImage = UIImage(data: data)
            
            if dowloadedImage != nil{
//                Cashing image
                cashe.setObject(dowloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            
            DispatchQueue.main.async {
               complition(dowloadedImage)
            }
            
        }
        dataTask.resume()
    }
    
    static func getImageFromCashe(withURL url: URL, complition: @escaping (_ image: UIImage?)->()){
        if let image = cashe.object(forKey: url.absoluteString as NSString){
            complition(image)
        }else{
            dowloadImage(withURL: url, complition: complition)
        }
    }
    
}
