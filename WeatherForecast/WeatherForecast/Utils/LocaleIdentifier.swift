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
    
    func getLocaleIdentifier() -> Locale
}

struct LocaleIdentifier: Localable {
    static var identifier: String = Locale.current.identifier
    static var regionCode: String? = Locale.current.region?.identifier
    static var languageCode: String? = Locale.current.language.languageCode?.identifier
}

extension LocaleIdentifier {
    func getLocaleIdentifier() -> Locale {
        guard let regionCode =  LocaleIdentifier.regionCode else { return KoreaLocaleCode }
        guard let languageCode = LocaleIdentifier.languageCode else { return KoreaLocaleCode }
        return Locale(identifier: "\(LocaleIdentifier.identifier)_\(LocaleIdentifier.regionCode)-\(LocaleIdentifier.languageCode)")
    }
}
