//
//  ImageLoader.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/8/24.
//

import UIKit

enum ImageDirectory: CaseIterable {
    case memory
    case disk
}

fileprivate extension ImageDirectory {
    var cache: ImageCacheable? {
        switch self {
        case .memory:
            return MemoryCacheManager.shared
        case .disk:
            return DiskCacheManager()
        }
    }
}

protocol ImageLoadable {
    func getImage(from directory: ImageDirectory, forKey urlString: String) -> UIImage?
    func getImageFromDownload(with urlString: String) async -> UIImage?
}

struct ImageLoader: ImageLoadable {

    private let networkManager: NetworkManagerDelegate
    
    init(networkManager: NetworkManagerDelegate = NetworkManager()) {
        self.networkManager = networkManager
    }

    func getImage(from directory: ImageDirectory, forKey urlString: String) -> UIImage? {
        return directory.cache?.getImage(forKey: urlString)
    }
    
    func getImageFromDownload(with urlString: String) async -> UIImage? {
        guard let image = await networkManager.getIconImage(with: urlString) 
        else {
            return nil
        }
        
        self.setImage(image, forKey: urlString)
        
        return image
    }
    
    private func setImage(_ image: UIImage, forKey key: String) {
        ImageDirectory.allCases.forEach { directory in
            directory.cache?.setImage(image, forKey: key)
        }
    }

}
