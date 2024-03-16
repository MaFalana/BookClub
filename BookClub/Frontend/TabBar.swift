//
//  TabBar.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import Foundation
import SwiftUI

struct TabBar: View
{
    @State var tabSelection = 3
    
    var body: some View
    {
        TabView(selection: $tabSelection )
        {
            HistoryView().tabItem { Image(systemName: "books.vertical"); Text("History") }.tag(1)
            
            RecView().tabItem { Image(systemName: "arrow.left.arrow.right.circle"); Text("Recs") }.tag(2)
            
            ScanView().tabItem { Image(systemName: "barcode.viewfinder"); Text("Scan") }.tag(3)
            
            TopsView().tabItem { Image(systemName: "list.star"); Text("Tops") }.tag(4)
            
            SearchView().tabItem { Image(systemName: "magnifyingglass"); Text("Search") }.tag(5)
            
        }
    }
}

#Preview
{
    TabBar()
}
