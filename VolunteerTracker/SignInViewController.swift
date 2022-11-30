//
//  SignInViewController.swift
//  VolunteerTracker
//
//  Created by Emily Rubright on 11/29/22.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email Address"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        emailTextField.becomeFirstResponder()
    }

    @IBAction func SignInClick(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            // show alert
            return
        }
        
        // Get Auth Instance
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] _result ,_error in
            guard let strongSelf = self else {
                return
            }
            
            guard _error == nil else {
                // Show acct create
                strongSelf.CreateAccount(email: email, password: password)
                return
            }
            
            strongSelf.emailTextField.text = ""
            strongSelf.passwordTextField.text = ""
            print("Signed In")
        })
        
    }
    
    func CreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] _result ,_error in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard _error == nil else {
                        print("Account Creation Failed")
                        return
                    }
                
                strongSelf.emailTextField.text = ""
                strongSelf.passwordTextField.text = ""
                print("Signed In")
            })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in
        }))
        present(alert, animated: true)
    }
    
    @IBAction func SignOutClick(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("Signed Out")
        }
        catch {
            print("error occurred")
        }
    }

}
