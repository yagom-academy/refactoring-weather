//
//  Utils.swift
//  WeatherForecast
//
//  Created by 김정원 on 2/8/24.
//

import Foundation
import UIKit

//final class Utils {
//    
//    static func formatDate(date: Date)
//    
//}

extension DateFormatter {
    static let koreanTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    static let date: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
}
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIImageView {
    
    static func fetchImage(iconName: String) async -> UIImage? {
        let iconImage = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        let cacheKey = NSString(string: iconImage)
        
        if let cachedImage = ImageCacheManager.shared.getImage(forKey: iconImage) {
            return cachedImage
            
        }
        guard let url = URL(string: iconImage) else {return nil }
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return nil
            }
            ImageCacheManager.shared.cacheImage(image, forKey: iconImage)
            return image
        } catch {
            print("Error fetching weather icon: \(error)")
            return nil
        }
    }
    
}
