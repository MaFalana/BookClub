//
//  ScanModalView.swift
//  BookClub
//
//  Created by Malik on 2/16/24.
//

import SwiftUI

struct ScanModalView: View 
{
    let book: Book
    
    @ObservedObject var BM = BookManager.shared
    
    var body: some View
    {
        HStack
        {
            AsyncImage(url: book.cover)
                .frame(width: 60, height: 110)
                .scaledToFit()
            
            VStack
            {
                Text(book.title)
                    .bold()
                
                Text(book.author.first ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
        }
        
    }
}

