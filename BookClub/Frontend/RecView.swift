//
//  RecView.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI

struct RecView: View 
{
    @ObservedObject var APP = AppManager.shared
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                ForEach(APP.history.filter(\.isFavorited) )
                {
                    item in
                    
                    if !item.recommendations!.isEmpty // if favorited book has recommendations
                    {
                        RecItem(book: item)
                    }
                    
                }
                
                
            }
            .navigationTitle("Recommendations")
        }
    }
}

#Preview 
{
    RecView()
}



struct RecItem: View
{
    let book: Book
    
    var body: some View
    {
        //Divider()
        
        HStack
        {
            //item // Source
            NavigationLink(destination: HistoryDetail(book: book) )
            {
                VStack
                {
                    AsyncImage(url: book.cover)
                    { image in
                        
                        image.resizable()
                            .frame(width: 120, height: 170)
                            .clipped()
                    }
                placeholder:
                    {
                        ProgressView()
                    }
                    
                    Text(book.title)
                    Text(book.author[0])
                }
                .lineLimit(1)
            }
            .padding(.horizontal)
            
            
            // item.reccomendations.first // top Recommendation
            NavigationLink(destination: MoreRecommendations(recs: book.recommendations!) )
            {
                VStack
                {
                    AsyncImage(url: book.recommendations!.first?.cover)
                    { image in
                        
                        image.resizable()
                            .frame(width: 120, height: 170)
                            .clipped()
                    }
                placeholder:
                    {
                        ProgressView()
                    }
                    
                    Text(book.recommendations!.first!.title)
                    //Text(book.recommendations!.first!.author[0])
                }
                .lineLimit(1)
            }
            .padding(.horizontal)
        }
        
        Divider()
    }
}
