#  BookClub

## Description
This app works by utilizing Scandit's SDK for the sccanning capabilities and then leveraging the data of the Google Books API and The NYTimes API into a custom data objects. The later is used to generate a list of Best Sellers when the user first opens the app, the former is used for the "searching" and "scanning" functions within the apps backened. How it works? Much like its inspiration [Yuka](https://yuka.io/en/), the app scans an item's barcode, in this case it would by the IBSN that comes with every book. If a valid IBSN is detected then it used to make a request to the Google Books API and reviece a JSON repsonse, which I then use to create a 'Book' object' that houses the general information of that book.


## Getting Started

### Dependencies
- IOS Device running a miniumum firmware of 17.0

### Installing
- Just click the [link]() and follow the instructions.

### Features
- User generated reading lists

- Searching Capabilities

- IBSN Scanning

### Planned Features
- Add sharing capablities

- Book avalibitly near user using their current location

- Book recommendations (recommendations based on the author may be the easiest to implement)

- Using LibGen to download avlaible epub files and open them in Apple Books

## Problems, Issues and how I overcame them

### What I Learned

Using SwiftData with MVVM

SwiftData is a fairly new alternative to Swift's core data. One of my favorite feacture of it is the '@Query' function which allows the automatic fetching of SwiftData objects, however due to the way I organize my code; I like to seperate my backend (class managers) and frontend (views). '@Query' can only be used on views, so I needed a workaround to produce this same functionality in my backend classes. I was able to achieve this through a Model View ViewModel (MVVM) architecture.

UPC barcode.

ISBN (International Standard Book Number) barcode.

Using apple maps to serch for releevant locations

Delaying functions so that they run at a certain time

leverageing data from multiple apis together into one cohesive data model

A book cannot exist in multiple lists after starting an new app session -> Fixed it by Using a many to many relationship, Books can be long too many lists

When I first began developing iOS apps get data from a JSON request was very tredious since I had to design a struct that would be compatible with every possibility of data that may or may not be present for a response. After making apis using python I wonder if there was a simplier way to do it in swift as well. There was! using SwiftyJSON I was able to cut my workload drastically. Now instead of making a model for data in a response that I may or not receive, I am able to handle the more specialized conditions within the class initilizaers wchich leads to a more stremlined process.


### Current Bugs

When a book is added to a user generated list there is no checkmark indicting what list(s) it belongs to

Books in user generated lists are never in the same order after starting a new app session




## Acknowledgements

Inspiration, code snippets, etc.

- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

- [Scandit SDK](https://github.com/Scandit/datacapture-spm)

- [Get Started With Barcode Capture](https://docs.scandit.com/data-capture-sdk/ios/get-started-barcode.html)

- [Developer Tutorial: Add MatrixScan Find to an iOS App | Scandit](https://youtu.be/DFKcc32bMfs?si=SQVCZA_qmbf__hqC)

- [Splitting SwiftData and SwiftUI via MVVM](https://dev.to/jameson/swiftui-with-swiftdata-through-repository-36d1)

- [Barcode Capture Simple Sample Swift](https://github.com/Scandit/datacapture-ios-samples/blob/master/BarcodeCaptureSimpleSampleSwift/BarcodeCaptureSimpleSampleSwift/ViewController.swift)

- [MapKit](https://developer.apple.com/documentation/mapkit/)

- [MKLocalSearch.Request](https://developer.apple.com/documentation/mapkit/mklocalsearch/request)

- [NYTimes Books API](https://developer.nytimes.com/docs/books-product/1/overview)

- [swift: how would I run a function at a scheduled time weekly](https://stackoverflow.com/questions/61992530/swift-how-would-i-run-a-function-at-a-scheduled-time-weekly)

- [Swift display time ago from Date (NSDate)](https://stackoverflow.com/questions/44086555/swift-display-time-ago-from-date-nsdate)

- [How to create a custom FetchDescriptor](https://www.hackingwithswift.com/quick-start/swiftdata/how-to-create-a-custom-fetchdescriptor)

- [6. Swift Data Many to Many relationships](https://www.youtube.com/watch?v=lHdBkXp3j74)

- [Fixing A Crash With Relationship Deletions](https://www.youtube.com/watch?v=_QMalUGTM4E&t=581s)

- [PaletteMaker](https://palettemaker.com/app)

- [Paterrn Monster](https://pattern.monster)

- [OverDrive Library Availability API](https://developer.overdrive.com/apis/library-availability-new)

- [OverDrive Library Account API](https://developer.overdrive.com/apis/library-account)

## Misc. Notes (Ignore -- will delete later)

Barnes and Noble

Books a Million

Half price books

Library of Congress ?

Near by public libraries 

5 mi to 200 mi

Pulldown to refresh on "Avaliabitlity near me"
