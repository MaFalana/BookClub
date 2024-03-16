//
//  SearchView.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI

struct SearchView: View 
{
    @ObservedObject var APP = AppManager.shared

    @State private var query = ""
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(APP.searchResults)
                {
                    item in
                    
                    Button 
                    {
                        APP.addToHistory(book: item)
                    }
                    label:
                    {
                        HistoryItem(book: item)
                    }
                }
            }
            .searchable(text: $query, prompt: "Find some books")
            .onSubmit(of: .search)
            {
                print("Submitting query: \(query)")
                APP.search(query: query)
            }
            .navigationTitle("Search")
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button(action: {})
                    {
                        Label("", systemImage: "exclamationmark.circle").labelStyle(.iconOnly)
                    }
                }
            }
        }
    }
}

#Preview 
{
    SearchView()
}
