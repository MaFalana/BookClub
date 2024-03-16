//
//  App Manager.swift
//  BookClub
//
//  Created by Malik Falana on 2/24/24.
//  Interface? to handle main app functions

import Foundation
import SwiftyJSON
import SwiftData
import SwiftUI

class AppManager: ObservableObject
{
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = AppManager() // Singleton instance

    @MainActor
    private init()
    {
        self.modelContainer = try! ModelContainer(for: Book.self, ReadingList.self)
        self.modelContext = modelContainer.mainContext
        
        self.fetchHistory() // Fetches history
        self.fetchReadingLists() // Fetches user genereated reading lists
        self.fetchBestSellers() // Fetches Best Sellers List (NY Times)
        
        print("There are \(history.count) unique items in the history")
        print("There are \(userLists.count) user generated lists")
    }
    
    @ObservedObject var AM = ApiManager.shared
    
    @ObservedObject var LM = LocationManager.shared
    
    @ObservedObject var NY = NYTimeManager.shared
    
    @Published var bestSellers = [ReadingList]()
    
    @Published var userLists = [ReadingList]()
    
    @Published var history = [Book]()
    
    @Published var searchResults = [Book]()
    
    @Published var showScan = false // not sure if needed
    
    @Published var showError = false // not sure if needed
    
    @Published var editMode = false
    
    @Published var staticList: ReadingList = ReadingList(nil, "", nil)!
    
    
    
    public func search(query: String)
    {
        Task
        {
            if !searchResults.isEmpty
            {
                searchResults.removeAll()
            }
            
            let data = await AM.searchBook(query: query)
            
            for item in data
            {
                if let result = Book(item.1 ,nil)
                {
                    
                    searchResults.append(result)
                }
            }
        }
    }
    
    func setReccomendations(book: Book)
    {
        Task
        {
            do
            {
                if book.author.first != nil
                {
                    let data = await AM.searchBook(query: book.author.first!)
                    
                    for item in data.arrayValue
                    {
                        let newBook = Book(item, nil)!
                        
                        if newBook.ibsn != book.ibsn && newBook.title != book.title
                        {
                            book.recommendations?.append(newBook)
                        }
                    }
                }
            }
            catch
            {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    func refreshLocations(book: Book)
    {
        Task
        {
            let mapItems = await LM.findNearbyLocations()
            
            var data: [Location] = []
            
            for item in mapItems!
            {
                //print(item)
                
                let newLocation = Location(item)
                
                
                data.append(newLocation)
            }
            
            if !data.isEmpty
            {
                print("Availibilty Array: \(data)")
                
                modelContext.insert(book) // Inserts book object into the modelContext then saves
                
                book.updateAvailbility(items: data)
                
                try modelContext.save()
            }
            

        }
    }
}


extension AppManager // History Related Methods
{
    private func fetchHistory()
    {
        do
        {
            let predicate = #Predicate<Book>{ item in item.inHistory} // gets hist
            let fetchDescriptor = FetchDescriptor<Book>(predicate: predicate, sortBy: [SortDescriptor(\.timestamp)])
            history = (try modelContext.fetch(fetchDescriptor) )
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    public func addToHistory(book: Book)
    {
        do
        {
            try withAnimation
            {
                modelContext.insert(book) // Inserts book object into the modelContext then saves
                book.timestamp = Date() // Makes sure that book brought up in the same search result do nto have the same timestamp
                book.inHistory.toggle()
                try modelContext.save()
                fetchHistory() // reload History
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func deleteFromHistory(offsets: IndexSet) // Deletes item form history
    {
        
        do
        {
            try withAnimation
            {
                for index in offsets
                {
                    modelContext.delete(history[index])
                }
                try modelContext.save()
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
}

extension AppManager // Best Seller Related Methods
{
    func getBestSellers()
    {
        Task
        {
            let source = await NY.getBestSellerLists()
            
            let lists = source["lists"].arrayValue
            
            for list in lists
            {
                let newList = ReadingList(list, nil, modelContext)!

                addToBestSellerList(list: newList)
            }

        }
    }
    
    private func fetchBestSellers()
    {
        do
        {
            //let questionPredicate = #Predicate<ReadingList> { $0.books.isEmpty }
            let fetchDescriptor = FetchDescriptor<ReadingList>(predicate: #Predicate{ item in item.isBestSellerList} ) // Not sure how to sort it because it is not numerical or alphabetical order
            bestSellers = (try modelContext.fetch(fetchDescriptor) )
            
            if bestSellers.isEmpty
            {
                getBestSellers()
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
        
        // updateBestSeller(BestSellerList: ReadingList) // Update Best Seller List depending on Update Frequency
        
        // try modelContext.save() // Save newly updated context
        
        // fetchBestSellers() // Reload BestSellers
    }
    
    private func updateBestSeller(BestSellerList: ReadingList) // Updates a specific best seller list
    {
        Task
        {
            BestSellerList.books.removeAll() // Clear bppks from the list
            
            let data = await NY.getBestSeller(name: BestSellerList.urlString) // Queries a specific Best Seller List using the NY Times API
            
            for item in data["books"].arrayValue
            {
                let newBook = Book(nil, item)!
                
                BestSellerList.books.append(newBook)
            }
        }
    }
    
    public func addToBestSellerList(list: ReadingList)
    {
        do
        {
            try withAnimation
            {
                modelContext.insert(list) // Inserts book object into the modelContext then saves
                try modelContext.save()
                fetchBestSellers() // reload?
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
}

extension AppManager // User Generated Lists Related Methods
{
    private func fetchReadingLists()
    {
        do
        {
            let fetchDescriptor = FetchDescriptor<ReadingList>(predicate: #Predicate{ item in !item.isBestSellerList} ) // Predicate retrives the items that are NOT a best seller list
            userLists = (try modelContext.fetch(fetchDescriptor) )
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func createList(name: String)
    {
        do
        {
            let newList = ReadingList(nil, name, nil)!
            
            addToList(list: newList)
            
            //userLists.append(newList)
            
            //try modelContext.save()
            
            //fetchReadingLists() // reload?
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
        
    }
    
    public func addToList(list: ReadingList)
    {
        do
        {
            try withAnimation
            {
                modelContext.insert(list) // Inserts book object into the modelContext then saves
                try modelContext.save()
                fetchReadingLists() // reload?
            }
        }
        catch
        {
                fatalError(error.localizedDescription)
        }
    }
    
    public func updateList(list: ReadingList, name: String)
    {
        
        do
        {
            list.title = name
            
            try modelContext.save()
            
            //fetchReadingLists() // reload ?
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    public func deleteList(source: ReadingList)
    {
        
    }

}

extension AppManager // Scanner related functions  - each method should do at most one thing
{
    public func scanBook(IBSN: String)
    {
        Task
        {
            let data = await AM.findBook(IBSN: IBSN) // Queries API with an IBSN as a parameter
            
            //for item in data
            //{
            print(data.first)
            if data.first != nil
            {
                let newBook = Book(data.first?.1, nil)! // Creates a book object from the IBSN
                addToHistory(book: newBook) // adds newly created book to history
            }
            //}
            showScan.toggle()
        }
    }
}
