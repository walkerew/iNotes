//
//  NewNotebookViewController.swift
//  iNotes
//
//  Created by Emily Walker on 12/1/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import UIKit

class NewNotebookViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var newNotebook: Notebook?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "icon2")
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            newNotebook = Notebook(title: titleTextField.text!)
        }
    }
    

}
