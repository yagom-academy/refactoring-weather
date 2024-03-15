//
//  ReusableCell.swift
//  WeatherForecast
//
//  Created by Kyeongmo Yang on 3/13/24.
//

import UIKit

protocol ReusableCell {
    associatedtype SuperView
    
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
    
    static func registerNib(superView: SuperView)
    static func registerClass(superView: SuperView)
    static func dequeueReusableCell(superView: SuperView, indexPath: IndexPath) -> Self
}

extension ReusableCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    static var nibName: String {
        String(describing: self)
    }
}

extension ReusableCell where Self: UITableViewCell, SuperView: UITableView {
    static func registerNib(superView: SuperView) {
        let nib = UINib(nibName: self.nibName, bundle: nil)
        superView.register(nib, forCellReuseIdentifier: self.reuseIdentifier)
    }
    
    static func registerClass(superView: SuperView) {
        superView.register(Self.self, forCellReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(superView: SuperView, indexPath: IndexPath) -> Self {
        guard let cell = superView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Error! \(self.reuseIdentifier)")
        }
        
        return cell
    }
}

extension ReusableCell where Self: UICollectionViewCell, SuperView: UICollectionView {
    static func registerNib(superView: SuperView) {
        let nib = UINib(nibName: self.nibName, bundle: nil)
        superView.register(nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func registerClass(superView: SuperView) {
        superView.register(Self.self, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(superView: SuperView, indexPath: IndexPath) -> Self {
        guard let cell = superView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Self else {
            fatalError("Error! \(self.reuseIdentifier)")
        }
        
        return cell
    }
}
