//
//  TopsView.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import SwiftUI

struct TopsView: View 
{
    @ObservedObject var APP = AppManager.shared
    @State private var selectedView = 0
    var modes: [String] = ["NY Times Best Sellers", "Your Lists"]
    
    
    var body: some View
    {
        NavigationView
        {
            VStack(spacing: 0)
            {
                Picker("Modes", selection: $selectedView)
                {
                    Text(modes[0]).tag(0)
                    Text(modes[1]).tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                //Spacer()
                
                List
                {
                    if (selectedView == 0)
                    {
                        ForEach(APP.bestSellers, id: \.id)
                        {
                            item in
                            
                            NavigationLink(destination: ReadingListView(readingList: item) )
                            {
                                Text(item.title)
                                    //.foregroundColor(.black)
                                //ListCard(title: item.title, count: item.books.count)
                                    
                            }
                            
                        }
                    }
                    else
                    {
                        ForEach(APP.userLists, id: \.id)
                        {
                            item in
                            
                            NavigationLink(destination: ReadingListView(readingList: item) )
                            {
                                Text(item.title)
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                    
                }
                .listStyle(.insetGrouped)
                .navigationTitle(modes[selectedView])
                
            }
            
        }
        .onAppear
        {
            //BM.getLists()
        }
    }
}

//#Preview 
//{
//    TopsView()
//}
