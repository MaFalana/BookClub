//
//  BookManager.swift
//  BookClub
//
//  Created by Malik Falana on 2/15/24.
//

import Foundation
import SwiftyJSON
import SwiftData
import SwiftUI

class BookManager: ObservableObject
{
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = BookManager() // Singleton instance

    @MainActor
    private init() 
    {
        self.modelContainer = try! ModelContainer(for: Book.self, ReadingList.self)
        self.modelContext = modelContainer.mainContext
        self.fetchItems()
        self.getLists()
        print("\(items.count) Items")
        self.getBestSellers()
    }
    
    @ObservedObject var AM = ApiManager.shared
    
    @ObservedObject var LM = LocationManager.shared
    
    @ObservedObject var NY = NYTimeManager.shared

    @Published var editMode = false
    
    //@Environment(\.modelContext) var modelContext
    
    //@Query public var items: [Book]
    
    @Published var staticList: ReadingList = ReadingList(nil, "", nil)!
    
    @Published var bestSellers: [ReadingList] = []
    
    @Published var activeLists = [ReadingList]()
    
    @Published var items: [Book] = []
    
    @Published var searchResults = [Book]()
    
    @Published var showScan = false
    
    public func addToHistory(book: Book)
    {
        do
        {
            try withAnimation
            {
                modelContext.insert(book)
                try modelContext.save()
                fetchItems() // reload fetch
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func addBook(JSON: JSON)
    {
        do
        {
            try withAnimation
            {
                let newBook = Book(JSON,nil)!
                modelContext.insert(newBook)
                try modelContext.save()
                fetchItems() // reload fetch
                //searchResults.append(newBook)
                showScan.toggle()
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    private func fetchItems()
    {
        do
        {
            let fetchDescriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.timestamp)])
            items = (try modelContext.fetch(fetchDescriptor) )
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func deleteItems(offsets: IndexSet)
    {
        
        do
        {
            try withAnimation
            {
                for index in offsets
                {
                    modelContext.delete(items[index])
                }
                try modelContext.save()
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func search(query: String)
    {
        Task
        {
            if !searchResults.isEmpty
            {
                searchResults.removeAll()
            }
            
            let data = await AM.searchBook(query: query)//["items"].arrayValue
            
            //print(data)
            
            for item in data
            {
                if let result = Book(item.1,nil)
                {
                    
                    searchResults.append(result)
                }
            }
            
            print(searchResults.count)
            print(searchResults.first?.cover ?? "")
        }
    }
    
    public func scanBook(IBSN: String)
    {
        Task
        {
            let data = await AM.findBook(IBSN: IBSN) //["items"].arrayValue
            
            //print(data)
            
            for item in data
            {
                print(item)
                
                addBook(JSON: item.1) // adds data to history
            }
        }
    }
    
//    public func refreshLocations() -> [Location]
//    {
//        let mapItems = LM.findNearbyLocations()
//        
//        var data: [Location] = []
//        
//        for item in mapItems!
//        {
//            print(item)
//            
//            let newLocation = Location(item)!
//            
//            data.append(newLocation)
//        }
//        
//        return data
//    }

    func getBestSellers()
    {
        Task 
        {
            let source = await NY.getBestSellerLists()
            
            let lists = source["lists"].arrayValue
            
            for list in lists
            {
                let newList = ReadingList(list, nil, nil)!

                bestSellers.append(newList)
            }

        }
    }
    
    private func getLists()
    {
        do
        {
            //let questionPredicate = #Predicate<ReadingList> { $0.books.isEmpty }
            let fetchDescriptor = FetchDescriptor<ReadingList>(sortBy: [SortDescriptor(\.id)])
            activeLists = (try modelContext.fetch(fetchDescriptor) )
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    func createList(name: String)
    {
        do
        {
            let newList = ReadingList(nil, name, nil)!
            
            activeLists.append(newList)
            
            try modelContext.save()
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func updateList(list: ReadingList, name: String)
    {
        
        do
        {
            list.title = name
            
            try modelContext.save()
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteList(source: ReadingList)
    {
        
    }

}
