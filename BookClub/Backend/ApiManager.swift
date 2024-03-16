//
//  ApiManager.swift
//  BookClub
//
//  Created by Malik Falana on 2/13/24.
//

import Foundation
import SwiftyJSON

class ApiManager: ObservableObject
{
    static let shared = ApiManager() // Singleton instance
    
    // https://www.googleapis.com/books/v1/volumes?q=isbn:9780553804577
    
    public func findBook(IBSN: String) async -> JSON
    {
        do
        {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "www.googleapis.com"
            components.path = "/books/v1/volumes"
            components.queryItems =
            [
                URLQueryItem(name: "q", value: "isbn:\(IBSN)")
            ]

            guard let url = components.url else // Create the URL
            {
                print("Failed to create URL in the findBook function")
                return JSON()
            }
            
            print(url)
            
            let (data, _) = try await URLSession.shared.data(from: url)
                            
            if let json = try? JSON(data: data)
            {
                return json["items"]
            }
        }
        catch let error
        {
            print("There was an issue finding a book with the IBSN \(IBSN): \(error)")
        }
        
        return JSON() // return an appropriate value here in case of an error

    }
    
    public func searchBook(query: String) async -> JSON
    {
        do
        {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "www.googleapis.com"
            components.path = "/books/v1/volumes"
            components.queryItems =
            [
                URLQueryItem(name: "q", value: query)
            ]

            guard let url = components.url else // Create the URL
            {
                print("Failed to create URL in the search function")
                return JSON()
            }
            
            print(url)
            
            let (data, _) = try await URLSession.shared.data(from: url)
                            
            if let json = try? JSON(data: data)
            {
                print(json["totalItems"])
                
                return json["items"]
                
            }
        }
        catch let error
        {
            print("There was an issue finding a book with the query \(query): \(error)")
        }
        
        return JSON() // return an appropriate value here in case of an error
    }
    
    private func findBookRecs()
    {
        
    }
    
}
