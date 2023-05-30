//
//  Configurator.swift
//  Caching
//
//  Created by AMALITECH MACBOOK on 28/04/2023.
//

import Foundation
final class Configurator {
    private func getSecretItem(isURL: Bool = true, baseURL: _Secrets) -> String{
        let fetchedLink = Bundle.main.object(forInfoDictionaryKey: baseURL.rawValue ) as? String
        guard let secretURL = fetchedLink, !(secretURL.isEmpty ) else {
            fatalError("URL is empty")
        }
        return isURL ? "https://\(secretURL)": secretURL
    }
    lazy var baseURL: String = {
        return getSecretItem(baseURL: .BaseURL)
    }()
    lazy var apikey: String = {
        return getSecretItem(isURL: false, baseURL: .ApiKey)
    }()
    enum _Secrets: String {
        case BaseURL
        case ApiKey
    }
}

