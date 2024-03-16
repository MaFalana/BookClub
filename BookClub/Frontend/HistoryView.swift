//
//  HistoryView.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View 
{
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var APP = AppManager.shared
    
    @State private var showFavorites = false
    
    var body: some View
    {
        NavigationView
        {
            List
            {
                ForEach(APP.history)
                {
                    item in
                    
                    HistoryItem(book: item, isHistory: true)
                        .contextMenu {
                            //FavoriteButton(isFavorited: $item.isFavorited)
                                
                            Button("Share", systemImage: "square.and.arrow.up", action: {print("Share Button clicked")})
                                .imageScale(.large)
                            
                            } preview: {
                                AsyncImage(url: item.cover)
                                .cornerRadius(10)
                            }
                        
                }
                .onDelete(perform: APP.deleteFromHistory)
            }
            .listStyle(.plain)
            .navigationTitle("History")
            .sheet(isPresented: $showFavorites)
            {
                FavoriteView()
            }
            .presentationDetents([.medium])
            .toolbar
            {
                ToolbarItem(placement: .navigationBarLeading)
                {
                    Button("Favorites"){ showFavorites.toggle() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    HStack
                    {
                        Button(action: {})
                        {
                            //Label("", systemImage: "trash").labelStyle(.iconOnly)
                            EditButton()
                        }
//                        Button(action: APP.addBook)
//                        {
//                            Label("", systemImage: "exclamationmark.circle").labelStyle(.iconOnly)
//                        }
                    }
                }
            }
        }
        
        
    }
}

#Preview 
{
    HistoryView()
        .modelContainer(for: Book.self, inMemory: true)
}
