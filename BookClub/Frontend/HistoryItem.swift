//
//  HistoryItem.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI

struct HistoryItem: View 
{
    let book: Book
    
    var isHistory: Bool = false
    
    @ObservedObject var APP = AppManager.shared

    
    var body: some View
    {
        NavigationLink(destination: HistoryDetail(book: book, isHistory: isHistory) )
        {
            HStack
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
                
                //Spacer()
                
                VStack
                {
                    Text(book.title) // Title
                        .lineLimit(1)
                        
                    Text(book.author.first ?? "") // Author
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if isHistory
                    {
                        Label(book.timestamp.timeAgoDisplay(), systemImage: "clock")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                
                
            }
            .padding()
            .onAppear
            {
                if (book.recommendations!.isEmpty && book.isFavorited)
                {
                    APP.setReccomendations(book: book)
                }
            }
        }//.padding()
    }
}


extension Date {
    func timeAgoDisplay() -> String {
 
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
