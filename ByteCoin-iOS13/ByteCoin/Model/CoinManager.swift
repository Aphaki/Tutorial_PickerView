//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateCoinPrice(_ coinManager: CoinManager, rates: [Rate])
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "878E4423-AF7E-4075-A04A-1D3EA03B07A3"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","KRW","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            print("!! Invalid URL !!")
            return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                delegate?.didFailWithError(error: error!)
                print(error!)
                return
            }
            if let safeData = data {
                if let decodedData = self.parseJSON(safeData) {
                    let myRates = customFiltering(totalRates: decodedData.rates, myCurrencyArray: currencyArray)
                    self.delegate?.didUpdateCoinPrice(self, rates: myRates)
                }
            }
        }
    }
    
    private func parseJSON(_ data: Data) -> RateData? {
        let decoder = JSONDecoder()
        do {
          let decodedData = try decoder.decode(RateData.self, from: data)
            return decodedData
        } catch let error{
            print(error)
            return nil
        }
    }
    
    private func customFiltering(totalRates: [Rate], myCurrencyArray: [String]) -> [Rate] {
        var myArray = [Rate]()
        for assetId in myCurrencyArray {
           if let value =
                totalRates.first(where: { rate in
                    return rate.assetIDQuote == assetId
                }) {
            myArray.append(value)
           }
        }
        return myArray
        
    }
}
