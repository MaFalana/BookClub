//
//  NYTimeManager.swift
//  BookClub
//
//  Created by Malik on 2/24/24.
//

import Foundation
import SwiftyJSON

class NYTimeManager: ObservableObject
{
    static let shared = NYTimeManager() // Singleton instance
    
    let apiKey = "GobuCk8CDOcgYaG1uAwALmLAiG7IFxnG"
    
    func getBestSellerLists() async -> JSON
    {
        do
        {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.nytimes.com"
            components.path = "/svc/books/v3/lists/full-overview.json"
            components.queryItems =
            [
                URLQueryItem(name: "api-key", value: apiKey)
            ]

            guard let url = components.url else // Create the URL
            {
                print("Failed to create URL in the getBestSellerLists function")
                return JSON()
            }
            
            print(url)
            
            let (data, _) = try await URLSession.shared.data(from: url)
                            
            if let json = try? JSON(data: data)
            {
                return json["results"]
            }
        }
        catch let error
        {
            print("There was an issue finding best sellers list: \(error)")
        }
        
        return JSON() // return an appropriate value here in case of an error


    }

    func getBestSeller(name: String) async -> JSON
    {
        do
        {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.nytimes.com"
            components.path = "/svc/books/v3/lists/\(name).json"
            components.queryItems =
            [
                URLQueryItem(name: "api-key", value: apiKey)
            ]

            guard let url = components.url else // Create the URL
            {
                print("Failed to create URL in the getBestSeller function")
                return JSON()
            }
            
            print(url)
            
            let (data, _) = try await URLSession.shared.data(from: url)
                            
            if let json = try? JSON(data: data)
            {
                return json["results"]
            }
        }
        catch let error
        {
            print("There was an issue finding best sellers list: \(error)")
        }
        
        return JSON() // return an appropriate value here in case of an error
    }

    
}



