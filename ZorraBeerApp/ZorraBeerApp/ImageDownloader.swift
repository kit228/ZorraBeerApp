//
//  ImageDownloader.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 20.07.2021.
//

import UIKit

class ImageDownloader {
    
    static let imageDownloaderSingletone = ImageDownloader()
    
    var imageCache = NSCache<NSString, UIImage>() // кеш картинок
    
    func downloadImageOrCache(imageUrl: URL, completion: @escaping (UIImage?) -> Void) { // @escaping потому, что сбегающее замыкание
        
        if let cachedImage = imageCache.object(forKey: imageUrl.absoluteString as NSString) {
            
            completion(cachedImage) // возвращаем картинку, если она есть в кеше
            print("Вернули картинку из кеша")
            
        } else { // если в кеше нет - грузим картинку
            let dataTask = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                
//                if let response = response {
//                    print("response: \(response)")
//                }
                
                if let error = error {
                    print("Ошибка загрузки: \(error)")
                }
                
                guard let responsedData = data else {
                    //completion(nil) // убрал //completion(nil), потому что возвращала пустую картинку и не давала поставить заглушку
                    return
                }
                
                guard let image = UIImage(data: responsedData) else { // проверяем, загрузилась ли картинка
                    //completion(nil)
                    return
                }
                self.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString) // кладем загруженную картинку в кеш
                completion(image) // возвращаем загруженную картинку
            }
            dataTask.resume() // для URLDatatask
        }
    }
    
}
