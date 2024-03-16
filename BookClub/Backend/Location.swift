//
//  Location.swift
//  BookClub
//
//  Created by Malik Falana on 2/21/24.
//

import Foundation
import SwiftData
import SwiftyJSON
import SwiftUI
import MapKit

@Model
final class Location
{
    var name: String = ""
    var url: URL
    var phoneNumber: String = ""
    //var category: MKPointOfInterestCategory
    
    init(_ source: MKMapItem)
    {
       //guard let source = source else { return nil }
        
        self.name = source.name!
        self.phoneNumber = source.phoneNumber!
        //source.placemark
        //self.category = source.pointOfInterestCategory!
        self.url = source.url!
        
        //let location = source.placemark.location
        
        print(self.url)
    }
}
