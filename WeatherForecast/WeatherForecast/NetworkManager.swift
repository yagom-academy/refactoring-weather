//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Tony Lim on 2/6/24.
//

import UIKit

protocol NetworkManagerDelegate {
    func getIconImage(with urlString: String) async -> UIImage?
}

struct NetworkManager: NetworkManagerDelegate {
    func getIconImage(with urlString: String) async -> UIImage? {
        guard let url: URL = URL(string: urlString),
              let (data, _) = try? await URLSession.shared.data(from: url)
        else {
            return nil
        }
        
        return UIImage(data: data)
    }
}
