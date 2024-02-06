//
//  TempUnitManagerService.swift
//  WeatherForecast
//
//  Created by MIN SEONG KIM on 2024/02/06.
//

import Foundation

protocol TempUnitManagerService {
    var tempUnit: TempUnit { get }
    
    func update()
}
