//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import UIKit

struct NetworkManager {
    func getIconImage(byName iconName: String) async -> UIImage? {
        let urlString: String = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        return await getIconImage(with: urlString)
    }
    
    func getIconImage(with urlString: String) async -> UIImage? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url)
        else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
}
