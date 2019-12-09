//
//  NotebookListViewController.swift
//  iNotes
//
//  Created by Emily Walker on 12/1/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
//import GoogleSignIn

class NotebookListViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var notebooksArray: [Notebook] = []
    var notesArray: [Note] = []
    //var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "icon1")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    func signIn() {
//        let providers: [FUIAuthProvider] = [
//            FUIGoogleAuth(),
//            ]
//        if authUI.auth?.currentUser == nil {
//            self.authUI.providers = providers
//            present(authUI.authViewController(), animated: true, completion: nil)
//        } else {
//            tableView.isHidden = false
//        }
//
//    }
    
    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addBarButton.isEnabled = true
            editBarButton.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            addBarButton.isEnabled = false
            // FIX
            editBarButton.title = "Done"
        }
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func unwindFromNewNotebookViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! NewNotebookViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            notebooksArray[indexPath.row].title = sourceViewController.newNotebook!.title!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: notebooksArray.count, section: 0)
            notebooksArray.append(sourceViewController.newNotebook!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func unwindFromNotebookDetailViewController(segue: UIStoryboardSegue) {
    print("unwinding from note view controller")
    let sourceViewController = segue.source as! NoteViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            print("editing")
            notesArray[indexPath.row] = sourceViewController.note
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            print("adding")
            let newIndexPath = IndexPath(row: notesArray.count, section: 0)
            notesArray.append(sourceViewController.note)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }

}

extension NotebookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebooksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notebooksArray[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notebooksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // for moving
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = notebooksArray[sourceIndexPath.row]
        notebooksArray.remove(at: sourceIndexPath.row)
        notebooksArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNotebookDetail" { // tableView cell was clicked
            print("Segue to notebook detail")
            let destination = segue.destination as! NotebookDetailViewController
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            destination.notebookIndex = selectedIndex
            destination.notebookTitle = notebooksArray[selectedIndex].title
            destination.notebooksArray = notebooksArray
        } else { // + button was clicked
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
}
