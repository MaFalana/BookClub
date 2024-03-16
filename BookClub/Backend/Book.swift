//
//  Book.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import Foundation
import SwiftData
import SwiftyJSON
import SwiftUI

@Model
final class Book
{
    var ibsn: [String] = []
    var title: String = ""
    var author: [String] = []
    var publisher: String = ""
    var publishDate: String = ""
    var synopsis: String = ""
    var cover: URL = URL(string: "https://placehold.co/60x110")!
    var pages: Int = 0
    var timestamp: Date = Date()
    var isFavorited: Bool = false
    var inHistory: Bool = false
    var availbility: [Location]?
    var recommendations: [Book]?
    @Relationship(inverse: \ReadingList.books) var lists: [ReadingList]?
    
    init?(_ json: JSON?, _ ny: JSON?)
    {
        guard let source = json ?? ny else 
        {
            return nil // Exit early if both json and ny are nil
        }
        
        if let source = json
        {
            //self.ibsn = source["volumeInfo"]["industryIdentifiers"][0]["identifier"].stringValue
            
            for item in source["volumeInfo"]["industryIdentifiers"].arrayValue
            {
                self.ibsn.append(item["identifier"].stringValue)
            }
                
            self.title = source["volumeInfo"]["title"].stringValue
            
            if let authorsArray = source["volumeInfo"]["authors"].array {
                self.author = authorsArray.compactMap { $0.string }
            } else {
                // Handle the case where "authors" is not an array or is nil
                self.author = [] // or set to an appropriate default value
            }

            
            self.publisher = source["volumeInfo"]["publisher"].stringValue
            
            self.publishDate = source["volumeInfo"]["publishedDate"].stringValue
            
            self.synopsis = source["volumeInfo"]["description"].stringValue
            
            if source["volumeInfo"]["imageLinks"].exists()
            {
                self.cover = URL(string: source["volumeInfo"]["imageLinks"]["thumbnail"].stringValue.replacingOccurrences(of: "http", with: "https") )!
            }
            
            self.pages = source["volumeInfo"]["pageCount"].intValue
        }
        
        if let source = ny
        {
            self.ibsn = [source["primary_isbn13"].stringValue]
            self.title = source["title"].stringValue
            self.author = [source["author"].stringValue]
            self.publisher = source["publisher"].stringValue
            //self.publishDate = ""
            self.synopsis = source["description"].stringValue
            self.cover = URL(string: source["book_image"].stringValue) ?? self.cover
        }
        
        //self.availbility = []
    }
    
    func updateAvailbility(items: [Location])
    {
        self.availbility = items
    }
    
}

