//
//  Observable.swift
//  WeatherForecast
//
//  Created by hyosung on 2/2/24.
//

final class Observable<T> {
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  func subscribe(listener: Listener?) {
    self.listener = listener
  }
  
  func onNext(_ value: T) {
    listener?(value)
  }
}
