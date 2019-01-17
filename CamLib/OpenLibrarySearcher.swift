//
//  OpenLibrarySearcher.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/28/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import Foundation

struct BookData {
    let cover: Data?
    let title: String?
    let isbn: String?
    let json: [String : Any]?
    
    init(cover: Data?, title: String?, isbn: String?, json: [String : Any]?) {
        self.cover = cover
        self.title = title
        self.isbn = isbn
        self.json = json
    }
}

class OpenLibrarySearcher {
    let searchURLString = "http://openlibrary.org/search"
    let coverURLString = "http://covers.openlibrary.org/b/isbn/"
    
    
    func searchForBookDataa(query: String) -> [BookData] {
        let queryOneLine = query.replacingOccurrences(of: "\n", with: "+")
        let queryOneLineNoSpaces = queryOneLine.replacingOccurrences(of: " ", with: "+")
        var searchQuery = queryOneLineNoSpaces
        var bookData = [BookData]()
        print("searchQuery: '\(searchQuery)'")
        if searchQuery.isEmpty {
            return bookData
        }
        while bookData.isEmpty {
            bookData = searchForBookData(query: searchQuery)
            var queryComponents = searchQuery.components(separatedBy: "+")
            queryComponents.removeLast()
            if queryComponents.isEmpty {
                break
            }
            searchQuery = queryComponents.joined(separator: "+")
        }
        return bookData
    }
    
    
    func searchForBookData(query: String) -> [BookData] {
        var bookData = [BookData]()
        
        let queryOneLine = query.replacingOccurrences(of: "\n", with: "+")
        let queryOneLineNoSpaces = queryOneLine.replacingOccurrences(of: " ", with: "+")
        
        let isbns = searchForISBN(query: queryOneLineNoSpaces)
        for isbnCount in 0..<isbns.count {
            if isbnCount > 5 {
                break
            }
            let isbn = isbns[isbnCount]
            bookData += [BookData(cover: searchForCover(isbn: isbn), title: searchForTitle(isbn: isbn), isbn: isbn, json: searchForJSON(isbn: isbn))]
        }
        return bookData
    }
    
    func searchForISBN(query: String) -> [String] {
        guard let url = URL(string: "\(searchURLString).json?q=\(query)") else { return [] }
        var isbnList = [String]()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    // Convert JSON to OpenLibrarySearchResult
                    if let json = jsonSerialized {
                        if let books = json["docs"] as? [[String : Any]], !books.isEmpty {
                            for book in books {
                                if let bookISBNList = book["isbn"] as? [String], let bookISBN = bookISBNList.first {
                                    if !isbnList.contains(bookISBN) {
                                        isbnList += [bookISBN]
                                    }
                                }
                            }
                        }
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        sleep(2)
        return isbnList
    }
    
    func searchForCover(isbn: String) -> Data? {
        var bookCover: Data?
        guard let url = URL(string: "\(coverURLString)\(isbn)-S.jpg?default=false") else { return nil }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let coverData = data {
                do {
                    bookCover = coverData
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        sleep(2)
        return bookCover
    }
    
    func searchForTitle(isbn: String) -> String? {
        var title: String?
        guard let url = URL(string: "\(searchURLString).json?isbn=\(isbn)") else { return nil }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    // Convert JSON to OpenLibrarySearchResult
                    if let json = jsonSerialized {
                        if let bookJSON = json["docs"] as? [[String : Any]] {
                            if let book = bookJSON.first {
                                title = book["title_suggest"] as? String
                            }
                        }
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        sleep(2)
        return title
    }
    
    func searchForJSON(isbn: String) -> [String : Any]? {
        var json: [String : Any]?
        guard let url = URL(string: "\(searchURLString).json?isbn=\(isbn)") else { return nil }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    // Convert JSON to OpenLibrarySearchResult
                    if let responseJSON = jsonSerialized {
                        if let bookJSONs = responseJSON["docs"] as? [[String : Any]] {
                            if let bookJSON = bookJSONs.first {
                                json = bookJSON
                            }
                        }
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
        sleep(2)
        return json
    }
}
