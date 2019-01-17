//
//  BookTableViewController.swift
//  CamLib
//
//  Created by Samuel Silverman on 11/28/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    
    var books = [BookData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Might crash when indexPath = book.count + 1 or indexPath = book.count
        // Add flash support when taking photos of books
        if indexPath.row < books.count {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
            if let isbn = books[indexPath.row].isbn {
                cell.isbnLabel.text = "ISBN: \(isbn)"
            }
            else {
                cell.isbnLabel.text = "ERROR: ISBN unavailable."
            }
            cell.titleLabel.text = books[indexPath.row].title ?? "ERROR: Title unavailable."
            if let image = books[indexPath.row].cover, let cover = UIImage(data: image) {
                cell.coverImage.image = cover
            }
            else {
                cell.coverImage.image = #imageLiteral(resourceName: "no-image-available")
            }
            cell.layoutSubviews()
            return cell
        }
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchISBN", for: indexPath)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select Book" {
            let selectedBook = books[self.tableView.indexPathForSelectedRow!.row]
            if let barVC = segue.destination as? UITabBarController {
                barVC.viewControllers?.forEach {
                    if let vc = $0 as? BibliographyViewController {
                        if vc.restorationIdentifier == "MLA" {
                            vc.bibliographyText = BookInfoGenerator.generateMLACitation(bookJSON: selectedBook.json!)
                        }
                        if vc.restorationIdentifier == "APA" {
                            vc.bibliographyText = BookInfoGenerator.generateAPACitation(bookJSON: selectedBook.json!)
                        }
                        if vc.restorationIdentifier == "Chicago" {
                            vc.bibliographyText = BookInfoGenerator.generateChicagoCitation(bookJSON: selectedBook.json!)
                        }
                    }
                }
            }
        }
    }
}
