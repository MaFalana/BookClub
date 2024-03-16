//
//  MoreRecommendations.swift
//  BookClub
//
//  Created by Malik Falana on 2/29/24.
//

import SwiftUI

struct MoreRecommendations: View 
{
    let recs: [Book]
    
    var body: some View
    {
        //NavigationView
        //{
            List
            {
                ForEach(recs)
                {
                    item in
                    
                    HistoryItem(book: item)
                }
                
            }
            .listStyle(.plain)
            //.navigationTitle("Recommendations")
        //}
    }
}

