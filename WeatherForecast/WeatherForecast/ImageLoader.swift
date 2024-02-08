//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/8/24.
//

import UIKit

struct ImageDirectories: OptionSet {
    let rawValue: Int
    
    static let none: ImageDirectories = .init(rawValue: 0)
    static let memory: ImageDirectories = .init(rawValue: 1 << 0)
    static let disk: ImageDirectories = .init(rawValue: 1 << 1)
    static let all: ImageDirectories = [.memory, .disk]
}

protocol ImageLoadable {
    func loadImage(with urlString: String, 
                   from directories: ImageDirectories) async -> UIImage?
}

struct ImageLoader: ImageLoadable {

    private let memoryCacheManager: ImageCacheable
    private let diskCacheManager: ImageCacheable?
    private let networkManager: NetworkManagerDelegate
    
    init(memoryCacheManager: ImageCacheable = MemoryCacheManager.shared,
         diskCacheManager: ImageCacheable? = DiskCacheManager(),
         networkManager: NetworkManagerDelegate = NetworkManager()
    ) {
        self.memoryCacheManager = memoryCacheManager
        self.diskCacheManager = diskCacheManager
        self.networkManager = networkManager
    }
    
    func loadImage(with urlString: String, 
                   from directories: ImageDirectories
    ) async -> UIImage? {
        if directories.contains(.memory) {
            if let image = memoryCacheManager.getImage(forKey: urlString) {
                return image
            }
        }
        
        if directories.contains(.disk) {
            if let image = diskCacheManager?.getImage(forKey: urlString) {
                return image
            }
        }
        
        if !directories.contains([.memory, .disk]) {
            guard let image = await downloadImage(with: urlString)
            else { return nil }
            
            saveImage(image, forKey: urlString, at: directories)
            
            return image
        }
        
        return nil
    }

    private func downloadImage(with urlString: String) async -> UIImage? {
        guard let image = await networkManager.getIconImage(with: urlString)
        else {
            return nil
        }
        
        return image
    }
    
    private func saveImage(_ image: UIImage, forKey key: String, at directories: ImageDirectories) {
        if directories.contains(.memory) {
            memoryCacheManager.setImage(image, forKey: key)
        }
        
        if directories.contains(.disk) {
            diskCacheManager?.setImage(image, forKey: key)
        }
    }

}
