//
//  LocaleIdentifier.swift
//  WeatherForecast
//
//  Created by user on 2/9/24.
//

import Foundation

protocol Localable {
    static var identifier: String { get set }
    static var regionCode: String? { get set }
    static var languageCode: String? { get set }
    
    func getLocaleIdentifier() -> String
}

struct LocalIdentifier: Localable {
    static var identifier: String = Locale.current.identifier
    static var regionCode: String? = Locale.current.region?.identifier
    static var languageCode: String? = Locale.current.language.languageCode?.identifier
}

extension LocalIdentifier {
    func getLocaleIdentifier() -> String {
        guard let regionCode =  LocalIdentifier.regionCode else { return KoreaIdentifierCode }
        guard let languageCode = LocalIdentifier.languageCode else { return KoreaIdentifierCode }
        
        return "\(LocalIdentifier.identifier)_\(LocalIdentifier.regionCode)-\(LocalIdentifier.languageCode)"
    }
}
