//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "37EDE0F6-CE61-4DF3-BE19-02897E958B78"
    var delegate: CoinManagerDelegate?
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        if let url = URL(string: "\(baseURL)/\(currency)?apikey=\(apiKey)") {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                } else {
                    if let safeData = data {
                        if let currency = self.parseJSON(for: safeData) {
                            self.delegate?.didUpdateCoin(self, coin: currency)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(for data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
}
