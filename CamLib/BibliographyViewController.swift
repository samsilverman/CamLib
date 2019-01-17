//
//  BibliographyViewController.swift
//  CamLib
//
//  Created by Samuel Silverman on 12/1/18.
//  Copyright © 2018 Samuel Silverman. All rights reserved.
//

import UIKit

class BibliographyViewController: UIViewController {

    @IBOutlet weak var bibliographyTextView: UITextView!
    
    var bibliographyText: String = "ERROR: Bibliography unavailable."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        bibliographyTextView.text = bibliographyText
    }

}
