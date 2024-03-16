//
//  BookClubApp.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI
import SwiftData

@main
struct BookClubApp: App 
{
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Book.self,//
            ReadingList.self,
            Location.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do 
        {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } 
        catch
        {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene 
    {
        WindowGroup
        {
            //ContentView()
            TabBar()
        }
        //.modelContainer(sharedModelContainer)
    }
}
