//
//  Misc.swift
//  BookClub
//
//  Created by Malik on 2/16/24.
//

import Foundation
import SwiftUI



extension Button
{
    func favorite() -> some View
    {
        self
        
    }
}


// star - false

// star.fill - true


struct FavoriteToggle: ToggleStyle 
{
    @Binding var book: Book

    init(book: Binding<Book>) 
    {
        _book = book
    }

    func makeBody(configuration: Configuration) -> some View 
    {
        Button 
        {
            book.isFavorited.toggle()
        } 
        label:
        {
            Label 
            {
                configuration.label
            } 
            icon: 
            {
                Image(systemName: configuration.isOn ? "star.fill" : "star")
                    .foregroundStyle(.black)
                    .imageScale(.large)
            }
        }
        .buttonStyle(.plain)
    }
}




struct FavoriteButton: View 
{
    @Binding var isFavorited: Bool

    var body: some View 
    {
        HStack 
        {
            Text(isFavorited ? "Remove from favorites" : "Add to favorites")
            Spacer()
            Image(systemName: isFavorited ? "star.fill" : "star")
                .imageScale(.large)
        }
        .foregroundColor(.black)
        .onTapGesture
        {
            isFavorited.toggle()
        }
    }
}




struct TrashButton: View
{
    @State private var isPresentingConfirm: Bool = false
    
    var body: some View
    {
        Button
        {
            isPresentingConfirm = true
        }
        label:
        {
            HStack
            {
                Text("Delete from history")
                Spacer()
                Image(systemName: "trash")
                    .imageScale(.large)
            }
        }
        .foregroundColor(.black)
        .confirmationDialog("Are you sure?",
        isPresented: $isPresentingConfirm)
        {
            Button("Delete from history", role: .destructive)
            {
                print("This item wouldve been deleted")
                //store.deleteAll()
            }
        }
    }
}


struct AddListButton: View
{
    //@State private var isAdding: Bool = false
    
    //var book: Book
    
    var body: some View
    {
        HStack
        {
            Text("Add to a list")
            Spacer()
            Image(systemName: "folder.badge.plus")
                .imageScale(.large)
        }
        .foregroundColor(.black)
//        .sheet(isPresented: $isAdding)
//        { 
//            AddListView(book: book)
//        }
//        .onTapGesture
//        {
//            isAdding.toggle()
//        }
    }
}


struct DeleteButton: View 
{
    //@EnvironmentObject var store: Store
    @State private var isPresentingConfirm: Bool = false

    var body: some View
    {
        Button("Delete", role: .destructive)
        {
            isPresentingConfirm = true
        }
        .confirmationDialog("Are you sure?",
        isPresented: $isPresentingConfirm)
        {
            Button("Delete from history", role: .destructive)
            {
                //store.deleteAll()
            }
        }
    }
}




struct HistoryDetailRow1: View
{
    var title: String
    
    var desc: String

    var body: some View
    {
        HStack
        {
            Text(title)
            
            Spacer()
            
            Text(desc)
                .foregroundColor(.gray)
        }
        .padding([.horizontal, .top])
        
        Divider()
    }
}


struct ListCard: View
{
    var title: String = "Combined Print & E-Book Fiction"
    
    var background: Color = Color(.Spring.color4)
    
    var image: Image = Image(.Spring.image)
    
    var count = 12
    
    var body: some View
    {
        HStack(spacing: 0)
        {
            VStack(alignment: .leading)
            {
                Text(title.replacingOccurrences(of: "&", with: "\n&"))
                    .font(.title2)
                    //.font(.custom("Trebuchet MS", size: 22))
                
                Spacer()
                
                Text("\(count) books in collection")
                    .font(.footnote)
                    .background(RoundedRectangle(cornerRadius: 2.0)
                        .opacity(0.2)
                        //.padding()

                        )
                //
  
            }
            .bold()
            .textCase(.uppercase)
            .padding()
            
            VStack
            {
                Image(.Spring.image)
                    .frame(width: 200)
                    .opacity(0.1)
                    //.clipped()
            }
            .clipped()
            
        }
        .frame(width: 400, height: 200)
        .clipped()
        .background(RoundedRectangle(cornerRadius: 25.0)
            .fill(background)
            )
        .shadow(radius: 10)
        //.font(.custom("Trebuchet MS", size: 22))

        
    }
}

#Preview
{
    ListCard()
}
