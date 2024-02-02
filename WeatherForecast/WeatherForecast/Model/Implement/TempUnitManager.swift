//
//  TempUnitManager.swift
//  WeatherForecast
//
//  Created by hyosung on 2/3/24.
//

final class TempUnitManager: TempUnitManagerService {
  private var tempUnit: TempUnit = .metric
  private let tempObservable: Observable<TempUnit> = .init(value: .metric)
  var currentValue: TempUnit {
    return tempObservable.value ?? .imperial
  }
}

extension TempUnitManager {
  func subscribe(_ listener: @escaping (TempUnit) -> Void) {
    return tempObservable.subscribe(listener: listener)
  }
  
  func update() {
    switch tempUnit {
    case .metric:
      tempUnit = .imperial
      tempObservable.onNext(tempUnit)
    case .imperial:
      tempUnit = .metric
      tempObservable.onNext(tempUnit)
    }
  }
}
