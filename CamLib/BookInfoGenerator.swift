//
//  BookInfoGenerator.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/29/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import Foundation

class BookInfoGenerator {
    static func generateMLACitation(bookJSON: [String : Any]) -> String {
        let authorNames = bookJSON["author_name"] as? [String] ?? nil
        let contributorNames = bookJSON["contributor"] as? [String] ?? nil
        var authorsAndContributors = "N/A"
        if authorNames != nil, contributorNames != nil {
            authorsAndContributors = (authorNames! + contributorNames!).joined(separator: ", ")
        }
        let title = bookJSON["title_suggest"] as? String ?? "N/A"
        let publishPlaces = bookJSON["publish_place"] as? [String] ?? nil
        var publishPlace = "N/A"
        if publishPlaces != nil {
            publishPlace = publishPlaces!.first ?? "N/A"
        }
        let publishers = bookJSON["publisher"] as? [String] ?? nil
        var publisher = "N/A"
        if publishers != nil {
            publisher = publishers!.first ?? "N/A"
        }
        let publishDate = bookJSON["first_publish_year"] as? String ?? "N/A"
    
        return "\(authorsAndContributors). \(title). \(publishPlace): \(publisher), \(publishDate). Print."
    }
    
    static func generateAPACitation(bookJSON: [String : Any]) -> String {
        let authorNames = bookJSON["author_name"] as? [String] ?? nil
        let contributorNames = bookJSON["contributor"] as? [String] ?? nil
        var authorsAndContributors = "N/A"
        if authorNames != nil, contributorNames != nil {
            authorsAndContributors = (authorNames! + contributorNames!).joined(separator: ", ")
        }
        let title = bookJSON["title_suggest"] as? String ?? "N/A"
        let publishPlaces = bookJSON["publish_place"] as? [String] ?? nil
        var publishPlace = "N/A"
        if publishPlaces != nil {
            publishPlace = publishPlaces!.first ?? "N/A"
        }
        let publishers = bookJSON["publisher"] as? [String] ?? nil
        var publisher = "N/A"
        if publishers != nil {
            publisher = publishers!.first ?? "N/A"
        }
        let publishDate = bookJSON["first_publish_year"] as? String ?? "N/A"

        return "\(authorsAndContributors). (\(publishDate)). \(title). \(publishPlace): \(publisher)."
    }
    
    static func generateChicagoCitation(bookJSON: [String : Any]) -> String {
        let authorNames = bookJSON["author_name"] as? [String] ?? nil
        let contributorNames = bookJSON["contributor"] as? [String] ?? nil
        var authorsAndContributors = "N/A"
        if authorNames != nil, contributorNames != nil {
            authorsAndContributors = (authorNames! + contributorNames!).joined(separator: ", ")
        }
        let title = bookJSON["title_suggest"] as? String ?? "N/A"
        let publishPlaces = bookJSON["publish_place"] as? [String] ?? nil
        var publishPlace = "N/A"
        if publishPlaces != nil {
            publishPlace = publishPlaces!.first ?? "N/A"
        }
        let publishers = bookJSON["publisher"] as? [String] ?? nil
        var publisher = "N/A"
        if publishers != nil {
            publisher = publishers!.first ?? "N/A"
        }
        let publishDate = bookJSON["first_publish_year"] as? String ?? "N/A"
        return "\(authorsAndContributors). \(title). \(publishPlace): \(publisher), \(publishDate)."
    }
}
