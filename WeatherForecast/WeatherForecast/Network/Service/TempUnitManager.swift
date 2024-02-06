//
//  TempUnitManager.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/06.
//

import Foundation

final class TempUnitManager: TempUnitManagerService {
    var tempUnit: TempUnit = .metric
    
    func update() {
        switch tempUnit {
        case .metric:
            tempUnit = .imperial
        case .imperial:
            tempUnit = .metric
        }
    }
    
    
}
