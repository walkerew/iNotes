//
//  NotebookDetailViewController.swift
//  iNotes
//
//  Created by Emily Walker on 12/1/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import UIKit

class NotebookDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var notebooksArray: [Notebook] = []
    var notebookIndex: Int!
    var notesArray: [Note] = []
    var notebookTitle: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "icon3")
        tableView.delegate = self
        tableView.dataSource = self
        notebookTitle = notebooksArray[notebookIndex].title
        if let notebookTitle = notebookTitle {
            titleLabel.text = notebookTitle
        }
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    @IBAction func editBarButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            editBarButton.title = "Done"
        }
    }
    @IBAction func addBarButtonPressed(_ sender: Any) {
    }
    
    // MARK:- PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNote" { // tableView cell was clicked
            let destination = segue.destination as! NoteViewController
            let selectedIndex = tableView.indexPathForSelectedRow!
            destination.note = notesArray[selectedIndex.row]
            destination.notesArray = notesArray
            destination.noteIndex = selectedIndex.row
            destination.cancelButton.tintColor = UIColor.clear
            destination.cancelButton.isEnabled = false
        } else if segue.identifier == "UnwindFromNotebookDetailVC" {
            notebooksArray[notebookIndex] = Notebook(title: notebookTitle!, notesArray: notesArray)
        } else { // + button was clicked
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    // MARK:- UNWIND
    @IBAction func unwindFromNoteViewController(segue: UIStoryboardSegue) {
        print("unwinding from note view controller")
        let sourceViewController = segue.source as! NoteViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            print("editing")
            notesArray[indexPath.row] = sourceViewController.note
            notesArray = sourceViewController.notesArray
            notebooksArray[notebookIndex].notesArray[indexPath.row] = sourceViewController.note
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            print("adding")
            let newIndexPath = IndexPath(row: notesArray.count, section: 0)
            notesArray.append(sourceViewController.note)
            notebooksArray[notebookIndex].notesArray.append(sourceViewController.note)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        print(notesArray.count)
        print(notesArray[0].title)
    }
}

extension NotebookDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // for moving
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = notesArray[sourceIndexPath.row]
        notesArray.remove(at: sourceIndexPath.row)
        notesArray.insert(itemToMove, at: destinationIndexPath.row)
    }
}

