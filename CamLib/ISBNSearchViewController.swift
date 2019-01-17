//
//  ISBNSearchViewController.swift
//  CamLib
//
//  Created by Samuel Silverman on 12/7/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import UIKit

class ISBNSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var isbnTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonLabel: UILabel!
    
    let numberToolbar = UIToolbar()
    let minSizeOfISBN = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isbnTextField.delegate = self
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(closeTextField))]
        numberToolbar.sizeToFit()
        isbnTextField.inputAccessoryView = numberToolbar
        // Do any additional setup after loading the view.
        searchButton.isEnabled = false
        searchButton.alpha = 0.25
        searchButtonLabel.alpha = 0.25
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let isbn = isbnTextField.text, isbn.count >= minSizeOfISBN {
            searchButton.isEnabled = true
            searchButton.alpha = 1.0
            searchButtonLabel.alpha = 1.0
        }
        else {
            searchButton.isEnabled = false
            searchButton.alpha = 0.25
            searchButtonLabel.alpha = 0.25
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewDidAppear(false)
        self.view.endEditing(true)
    }
    
    @objc func closeTextField() {
        viewDidAppear(false)
        isbnTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let isbn = isbnTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let searcher = OpenLibrarySearcher()
        if let vc = segue.destination as? BookTableViewController {
            vc.books = searcher.searchForBookDataa(query: isbn)
        }
    }
}
