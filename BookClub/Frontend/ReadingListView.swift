//
//  BestSellerView.swift
//  BookClub
//
//  Created by Malik on 2/24/24.
//

import SwiftUI

struct ReadingListView: View
{
    var readingList: ReadingList
    
    var body: some View
    {
        List
        {
            ForEach(readingList.books)
            {
                item in
                
                HistoryItem(book: item)
            }
            
        }
        .listStyle(.plain)
        .navigationTitle(readingList.title)
    }
}

