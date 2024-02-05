//
//  Observable.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

final class Observable<T> {
  typealias Listener = (T) -> Void
  var value: T?
  private var listener: Listener?
  
  init(value: T) {
    self.value = value
  }
  
  func subscribe(listener: Listener?) {
    self.listener = listener
    
    if let value = value {
      self.listener?(value)
    }
  }
  
  func onNext(_ value: T) {
    self.value = value
    listener?(value)
  }
}
