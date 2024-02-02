//
//  TempUnitManagerService.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

protocol TempUnitManagerService: AnyObject {
  func subscribe(_ listener: @escaping (TempUnit) -> Void)
  func update()
  var currentValue: TempUnit { get }
}
