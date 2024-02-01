//
//  WeatherListViewModel.swift
//  WeatherForecast
//
//  Created by 윤형석 on 2/1/24.
//

import Foundation

final class WeatherListViewModel {
    private(set) var weatherJSON: WeatherJSON?
    private(set) var tempUnit: TempUnit = .metric
    let imageDataChache: NSCache<NSString, NSData> = NSCache()

    let dataRequester: DataRequestable
    let jsonExtracter: any JsonExtractable

    init(dataRequester: DataRequestable = DataRequest(), jsonExtracter: any JsonExtractable = WeatherJsonExtracter()) {
        self.dataRequester = dataRequester
        self.jsonExtracter = jsonExtracter
    }
}

// MARK: - Return Funcs..

extension WeatherListViewModel {
    func extractedWeatherJsonResult() -> WeatherJsonExtracter.Result? {
        guard let result = jsonExtracter.extract() as? WeatherJsonExtracter.Result else { return nil }
        return result
    }
    
    func weatherIconImageDataAfterRequest(urlString: String) async -> Data? {
        do {
            let data = try await dataRequester.request(urlString: urlString)
            return data
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func dataFromImageDataCache(key: String) -> Data? {
        let imageNSData: NSData? = imageDataChache.object(forKey: key as NSString)
        
        guard let imageNSData = imageNSData else { return nil }
        let data = Data(referencing: imageNSData)
        
        return data
    }

    func urlStringForIconRequest(iconName: String) -> String {
        return "https://openweathermap.org/img/wn/\(iconName)@2x.png"
    }
    
    func weatherForecastInfo(index: Int) -> WeatherForecastInfo? {
        return weatherJSON?.weatherForecast[index]
    }
}


// MARK: - Set Funcs..

extension WeatherListViewModel {
    func setWeatherJson(_ weatherJson: WeatherJSON) {
        self.weatherJSON = weatherJson
    }
    
    func setImageDataCache(data: Data?, key: String) {
        if let data = data {
           imageDataChache.setObject(NSData(data: data), forKey: key as NSString)
        }
    }
    
    func setTempUnit(state: TempUnit) {
        tempUnit = state
    }
}

// MARK: - ETC Funcs..

extension WeatherListViewModel {
    
    func changeTempUnit() {
        tempUnit.change()
    }
}
