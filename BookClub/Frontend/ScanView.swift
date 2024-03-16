//
//  ScanView.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//
import UIKit
import SwiftUI
import ScanditCaptureCore
import ScanditBarcodeCapture

struct ScannerView: UIViewControllerRepresentable 
{
    typealias UIViewControllerType = Scanner
    
    var scanner: Scanner

    init(scanner: Scanner)
    {
        self.scanner = scanner
    }

    func makeUIViewController(context: Context) -> Scanner 
    {
        return Scanner()
    }

    func updateUIViewController(_ uiViewController: Scanner, context: Context) 
    {
        // You can perform any necessary updates here
    }
}

struct ScanView: View 
{
    @ObservedObject var APP = AppManager.shared
    @State private var scanner = Scanner()
    
    var body: some View
    {
        NavigationView 
        {
            ScannerView(scanner: scanner)
                .edgesIgnoringSafeArea(.top)
            .sheet(isPresented: $APP.showScan, onDismiss: {APP.showScan = false; scanner.viewWillAppear(true) } )
            {
                if let mostRecentScan = APP.history.last
                {
                    HistoryDetail(book: mostRecentScan )
                        .frame(alignment: .bottom)
                }
            }
            .presentationDetents([.medium, .large])
            
            .sheet(isPresented: $APP.showError, onDismiss: {APP.showError = false; scanner.viewWillAppear(true) } )
            {
                Text("BookClub cannot scan this item")
            }
            .presentationDetents([.medium, .large])
        }
    }
}
