//
//  HistoryDetail.swift
//  BookClub
//
//  Created by Malik Falana on 2/15/24.
//

import SwiftUI

struct HistoryDetail: View
{
    @State var book: Book
    var isHistory: Bool = false
    @State private var lineLimit = 3
    @State private var Limit = false
    @State private var isAdding = false
    @ObservedObject var APP = AppManager.shared
    
    var body: some View
    {
        ScrollView
        {

            VStack(spacing: 0)
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
                    
                    Spacer()
                    
                    VStack
                    {
                        Text(book.title)
                            .bold()
                        
                        Text(book.author.first ?? "")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    //.padding(.horizontal)
                }
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                //Divider()
                
                VStack(spacing: 0)
                {
                    HStack
                    {
                        Text("Description")
                            .bold()
                            .font(.title2)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    Text(book.synopsis)
                        .padding()
                        .lineLimit(Limit ? nil : lineLimit)
                        .onTapGesture
                    {
                        Limit.toggle()
                    }
                    
                    Divider()
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                
                VStack
                {
                    if !book.ibsn.isEmpty
                    {
                        ForEach(book.ibsn, id: \.self)
                        {
                            item in
                            
                            if item.count == 13
                            {
                                HistoryDetailRow1(title: "ISBN-13", desc: item)
                            }
                            else
                            {
                                HistoryDetailRow1(title: "ISBN-10", desc: item)
                            }
                        }
                        
                    }
                    
                    
                    HistoryDetailRow1(title: "Publisher", desc: book.publisher)
                    
                    HistoryDetailRow1(title: "Published", desc: book.publishDate)
                    
                    HistoryDetailRow1(title: "Pages", desc: "\(book.pages)")
                    
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                
                
                VStack
                {
                    HStack
                    {
                        Text("Avaliability Near Me")
                            .bold()
                            .font(.title2)
                            .padding()
                        
                        Spacer()
                        
                        Button("Refresh Locations", systemImage: "arrow.clockwise.circle.fill", action: {print("Button clicked"); APP.refreshLocations(book: book)})
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                        .padding(.horizontal)
                        
                    }
                    
                    if book.availbility!.isEmpty
                    {
                        Text("BookClub has not found any nearby locations for this product.")
                            .padding()
                    }
                    else
                    {
                        ScrollView
                        {
                            VStack
                            {
                                ForEach(book.availbility!, id: \.self)
                                {
                                    item in
                                    
                                    Text(item.name)
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                
                
                VStack
                {
                    HStack
                    {
                        Text("Reccomendations")
                            .bold()
                            .font(.title2)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        NavigationLink(destination: MoreRecommendations(recs: book.recommendations!))
                        {
                            Image(systemName: "chevron.right")
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                
                    if book.recommendations!.isEmpty
                    {
                        Text("BookClub has not found any simmilar texts for this product.")
                            .padding()
                    }
                    else
                    {
                        ScrollView(.horizontal)
                        {
                            HStack
                            {
                                ForEach(book.recommendations!.prefix(5))
                                {
                                    item in
                                    
                                    VStack
                                    {
                                        
                                        NavigationLink(destination: HistoryDetail(book: item)) //link to profile page
                                        {
                                            AsyncImage(url: item.cover)
                                            { image in
                                                
                                                image.resizable()
                                                    .frame(width: 120, height: 170)
                                                    .clipped()
                                            }
                                            placeholder:
                                            {
                                                ProgressView()
                                            }
                                            .cornerRadius(10)
                                        }
                                        Text(item.title).bold().frame(width: 120).lineLimit(1)
                                    }
                                    
                                }
                            }
                        }
                        .padding()
                    }
                }
                .background(Color(UIColor.secondarySystemGroupedBackground))
                
                //Spacer()
                
                HStack
                {
                    Text("Options")
                        .bold()
                        .font(.title2)
                        .padding()
                    Spacer()
                }
                
                VStack
                {
                    FavoriteButton(isFavorited: $book.isFavorited)
                    Divider()
                    
                    AddListButton()
                        .onTapGesture
                        {
                            isAdding.toggle()
                        }
                        .sheet(isPresented: $isAdding)
                        {
                            AddListView(book: book)
                        }
                    
                    
                    if isHistory
                    {
                        Divider()
                        
                        TrashButton()
                    }
                    //Divider()
                }
                .padding()
                
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            //.padding(.vertical, 10)
            
        }
        .background(Color(UIColor.systemGroupedBackground))
        //.textSelection(true)
        
    }
}

