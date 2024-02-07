//
//  ImageCacheManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import UIKit

protocol ImageCacheable {
    func setImage(_ image: UIImage, forKey key: String)
    func getImage(forKey key: String) -> UIImage?
}

final class MemoryCacheManager: ImageCacheable {
    static let shared: MemoryCacheManager = .init()
    private var memoryCache: NSCache<NSString, UIImage> = .init()
    private init() {}
    
    func setImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
}

final class DiskCacheManager: ImageCacheable {
    private let fileManager = FileManager.default
    private var cachesDirectory: URL

    init?() {
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            print("잘못된 경로로 접근함.")
            return nil
        }
        self.cachesDirectory = cachesDirectory
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        let fileURL = cachesDirectory.appending(path: key)
        
        guard let data = image.jpegData(compressionQuality: 1.0)
        else { 
            print("이미지 -> jpegData 변환 실패")
            return
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("디스크에 쓰는거 실패함. \(error)")
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        let fileURL = cachesDirectory.appending(path: key)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("이미지 가져오는거 실패함. \(error)")
            return nil
        }
    }
}
