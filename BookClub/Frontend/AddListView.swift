//
//  AddListView.swift
//  BookClub
//
//  Created by Malik Falana on 2/24/24.
//

import SwiftUI

struct AddListView: View 
{
    @ObservedObject private var APP = AppManager.shared
    @State private var userInput: String = ""
    @State private var editMode: Bool = AppManager.shared.editMode
    @State private var showAlert: Bool = false
    @State private var chosenAlert: Alert = Alert(title: Text("Alert"))
    var book: Book
       
    @State var selectedLists = Set<String>()
    
    private func alertOne(userInput: String) -> Alert
    {
        return Alert(title: Text("\(userInput) already exists") )
    }
    
    private func alertTwo(previousName: String, currentName: String ) -> Alert
    {
        return Alert(title: Text("\(previousName) is now \(currentName)") )
    }
    
    
    private func alertThree(userInput: String) -> Alert
    {
        return Alert(title: Text("\(userInput) successfully created") )
    }
    
    func alertFour(name: String) -> Alert
    {
        return Alert(title: Text("\(name) and its contents were successfully deleted") )
    }

   
    var body: some View
    {
        NavigationView
        {
            VStack
            {
                List(selection: $selectedLists)
                {
                    ForEach(APP.userLists, id: \.id)
                    {
                        list in
                        
                        listRow2(source: list, selectedItems: $selectedLists, book: book)
                        
                        .swipeActions(edge: .leading, allowsFullSwipe: false)
                        {
                            Button
                            {
                                showAlert.toggle()
                                APP.deleteList(source: list)
                                chosenAlert = alertFour(name: list.title)
                            }
                            label:
                            {
                                Label("Remove", systemImage: "trash")
                            }.tint(.indigo)
                            .alert(isPresented: $showAlert)
                            {
                                chosenAlert
                            }
                            
                            Button
                            {
                                editMode.toggle()
                                APP.staticList = list
                            }
                            label:
                            {
                                Label("Edit", systemImage: "pencil")
                                
                            }.tint(.orange)
                        }
                        
                        
                    }
                    
                }.listStyle(.insetGrouped)//.padding()
                
                TextField("List Name", text: $userInput )
                .textFieldStyle(.roundedBorder)
                .padding()
                
                Button(editMode ? "Change Name" : "Create New List")
                {
                    showAlert.toggle()
                    if editMode
                    {
                        let previousName = APP.staticList.title

                        if APP.userLists.contains(where: { $0.title == userInput })
                        {
                            chosenAlert = alertOne(userInput: userInput)
                        }
                        else
                        {
                            APP.updateList(list: APP.staticList, name: userInput)
                            let currentName = APP.staticList.title
                            chosenAlert = alertTwo(previousName: previousName, currentName: currentName)
                            userInput = "" //reverts back to empty string
                        }
                    }
                    else
                    {
                        guard !userInput.isEmpty else {return} // makes sure field is not empty
                        if APP.userLists.contains(where: { $0.title == userInput })
                        {
                            chosenAlert = alertOne(userInput: userInput)
                        }
                        else
                        {
                            APP.createList(name: userInput)
                            chosenAlert = alertThree(userInput: userInput)
                            userInput = "" //reverts back to empty string
                            editMode = false
                            //crudManager.Append()
                            //crudManager.Save()
                        }
                    }
                    
                }
                .buttonStyle(.bordered)
                .alert(isPresented: $showAlert)
                {
                    chosenAlert
                }
                
            }.navigationBarTitle("Lists", displayMode: .inline)
        }
        
    }

}





struct listRow2: View
{
    var source: ReadingList
    //let mangaInfo: [String]
    @ObservedObject private var APP = AppManager.shared
    

    @Binding var selectedItems: Set<String>
    //var info: [String]
   // @Binding var selectedManga: Set<String>
    //@EnvironmentObject var network: SourceManager
    //@EnvironmentObject var crudManager: CRUDManager
    @State var showAlert: Bool = false
    var book: Book
    
    var isSelected: Bool
    {
        selectedItems.contains(source.id)
    }
    
    
    func Exists()
    {
        if source.books.contains(where: {$0.ibsn == book.ibsn}) //Only allows one of each manga to be added
        {
            
            print("\(book.title) is already in \(source.title)")
            //CRUDManager.shared.removeManga(Library: library, selectedManga: queuedManga)
            //library.removeFromData(queuedManga)
            //CRUDManager.shared.Save()
        }
        else
        {
            source.addToList(item: book)
        }
            

    }
    
    
    var body: some View
    {
        
        HStack
        {
            Text(source.title)
            Spacer()
            if isSelected // Checking to see if library has a manga
            {
                Image(systemName: "checkmark")
            }
        }.contentShape(Rectangle()).onTapGesture {
            if isSelected //If deselected
            {
                self.selectedItems.remove(source.id)
            }
            else //If selected
            {
                self.selectedItems.insert(source.id)
                Exists()
            }
            //APP.Save() // Save function should be called her
        }
    }
}
