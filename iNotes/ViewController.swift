//
//  ViewController.swift
//  iNotes
//
//  Created by Emily Walker on 12/1/19.
//  Copyright © 2019 Emily Walker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn


class ViewController: UIViewController {
    

    @IBOutlet weak var imageView: UIImageView!
    
    var authUI: FUIAuth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        imageView.image = UIImage(named: "openingImage")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }

    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil {
            self.authUI.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        } //else {
            //tableView.isHidden = false
        //}
        
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            //tableView.isHidden = true
            signIn()
        } catch {
            //tableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }
    }
    
}

extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            // Assumes data will be isplayed in a tableView that was hidden until login was verified so unauthorized users can't see data.
            //tableView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
}

