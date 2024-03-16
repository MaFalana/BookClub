//
//  ScanditManager.swift
//  BookClub
//
//  Created by Malik on 2/13/24.
//

import Foundation
import ScanditCaptureCore
import ScanditBarcodeCapture
import UIKit
import SwiftUI


class ScanditManager: UIViewController //ObservableObject
{
    //static let shared = ScanditManager() // Singleton instance
    
    var barcodeFindView: BarcodeFindView!
    
    private var licenseKey = "AQNE9SdMA9xtO11v5T0nZ1AecF3/Cv/dx3oTa5B5uaZgb5iSy1Hoco5bKKPLSA/jvA0cix8eHUcuCQ9b01gL3ssgnNgYb9rXgjuChgVGpdrxJICWfm4qyRdoAq5ZFKYcDH06oFVKjNfBcpTexgHuFbBt00IIf9r1r2gQvXUesRotCIG/Kk0/34wB/LP6cZyyMhOHRu0IIiIsPzgM+XDaOeZJe8eaSVux4xsyiTAJqJYwdIit9lHaupt+K5ksLuCUYHWrCCpTs/4HU0Q/MFyGTZBXHcNNbzKVgl52tmFYFXK8FFxGwmDNx488bC8ffUkIy0BAsCNBo7x/R0Iot13kbQF1nxPlbDSaumqiAJ1PXNWKOSzDJHHMmlJF4mfgeiRzbHjcAjNZ61ZRUH88CVjcR/9yvDe5DxCSN0l1RL52bnlxQkiEnFMJ5pdBMYObRRo5q1Xb5KxLHfO3Qt+Ugx71U5JE56RtRnn2CDfjFmllLfX5Yth/twOrE856BtD0RqWSDkaPDYl6oljYUXb6XDARBmd31zdxaXguoVuU0TtpfJHxTc7HI0s058ct16he3+oT6DnJdtZP0VDjODDnzZkI0HsjhCX9NozBlgcCBiUzTto6rTP8KPsqwa5od3w5nyLigQ8Rf+rFrx7kXMJYRiJKqwKO32w86d+/KkWAOXlZoK5u57VT5wDmOf6pBCdKENmvf94GMNHk8yoN80GVqqYclzpRLZezLJ/MtWhze/wIJ+tUmW+zplFu/W6kY9+7QeCFRMzOfmQNg4kq+icB+gxXJhyZaT6rK6YPh+fpkk1KKeCMc7IY1bpoJfvVbiYGu5AmG+QDezbPtdaoguIYLLNx8mGzm8/C/RuZp9wzuCH8zjYkSg/8cVkzA5TXdi8aIh1lMn5oIixDdZ7i2cv27AT0KyLD5NydI76+aX6+3GH57Hf/ke4rRDM0+WCpK7G8yb3AgfEd6Emm9mji8udcCFQ3o5aNp/fKx6/3OlSqe7erO21LEpAg73lOnKc6Kwd2dwmY+kP5LlADGsIAUej2gn8p7Y324Gc4BX0fUY0wp9oh81b3cRy8gHpn043FFtaTomk6yN4uSrTWI29mmmCDp/AztdojhgjANWCxXNblRN5PCWqw+hkfRwsze1904iowAOjG+dzv39t7ss5OkO/xHBgD8bSLXg8R6cNyaj3OD2d7caVpwcDbqgHGcVcLCejlzV1/Nbkrbp5KciMF80tCqdT36r3nb3NlaZd0d1bHsQ=="
    
    
    
 
    
//    private func setupBarcodeCapture(on view: UIView) {
//           let settings = BarcodeCaptureSettings()
//           settings.set(symbology: .code128, enabled: true)
//           settings.set(symbology: .code39, enabled: true)
//           settings.set(symbology: .qr, enabled: true)
//           settings.set(symbology: .ean8, enabled: true)
//           settings.set(symbology: .upce, enabled: true)
//           settings.set(symbology: .ean13UPCA, enabled: true)
//
//           let barcodeCapture = BarcodeCapture(context: context, settings: settings)
//
//           let cameraSettings = BarcodeCapture.recommendedCameraSettings
//
//           let camera = Camera.default
//           camera?.apply(cameraSettings)
//
//           context.setFrameSource(camera)
//
//           camera?.switch(toDesiredState: .on)
//
////           let captureView = DataCaptureView(for: context, frame: view.bounds)
////           captureView.dataCaptureContext = context
////           captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
////           view.addSubview(captureView)
////
////           let overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: captureView)
//       }
    
    
    // --- MatrixScan
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupRecognition()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        barcodeFindView.startSearching()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        barcodeFindView.stopSearching()
    }
    
    private func setupRecognition()
    {
        let context = DataCaptureContext(licenseKey: licenseKey) // Create context
        
        let settings = BarcodeFindSettings() // Create settings for barcode find
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)
        
        
        let barcodeFind = BarcodeFind(settings: settings) //create barcode find
        
        let viewSettings = BarcodeFindViewSettings() //create view settings
        
        barcodeFindView = BarcodeFindView(parentView: self.view, context: context, barcodeFind: barcodeFind, settings: viewSettings)// create barcode find view
        
        barcodeFindView.prepareSearching()
    }

}






class Scanner: UIViewController
{
    @ObservedObject var APP = AppManager.shared
    
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    public var barcodeCapture: BarcodeCapture!
    private var barcodeCaptureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    
    var isModalPresented = false

