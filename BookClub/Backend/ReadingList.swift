//
//  ReadingList.swift
//  BookClub
//
//  Created by Malik Falana on 2/24/24.
//  Class model for user genreated lists

import Foundation
import SwiftyJSON
import SwiftData

@Model
final class ReadingList
{
    var id: String = UUID().uuidString
    var title: String = ""
    var urlString: String = ""
    var updateFrequency: String = ""
    var isBestSellerList: Bool = false
    @Relationship(deleteRule: .cascade) var books = [Book]()
    //@Relationship(deleteRule: .cascade) var books: [Book] = []
    //var books: [Book] = []

    init?(_ json: JSON?, _ title: String?, _ ModelContext: ModelContext?)
    {
        if let title
        {
            self.title = title
        }
        
        if let source = json
        {
            self.id = source["list_id"].stringValue
            self.title = source["display_name"].stringValue
            self.urlString = source["list_name_encoded"].stringValue
            self.updateFrequency = source["updated"].stringValue
            self.isBestSellerList = true
            
            //print("\(self.title) has the id \(id)")
            
            for item in source["books"].arrayValue
            {
                print(item)
                
                let newBook = Book(nil, item)!
                
                //self.books.append(newBook)
                
                ModelContext?.insert(newBook)
                
                if self.books.isEmpty
                {
                    self.books = [newBook]
                }
                else
                {
                    self.books.append(newBook)
                }
                
                //addToList(item: newBook)
            }
        }
    }
    
    func addToList(item: Book)
    {
        books.append(item)
    }
    
    func removeFromList(item: Book)
    {
        books.removeAll(where: {$0.ibsn == item.ibsn} )
    }
}



extension String
{
    var isInt: Bool
    {
        return Int(self) != nil
    }
}
