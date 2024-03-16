//
//  FavoriteView.swift
//  BookClub
//
//  Created by Malik Falana on 2/15/24.
//

import SwiftUI

struct FavoriteView: View 
{
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var APP = AppManager.shared
        
    @Environment(\.dismiss) var dismiss
    
    // When an item is favortied the timestamp changes, but only in the favorites list
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(APP.history.filter(\.isFavorited) )
                {
                    item in
                    
                    HistoryItem(book: item)
                }
                .onDelete(perform: APP.deleteFromHistory)
            }
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button("Close"){ dismiss() }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview 
{
    FavoriteView()
}