    private var licenseKey = "AQNE9SdMA9xtO11v5T0nZ1AecF3/Cv/dx3oTa5B5uaZgb5iSy1Hoco5bKKPLSA/jvA0cix8eHUcuCQ9b01gL3ssgnNgYb9rXgjuChgVGpdrxJICWfm4qyRdoAq5ZFKYcDH06oFVKjNfBcpTexgHuFbBt00IIf9r1r2gQvXUesRotCIG/Kk0/34wB/LP6cZyyMhOHRu0IIiIsPzgM+XDaOeZJe8eaSVux4xsyiTAJqJYwdIit9lHaupt+K5ksLuCUYHWrCCpTs/4HU0Q/MFyGTZBXHcNNbzKVgl52tmFYFXK8FFxGwmDNx488bC8ffUkIy0BAsCNBo7x/R0Iot13kbQF1nxPlbDSaumqiAJ1PXNWKOSzDJHHMmlJF4mfgeiRzbHjcAjNZ61ZRUH88CVjcR/9yvDe5DxCSN0l1RL52bnlxQkiEnFMJ5pdBMYObRRo5q1Xb5KxLHfO3Qt+Ugx71U5JE56RtRnn2CDfjFmllLfX5Yth/twOrE856BtD0RqWSDkaPDYl6oljYUXb6XDARBmd31zdxaXguoVuU0TtpfJHxTc7HI0s058ct16he3+oT6DnJdtZP0VDjODDnzZkI0HsjhCX9NozBlgcCBiUzTto6rTP8KPsqwa5od3w5nyLigQ8Rf+rFrx7kXMJYRiJKqwKO32w86d+/KkWAOXlZoK5u57VT5wDmOf6pBCdKENmvf94GMNHk8yoN80GVqqYclzpRLZezLJ/MtWhze/wIJ+tUmW+zplFu/W6kY9+7QeCFRMzOfmQNg4kq+icB+gxXJhyZaT6rK6YPh+fpkk1KKeCMc7IY1bpoJfvVbiYGu5AmG+QDezbPtdaoguIYLLNx8mGzm8/C/RuZp9wzuCH8zjYkSg/8cVkzA5TXdi8aIh1lMn5oIixDdZ7i2cv27AT0KyLD5NydI76+aX6+3GH57Hf/ke4rRDM0+WCpK7G8yb3AgfEd6Emm9mji8udcCFQ3o5aNp/fKx6/3OlSqe7erO21LEpAg73lOnKc6Kwd2dwmY+kP5LlADGsIAUej2gn8p7Y324Gc4BX0fUY0wp9oh81b3cRy8gHpn043FFtaTomk6yN4uSrTWI29mmmCDp/AztdojhgjANWCxXNblRN5PCWqw+hkfRwsze1904iowAOjG+dzv39t7ss5OkO/xHBgD8bSLXg8R6cNyaj3OD2d7caVpwcDbqgHGcVcLCejlzV1/Nbkrbp5KciMF80tCqdT36r3nb3NlaZd0d1bHsQ=="

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        setupRecognition()
    }

    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        if let barcodeCapture = barcodeCapture 
        {
            beginAppearanceTransition(true, animated: animated)

            barcodeCapture.isEnabled = true

            endAppearanceTransition()
        }
        else
        {
           // Handle the case when barcodeCapture is nil (optional is not set)
           print("Error: barcodeCapture is nil")
       }
        camera?.switch(toDesiredState: .on)
    }

    override func viewWillDisappear(_ animated: Bool) 
    {
        super.viewWillDisappear(animated)
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }

    private func setupRecognition() 
    {
        context = DataCaptureContext(licenseKey: licenseKey)

        let settings = BarcodeCaptureSettings()
        //settings.set(symbology: .code128, enabled: true)
        //settings.set(symbology: .code39, enabled: true)
        //settings.set(symbology: .qr, enabled: true)
        //settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .ean13UPCA, enabled: true)

        barcodeCapture = BarcodeCapture(context: context, settings: settings)
        barcodeCapture.addListener(self)

        let cameraSettings = BarcodeCapture.recommendedCameraSettings
        
        camera = Camera.default
        camera?.apply(cameraSettings)

        context.setFrameSource(camera)

        camera?.switch(toDesiredState: .on)

        barcodeCaptureView = DataCaptureView(context: context, frame: view.bounds)
        //barcodeCaptureView.context = context
        barcodeCaptureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(barcodeCaptureView)

        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture, view: barcodeCaptureView)
        
        barcodeCaptureView.addOverlay(overlay)
        
        overlay.viewfinder = RectangularViewfinder(style: .legacy)
        
        barcodeCapture.isEnabled = true
        
    }

    
}


// MARK: - BarcodeCaptureListener

extension Scanner: BarcodeCaptureListener
{
    
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData)
    {
        let recognizedBarcodes = session.newlyRecognizedBarcodes
        
        for barcode in recognizedBarcodes
        {
            
            let ibsn = barcode.data! // Do something with the barcode data.
            
            print(ibsn)
            
            print(barcode.symbology.description)
            
            
            if ibsn.first!.isNumber && ibsn.count >= 13
            {
                APP.scanBook(IBSN: ibsn)
            }
            else
            {
                
            }
        }
        
        barcodeCapture.isEnabled = false
    }
    
    
    private func showModal(_ result: String, completion: @escaping () -> Void)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: result, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion() }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func modal()
    {
        barcodeCapture.isEnabled = true
    }
    
    func toggleTorch()
    {
        camera?.desiredTorchState = .on
    }
    

}
