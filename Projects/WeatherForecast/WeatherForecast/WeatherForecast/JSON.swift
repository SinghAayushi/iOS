//
//  JSON.swift
//  WeatherForecast
//
//  Created by nareshkalekar on 05/03/21.
//

import UIKit

typealias JSON = [String: Any]

class Weak<T: AnyObject> {
  fileprivate(set) weak var value: T?
  
  init(value: T?) {
    self.value = value
  }
}

enum Either<T, U> {
  case one(T)
  case two(U)
}

func delay(_ delay: Double, queue: DispatchQueue = .main, closure: @escaping () -> Void) {
  queue.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
